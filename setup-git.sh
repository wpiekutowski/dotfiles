#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
git config --file ~/.config/git/config-local init.templateDir "$DOTFILES_DIR/git-templates"
git config --file ~/.config/git/config-local core.hooksPath "$DOTFILES_DIR/git-templates/hooks"

