#!/bin/bash
cat "$0"

if grep -q '/vagrant/live-linux.* nodev' /proc/mounts ; then
    echo "Remount vagrant dir"
    sudo mount -i -o remount,rw,exec,dev /vagrant/live-linux
fi

if ! which lb ; then
    export LIVE_BUILD_SRC_PATH=~/live-build
    if ! test -d "${LIVE_BUILD_SRC_PATH}"; then
        echo "[Info] Install live-build"
        GIT_CURL_VERBOSE=1 git clone --ipv4 https://github.com/EvgeniyBlinov/live-build.git ${LIVE_BUILD_SRC_PATH}
        cd "${LIVE_BUILD_SRC_PATH}"
        git checkout blinov

        make test && ( make install || true )
    fi
fi
