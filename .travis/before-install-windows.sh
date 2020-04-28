#!/bin/bash

# psutils is to pick up shasum, which for some reason is not included in git bash on Travis
choco install python3 psutils
which shasum
exit 4