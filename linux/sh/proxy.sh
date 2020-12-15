# 该脚本实现代理服务器的配置和关闭

if [ "$1" = "n" ]
    then
    export http_proxy=
    export https_proxy=
    echo Proxy unset
elif [ "$1" = "y" ]
    then
    export http_proxy=http://192.168.2.152:5717
    export https_proxy=http://192.168.2.152:5717
    echo Proxy setup
else
    echo Unknow parameter
fi
