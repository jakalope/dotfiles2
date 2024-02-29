#!/bin/bash

#!/bin/bash

if [[ "$(uname -r)" == *microsoft* || "$(uname -r)" == *WSL* || -n "$WSL_DISTRO_NAME" ]]; then
    echo "Running in WSL"
    sudo apt install x11-xkb-utils

    # Create a custom XKB keymap for Caps Lock as Control when chorded
    mkdir -p ~/.xkb/symbols
    cp /usr/share/X11/xkb/symbols/us ~/.xkb/symbols/my_custom_layout

    # Define the custom keymap to remap Caps Lock to Control when chorded
    cat << 'EOF' > ~/.xkb/symbols/my_custom_layout
    default partial alphanumeric_keys
    xkb_symbols "basic" {

        include "us(basic)"
        name[Group1]= "English (US)";

        key <CAPS> { [ Control_L, Control_L, Control_L, Control_L, Control_L, Control_L, Control_L, Control_L, Control_L, Control_L ] };
    };
EOF

    # Create another custom keymap to remap Caps Lock to Escape when not chorded
    cat << 'EOF' > ~/.xkb/symbols/my_custom_layout_escape
    default partial alphanumeric_keys
    xkb_symbols "basic" {

        include "us(basic)"
        name[Group1]= "English (US)";

        key <CAPS> { [ Escape, Escape ] };
    };
EOF

    # Apply the custom keymap for Caps Lock as Control
    xkbcomp -I$HOME/.xkb $HOME/.xkb/symbols/my_custom_layout $DISPLAY

    # Make the changes permanent for Caps Lock as Control
    if [ -f $HOME/.xkb/symbols/my_custom_layout ]; then
       echo 'if [ -f $HOME/.xkb/symbols/my_custom_layout ]; then
       xkbcomp -I$HOME/.xkb $HOME/.xkb/symbols/my_custom_layout $DISPLAY
    fi' >> ~/.bashrc
    fi

    # Inform the user to restart their WSL session
    echo "Caps Lock has been remapped to Control when chorded. Please restart your WSL session for the changes to take effect."

    # Now, create a script to remap Caps Lock to Escape when not chorded
    # Add it to your .bashrc or .zshrc to apply it whenever you start a new shell session

    echo 'if [ -f $HOME/.xkb/symbols/my_custom_layout_escape ]; then
       xkbcomp -I$HOME/.xkb $HOME/.xkb/symbols/my_custom_layout_escape $DISPLAY
    fi' >> ~/.bashrc

    # Inform the user to restart their WSL session again for the Caps Lock to Escape mapping
    echo "Caps Lock has been remapped to Escape when not chorded. Please restart your WSL session for this change to take effect."
else
    sudo apt install xcape
    # Remap Caps Lock to act as Control when chorded with another key
    setxkbmap -option 'ctrl:nocaps'
    # Use xcape to make Caps Lock emit an Escape signal when pressed and released alone
    xcape -e 'Control_L=Escape'

    echo "setxkbmap -option 'ctrl:nocaps'" >> ~/.xprofile
    echo "xcape -e 'Control_L=Escape'" >> ~/.xprofile
fi


