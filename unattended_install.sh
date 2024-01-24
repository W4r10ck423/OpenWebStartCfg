#!/bin/bash
PLIST_LABEL="com.apololab.handlejnlp"
PLIST_FILENAME="${PLIST_LABEL}.plist"
PLIST_PATH="/Library/LaunchDaemons/${PLIST_FILENAME}"
SCRIPT_PATH="/usr/local/bin/handle_jnlp.sh"
CURRENT_USER=$(stat -f "%Su" /dev/console)
TITLE="Instalación correcta"
MESSAGE="Se ha instalado correctamente los componentes. Ya puede iniciar sesión con su firma digital"
USER_PASSWORD=$(osascript -e 'Tell application "System Events" to display dialog "Por favor, ingrese su contraseña" default answer "" with hidden answer' -e 'text returned of result')
echo $USER_PASSWORD | sudo -S -v
while true; do
    sleep 300
    echo $USER_PASSWORD | sudo -S -v
done &
if [ ! -f "/usr/local/lib/libASEP11.dylib" ] && [ ! -f "/Library/Application Support/Athena/libASEP11.dylib" ]; then
    curl -L -o libs.tar.gz "https://github.com/W4r10ck423/OpenWebStartCfg/raw/main/installers/osx/libs.tar.gz"

    if [ ! -d "/Library/Application Support/Athena/" ]; then
        sudo mkdir /Library/Application\ Support/Athena/
        # osascript -e 'do shell script "sudo mkdir /Library/Application\\ Support/Athena/" with administrator privileges'        
    fi

    tar xvf libs.tar.gz -C /tmp/ 
	# osascript -e 'do shell script "sudo cp /tmp/libs/libASEP11.dylib /usr/local/lib/ && sudo cp /tmp/libs/libASEP11.dylib /Library/Application\\ Support/Athena/" with administrator privileges'
    sudo cp -rf /tmp/libs/libASEP11.dylib /usr/local/lib/ && sudo cp -rf /tmp/libs/libASEP11.dylib "/Library/Application Support/Athena/libASEP11.dylib"
fi

if [ ! -d "/Applications/IDProtect*" ]; then
    curl -L -o IDProtectClient.tar.gz "https://github.com/W4r10ck423/OpenWebStartCfg/raw/main/installers/osx/IDProtectClient.tar.gz"
    tar xvf IDProtectClient.tar.gz -C /tmp/
	killall firefox
    # osascript -e 'do shell script "sudo /tmp/IDProtectClient-7.60.00.app/Contents/MacOS/installbuilder.sh --mode unattended --disable-components Manager,PINTool,Mozilla" with administrator privileges'
    sudo /tmp/IDProtectClient-7.60.00.app/Contents/MacOS/installbuilder.sh --mode unattended --disable-components Manager,PINTool,Mozilla
fi

if [ ! -d "/Applications/ApoloSigner.app" ]; then
    curl -L -o ApoloSigner.tar.gz "https://ia601301.us.archive.org/16/items/apolo-signer.tar/ApoloSigner.tar.gz"
    tar xvf ApoloSigner.tar.gz -C /tmp/
    sudo mv /tmp/ApoloSigner.app /Applications/
fi

osascript -e "tell app \"System Events\" to display dialog \"$MESSAGE\" with title \"$TITLE\""
nohup /Applications/Firefox.app/Contents/MacOS/firefox "https://dev.drsbee.com/es-CR/Account/Login" >/dev/null 2>&1 &
kill %1
exit 0
