#!/bin/bash

# ref: https://owensd.io/2017/04/28/travis-ci-swift-oslinux-config/

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
	DIR="$(pwd)"
	cd ~/
	export SWIFT_VERSION=swift-5.2.4
    wget https://swift.org/builds/${SWIFT_VERSION}-release/ubuntu1804/${SWIFT_VERSION}-RELEASE/${SWIFT_VERSION}-RELEASE-ubuntu18.04.tar.gz
	tar xzf $SWIFT_VERSION-RELEASE-ubuntu18.04.tar.gz
    export PATH="${PWD}/${SWIFT_VERSION}-RELEASE-ubuntu18.04/usr/bin:${PATH}"
    echo "* ~/.bashrc"
    cat ~/.bashrc

    echo "*~/.profile"
    cat ~/.profile

    echo "export PATH=\"${PWD}/${SWIFT_VERSION}-RELEASE-ubuntu18.04/usr/bin:\${PATH}\"" >> ~/.bashrc
	cd "$DIR"
    swift -version
    echo "* Home Folder"
    ls -lFa ~/
    echo "* Environment"
    env
    echo "* Done install"
else
	#export SWIFT_VERSION=swift-3.1.1-RELEASE
    #curl -O https://swift.org/builds/swift-3.1.1-release/xcode/${SWIFT_VERSION}/${SWIFT_VERSION}-osx.pkg
	#sudo installer -pkg ${SWIFT_VERSION}-osx.pkg -target /
	#export TOOLCHAINS=swift
    echo "TODO: Not available"
    env
    false
fi
