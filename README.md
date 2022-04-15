# isc-dhcp-pfsense
Cria um arquivo XML importável pelo pfSense a partir do mapeamento IP x MAC do ISC DHCP Server do GNU/Linux.
Ao importá-lo no pfSense, os mapeamentos já configurados, serão sobrescritos.

## Modo de execução
./isc-dhcp-pfsense.sh arquivo_isc_mapping

## Arquivos
- isc-dhcp-pfsense.sh - script
- isc-dhcp-pfsense.conf - arquivo de configuração contendo a definição de variáveis
- IPsReservadoISCDHCP - modeelo de teste com a sintaxe do isc-dhcp-server
