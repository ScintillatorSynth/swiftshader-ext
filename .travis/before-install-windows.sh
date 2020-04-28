#!/bin/bash

choco install python3
ls -la /c/ProgramData/chocolatey/bin
grep python3 /c/ProgramData/chocolatey/logs/chocolatey.log
tail -n100 /c/ProgramData/chocolatey/logs/chocolatey.log
exit 4

