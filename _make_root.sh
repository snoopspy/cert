#!/bin/bash

# --------------------------------------------------------
# usage   : ./_make_root.sh <common name>
# example : ./_make_root.sh gilgil
# --------------------------------------------------------
if [ -z "$1" ]; then
	echo "usage   : ./_make_root.sh <common name>"
	echo "example : ./_make_root.sh gilgil"
	exit 1
fi
COMMON_NAME="$1"

if [ -d "root" ]; then
	echo "root folder already exists"
	exit 1
fi

# --------------------------------------------------------
# make root folder
# --------------------------------------------------------
mkdir -p root

# --------------------------------------------------------
# make key file(root.key)
# --------------------------------------------------------
openssl genrsa -out root/root.key 2048

# --------------------------------------------------------
# make csr file(root.csr)
# --------------------------------------------------------
openssl req -new -key root/root.key -subj "/C=US/CN=$COMMON_NAME/O=$COMMON_NAME/OU=$COMMON_NAME" -out root/root.csr

# --------------------------------------------------------
# make crt file(root.crt)
# --------------------------------------------------------
sudo timedatectl set-ntp false
sudo date -s "2026-04-29 12:00:00"
openssl x509 -req -days 4748 -extensions v3_ca -set_serial 1 -in root/root.csr -signkey root/root.key -out root/root.crt \
	-extfile <(printf "[v3_ca]\nbasicConstraints=critical,CA:true\nkeyUsage=critical,keyCertSign,cRLSign\nsubjectKeyIdentifier=hash\n")
sudo timedatectl set-ntp true # sudo rdate -s time.bora.net

# --------------------------------------------------------
# make der file(root.der)
# --------------------------------------------------------
openssl x509 -inform pem -in root/root.crt -outform der -out root/root.der

# --------------------------------------------------------
# make pem file(root.pem)
# --------------------------------------------------------
cat root/root.key root/root.crt > root/root.pem
