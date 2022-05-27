#!/usr/bin/env bash


sudo apt update
sudo apt install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo "export PYENV_VIRTUALENV_DISABLE_PROMPT=1" >> ~/.zshrc
echo "export PYENV_ROOT=\"\$HOME/.pyenv\"" >> ~/.zshrc
echo "export PATH=\"\$PYENV_ROOT/bin:$PATH\"" >> ~/.zshrc
echo "eval \"\$(pyenv init --path)\"" >> ~/.zshrc
echo "eval \"\$(pyenv init -)\"" >> ~/.zshrc

source ~/.zshrc

git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

source ~/.zshrc

pyenv install 3.8.9
pyenv global 3.8.9

pyenv virtualenv default
echo 'pyenv activate default' >> ~/.zshrc
pyenv activate default
pip install --upgrade pip wheel
pip install jupyter ipdb

mkdir -p ~/.jupyter
cp ./jupyter_notebook_config.py ~/.jupyter/
