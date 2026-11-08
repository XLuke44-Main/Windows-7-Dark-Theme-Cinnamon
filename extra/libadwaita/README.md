# Libadwaita and LibAdapta integration

The Libadwaita bridge now forces primary application canvases, views, cards and sidebars to exact `#000000`, and restores the Windows 7 green-glass titlebar gradient at GTK user CSS priority. This is a toolkit integration issue: ordinary GTK theme CSS alone does not force upstream Libadwaita applications to use the theme.

## Linux Mint theme support

The theme now includes both `libadwaita-1.5/` and `libadapta-1.5/` at the theme root. Linux Mint's patched Libadwaita 1.5 and LibAdapta 1.5 discover these directories from the selected GTK theme and load:

- `defaults-light.css` and `defaults-dark.css` for the named surface/foreground palette;
- `base.css` for widget styling;
- `base-hc.css` for high-contrast widget styling.

The files import the shared AMOLED palette and the theme's GTK 4 widget stylesheet, so window content, cards, segmented controls, dialog surfaces, menus and inputs use the same black/graphite design. The active accent is declared as `accent_color` in the GTK 3 stylesheet for XApp's accent-colour portal integration.

References: [Linux Mint's patched Libadwaita theme support](https://github.com/linuxmint/libadwaita), [LibAdapta theme support](https://github.com/xapp-project/libadapta).

## Upstream Libadwaita fallback

Upstream Libadwaita intentionally does not provide general desktop-theme selection. To apply the bridge for applications which load the normal per-user GTK 4 CSS, run `install-libadwaita.sh` from the theme root after placing the theme in `~/.themes/`. For strict GTK 3/4 `#000000` surfaces and consistent titlebars, also run `install-gtk-user-overrides.sh`.

The installer:
- copies `windows-7-aero-amoled.css` into `~/.config/gtk-4.0/`;
- prepends one import to `~/.config/gtk-4.0/gtk.css`;
- preserves existing CSS content and is safe to run repeatedly.

Restart affected apps after installation. Run `uninstall-libadwaita.sh` to remove only this theme's import and copied stylesheet. Flatpak sandbox permissions may still prevent an app from reading host user CSS.

## Scope

This integration targets GTK 4 applications using Libadwaita or LibAdapta. It cannot restyle Qt/KDE, Electron, web-based or application-drawn user interfaces. App-specific CSS may also deliberately override theme styles.
