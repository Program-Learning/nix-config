package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

type WallpaperSwitcher struct {
	WallpapersDir         string
	ImageExtensions       []string
	StateFilePath         string
	WaitMin               int
	WaitMax               int
	CurrentWallpaperList  []string
	CurrentWallpaperIndex int
}

var PidsRequiredKilling []int

func (ws *WallpaperSwitcher) Run() {
	ws.InitializeState()
	for {
		for i, wallpaper := range ws.CurrentWallpaperList {
			if i < ws.CurrentWallpaperIndex {
				continue
			}

			fmt.Printf("Setting wallpaper %d/%d: %s\n", i+1, len(ws.CurrentWallpaperList), wallpaper)
			ws.SetWallpaper(wallpaper)

			ws.CurrentWallpaperIndex = i
			ws.SaveState()

			waitTime := rand.Intn(ws.WaitMax-ws.WaitMin+1) + ws.WaitMin
			fmt.Printf("Waiting %d seconds...\n", waitTime)
			time.Sleep(time.Duration(waitTime) * time.Second)
		}

		ws.ResetState()
	}
}

func (ws *WallpaperSwitcher) SaveState() {
	state := map[string]interface{}{
		"current_wallpaper_list":  ws.CurrentWallpaperList,
		"current_wallpaper_index": ws.CurrentWallpaperIndex,
	}
	stateJSON, err := json.Marshal(state)
	if err != nil {
		log.Fatalf("Error marshalling state JSON: %v", err)
	}
	if err := os.WriteFile(ws.StateFilePath, stateJSON, 0644); err != nil {
		log.Fatalf("Error saving state file: %v", err)
	}
}

func (ws *WallpaperSwitcher) InitializeState() {
	stateJSON, err := os.ReadFile(ws.StateFilePath)
	if err != nil {
		log.Printf("No state found, resetting...")
		ws.ResetState()
	} else {
		log.Printf("State found, reloading...")
		var state map[string]interface{}
		if err := json.Unmarshal(stateJSON, &state); err != nil {
			log.Fatalf("Error unmarshalling state JSON: %v", err)
		}

		// Convert interface{} to []string
		wallpaperListInterface := state["current_wallpaper_list"].([]interface{})
		wallpaperList := make([]string, len(wallpaperListInterface))
		for i, v := range wallpaperListInterface {
			wallpaperList[i] = v.(string)
		}

		ws.CurrentWallpaperList = wallpaperList
		ws.CurrentWallpaperIndex = int(state["current_wallpaper_index"].(float64))
	}
}

func (ws *WallpaperSwitcher) ResetState() {
	log.Printf("Rescanning & shuffle wallpapers in %s ...\n", ws.WallpapersDir)
	files, err := filepath.Glob(filepath.Join(ws.WallpapersDir, "*"))
	if err != nil {
		log.Fatalf("Error listing wallpapers directory: %v", err)
	}

	var wallpapers []string
	for _, file := range files {
		ext := filepath.Ext(file)
		for _, extAllowed := range ws.ImageExtensions {
			if ext == extAllowed {
				wallpapers = append(wallpapers, file)
				break
			}
		}
	}
	rand.Shuffle(len(wallpapers), func(i, j int) {
		wallpapers[i], wallpapers[j] = wallpapers[j], wallpapers[i]
	})
	ws.CurrentWallpaperList = wallpapers
	ws.CurrentWallpaperIndex = 0
}

func (ws *WallpaperSwitcher) SetWallpaper(wallpaper string) {
	// Add code to set wallpaper based on OS
	if os.Getenv("WAYLAND_DISPLAY") != "" || os.Getenv("XDG_SESSION_TYPE") == "wayland" {
		KillProcessesByPids(PidsRequiredKilling)
		PidsRequiredKilling = []int{}
		ws.SetWallpaperWayland(wallpaper)
	} else {
		ws.SetWallpaperX11(wallpaper)
	}
}

func (ws *WallpaperSwitcher) SetWallpaperX11(wallpaper string) {
	cmd := exec.Command("feh", "--bg-fill", wallpaper)
	if err := cmd.Run(); err != nil {
		log.Fatalf("Error setting wallpaper using feh: %v", err)
	}
}
func (ws *WallpaperSwitcher) SetWallpaperWayland(wallpaper string) {
	// err := KillProcessByName("swaybg")
	// if err != nil {
	// 	fmt.Printf("Error: %v\n", err)
	// }

	cmd := exec.Command("swaybg", "--output", "*", "--mode", "fill", "--image", wallpaper)
	if err := cmd.Start(); err != nil {
		log.Fatalf("Error starting swaybg: %v", err)
	}
	PidsRequiredKilling = append(PidsRequiredKilling, cmd.Process.Pid)
	time.Sleep(1) // Wait for swaybg to start
}

func KillProcessesByPids(pids []int) {
	for _, pid := range pids {
		process, err := os.FindProcess(pid)
		if err != nil {
			log.Printf("Error finding process with PID %d: %v", pid, err)
			continue
		}

		if err := process.Kill(); err != nil {
			log.Printf("Error killing process with PID %d: %v", pid, err)
		} else {
			log.Printf("Process with PID %d killed successfully", pid)
		}
	}
}
func KillProcessByName(name string) error {
	// Get the process information by name
	output, _ := exec.Command("ps", "-o", "pid,comm", "-C", name).Output()
	lines := strings.Split(string(output), "\n")

	for i, line := range lines {
		if i == 0 {
			continue
		}
		fields := strings.Fields(line)
		if len(fields) < 2 {
			continue
		}
		fmt.Printf("Killing process: %s (PID: %s)\n", fields[1], fields[0])
		// Kill the process
		exec.Command("pkill", "-f", fields[0]).Run()
	}
	return nil
}

func main() {
	wallpapersDir := os.Getenv("WALLPAPERS_DIR")
	stateFilePath := os.Getenv("WALLPAPERS_STATE_FILEPATH")
	if wallpapersDir == "" || stateFilePath == "" {
		log.Fatal("WALLPAPERS_DIR or WALLPAPERS_STATE_FILEPATH not set")
	}

	waitMin, _ := strconv.Atoi(os.Getenv("WALLPAPER_WAIT_MIN"))
	waitMax, _ := strconv.Atoi(os.Getenv("WALLPAPER_WAIT_MAX"))
	if waitMin == 0 || waitMax == 0 {
		waitMin = 60
		waitMax = 180
	}

	imageExtensions := []string{".jpg", ".jpeg", ".png"}

	wallpaperSwitcher := WallpaperSwitcher{
		WallpapersDir:   wallpapersDir,
		ImageExtensions: imageExtensions,
		StateFilePath:   stateFilePath,
		WaitMin:         waitMin,
		WaitMax:         waitMax,
	}

	wallpaperSwitcher.Run()
}
