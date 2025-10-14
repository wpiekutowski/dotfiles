# Homebrew
xcode-select --install

if [[ ! -f "/opt/homebrew/bin/brew" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update && brew upgrade

brew install --no-quarantine mhaeuser/mhaeuser/battery-toolkit
brew install sst/tap/opencode

brew install nikitabobko/tap/aerospace
brew install FelixKratz/formulae/borders
brew install mediosz/tap/swipeaerospace

# objective-see
brew install \
	blockblock \
	reikey \
	ransomwhere \
	knockknock \
	taskexplorer \
	netiquette \
	oversight \

# Colima provides VM for docker
brew install \
        asdf \
        betterdisplay \
	bettertouchtool \
	chatgpt \
	codex \
        colima \
	devcontainer \
        difftastic \
        direnv \
        docker \
        docker-buildx \
        docker-compose \
        docker-credential-helper \
        entr \
        iterm2 \
	itermai \
        jq \
        mise \
        neovim \
        nodejs \
        tmux \
        ungoogled-chromium \
	uv \
        visual-studio-code \
        wget \
	# YubiKey manager
	ykman \
        yq \
	zsh \

	# It seems autoupgrade doesn't work when installed via homebrew 
        # google-chrome \
	# zed@preview \
	
	# Stores credentials in easily accessible way in keychain :(
	# gh \

