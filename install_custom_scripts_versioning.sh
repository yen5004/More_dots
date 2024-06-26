#!/bin/bash

# Define your custom aliases and functions
custom_aliases=$(cat << 'EOF'
# Change dirs
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
EOF
)

custom_functions=$(cat << 'EOF'
# Find string in files
fstr() {
    grep -Rnw "." -e "$1"
}
EOF
)

# Version check function
function version_gt() {
    local ver1=$1
    local ver2=$2
    # Trim whitespace from both versions
    ver1=$(echo "$ver1" | tr -d '[:space:]')
    ver2=$(echo "$ver2" | tr -d '[:space:]')
    if [[ "$(printf '%s\n' "$ver1" "$ver2" | sort -V | head -n 1)" == "$ver1" ]]; then
        return 0  # true
    else
        return 1  # false
    fi
}

# Function to add custom entries (aliases or functions)
function add_custom_entries() {
    local custom_entries="$1"
    local entry_type="$2"  # e.g., "alias" or "function"

    if [[ ! -w ~/.bashrc ]]; then
        echo "Error: ~/.bashrc is not writable. Please check permissions."
        return 1
    fi

    # Add or update .bashrc with custom entry
    echo "$custom_entries" >> ~/.bashrc
    echo "# Custom Scripts Version: $new_version ($(date '+%F'))" >> ~/.bashrc
    echo "Added custom $entry_type to ~/.bashrc."
}

# Customize these as needed
new_version="2.1"  # Update with your actual version number
current_version=$(grep -oP 'Custom Scripts Version: \K[^)]+' ~/.bashrc | head -n 1)

# Debugging output
echo "Debugging:"
echo "new_version: $new_version"
echo "current_version: \"$current_version\""  # Print current_version with quotes

# Compare versions (trimming whitespace)
if [[ -z "$current_version" ]]; then
    echo "No current version found in ~/.bashrc. Adding new version."
    add_custom_entries "$custom_functions" "function"
    add_custom_entries "$custom_aliases" "alias"
else
    # Version exists, so compare and update if necessary
    if version_gt "$new_version" "$current_version"; then
        add_custom_entries "$custom_functions" "function"
        add_custom_entries "$custom_aliases" "alias"
    else
        echo "No update needed. Current version ($current_version) is up to date."
    fi
fi
