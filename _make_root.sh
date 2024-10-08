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
openssl req -new -key root/root.key -subj "/C=US/CN=$COMMON_NAME/O=$COMMON_NAME" -out root/root.csr

# --------------------------------------------------------
# make crt file(root.crt)
# --------------------------------------------------------
sudo date -s "29 APR 2023 12:00:00"
openssl x509 -req -days 3653 -extensions v3_ca -set_serial 1 -in root/root.csr -signkey root/root.key -out root/root.crt
rdate -s time.bora.net

# --------------------------------------------------------
# make der file(root.der)
# --------------------------------------------------------
openssl x509 -inform pem -in root/root.crt -outform der -out root/root.der

# --------------------------------------------------------
# make pem file(root.pem)
# --------------------------------------------------------
cat root/root.key root/root.crt > root/root.pem
