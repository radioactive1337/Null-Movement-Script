#Requires AutoHotkey v2
#SingleInstance force
#MaxThreads 1
#MaxThreadsBuffer 1
Persistent
ListLines False
KeyHistory 0
ProcessSetPriority "High"
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 0
SetKeyDelay -1, -1

; Define keys with their scan codes and state
global keys := Map(
    "a", {sc: "SC01E", state: 0},
    "d", {sc: "SC020", state: 0},
    "w", {sc: "SC011", state: 0},
    "s", {sc: "SC01F", state: 0}
)

global scriptEnabled := true

; Function to handle key events
HandleKeyEvent(key, oppositeKey, isPress) {
    if (!scriptEnabled)
        return

    if (isPress) {
        keys[key].state |= 1
        if (keys[oppositeKey].state & 2) {
            keys[oppositeKey].state &= ~2
            SendInput "{Blind}{" . keys[oppositeKey].sc . " up}"
        }
        keys[key].state |= 2
        SendInput "{Blind}{" . keys[key].sc . " down}"
    } else {
        keys[key].state &= ~1
        if (keys[key].state & 2) {
            keys[key].state &= ~2
            SendInput "{Blind}{" . keys[key].sc . " up}"
        }
        if ((keys[oppositeKey].state & 1) && !(keys[oppositeKey].state & 2)) {
            keys[oppositeKey].state |= 2
            SendInput "{Blind}{" . keys[oppositeKey].sc . " down}"
        }
    }
}

; Hotkeys for A and D
*SC01E:: HandleKeyEvent("a", "d", true)
*SC01E up:: HandleKeyEvent("a", "d", false)
*SC020:: HandleKeyEvent("d", "a", true)
*SC020 up:: HandleKeyEvent("d", "a", false)

; Hotkeys for W and S
*SC011:: HandleKeyEvent("w", "s", true)
*SC011 up:: HandleKeyEvent("w", "s", false)
*SC01F:: HandleKeyEvent("s", "w", true)
*SC01F up:: HandleKeyEvent("s", "w", false)

; Toggle script on/off
^!z::
{
    scriptEnabled := !scriptEnabled
    if (scriptEnabled)
        ToolTip "Script enabled"
    else
        ToolTip "Script disabled"
    SetTimer () => ToolTip(), -1000
}
