@echo off

rem --------------------------------------------------------
rem usage   : _make_root <common name>
rem example : _make_root gilgil
rem --------------------------------------------------------
if "%1"=="" goto usage
set COMMON_NAME=%1

if exist root goto exist_error

rem --------------------------------------------------------
rem make root folder
rem --------------------------------------------------------
mkdir root

rem --------------------------------------------------------
rem make key file(root.key)
rem --------------------------------------------------------
openssl genrsa -out root\root.key 4096

rem --------------------------------------------------------
rem make csr file(root.csr)
rem --------------------------------------------------------
openssl req -new -key root\root.key -subj "/C=US/CN=%COMMON_NAME%/O=%COMMON_NAME%/OU=%COMMON_NAME%" -out root\root.csr

rem --------------------------------------------------------
rem make crt file(root.crt)
rem --------------------------------------------------------
rem timedatectl set-ntp false
date 04-29-2026
time 12:00:00.00

echo [v3_ca] > root\v3_ca.ext
echo basicConstraints=critical,CA:true >> root\v3_ca.ext
echo keyUsage=critical,keyCertSign,cRLSign >> root\v3_ca.ext
echo subjectKeyIdentifier=hash >> root\v3_ca.ext
openssl x509 -req -days 4748 -extensions v3_ca -set_serial 1 -in root/root.csr -signkey root\root.key -out root\root.crt -extfile root\v3_ca.ext
del root\v3_ca.ext
rem sudo timedatectl set-ntp true # sudo rdate -s time.bora.net

rem --------------------------------------------------------
rem make der file(root.der)
rem --------------------------------------------------------
openssl x509 -inform pem -in root\root.crt -outform der -out root\root.der

rem --------------------------------------------------------
rem make pem file(root.pem)
rem --------------------------------------------------------
copy root\root.key + root\root.crt root\root.pem

goto eof

:usage
echo "usage   : _make_root <common name>"
echo "example : _make_root gilgil"
goto eof

:exist_error
echo "root folder already exists"

:eof
