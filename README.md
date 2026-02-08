# ATS_ScreenShots
A little screenshot automation with AutoHotKey to taking screenshot in ATS with toast notification

## Hotkeys

|  hotkey        |        description        |   Variable  |  Changed  |
|  ------------  |  -----------------------  |  ---------  |  -------  |
|  **=**         |  start taking screenshots |  runscript  |  <p align="center">✅</p>  |
|  **-**         |  stop taking screenshots  |  stopscript |  <p align="center">✅</p>  |
|  **?**         |  show an helper box       |  help       |  <p align="center">✅</p>  |
|  **Esc**       |  close helper box         |  closehelp  |  <p align="center">✅</p>  |
|  **Ctrl+Del**  |  quit the script          |  can't change |  <p align="center">❌</p>  |
> You can change the variables and choose the hotkey you prefer; everything is in the **variable** section. (Ctrl+Del is intentionally hard-coded; if you want to change it you must edit the code directly.)

All hotkeys: https://www.autohotkey.com/docs/v2/KeyList.htm

## How it Work
> A small script to capture screenshots with coordinates in American Truck Simulator.

After you press the "**=**" key the script start a cycle that repeats every 5 seconds.
This cycle will press "**SHIFT**+**F11**" and then press "**ENTER**".

A simple non-interactive GUI was added just for fun to show the available hotkeys.
You can open the helper by default with "**?**".
