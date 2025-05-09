use rand::random_range;
use serde::{Deserialize, Serialize};
use std::env;
use std::{fs::File, io::BufReader, thread, time::Duration};

#[derive(Serialize, Deserialize)]
struct WallpaperSwitcher {
    wallpapers_dir: String,
    image_extensions: Vec<String>,
    state_file_path: String,
    wait_min: u64,
    wait_max: u64,
    current_wallpaper_list: Vec<String>,
    current_wallpaper_index: usize,
    old_pids: Vec<i32>,
}

impl WallpaperSwitcher {
    #![allow(dead_code)]
    fn clone(&self) -> Self {
        Self {
            wallpapers_dir: self.wallpapers_dir.clone(),
            image_extensions: self.image_extensions.clone(),
            state_file_path: self.state_file_path.clone(),
            wait_min: self.wait_min,
            wait_max: self.wait_max,
            current_wallpaper_list: self.current_wallpaper_list.clone(),
            current_wallpaper_index: self.current_wallpaper_index,
            old_pids: self.old_pids.clone(),
        }
    }
    fn run(&mut self) {
        self.initialize_state();
        loop {
            let current_wallpaper_list = self.current_wallpaper_list.clone();
            for (i, wallpaper) in current_wallpaper_list.iter().enumerate() {
                if i < self.current_wallpaper_index {
                    continue;
                }

                println!(
                    "Setting wallpaper {}/{}: {}",
                    i + 1,
                    self.current_wallpaper_list.len(),
                    wallpaper
                );
                for pid in &self.old_pids {
                    if let Err(err) = std::process::Command::new("kill")
                        .arg("-9")
                        .arg(pid.to_string())
                        .status()
                    {
                        eprintln!("Error killing old swaybg process {}: {}", pid, err);
                    }
                }

                self.old_pids.clear();
                let new_pid = self.set_wallpaper(wallpaper) as i32;
                self.old_pids.push(new_pid);
                self.current_wallpaper_index = i;
                self.save_state();

                let wait_time = random_range(self.wait_min..=self.wait_max);

                println!("Waiting {} seconds...", wait_time);
                thread::sleep(Duration::from_secs(wait_time));
            }

            self.reset_state();
        }
    }

    fn save_state(&self) {
        let state_json = serde_json::to_string(&self).unwrap();
        std::fs::write(&self.state_file_path, state_json).expect("Error saving state file");
    }

    fn initialize_state(&mut self) {
        if let Ok(file) = File::open(&self.state_file_path) {
            let reader = BufReader::new(file);
            if let Ok(state) = serde_json::from_reader::<BufReader<File>, WallpaperSwitcher>(reader)
            {
                self.current_wallpaper_list = state.current_wallpaper_list;
                self.current_wallpaper_index = state.current_wallpaper_index;
                return;
            }
            eprintln!("Error reading state file: {}", self.state_file_path);
        }

        eprintln!("No state found, resetting...");
        self.reset_state();
    }

    fn reset_state(&mut self) {
        println!(
            "Rescanning & shuffle wallpapers in {}...",
            self.wallpapers_dir
        );
        let wallpapers = match std::fs::read_dir(&self.wallpapers_dir) {
            Ok(files) => files
                .filter_map(|file| {
                    file.ok()
                        .map_or(None, |f| f.path().to_str().map(String::from))
                })
                .filter(|path| self.image_extensions.iter().any(|ext| path.ends_with(ext)))
                .collect(),
            Err(e) => {
                eprintln!("Error listing wallpapers directory: {}", e);
                Vec::new()
            }
        };

        self.current_wallpaper_list = wallpapers;
        self.current_wallpaper_index = 0;
    }

    fn set_wallpaper(&mut self, wallpaper: &str) -> u32 {
        // Check if the environment variable WAYLAND_DISPLAY is set or if the XDG_SESSION_TYPE is wayland
        if env::var("WAYLAND_DISPLAY").is_ok()
            || env::var("XDG_SESSION_TYPE").unwrap_or_default() == "wayland"
        {
            self.set_wallpaper_wayland(wallpaper)
        } else if env::var("DISPLAY").is_ok()
            || env::var("XDG_SESSION_TYPE").unwrap_or_default() == "x11"
        {
            self.set_wallpaper_x11(wallpaper)
        } else {
            self.set_wallpaper_wayland(wallpaper)
        }
    }
    fn set_wallpaper_x11(&mut self, wallpaper: &str) -> u32 {
        // Implement the code to set wallpaper for x11 using feh
        let _output = std::process::Command::new("feh")
            .args(&["--bg-fill", wallpaper]) // Adjust feh command as needed
            .spawn()
            .expect("Error setting wallpaper with feh");

        thread::sleep(Duration::from_secs(1)); // Wait for swaybg to start
        return _output.id();
    }
    fn set_wallpaper_wayland(&mut self, wallpaper: &str) -> u32 {
        // Implement the code to set wallpaper for Wayland using swaybg
        let _output = std::process::Command::new("swaybg")
            .args(&["--output", "*", "--mode", "fill", "--image", wallpaper]) // Adjust swaybg command as needed
            .spawn()
            .expect("Error setting wallpaper with swaybg");

        thread::sleep(Duration::from_secs(1)); // Wait for swaybg to start
        _output.id()
    }
}

fn main() {
    let wait_min = env::var("WALLPAPER_WAIT_MIN")
        .map(|val| val.parse::<u64>().unwrap_or(60))
        .unwrap_or(60);

    let wait_max = env::var("WALLPAPER_WAIT_MAX")
        .map(|val| val.parse::<u64>().unwrap_or(180))
        .unwrap_or(180);

    let wallpapers_dir =
        env::var("WALLPAPERS_DIR").expect("WALLPAPERS_DIR environment variable not set");
    let state_file_path = env::var("WALLPAPERS_STATE_FILEPATH")
        .expect("WALLPAPERS_STATE_FILEPATH environment variable not set");

    let image_extensions = vec![
        String::from(".jpg"),
        String::from(".jpeg"),
        String::from(".png"),
    ];

    let mut wallpaper_switcher = WallpaperSwitcher {
        wallpapers_dir,
        image_extensions,
        state_file_path,
        wait_min,
        wait_max,
        current_wallpaper_list: Vec::new(),
        current_wallpaper_index: 0,
        old_pids: Vec::new(),
    };

    wallpaper_switcher.run();
}
