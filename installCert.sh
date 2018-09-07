#!/bin/bash


# Check for root privs
if [[ $EUID -ne 0 ]]; then
   echo "[!] Please run as root (try 'sudo bash installCert.sh')" 
   exit 1
fi

# Define keychain location
KEYCHAIN=/Library/Keychains/System.keychain

# Check if Keychain is accessible
if [ ! -f $KEYCHAIN ]; then
   echo "[!] Error - could not find System Keychain at \'$KEYCHAIN\'"
   exit 1
fi

# Get current directory
PWD=$(pwd)

# Ask the user for the server hostname
read -p "Please enter the server hostname (ex. trustedsite.example.com): " HOSTNAME

###### To hardcode a hostname ######
## comment/remove the line above and edit this line:
#HOSTNAME='trustedsite.example.com'

# Make sure the server is accessible on port 443
nc -z $HOSTNAME 443 > /dev/null 2>&1
if [ $? -ne 0 ]; then
   echo [!] Error - cannot reach \'$HOSTNAME\' on port 443. Please check hostname
   exit 1
else
   echo [-] Using hostname \'$HOSTNAME\'
fi

# Download server TLS cert
CERTFILE=$PWD/cert.pem
echo [-] Saving TLS certificate as \'$CERTFILE\'
openssl s_client -showcerts -connect $HOSTNAME:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > $CERTFILE

# Make sure Cert downloaded successfully
if [ ! -f $CERTFILE ]; then
   echo "[!] Error downloading certificate to '$CERTFILE'"
   exit 1
fi

# Import cert to Keychain
echo [-] Importing certificate in Keychain
security add-trusted-cert -d -r trustRoot -k $KEYCHAIN $CERTFILE

# Delete Cert file
echo [-] Cleaning up cert file
rm $CERTFILE

echo [+] Done
