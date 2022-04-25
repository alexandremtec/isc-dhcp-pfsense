#!/bin/bash 

#file=$1

# Importando as configurações de isc-dhcp-pfsense.conf
source isc-dhcp-pfsense.conf

# Funções


# Verifica os parâmetros passados na chamada do script

validation(){
	if [[  -z $ARG ]]; then
		clear
		echo "Execute o script passando o arquivo do ISC DHCP (sem espaços) como parâmetro!
		Exemplo: ./isc-dhcp-pfsense \"IPsISCDHCP.conf\""
		echo $ARG
		exit 1
	fi
}

# Cria o diretório de trabalho

make_temp_dir(){
	if [[ ! -d $WORKDIR ]]; then
		mkdir -p $WORKDIR
	fi
}

prepare_file(){
	egrep -v '^#' "$ARG" | sed -r 's/\;|\{|\}/ /g' > $FILEIN
}

# Divide o arquivo os campos do arquivo isc.txt em seus respectivos arquivos

split_file(){
	grep -o 'ethernet.*' $FILEIN | awk '{print $2}' > $FILEMAC
	echo MAC...done!
	grep '^host ' $FILEIN | awk '{print $2}' > $FILEHOST
	echo HOST...done!
	grep -o 'fixed-address.*' $FILEIN | awk '{print $2}' > $FILEIP
	echo IP...done!
	sleep 2
	clear
}

# Lê os campos MAC, HOST e IP de seus respectivos arquivos e faz o referenciamento no arquivo XML

data_marge(){
	while read -r  mac host ip
	do
		echo -e "<staticmap>
	               \r\t<mac>$mac</mac>
		       \r\t<descr>$host</descr>
		       \r\t<hostname>$host</hostname>
		       \r\t<ipaddr> $ip</ipaddr>
		      \r</staticmap>" >> $OUTFILE 
	done <<< $(paste $FILEMAC $FILEHOST $FILEIP)
}

cleaning(){
	echo "Removing temporary files..."
	rm -rf $WORKDIR
	sleep 2
	echo "Done!"
}


# main

validation

make_temp_dir

prepare_file

split_file

echo "<dhcpd>
<$IFACE>
<enable></enable>" > $OUTFILE

data_marge
echo "</$IFACE>
</dhcpd>" >> $OUTFILE
cleaning

echo "Your $OUTFILE file is here: $(pwd)/$OUTFILE"
