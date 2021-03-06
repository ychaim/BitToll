#!/bin/bash

#Programs to install:
# Haskell compiler etc..
sudo pacman -S cabal-install
cabal-install cabal-dev
# Python for the testsuite
sudo pacman -S python2-pip cabal-dev python2-fabric python2-requests
sudo pip2 install pytest

#Also need vagrant. If you have aura this might work
#sudo aura -Ak vagrant

#How to actually test

#1st set the vm host name
echo "192.168.56.2    vm  " >> /etc/hosts

#then bring up the vagrant box
vagrant up

#Then run the testsuite
py.test testsuite/ -s

#Random Useful notes
# We only lock when we are decrementing. Increments are always safe since balance won't go negative
