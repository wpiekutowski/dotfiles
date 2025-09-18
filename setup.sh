#!/bin/bash

# This script creates symbolic links from the home directory to the files
# in this dotfiles directory.

# Get the absolute path to the directory where this script is located.
# This ensures that the script can be run from any working directory.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# List of files and directories to ignore in the dotfiles directory.
# Add any other files you don't want to be symlinked here.
IGNORE_LIST=("." ".." ".git" "host" "setup.sh" "README.md" "LICENSE")

echo "Starting dotfile setup..."
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Home directory:     $HOME_DIR"
echo

# Function to check if a file is in the ignore list.
is_ignored() {
    local filename="$1"
    for ignored_item in "${IGNORE_LIST[@]}"; do
        if [[ "$filename" == "$ignored_item" ]]; then
            return 0 # 0 for true in bash
        fi
    done
    return 1 # 1 for false
}

# Iterate over all items in the dotfiles directory.
for file in "$DOTFILES_DIR"/.*; do
    filename=$(basename "$file")
    source_path="$DOTFILES_DIR/$filename"
    target_path="$HOME_DIR/$filename"

    # Skip ignored files
    if is_ignored "$filename"; then
        continue
    fi

    echo "Processing '$filename'..."

    # Case 1: A valid symlink already exists.
    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" == "$source_path" ]; then
        echo "  -> Valid symlink already exists. Skipping."
    # Case 2: An invalid symlink exists (broken or points to wrong location).
    elif [ -L "$target_path" ]; then
        echo "  -> Invalid symlink found at '$target_path'."
        rm "$target_path"
        ln -s "$source_path" "$target_path"
        echo "  -> Removed invalid link and created a new one."
    # Case 3: A regular file exists at the target location.
    elif [ -f "$target_path" ]; then
        echo "  -> WARNING: A file already exists at '$target_path'."
        echo "     Showing diff between your file and the repository's version:"

        # Show diff, using colordiff if available for better readability.
        # The '|| true' prevents the script from exiting if diff finds differences.
        if command -v colordiff &> /dev/null; then
            diff --unified "$target_path" "$source_path" | colordiff || true
        else
            diff --unified "$target_path" "$source_path" || true
        fi

        read -p "     Overwrite this file with a symlink? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$target_path"
            ln -s "$source_path" "$target_path"
            echo "  -> Replaced file with symlink."
        else
            echo "  -> Skipping."
        fi
    # Case 4: A directory exists at the target location.
    elif [ -d "$target_path" ]; then
        echo "  -> WARNING: A directory already exists at '$target_path'."
        read -p "     Overwrite this directory with a symlink? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$target_path"
            ln -s "$source_path" "$target_path"
            echo "  -> Replaced directory with symlink."
        else
            echo "  -> Skipping."
        fi
    # Case 5: Nothing exists at the target location.
    else
        echo "  -> Creating new symlink."
        ln -s "$source_path" "$target_path"
        echo "  -> Symlink created at '$target_path'."
    fi
    echo # Add a blank line for better output readability
done

echo "Dotfile setup complete."
