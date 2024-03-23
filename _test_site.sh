#!/bin/bash

# --------------------------------------------------------
# usage   : ./_test_site.sh <base file name>
# example : ./_test_site.sh foo.com
# --------------------------------------------------------
if [ -z "$1" ]; then
	echo "usage   : ./_test_site.sh <base file name>"
	echo "example : ./_test_site.sh foo.com"
	exit 1
fi
BASE_FILE_NAME="$1"

# --------------------------------------------------------
# run server
# --------------------------------------------------------
openssl s_server -key $BASE_FILE_NAME.key -cert $BASE_FILE_NAME.crt -accept 443 -www
