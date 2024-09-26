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
openssl req -new -key root\root.key -subj "/C=US/CN=%COMMON_NAME%/O=%COMMON_NAME%" -out root\root.csr

rem --------------------------------------------------------
rem make crt file(root.crt)
rem --------------------------------------------------------
date 04-29-2023
time 12:00:00.00
openssl x509 -req -days 3653 -extensions v3_ca -set_serial 1 -in root/root.csr -signkey root\root.key -out root\root.crt
rem rdate -s time.bora.net

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
