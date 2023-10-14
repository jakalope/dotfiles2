; Initialize a variable to track whether Caps Lock is chorded
Chorded := 0

; Set CapsLock to act as Ctrl when held down
CapsLock::Ctrl

; When CapsLock is released:
CapsLock Up::  
    ; If CapsLock was not chorded (quick press and release), send Esc
    if (Chorded = 0) {
        Send, {Esc}
    }
    ; Reset the Chorded variable
    Chorded := 0
    return

; When CapsLock is used in combination with another key (chorded):
; Send Ctrl + the chorded key
CapsLock & a::Send, ^a
CapsLock & b::Send, ^b
CapsLock & c::Send, ^c
CapsLock & d::Send, ^d
CapsLock & e::Send, ^e
CapsLock & f::Send, ^f
CapsLock & g::Send, ^g
CapsLock & h::Send, ^h
CapsLock & i::Send, ^i
CapsLock & j::Send, ^j
CapsLock & k::Send, ^k
CapsLock & l::Send, ^l
CapsLock & m::Send, ^m
CapsLock & n::Send, ^n
CapsLock & o::Send, ^o
CapsLock & p::Send, ^p
CapsLock & q::Send, ^q
CapsLock & r::Send, ^r
CapsLock & s::Send, ^s
CapsLock & t::Send, ^t
CapsLock & u::Send, ^u
CapsLock & v::Send, ^v
CapsLock & w::Send, ^w
CapsLock & x::Send, ^x
CapsLock & y::Send, ^y
CapsLock & z::Send, ^z
; Add other key combinations as needed

