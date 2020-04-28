#!/bin/bash

mkdir -p $HOME/python3
choco install python3 --params "/InstallDir:$HOME/python3"
ls -la $HOME/python3
exit 4

