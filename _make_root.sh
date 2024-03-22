#!/bin/bash

# --------------------------------------------------------
# usage   : _make_root <common name>
# example : _make_root gilgil
# --------------------------------------------------------
if [ -z "$1" ]; then
	echo "usage   : _make_root <common name>"
	echo "example : _make_root gilgil"
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
openssl x509 -req -days 3650 -extensions v3_ca -set_serial 1 -in root/root.csr -signkey root/root.key -out root/root.crt
