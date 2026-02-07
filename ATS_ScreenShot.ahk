#Requires AutoHotkey v2.0
SendMode "Input"
SetWorkingDir A_ScriptDir

; ---------- CONFIG ----------
interval_ms := 5000                               ; Interval between screenshots cycles (ms)
dialog_delay := 600                               ; Delay to wait for dialog to open (ms)
currentToast := ""
; --------- Variables ---------
running := false
runscript := "="
stopscript := "-"
killscript := "Ctrl+Del"                          ; Label shown to user
help := "?"
closehelp := "Esc"
; --------- Texts ---------
msgHeader := "Hotkeys"
msgBody := "Press: '" runscript "' to start taking screenshots.`n`n"
        . "Press: '" stopscript "' to stop taking screenshots.`n`n"
        . "Press: '" help "' to show this help box.`n`n"
        . "Press: '" closehelp "' to close helper box.`n`n"
        . "Press: '" killscript "' to quit the script."

; --------- Hotkeys ---------
Hotkey(runscript, Enable)             ; Run script
Hotkey(stopscript, Disable)           ; Stop script
Hotkey("^Del", ExitScript)            ; Kill script
Hotkey(help, ShowHelperWrapper)       ; Helper box
Hotkey("Esc", CloseHelper)            ; Close helper
; ---------------------------

Enable(*) {
  global running
  if running
    return
  running := true
  SetTimer(Cycle, interval_ms)
  secs := interval_ms / 1000
  ShowToast("Screenshot cycle started (" . Floor(secs) . " sec)")
}

Disable(*) {
  global running
  if !running
    return
  running := false
  SetTimer(Cycle, 0)
  ShowToast("Screenshot cycle stopped")
}

Cycle(*) {
  global dialog_delay

  ; Send Shift+F11
  Send "+{F11}"
  Sleep dialog_delay

  ; Confirm SCS PosBox
  Send "{Enter}"

}

; --------- Close Script ---------
ExitScript(*) {
  global currentToast
  try SetTimer(Cycle, 0)
  try SetTimer(DestroyCurrentToast, 0)

  try {
    if IsObject(currentToast)
      DestroyCurrentToast()
  }

  ExitApp()
}

; --------- GUI ---------
ShowToast(msg, width := 300, height := 40) {
  global currentToast

  if IsObject(currentToast) {
    DestroyCurrentToast()
  }
    
  ; Create GUI (click-through "+E0x20" so game keeps focus and cursos stays hidden)
  toast := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
  toast.BackColor := "262626"
  toast.SetFont("s12 cWhite", "Segoe UI")
  
  toast.AddText("Center w" width " h" height " wrap", msg)

  WinSetTransparent(220, toast.Hwnd)
  region := "0-0 w" width " h" height " r20-20"
  WinSetRegion(region, toast.Hwnd)

  margin := 20
  x := A_ScreenWidth - width - margin
  y := margin
  toast.Show("x" x " y" y " NoActivate")

  currentToast := toast

  ; Auto Close
  SetTimer(DestroyCurrentToast, -5000)
}

DestroyCurrentToast() {
  global currentToast
  if !IsObject(currentToast)
    return
  
  try {
    currentToast.Destroy()
  } catch Any as e {
    if IsObject(e) {
      FileAppend(A_Now " - Timer Error: " . e.Message . "`n", A_ScriptDir "\ats_errors.log")
    } else {
      FileAppend(A_Now " - Timer Error: " . e . "`n", A_ScriptDir "\ats_errors.log")
    }
  }

  currentToast := ""
}

CloseHelper(*) {
  global currentToast
  Hotkey("Esc", "")

  if IsObject(currentToast)
    try currentToast.Destroy()
    currentToast := ""
}

ShowHelperWrapper(*) {
  global msgHeader, msgBody
  ShowHelper(msgHeader, msgBody)
}

ShowHelper(header := "", body := "", width := 300, height := 300) {
    global currentToast

    if IsObject(currentToast)
        DestroyCurrentToast()

    w := width
    h := height

    header_h := 56
    if header = ""
        header_h := 0

    toast := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    toast.BackColor := "262626"

    ; Header
    if header_h {
        toast.SetFont("s18 cWhite", "Segoe UI Semibold")
        toast.AddText("Center w" w " h" header_h, header)
    }

    ; Body
    toast.SetFont("s12 cWhite", "Segoe UI")
    body_x := 10
    body_w := w - (body_x * 2)
    body_y := header_h + 6
    body_h := h - body_y - 6
    toast.AddText("x" body_x " y" body_y " w" body_w " h" body_h " wrap", body)

    WinSetTransparent(220, toast.Hwnd)
    region := "0-0 w" w " h" h " r12-12"
    WinSetRegion(region, toast.Hwnd)

    x := Floor((A_ScreenWidth - w) / 2)
    y := Floor((A_ScreenHeight - h) / 2)
    toast.Show("x" x " y" y " NoActivate")

    currentToast := toast
    Hotkey("Esc", CloseHelper)
    SetTimer(DestroyCurrentToast, -10000)
}
