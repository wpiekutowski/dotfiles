#!/bin/bash

# This script creates symbolic links from the home directory to the files
# in this dotfiles directory. It recursively finds all files and creates
# the necessary directory structure in the home directory.

# Get the absolute path to the directory where this script is located.
# This ensures that the script can be run from any working directory.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "Starting dotfile setup..."
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Home directory:     $HOME_DIR"
echo

# Use find to locate all files, excluding specified directories and files.
# The -path ... -prune -o ... syntax is the standard way to exclude paths.
find "$DOTFILES_DIR" \
    -path "$DOTFILES_DIR/.git" -prune -o \
    -path "$DOTFILES_DIR/.gitmodules" -prune -o \
    -path "$DOTFILES_DIR/claude-statusline-command" -prune -o \
    -path "$DOTFILES_DIR/dev" -prune -o \
    -path "$DOTFILES_DIR/host" -prune -o \
    -path "$DOTFILES_DIR/setup.sh" -prune -o \
    -path "$DOTFILES_DIR/setup-linux-apt.sh" -prune -o \
    -path "$DOTFILES_DIR/LICENSE" -prune -o \
    -path "$DOTFILES_DIR/README.md" -prune -o \
    -type f -print | while read -r source_path; do

    # Determine the path relative to the dotfiles directory to create the target path.
    relative_path="${source_path#$DOTFILES_DIR/}"
    target_path="$HOME_DIR/$relative_path"
    target_dir=$(dirname "$target_path")

    echo "Processing '$relative_path'..."

    # Create the parent directory in $HOME if it doesn't exist.
    if [ ! -d "$target_dir" ]; then
        echo "  -> Creating directory '$target_dir'."
        mkdir -p "$target_dir"
    fi

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
    # Case 4: A directory exists where a file should be.
    elif [ -d "$target_path" ]; then
        echo "  -> WARNING: A directory exists at '$target_path' where a file should be."
        read -p "     Remove directory and replace with a symlink? (y/N) " -n 1 -r
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
