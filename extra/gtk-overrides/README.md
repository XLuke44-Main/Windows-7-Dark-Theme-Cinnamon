# GTK 3/4 strict AMOLED overrides

Run `install-gtk-user-overrides.sh` from the theme root after installing the theme. This installs user CSS overlays in `XDG_CONFIG_HOME/gtk-3.0` and `gtk-4.0`. GTK gives these user stylesheets USER priority (above normal application CSS), so they can correct applications whose own normal stylesheet sets pale window/view backgrounds.

The overlay targets toolkit-defined GTK widgets. It cannot recolor a custom OpenGL/Vulkan/canvas surface, web content, a terminal emulator's separately configured palette, or an application that paints its own pixels without GTK style nodes. Such apps need their own color scheme.

The final titlebar block restores the original Windows 7 dark-blue glass gradient. It does not create a second titlebar and cannot change which process/compositor owns window decorations. See the root README and `qt/README.md` for process-local CSD/SSD launchers.
