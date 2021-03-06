#! /bin/bash
# ApoloLab's OpenWebStart Unattended Installation Script
# Developed by: Dani3l Murill0
echo "------WELCOME TO OPENWEBSTART INSTALLATION SCRIPT------"
echo "-----------------------APOLOLAB------------------------"
intelArch="i386"
macArch=$(uname -p)
if [ "$macArch" != "$intelArch" ]; then
    tag="/OpenWebStart_macos-aarch64"
else
    tag="/OpenWebStart_macos-x64"
fi
installerURL=$(curl -sL https://api.github.com/repos/karakun/OpenWebStart/releases/latest | grep $tag | cut -d\" -f4)
installerVersion=$(echo $installerURL | cut -d\/ -f8)
installerFile=$(echo $installerURL | cut -d\/ -f9)
jnlpFile="https://dev.drsbee.com/es-CR/Account/DoSignatureLogin?contextData=QVNQLk5FVF9TZXNzaW9uSWQ9QzNBOTFFMTBBMzE0RTEwREE5MTZDMUQx" #DEV
#jnlpFile="https://www.drsbee.com/es-CR/Account/DoSignatureLogin?contextData=QVNQLk5FVF9TZXNzaW9uSWQ9REVFODg4MEJBQ0M3MDgxNTA4NDA0MDZEOyBfZ2FfWUtIS1hNTERaSD1HUzEuMS4xNjQzMjExNjAwLjEuMC4xNjQzMjExNjAwLjA7IF9nYT1HQTEuMi4xMDgxOTk4NDk3LjE2NDMyMTE2MDE7IF9naWQ9R0ExLjIuMTUyMDQ5NTc2Mi4xNjQzMjExNjAyOyBfZ2F0X2d0YWdfVUFfMTc4NjQ0OTU1XzI9MTsgX2hqU2Vzc2lvblVzZXJfMjAwNDkxOD1leUpwWkNJNkltVXlaamhsTkRJMExUTTNaall0TldSaFpDMDVNemRqTFRFMFpETmlOekEwT0Rsa05pSXNJbU55WldGMFpXUWlPakUyTkRNeU1URTJNREUxTnpJc0ltVjRhWE4wYVc1bklqcG1ZV3h6WlgwPTsgX2hqRmlyc3RTZWVuPTE7IF9oakluY2x1ZGVkSW5TZXNzaW9uU2FtcGxlPTE7IF9oalNlc3Npb25fMjAwNDkxOD1leUpwWkNJNklqUTVZekkwTURWbExUSTJaVGt0TkdGa01DMWhaREJsTFRsa01UZzROalJpTnpOak15SXNJbU55WldGMFpXUWlPakUyTkRNeU1URTJNREUzTkRVc0ltbHVVMkZ0Y0d4bElqcDBjblZsZlE9PTsgX2hqSW5jbHVkZWRJblBhZ2V2aWV3U2FtcGxlPTE7IF9oakFic29sdXRlU2Vzc2lvbkluUHJvZ3Jlc3M9MQ==" #PROD
#jnlpFile="https://raw.githubusercontent.com/W4r10ck423/OpenWebStartCfg/main/TestSignatureDev.jnlp"
drsbeeSignerURL="https://github.com/W4r10ck423/DrsBeeWebStartDist/raw/main/DrsBeeSigner.tar.gz"
echo "[INFO] The current installer version is $installerVersion"
osascript -e 'display notification "(Este proceso puede tardar algunos minutos)" with title "DrsBee" subtitle "Por favor espere mientras se instalan los componentes requeridos" sound name "Submarine"'

if test -f "$installerFile"; then
	echo "[INFO] You have already downloaded the latest installer file... Now downloading installation config file..."
else
	echo "[INFO] Downloading the latest installer file... This may take several minutes, please wait"
	curl -L -o $installerFile $installerURL
fi

if test -f "response.varfile"; then
	echo "\[INFO] You have already downloaded the installer configuration file"
else
	echo "[INFO] Downloading the installer configuration file, please wait"
	curl -L -o response.varfile https://raw.githubusercontent.com/W4r10ck423/OpenWebStartCfg/main/response.varfile
        
fi

echo "[INFO] Downloading aditional configuration file, please wait..."
icedteaDir="$HOME/.config/icedtea-web"
if [[ ! -e $icedteaDir ]]; then
    mkdir $icedteaDir
fi
curl -L -o "$icedteaDir/deployment.properties" "https://raw.githubusercontent.com/W4r10ck423/OpenWebStartCfg/main/deployment.properties"

echo "[INFO] Performing unattended install, please wait..."
hdiutil attach $installerFile 
/Volumes/OpenWebStart/OpenWebStart\ Installer.app/Contents/MacOS/JavaApplicationStub -q -varfile response.varfile
#hdiutil detach /Volumes/OpenWebStart

curl -o "DrsBeeSigner.tar.gz" -L "$drsbeeSignerURL"
tar xvf DrsBeeSigner.tar.gz
cp -rf DrsBeeSigner.app /Applications
echo "[INFO] Cleaning installation resources..."
rm -rf response.varfile $installerFile DrsBeeSigner.tar.gz DrsBeeSigner.app
echo "[INFO] Running app for the first time..."
killall Finder
killall firefox
nohup /Applications/Firefox.app/Contents/MacOS/firefox "https://dev.drsbee.com/es-CR/Account/Login" >/dev/null 2>&1 &
nohup open "/Applications/DrsBeeSigner.app" >/dev/null 2>&1 &
echo "[INFO] Ejecting volumes"
#hdiutil detach /Volumes/DrsBeeWebStart
