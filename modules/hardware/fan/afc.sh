#!/bin/sh

#-------------------------------------------------------------------------------
# DESCRIPTION:
#   Simplified version that only takes temperature curve from args 
#   and uses constant ACPI base address 1335
#-------------------------------------------------------------------------------

# DESCRIPTION:
#   This is the entry point for the script
# PARAMETERS:
#   $@ - temperature arguments
main() {
    init_constants &&
    process_args "$@"
}

# DESCRIPTION:
#   Initializes static constants.
init_constants() {
    # ACPI related constants
    readonly ACPI_WRITE_COMMAND='\_SB.PCI0.LPCB.EC0.WRAM'
    readonly ACPI_READ_COMMAND='\_SB.PCI0.LPCB.EC0.RRAM'
    readonly ACPI_CALL_PATH=/proc/acpi/call
    readonly BASE_ADDRESS=1335
}

# DESCRIPTION:
#   Processes given arguments and performs all associated operations.
# PARAMETERS:
#   $@ - temperature arguments
process_args() {
    if [ "$#" -eq 0 ]; then
        echo "No temperature curve provided. Please provide temperatures." >&2
        return 1
    else
        check_acpi && set_custom_temps "$*"
    fi
}

# DESCRIPTION:
#   Checks given temperatures, applies them.
# PARAMETERS:
#   $1 - temperatures
set_custom_temps() {
    if ! check_temps "$1"; then
        echo "Invalid custom temperatures $1" >&2
        return 1
    fi

    write_temps "$BASE_ADDRESS" "$1"
}

# DESCRIPTION:
#   Checks whether a given argument represents valid temperatures.
# PARAMETERS:
#   $1 - any
check_temps() {
    previous_temp=0
    for temp in $1; do
        if ! [ "$temp" -ge "$previous_temp" ] 2>/dev/null; then
            return 1
        fi
        previous_temp="$temp"
    done
    return 0
}

# DESCRIPTION:
#   Sets given fan temperatures using ACPI calls based on given base address.
# PARAMETERS:
#   $1 - base address
#   $2 - temperatures
write_temps() {
    addr=$1
    temps_count=0
    for temp in $2; do
        write_acpi_temp "$((addr + temps_count))" "$temp" &&
        temps_count="$((temps_count + 1))" || return
    done
}

# DESCRIPTION:
#   Checks whether it is possible to perform an ACPI call.
check_acpi() {
    if ! [ -f "$ACPI_CALL_PATH" ]; then
        echo "File $ACPI_CALL_PATH does not exist" >&2
        return 1
    fi

    id_out="$(id -u)" && 
    if [ "$id_out" -ne 0 ]; then
        echo 'Root permissions needed' >&2
        return 1
    fi
}

# DESCRIPTION:
#   Writes a given temperature value to a given ACPI address.
# PARAMETERS:
#   $1 - address
#   $2 - temperature
write_acpi_temp() {
    echo "$ACPI_WRITE_COMMAND ${1:?} ${2:?}" > "$ACPI_CALL_PATH" &&
    get_acpi_result > /dev/null
}

# DESCRIPTION:
#   Reads and prints the previous ACPI call result, fails on detected errors.
get_acpi_result() {
    result="$(tr -d '\0' < "$ACPI_CALL_PATH")" &&

    if echo "$result" | grep -qi error; then
        echo "ACPI call failed with '$result'" >&2
        return 1
    else
        echo "$result"
    fi
}

# Call the main function with all arguments
main "$@"