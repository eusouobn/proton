#!/usr/bin/env sh

######################################################
# Automatização p/instalação do projeto ProtonK      #
# Autor Rodrigo bb Vulgo=Rbgames		     #
# Autor do Projeto Proton-Async Jibreel		     #
# 						     #
######################################################


echo "$(tput bel)$(tput bold)$(tput setaf 2)"Instalando depedencias..."" 
sleep 02

#descobrir base do sistema
base=$(grep '^ID_' /etc/os-release | cut -d "=" -f2)

#se for base debian, como ubuntu, mint e cia
if [ "$base" = "debian" ];then
     sudo apt install xz-utils unrar unrar-free git wget
#se for base arch, como manjaro e cia
elif [ "$base" = "arch" ];then
     sudo pacman -S xz unrar unrar-free git wget
fi

echo "$(tput setaf 7)$(tput setab 4)Feito$(tput sgr0)"
sleep 01

######################################################

#verificando

echo "Verificando..." 
sleep 02

DIR_COM=~/.steam/root/compatibilitytools.d
if [ ! -d "$DIR_COM" ];then
    mkdir -p $DIR_COM
    echo "$(tput bel)$(tput bold)$(tput setaf 2)"Criado $DIR_COM" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
else
    echo "$(tput bel)$(tput bold)$(tput setaf 2)"Diretorio $DIR_COM existe" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
fi

PROT=~/.steam/root/compatibilitytools.d/ProtonK\ 7.0-101
if [ ! -d "$PROT" ];then
    echo "$(tput bel)$(tput bold)$(tput setaf 2)"Baixando ProtonK 7.0-101...."" 
    sleep 02
    wget "https://dl.dropboxusercontent.com/s/7a3ufe87sqxw6bz/ProtonK 7.0-101.tar.gz"
    echo "Descompactando....."
    sleep 01
    tar -xvzf "ProtonK 7.0-101.tar.gz"
    echo "$(tput setaf 7)$(tput setab 4)compiando...$(tput sgr0)"
    sleep 02
    cp -r "ProtonK 7.0-101" ~/.steam/root/compatibilitytools.d/ProtonK\ 7.0-101
    echo "$(tput bel)$(tput bold)$(tput setaf 2)"Copiado $PROT" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
else
    echo "$(tput bel)$(tput bold)$(tput setaf 2)"A pasta já $PROT existe" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
fi

rm -fr "ProtonK 7.0-101" ProtonK\ 7.0-101.tar.gz

echo "$(tput setaf 7)$(tput setab 4)Feito $(tput sgr0)"
sleep 01

#######################################################
echo "Baixando latencyfles....."
sleep 02

#baixa o latencyFlex e descompacta e copia pro local de destino

wget https://github.com/ishitatsuyuki/LatencyFleX/releases/download/v0.1.0/latencyflex-v0.1.0.tar.xz
echo "$(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"

echo "Descompctando latencyflex....."
sleep 02
tar -xvf latencyflex-v0.1.0.tar.xz
cd latencyflex-v0.1.0/layer/usr/lib/x86_64-linux-gnu/
sudo cp -r liblatencyflex_layer.so /usr/lib/x86_64-linux-gnu/
cd -
cd latencyflex-v0.1.0/layer/usr/share/vulkan/implicit_layer.d/
sudo cp -r latencyflex.json  /usr/share/vulkan/implicit_layer.d/
echo "$(tput bel)$(tput bold)$(tput setaf 2)"COPIADO" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
sleep 02
cd -
rm -fr latencyflex-v0.1.0 latencyflex-v0.1.0.tar.xz
sleep 01

########################################################
echo "$(tput bel)$(tput bold)$(tput setaf 2)"Dxvk.conf...." $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
sleep 03

#Cria e edita o dxvk.conf

touch ~/.config/dxvk.conf

cat <<EOF |tee ~/.config/dxvk.conf
dxvk.enableAsync = True
EOF
echo "$(tput bel)$(tput bold)$(tput setaf 2)"Criado" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
sleep 02

##########################
 
cat /proc/cpuinfo | grep processor | wc -l | while read line
do
     echo 'dxvk.numAsyncThreads = ' $line  >> ~/.config/dxvk.conf 
done

cat /proc/cpuinfo | grep processor | wc -l | while read line
do
     echo 'dxvk.numCompilerThreads = ' $line  >> ~/.config/dxvk.conf 
done
echo "$(tput bel)$(tput bold)$(tput setaf 2)"Adicionado" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
sleep 02

##############################################################

#coloca os parametros p/ficar padrão do sistema

file=/etc/environment
if [  $(grep -c DXVK_ASYNC=1 /etc/environment) != 0 ]; then
     echo "$(tput bel)$(tput bold)$(tput setaf 2)"Ok""
     else
cat <<EOF | sudo tee -a /etc/environment
DXVK_ASYNC=1
EOF
fi

file=/etc/environment
if [  $(grep -c LFX=1 /etc/environment) != 0 ]; then
     echo "$(tput bel)$(tput bold)$(tput setaf 2)"Ok""
     else
cat <<EOF | sudo tee -a /etc/environment
LFX=1
EOF
fi

file=/etc/environment
if [  $(grep -c "DXVK_CONFIG_FILE=/home/{$USER}/.config/dxvk.conf" /etc/environment) != 0 ]; then
     echo "$(tput bel)$(tput bold)$(tput setaf 2)"Ok""
     else
cat <<EOF | sudo tee -a /etc/environment
DXVK_CONFIG_FILE=/home/{$USER}/.config/dxvk.conf
EOF
fi
echo "$(tput bel)$(tput bold)$(tput setaf 2)"Feito" $(tput setaf 7)$(tput setab 4)Ok...$(tput sgr0)"
sleep 01
echo "$(tput bel)$(tput bold)$(tput setaf 2)"Finished" $(tput setaf 7)$(tput setab 4)"Por favor reinicie seu Pc, Boa jogatina"$(tput sgr0)"
sleep 02
