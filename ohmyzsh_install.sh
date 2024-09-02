#!/bin/bash

sudo apt install zsh -y
# Install oh-my-zsh.
0>/dev/null sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM
# Configure plugins.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM}"/plugins/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM}"/plugins/you-should-use
sudo apt install  autojump fzf xclip micro fd-find -y
sed -i 's/^plugins=.*/plugins=(git\n extract\n autojump\n jsontools\n colored-man-pages\n zsh-autosuggestions\n zsh-syntax-highlighting\n zsh-history-substring-search\n fzf\n you-should-use\n nvm\n debian)/g' ~/.zshrc
# Enable nvm plugin feature to automatically read `.nvmrc` to toggle node version.
sed -i "1s/^/zstyle ':omz:plugins:nvm' autoload yes\n/" ~/.zshrc
# Install powerlevel10k and configure it.
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
wget -O ~/.p10k.zsh "https://raw.githubusercontent.com/Gdenich/zsh/main/.p10k.zsh"
wget -O ~/.zshrc "https://raw.githubusercontent.com/Gdenich/zsh/main/.zshrc"
# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e '/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST' ~/.zshrc
# Configure the default ZSH configuration for new users.
sudo cp ~/.zshrc /etc/skel/
sudo cp ~/.p10k.zsh /etc/skel/
sudo cp -r ~/.oh-my-zsh /etc/skel/
sudo chmod -R 755 /etc/skel/
sudo chown -R root:root /etc/skel/
wget -O ~/bash-to-zsh-hist.py "https://raw.githubusercontent.com/Gdenich/zsh/main/bash-to-zsh-hist.py"
cd ~/ && cp .bash_history .bash_history.bak && cat ~/.bash_history | python3 bash-to-zsh-hist.py >> ~/.zsh_history
read -p "Do you want to set ZSH as your default shell? (y/n) " response
case $response in
    y|Y )
        chsh -s "$(which zsh)"
        ;;
    n|N )
        echo "Exiting..."
        exit 1
        ;;
    * )
        echo "Invalid input. Exiting..."
        exit 1
esac
