#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"


PROGRAMAS_PARA_INSTALAR=(
  python3 
  python-pip 
  docker 
  docker-compose 
  git
  build-essential 
  libssl-dev 
  flatpak 
  gnome-software-plugin-flatpak
  zsh
)

# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #

## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Atualizando o repositório ##
sudo apt update -y


## Adicionando repositórios de terceiros e suporte a Snap (Drivers Nvidia)##
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
# ---------------------------------------------------------------------- #


# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb


# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

## Instalando pacotes Flatpak ##
flatpak install flathub com.obsproject.Studio -y

## Instalando pacotes Snap ##
sudo snap install spotify
sudo snap install code --classic 
sudo snap install insomnia  
sudo snap install dbeaver-ce
# ---------------------------------------------------------------------- #


# Instalar oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# ---------------------------------------------------------------------- #

# Baixar temas e plugins para o zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
# ---------------------------------------------------------------------- #


# Instalar tema zsh
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
# ---------------------------------------------------------------------- #

# Sobrescrevendo arquivo zshrc
git clone https://gist.github.com/b38909ea84c9e397fc290b8acd4e0083.git "$DIRETORIO_DOWNLOADS"
cp -f "$DIRETORIO_DOWNLOADS/b38909ea84c9e397fc290b8acd4e0083/.zshrc" ~/
# ---------------------------------------------------------------------- #


# Instalar nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.zshrc
# ---------------------------------------------------------------------- #




# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #
