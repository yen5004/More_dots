#!/bin/bash

# install_custom_scripts_versioning.sh
# This script is used to install custom command alias but ultizes a versioning system
# This will prevent double entries in the bashrc file
#25Jun2024

# example:
# Custom Scripts Version: 1.0 (25Jun2024) #2024-06-25
 
# Define your custom aliases and functions
aliases=$(cat << 'EOF'
# Change dirs
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias n='nano'
alias c='clear'
alias count='ls * | wc -l'

# cd to a folder passed as a function and ls -la
cda() { # cd && ls -la with a function passed
    cd "$1" && ls -la
}

# cd to a folder passed as a function and ls -ls
cds() { # cd && ls -ls with a function passed
    cd "$1" && ls -ls
}

# cd to a folder passed as a function and ls -lh
cdh() { # cd && ls -lh with a function passed
    cd "$1" && ls -lh
}
EOF
)

# Version check function
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# Check if custom entries are already in .bashrc
function add_custom_entries() {
    local custom_entries="$1"
    local entry_type="$2"  # e.g., "alias" or "function"

    while IFS= read -r entry; do
        if ! grep -q "$entry" ~/.bashrc; then
            # Add or update .bashrc with custom entry
            echo "$entry" >> ~/.bashrc
            echo "# Custom Scripts Version: $new_version ($(date '+%F'))" >> ~/.bashrc
            echo "Added custom $entry_type: $entry"
        else
            echo "Custom $entry_type already exists: $entry. Skipping."
        fi
    done <<< "$custom_entries"
}

# Customize these as needed
new_version="1.0"  # Update with your actual version number
current_version=$(grep -oP 'Custom Scripts Version: \K[^)]+' ~/.bashrc | head -n 1)

# Compare versions
if version_gt "$new_version" "$current_version"; then
    add_custom_entries "$aliases" "alias"
else
    echo "No update needed. Current version ($current_version) is up to date."
fi
