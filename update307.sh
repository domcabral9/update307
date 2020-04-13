#!/bin/bash

echo "##### Baixando Atualização do Bitbucket ... #####"
cd /var/www/html
wget -c https://bitbucket.org/snepdev/snep-3/get/master.tar.gz -O snep-dev.tar.gz
wget -c https://bitbucket.org/snepdev/billing/get/master.tar.gz -O bill.tar.gz
wget -c https://bitbucket.org/snepdev/ivr/get/master.tar.gz -O ivr.tar.gz

echo "##### Descompactando Arquivos ... #####"
tar xvf snep-dev.tar.gz
tar xvf bill.tar.gz
tar xvf ivr.tar.gz

echo "##### Atualizando Banco de Dados ... #####"
cd snepdev-snep-3-cce2cb01cb96
mysql -usnep -psneppass snep < install/database/update/3.07/update.sql 

echo "##### Substituindo Arquivos snep ... #####"
tar cf - . | tar xvf - -C ../snep/
cd ..

echo "##### Atualizando Billing ... #####"
cd snepdev-billing-104bff715f7c
tar cf - . | tar xvf - -C ../snep/modules/billing/
cd ..

echo "##### Atualizando ivr ... #####"
cd snepdev-ivr-5a6a4e67be68
tar cf - . | tar xvf - -C ../snep/modules/ivr/
cd ..

echo "##### Ajustando Permissoes ... #####"
cd /var/www/html
find . -type f  -exec chmod 640 {} \; -exec chown www-data:www-data {} \;
find . -type d  -exec chmod 755 {} \; -exec chown www-data:www-data {} \;
chmod +x /var/www/html/snep/agi/*

echo "##### Atualizando Configuração Asterisk ... #####"
mkdir ./backup
mv /etc/asterisk ./backup
mv /var/www/html/snep/install/etc/asterisk /etc/

echo "##### Removendo temporários ... #####"

rm -rf /var/www/html/snepdev-snep-3-cce2cb01cb96
rm -rf /var/www/html/snepdev-ivr-5a6a4e67be68
rm -rf /var/www/html/snepdev-billing-104bff715f7c
rm /var/www/html/snep-dev.tar.gz
rm /var/www/html/bill.tar.gz
rm /var/www/html/ivr.tar.gz

echo "##### Tudo Pronto ... #####"
echo "##### Reinicie o Asterisk quando possível #####"
exit 0

