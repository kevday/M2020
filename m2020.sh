#!/bin/bash
clear

################################################################################
#
# Passo a passo para instalar impressora Samsung M2020 na Raspberry e Banana Pi
# esse arquivio foi criado dia 28/03/2021 por Kevin [kevin@kevin.net.br]
#
################################################################################

# atualizar e instalar os cups, git e ferramentas para o servidor

sudo apt update
sudo apt install git cups system-config-printer build-essential libcups2-dev avahi-daemon samba
# Clonar splix com suporte ao m2020 https://gitlab.com/ScumCoder/splix/tree/patches/splix
git clone https://gitlab.com/ScumCoder/splix.git

# caso ocorra erro (ao complilar) no splix 
#git clone https://github.com/nu774/jbigkit.git


# compilando caso ocorra erro verifique  o nu774/jbigkit acima
cd splix/splix/
sudo make DISABLE_JBIG=1
cd ppd

# copiando os arquivos para os diretorios corretos e preconfigurando o servidor
clear
echo "Edite em Printets o parametro *printable=yes* "
echo "[printers]"
echo "   comment = All Printers"
echo "   browseable = no"
echo "   path = /var/spool/samba"
echo "   printable = yes"
echo "   guest ok = no"
echo "   read only = yes"
sudo nano /etc/samba/smb.conf

sudo cp m2020.ppd ../optimized/
cd  ../optimized/
USUARIO=$(whoami)
IPLOCAL=$(hostname -I)
sudo /etc/init.d/smbd restart
sudo usermod -a -G lpadmin $USUARIO
sudo cupsctl --remote-admin --remote-any
echo "Copiando... rastertoqpdl pstoqpdl"
sudo cp rastertoqpdl pstoqpdl  /usr/lib/cups/filter/
sudo chmod +x /usr/lib/cups/filter/rastertoqpdl
sudo chmod +x /usr/lib/cups/filter/pstoqpdl

echo "Pronto abra http://"$IPLOCAL":631"






