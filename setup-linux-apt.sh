sudo apt update && \
sudo apt install -y \
	build-essential \
	curl \
	direnv \
	docker.io \
	entr \
	fzf \
	gcc \
	git \
	jq \
	neovim \
	tmux \
	wget \
	yq \
	zsh \

chsh -s /bin/zsh

# mise
# https://mise.jdx.dev/installing-mise.html#apt
sudo apt update -y && sudo apt install -y gpg sudo wget curl
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=arm64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise


# Homebrew
if [[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo >> /home/w/.bashrc
	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/w/.bashrc
    	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew install difftastic
