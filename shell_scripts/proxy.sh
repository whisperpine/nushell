#!/bin/sh

# Setup proxy in CLI

BASEDIR=$(dirname "$0")
CUSTOM_FILE=$BASEDIR/custom.sh

source $CUSTOM_FILE

if [ -z $PORT ]; then
    echo "\$PORT is null"
    echo "\$PORT should be set in $CUSTOM_FILE"
    exit 1
fi

PROXY_HTTP="http://localhost:${PORT}"

set_proxy() {
    export all_proxy="${PROXY_HTTP}"
    export ALL_PROXY="${PROXY_HTTP}"

    git config --global http.https://github.com.proxy "${PROXY_HTTP}"
    git config --global https.https://github.com.proxy "${PROXY_HTTP}"

    echo "Proxy has been opened."
    echo "Port:" $PORT
    check_status
}

unset_proxy() {
    unset all_proxy
    unset ALL_PROXY

    git config --global --unset http.https://github.com.proxy
    git config --global --unset https.https://github.com.proxy

    echo "Proxy has been closed."
}

check_status() {
    echo "Try to connect to Google..."
    RESP=$(curl -I -s --connect-timeout 5 -m 5 -w "%{http_code}" -o /dev/null www.google.com)
    if [ ${RESP} = 200 ]; then
        echo "Proxy setup succeeded!"
    else
        echo "Proxy setup failed!"
    fi
}

help_msg() {
    echo "Please set alias 'proxy' in advance."
    echo "Suported arguments:"
    echo "  set     setup proxy and check status"
    echo "  unset   unset proxy"
    echo "  status  check whether proxy is setup"
    echo "  help    print help message"
}

if [ "$1" = "set" ]; then
    set_proxy
elif [ "$1" = "unset" ]; then
    unset_proxy
elif [ "$1" = "status" ]; then
    check_status
elif [ "$1" = "help" ]; then
    help_msg
elif [ "$1" = "--help" ]; then
    help_msg
elif [ "$1" = "" ]; then
    help_msg
else
    echo "Unsupported arguments."
fi
