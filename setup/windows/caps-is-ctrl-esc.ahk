#Persistent
SetCapsLockState, AlwaysOff

; Store the original Caps Lock state
GetKeyState, CapsLockState, CapsLock

; Set the Caps Lock key as a modifier
SetCapsLockState, Off

; Caps Lock as Ctrl when chorded with other keys
*CapsLock::Ctrl

; Caps Lock as Esc when pressed alone
CapsLock::Send {Esc}

; Restore the original Caps Lock state
if (CapsLockState = 1)
    SetCapsLockState, On
else
    SetCapsLockState, Off
