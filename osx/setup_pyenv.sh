#!/usr/bin/env bash

brew update
brew install openssl readline sqlite3 xz zlib tcl-tk
brew install pyenv
source ../universal/setup_pyenv.sh
