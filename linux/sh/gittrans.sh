#!/bin/bash

# 该脚本实现git仓库地址的转义
# 安装用法：gittrans.sh @i 
# 卸载用法：gittrans.sh @u

oriBin="git@real"
oriHost="https://github.com/"
#stubHost="file:///local.git/"
stubHost="https://github.com.cnpmjs.org/"

function patchModules()
{
    if [ -f "$PWD/.gitmodules" ]
    then
        if [ ! -f $PWD/.gitmodules.ori ]
        then
            cp $PWD/.gitmodules $PWD/.gitmodules.ori
        fi

        exec < $PWD/.gitmodules
        cat /dev/null > $PWD/.gitmodules.stub
        while read line; do
            echo "${line/$oriHost/$stubHost}" >> $PWD/.gitmodules.stub
        done
        cp -f $PWD/.gitmodules.stub $PWD/.gitmodules
    fi
}

function changeCmdLine()
{
    patchModules

    destArgs=
    for arg in $*
    do
        destArgs="$destArgs ${arg/$oriHost/$stubHost}"
    done
    echo \$ real command: $oriBin $destArgs #>& 2
    $oriBin $destArgs
}

if [ "$1" == "@" ]; then
    destArgs=
    for arg in $*
    do
        if [ "$arg" != "@" ]
        then
            destArgs="$destArgs $arg"
        fi
    done
    $oriBin $destArgs
elif [ "$1" == "@i" ]; then
    echo Installing...
    if [ ! -f /usr/bin/$oriBin ]; then
        mv -f /usr/bin/git /usr/bin/$oriBin
    fi
    if [ -f /usr/bin/git ]; then
        rm -f /usr/bin/git
    fi
    ln -s $(readlink -f $BASH_SOURCE) /usr/bin/git
    chmod 777 /usr/bin/git
    git @test
elif [ "$1" == "@u" ]; then
    echo Uninstalling...
    if [ -f /usr/bin/$oriBin ]; then
        rm -f /usr/bin/git
        ln -s /usr/bin/$oriBin /usr/bin/git
        chmod 777 /usr/bin/git
        git --version
    fi
elif [ "$1" == "@test" ]; then
    echo git stub installed!
else
    changeCmdLine $*
fi
