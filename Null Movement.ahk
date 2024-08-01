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

; Unified map for key data
global KeyData := Map(
    "a", {"sc": "SC01E", "opposite": "d"},
    "d", {"sc": "SC020", "opposite": "a"},
    "w", {"sc": "SC011", "opposite": "s"},
    "s", {"sc": "SC01F", "opposite": "w"}
)

; Function that handles key press or release
HandleKey(key, isPressed) {
    opposite := KeyData[key].opposite  ; The opposite key
    oppositeSC := KeyData[opposite]["sc"] ; Scan code of the opposite key

    if (isPressed) {
        if (KeyData[opposite].script_state) {
            KeyData[opposite].script_state := 0
            SendKeyEvent(oppositeSC, "up")
        }
        
        KeyData[key].script_state := 1
        SendKeyEvent(KeyData[key]["sc"], "down")
    } else {
        KeyData[key].script_state := 0
        SendKeyEvent(KeyData[key]["sc"], "up")

        if (!KeyData[opposite].script_state && GetKeyState(opposite, "P")) {
            KeyData[opposite].script_state := 1
            SendKeyEvent(oppositeSC, "down")
        }
    }
}

; Function to send a keyboard event
SendKeyEvent(scancode, action) {
    SendInput "{Blind}{" . scancode . " " . action . "}"
}

; Register hotkeys dynamically
For key, data in KeyData {
    Hotkey("*" . data["sc"], Func("HandleKey").Bind(key, 1))
    Hotkey("*" . data["sc"] . " up", Func("HandleKey").Bind(key, 0))
}

Return
