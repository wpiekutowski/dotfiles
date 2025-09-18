# dotfiles

## Setup

### Editing

git clone --bare git@github.com:wpiekutowski/dotfiles.git $HOME/dotfiles
alias git-dotfiles='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
git-dotfiles checkout
git-dotfiles config --local status.showUntrackedFiles no

### Read-only

git clone --bare https://github.com/wpiekutowski/dotfiles.git $HOME/dotfiles
alias git-dotfiles='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
git-dotfiles checkout
git-dotfiles config --local status.showUntrackedFiles no
