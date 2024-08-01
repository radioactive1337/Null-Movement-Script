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

; Define scan codes
global SC := Map(
    "A", "SC01E",
    "D", "SC020",
    "W", "SC011",
    "S", "SC01F"
)

; Group related variables
global keys := Map(
    "a", {held: 0, script_state: 0},
    "d", {held: 0, script_state: 0},
    "w", {held: 0, script_state: 0},
    "s", {held: 0, script_state: 0}
)

; Function to handle key press
HandleKeyPress(key, oppositeKey) {
    keys[key].held := 1
    
    if (keys[oppositeKey].script_state) {
        keys[oppositeKey].script_state := 0
        SendInput "{Blind}{" . SC[StrUpper(oppositeKey)] . " up}"
    }
    
    keys[key].script_state := 1
    SendInput "{Blind}{" . SC[StrUpper(key)] . " down}"
}

; Function to handle key release
HandleKeyRelease(key, oppositeKey) {
    keys[key].held := 0
    
    if (keys[key].script_state) {
        keys[key].script_state := 0
        SendInput "{Blind}{" . SC[StrUpper(key)] . " up}"
    }
    
    if (keys[oppositeKey].held && !keys[oppositeKey].script_state) {
        keys[oppositeKey].script_state := 1
        SendInput "{Blind}{" . SC[StrUpper(oppositeKey)] . " down}"
    }
}

; Hotkeys for A and D
*SC01E:: HandleKeyPress("a", "d")
*SC01E up:: HandleKeyRelease("a", "d")
*SC020:: HandleKeyPress("d", "a")
*SC020 up:: HandleKeyRelease("d", "a")

; Hotkeys for W and S
*SC011:: HandleKeyPress("w", "s")
*SC011 up:: HandleKeyRelease("w", "s")
*SC01F:: HandleKeyPress("s", "w")
*SC01F up:: HandleKeyRelease("s", "w")

; Error handling and logging function
LogError(message) {
    FileAppend "Error: " . message . "`n", "error_log.txt"
}
