#!/usr/bin/env bash

brew install emacs-mac

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install

cp ../universal/.doom.d/*.el ~/.doom.d/