#!/bin/bash

# --------------------------------------------------------
# usage   : ./_make_site.sh <common name> [<base file name>]
# example : ./_make_site.sh foo.com
# --------------------------------------------------------
if [ -z "$1" ]; then
	echo "usage   : ./_make_site.sh <common name> [<base file name>]"
	echo "example : ./_make_site.sh foo.com"
	exit 1
fi
COMMON_NAME="$1"
BASE_FILE_NAME="$1"
if  [ ! -z "$2" ]; then
	BASE_FILE_NAME="$2"
fi

# --------------------------------------------------------
# make key file(foo.com.key)
# --------------------------------------------------------
openssl genrsa -out $BASE_FILE_NAME.key 2048

# --------------------------------------------------------
# make csr file(foo.com.csr)
#--------------------------------------------------------
openssl req -new -key $BASE_FILE_NAME.key -subj "/C=US/CN=$COMMON_NAME/O=$COMMON_NAME" -out $BASE_FILE_NAME.csr

# --------------------------------------------------------
# make crt file(foo.com.crt)
# --------------------------------------------------------
openssl x509 -req -days 3650 -in $BASE_FILE_NAME.csr -CA root/root.crt -CAcreateserial -CAkey root/root.key -out $BASE_FILE_NAME.crt -extfile <(echo "subjectAltName=DNS:$COMMON_NAME,DNS:*.$COMMON_NAME")

# --------------------------------------------------------
# make der file(foo.com.der)
# --------------------------------------------------------
openssl x509 -inform pem -in $BASE_FILE_NAME.crt -outform der -out $BASE_FILE_NAME.der

# --------------------------------------------------------
# make pkcs file(foo.com.pfx)
# --------------------------------------------------------
openssl pkcs12 -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES -export -in $BASE_FILE_NAME.crt -inkey $BASE_FILE_NAME.key -out $BASE_FILE_NAME.pfx -name "$COMMON_NAME" -passin pass: -passout pass:

# --------------------------------------------------------
# make pem file(foo.com.pem)
# --------------------------------------------------------
cat $BASE_FILE_NAME.key $BASE_FILE_NAME.crt > $BASE_FILE_NAME.pem
