niri: {
  programs.niri.config =
    let
      inherit (niri.lib.kdl)
        node
        plain
        leaf
        flag
        ;
    in
    [
      # ============= Window Rules =============
      # Get all the window's information via:
      #   niri msg windows

      # --------------- 1Terminal ---------------
      (plain "window-rule" [
        (leaf "match" { app-id = "foot"; })
        (leaf "open-maximized" true)
      ])

      (plain "window-rule" [
        (leaf "match" { app-id = "Alacritty"; })
        (leaf "open-maximized" true)
      ])

      (plain "window-rule" [
        (leaf "match" { app-id = "com.mitchellh.ghostty"; })
        (leaf "open-maximized" true)
      ])

      # --------------- 2Browser ---------------

      (plain "window-rule" [
        (leaf "match" { app-id = "firefox"; })
        (leaf "open-maximized" true)
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "google-chrome"; })
        (leaf "open-maximized" true)
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "chromium-browser"; })
        (leaf "open-maximized" true)
      ])

      # --------------- 3Chatting ---------------
      (plain "window-rule" [
        (leaf "match" { app-id = "org.telegram.desktop"; })
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "wechat"; })
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "QQ"; })
      ])

      # --------------- 4Gaming ---------------

      (plain "window-rule" [
        (leaf "match" { app-id = "steam"; })
        (leaf "open-on-workspace" "4gaming")
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "steam_app_default"; })
        (leaf "open-on-workspace" "4gaming")
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "heroic"; })
        (leaf "open-on-workspace" "4gaming")
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "net.lutris.Lutris"; })
        (leaf "open-on-workspace" "4gaming")
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "com.vysp3r.ProtonPlus"; })
        (leaf "open-on-workspace" "4gaming")
      ])
      (plain "window-rule" [
        # Run anime games on Linux
        (leaf "match" { app-id = "^moe.launcher"; })
        (leaf "open-on-workspace" "4gaming")
      ])
      (plain "window-rule" [
        # All *.exe (Windows APPs)
        (leaf "match" { app-id = "\.exe$"; })
        (leaf "open-on-workspace" "4gaming")
      ])

      # --------------- 6File ---------------
      (plain "window-rule" [
        (leaf "match" { app-id = "com.github.johnfactotum.Foliate"; })
        (leaf "open-on-workspace" "6file")
      ])
      (plain "window-rule" [
        (leaf "match" { app-id = "thunar"; })
        (leaf "open-on-workspace" "6file")
      ])

      # --------------- 0Other ---------------

      (plain "window-rule" [
        (leaf "match" { app-id = "clash-verge"; })
      ])

      (plain "window-rule" [
        (leaf "match" { app-id = "Zoom Workplace"; })
      ])

    # --------------- Mayuri ---------------
    
    # --------------- Steam ---------------
      (plain "window-rule" [
        (leaf "match" { app-id = "^steam$"; title = "^Steam 大屏幕模式$"; })
        (leaf "match" { app-id = ".*Minecraft.*"; })
        (leaf "open-fullscreen" true)
      ])

    # --------------- Scrcpy ---------------
      (plain "window-rule" [
        (leaf "match" { app-id = ".*scrcpy.*"; })
        (leaf "open-floating" true)
      ])

    # --------------- DropDown Apps ---------------
      (plain "window-rule" [
        (leaf "match" { app-id = "^dropdown.*$"; })
        (leaf "open-floating" true)
        (leaf "default-floating-position" {x=0; y=0; relative-to="top-left";})
        (plain"default-window-height" [ (leaf "proportion" 0.5) ])
        (plain "default-column-width" [ (leaf "proportion" 1.0) ])
        ])

      (plain "window-rule" [
        (leaf "match" { app-id = "^dropdown.*$"; is-focused = false; })
        (leaf "opacity" 0.5)
      ])

      (leaf "workspace" "ndrop")
    ];
}
