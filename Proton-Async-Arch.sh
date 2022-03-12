#!/usr/bin/env sh

######################################################
# Automatização p/instalação do projeto Proton-Async no Arch Linux #
# Autor do Script Original (Para Debian): Rodrigo bb Vulgo=Rbgames #
# Autor do Script Para Arch: Bruno do Nascimento Vulgo=eusouobn    #
# Autor do Projeto Proton-Async: Jibreel		        #
# 						                       #
######################################################


echo "Instalando Depedências"

sudo pacman -S base-devel git wget tar libarchive bzip2 gzip lrzip lz4 lzip lzop xz zstd p7zip unrar zip unzip unarchiver --noconfirm

######################################################

#Descompacta e copia para o local de destino
tar -xvzf Proton-Async.tar.gz 
cd Proton-Async

DIR_COM=~/.steam/root/compatibilitytools.d
veri_DIR_COM='ls -l $compatibilitytools.d'
if [ $? = 2 ]; then
mkdir $DIR_COM
echo "Criado $DIR_COM"
else
echo "Diretorio $DIR_COM existe"
fi
cp -r Proton-Async-1.7-Stable Proton-Async-1.10-Experimental ~/.steam/root/compatibilitytools.d/
cd ..
rm -fr Proton-Async

#########################################################

#Baixa e Instala o YAY (Ferramenta AUR)

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -fr yay

########################################################

#Baixa e Instala o LatencyFlex e suas Dependências (Através do AUR)

yay -S latencyflex-git --noconfirm


########################################################

#Cria e edita o dxvk.conf

touch ~/.config/dxvk.conf

cat <<EOF |tee ~/.config/dxvk.conf
dxvk.enableAsync = True
EOF

##########################
 
cat /proc/cpuinfo | grep processor | wc -l | while read line
do
     echo 'dxvk.numAsyncThreads = ' $line  >> ~/.config/dxvk.conf 
done

cat /proc/cpuinfo | grep processor | wc -l | while read line
do
     echo 'dxvk.numCompilerThreads = ' $line  >> ~/.config/dxvk.conf 
done

##############################################################

#Define os parâmetros do DXVK para que funcionem em qualquer jogo


file=/etc/environment
if [  $(grep -c "DXVK_CONFIG_FILE=" /etc/environment) != 0 ]; then
whoami | while read line
do
echo 'DXVK_CONFIG_FILE=/home/'$line/.config/dxvk.conf | sudo tee -a /etc/environment
done
fi

if [  $(grep -c "DXVK_CONFIG_FILE=" /etc/environment) != 1 ]; then
sudo sed -i '/DXVK_CONFIG_FILE=/d' /etc/environment
whoami | while read line
do
echo 'DXVK_CONFIG_FILE=/home/'$line/.config/dxvk.conf | sudo tee -a /etc/environment
done
fi

file=/etc/environment
if [  $(grep -c DXVK_ASYNC=1 /etc/environment) != 0 ]; then
     echo "Ok"
     else
cat <<EOF | sudo tee -a /etc/environment
DXVK_ASYNC=1
EOF
fi

file=/etc/environment
if [  $(grep -c LFX=1 /etc/environment) != 0 ]; then
     echo "Ok"
     else
cat <<EOF | sudo tee -a /etc/environment
LFX=1
EOF
fi

echo "Finished! Por favor reinicie seu pc"\ "Boa jogatina"
