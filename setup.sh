#!/bin/bash

# This script creates symbolic links from the home directory to the files
# in this dotfiles directory. It recursively finds all files and creates
# the necessary directory structure in the home directory.

# Get the absolute path to the directory where this script is located.
# This ensures that the script can be run from any working directory.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Source the shared library
source "$DOTFILES_DIR/setup-lib.sh"

echo "Starting dotfile setup..."
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Home directory:     $HOME_DIR"
echo

# Use find to locate all files, excluding specified directories and files.
# The -path ... -prune -o ... syntax is the standard way to exclude paths.
find "$DOTFILES_DIR" \
    -path "$DOTFILES_DIR/.git" -prune -o \
    -path "$DOTFILES_DIR/.gitmodules" -prune -o \
    -path "$DOTFILES_DIR/better-touch-tool" -prune -o \
    -path "$DOTFILES_DIR/claude-statusline-command" -prune -o \
    -path "$DOTFILES_DIR/dev" -prune -o \
    -path "$DOTFILES_DIR/git-templates" -prune -o \
    -path "$DOTFILES_DIR/host" -prune -o \
    -path "$DOTFILES_DIR/setup.sh" -prune -o \
    -path "$DOTFILES_DIR/setup-*.sh" -prune -o \
    -path "$DOTFILES_DIR/LICENSE" -prune -o \
    -path "$DOTFILES_DIR/README.md" -prune -o \
    -type f -print | while read -r source_path; do

    # Determine the path relative to the dotfiles directory to create the target path.
    relative_path="${source_path#$DOTFILES_DIR/}"
    link_file "$source_path" "$relative_path"
done

# Install git hooks
install_git_hooks

echo "Dotfile setup complete."
