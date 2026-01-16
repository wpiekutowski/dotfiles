#!/bin/bash

# Shared library for dotfiles setup scripts.
# Contains common functions for creating symlinks.

# Function to create a symlink for a single file
link_file() {
    local source_path="$1"
    local relative_path="$2"
    local target_path="$HOME_DIR/$relative_path"
    local target_dir=$(dirname "$target_path")

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
}

# Function to install git hooks
install_git_hooks() {
    echo "Installing git hooks..."
    if [ -d "$DOTFILES_DIR/git-templates/hooks" ]; then
        # Ensure .config/git exists
        mkdir -p "$HOME_DIR/.config/git"

        # Configure git hooks path
        git config --file "$HOME_DIR/.config/git/config-local" init.templateDir "$DOTFILES_DIR/git-templates"
        git config --file "$HOME_DIR/.config/git/config-local" core.hooksPath "$DOTFILES_DIR/git-templates/hooks"
        echo "  -> Git hooks configured."
        echo
    else
        echo "  -> WARNING: git-templates/hooks directory not found. Skipping."
        echo
    fi
}
