#!/bin/bash

choco install python3
echo '======== GREP'
grep python3 /c/ProgramData/chocolatey/logs/chocolatey.log
echo '======== TAIL'
tail -n100 /c/ProgramData/chocolatey/logs/chocolatey.log
echo '======== FIND'
find /c/ProgramData/chocolatey -name 'python*'
echo '======== FIND TARGETDIR'
find /c/Python38 -type f
exit 4

