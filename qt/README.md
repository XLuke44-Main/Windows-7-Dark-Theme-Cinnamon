# Qt and KDE integration

This theme is a GTK theme, not a Qt style plugin. The GTK 3 and GTK 4 CSS files cannot directly style every Qt widget, Qt Quick scene, or application-owned title bar. The following integration options let compatible Qt applications reuse the theme's GTK palette or a native KDE color scheme.

## Option 1: use the GTK 3 theme from Qt 5/6

Install the GTK 3 QPA platform-theme plugin for each Qt major version you use. Depending on the distribution, it may be packaged separately (often under a name such as `qt5-gtk-platformtheme` or `qt6-gtk-platformtheme`).

With the theme installed and selected as the GTK theme, launch a Qt application with:

```sh
GTK_THEME=Windows-7-Theme-Cinnamon-AMOLED-Black \
QT_QPA_PLATFORMTHEME=gtk3 your-qt-application
```

The included `run-with-gtk3-theme.sh` wrapper does the same thing:

```sh
./run-with-gtk3-theme.sh your-qt-application [arguments...]
```

This asks Qt to use its GTK 3 platform-theme integration. It is not a separate Windows 7 Qt widget style and it does not force every Qt Quick/QML control or application-drawn surface to use GTK styling. The `gtk3` plugin must be installed; setting the variable cannot install it.

Do not set `QT_QPA_PLATFORMTHEME=gtk3` blindly on a KDE Plasma session: it replaces the selected Qt platform-theme plugin and may change native KDE dialogs/integration. On Plasma, use the native KDE color scheme below or your preferred Plasma Qt style instead.

## Option 2: KDE / Qt applications that read KDE color schemes

The included `Windows-7-Aero-AMOLED-Black.colors` file defines near-black window, view, button, tooltip, selection, and green-glass header colors.

Install it for the current user:

```sh
./install-kde-colorscheme.sh
```

Then select **Windows 7 Aero AMOLED Black** in **System Settings → Appearance → Colors** (wording varies by Plasma version).

This color scheme is consumed by KDE Frameworks applications and other Qt applications that read the KDE color scheme. Plain Qt applications using Fusion or a custom style may ignore KDE color roles. The scheme also does not replace a KWin window-decoration plugin; the active window decoration decides which titlebar roles it uses.

## Important limits

- Qt Widgets, Qt Quick/QML, Electron, and application-owned custom titlebars are different rendering paths. No GTK CSS file can force all of them to match.
- For Qt 5/6, prefer the GTK 3 platform-theme plugin when you want Qt to follow this GTK theme. For Plasma applications, prefer the supplied KDE color scheme with the normal KDE platform integration.
- A native Kvantum port would require its own Kvantum SVG and `.kvconfig`; a GTK stylesheet or KDE `.colors` file is not a Kvantum theme.


## Duplicate titlebars: optional per-application launchers

A duplicate titlebar is a decoration ownership problem, not a CSS color problem. Choose one decoration owner for the affected application:

- **GTK 3 apps using GTK's default CSD:** launch with `../run-gtk3-with-wm-decorations.sh app`. This sets `GTK_CSD=0` for that process only, allowing the window manager to draw the frame. GTK documents that this does *not* disable CSD when an application supplies a custom titlebar widget.
- **Qt apps using the Qt Wayland QPA plugin:** launch with `../run-qt-wayland-with-wm-decorations.sh app` only when the compositor provides server-side decorations. It sets `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` for that process. Do not use it for Qt X11 or where the compositor requires client decorations.
- **GTK apps with an application-supplied custom titlebar, GTK 4/libadwaita apps, Electron, and Qt X11 apps:** there is no theme-wide switch that safely removes the app's custom titlebar. Fix it with that app's own titlebar setting or a per-window rule in the active window manager/compositor. Do not set decoration-disable variables globally; some apps will become borderless.

The GTK user CSS override installer is `../install-gtk-user-overrides.sh`; uninstall with `../uninstall-gtk-user-overrides.sh`. These install black-surface and green-glass-titlebar overrides at GTK's USER CSS priority, above normal application CSS. Restart applications after installing.
