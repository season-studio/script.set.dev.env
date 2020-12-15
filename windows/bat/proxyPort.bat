@echo off
@rem 实现端口的转发
@rem 开启用法：proxyPort i 端口1 [端口2 [监听地址] ]
@rem 关闭用法：proxyPort u 端口1 [端口2 [监听地址] ]
if "%2" == "" (
    echo need port in argumnet 2
    goto LEnd
)
set port=%2
set bindport=%2
set addr=192.168.2.152
if "%3" == "" goto LStep1
set bindport=%3
:LStep1
if "%4" == "" goto LStep2
set addr=%4
:LStep2
if "%1" == "i" (
    netsh interface portproxy add v4tov4 listenaddress=%addr% listenport=%port% connectaddress=127.0.0.1 connectport=%bindport%
) else (
    netsh interface portproxy delete v4tov4 listenaddress=%addr% listenport=%port%
)
echo %ERRORLEVEL%
:LEnd
@echo on
