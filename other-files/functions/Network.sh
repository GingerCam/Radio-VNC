#!/bin/bash

chooseInterface() {
    # Turn the available interfaces into an array so it can be used with a whiptail dialog
    local interfacesArray=()
    # Number of available interfaces
    local interfaceCount
    # Whiptail variable storage
    local chooseInterfaceCmd
    # Temporary Whiptail options storage
    local chooseInterfaceOptions
    # Loop sentinel variable
    local firstLoop=1

    # Find out how many interfaces are available to choose from
    interfaceCount=$(wc -l <<<"${availableInterfaces}")

    # If there is one interface,
    if [[ "${interfaceCount}" -eq 1 ]]; then
        # Set it as the interface to use since there is no other option
        Radio_VNC_INTERFACE="${availableInterfaces}"
    # Otherwise,
    else
        # While reading through the available interfaces
        while read -r line; do
            # Use a variable to set the option as OFF to begin with
            mode="OFF"
            # If it's the first loop,
            if [[ "${firstLoop}" -eq 1 ]]; then
                # set this as the interface to use (ON)
                firstLoop=0
                mode="ON"
            fi
            # Put all these interfaces into an array
            interfacesArray+=("${line}" "available" "${mode}")
            # Feed the available interfaces into this while loop
        done <<<"${availableInterfaces}"
        # The whiptail command that will be run, stored in a variable
        chooseInterfaceCmd=(whiptail --separate-output --radiolist "Choose An Interface (press space to toggle selection)" "${r}" "${c}" "${interfaceCount}")
        # Now run the command using the interfaces saved into the array
        chooseInterfaceOptions=$("${chooseInterfaceCmd[@]}" "${interfacesArray[@]}" 2>&1 >/dev/tty) ||
            # If the user chooses Cancel, exit
            {
                printf "  %bCancel was selected, exiting config%b\\n" "${COL_LIGHT_RED}" "${COL_NC}"
                exit 1
            }
        # For each interface
        for desiredInterface in ${chooseInterfaceOptions}; do
            # Set the one the user selected as the interface to use
            Radio_VNC_INTERFACE=${desiredInterface}
            # and show this information to the user
            #printf "  %b Using interface: %s\\n" "${INFO}" "${Radio_VNC_INTERFACE}"
        done
    fi
}