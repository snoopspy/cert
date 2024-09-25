@echo off

rem --------------------------------------------------------
rem usage   : _test_site <base file name>
rem example : _test_site foo.com
rem --------------------------------------------------------
if "%1"=="" goto usage
set COMMON_NAME=%1

# --------------------------------------------------------
# run server
# --------------------------------------------------------
openssl s_server -key %BASE_FILE_NAME%.key -cert %BASE_FILE_NAME%.crt -accept 443 -www

:usage
echo "usage   : _test_site <base file name>"
echo "example : _test_site foo.com"
goto eof

:eof
