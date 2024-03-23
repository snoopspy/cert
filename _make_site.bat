rem @echo off

rem --------------------------------------------------------
rem usage   : _make_site <common name> [<base file name>]
rem example : _make_site foo.com
rem --------------------------------------------------------
if "%1"=="" goto usage
set COMMON_NAME=%1
set BASE_FILE_NAME=%1
if "%2"=="" goto next
set BASE_FILE_NAME=%2

:next

rem --------------------------------------------------------
rem make key file(foo.com.key)
rem --------------------------------------------------------
openssl genrsa -out %BASE_FILE_NAME%.key 2048

rem --------------------------------------------------------
rem make csr file(foo.com.csr)
rem --------------------------------------------------------
openssl req -new -key %BASE_FILE_NAME%.key -subj "/C=US/CN=%COMMON_NAME%/O=%BASE_FILE_NAME%/OU=%BASE_FILE_NAME%" -out %BASE_FILE_NAME%.csr

rem --------------------------------------------------------
rem make crt file(foo.com.crt)
rem --------------------------------------------------------
rem openssl x509 -req -days 3650 -in %BASE_FILE_NAME%.csr -CA root\root.crt -CAcreateserial -CAkey root\root.key -out %BASE_FILE_NAME%.crt -extfile <(echo "subjectAltName=DNS:%COMMON_NAME%,DNS:*.%COMMON_NAME%")
openssl x509 -req -days 3650 -in %BASE_FILE_NAME%.csr -CA root\root.crt -CAcreateserial -CAkey root\root.key -out %BASE_FILE_NAME%.crt
goto eof

rem --------------------------------------------------------
rem make pkcs file(foo.com.pfx)
rem --------------------------------------------------------
openssl pkcs12 -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES -export -in %BASE_FILE_NAME%.crt -inkey %BASE_FILE_NAME%.key -out %BASE_FILE_NAME%.pfx -name "%COMMON_NAME%" -passin pass: -passout pass:

rem --------------------------------------------------------
rem make pem file(foo.com.pem)
rem --------------------------------------------------------
copy %BASE_FILE_NAME%.key + %BASE_FILE_NAME.%crt %BASE_FILE_NAME%.pem

:usage
echo "usage   : _make_site <common name> [<base file name>]"
echo "example : _make_site foo.com"

:eof
