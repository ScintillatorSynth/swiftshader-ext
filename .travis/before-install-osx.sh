#!/bin/sh

export HOMEBREW_NO_ANALYTICS=1

brew update
brew unlink python@2
brew install ccache

export PATH="/usr/local/opt/ccache/libexec:$PATH"

