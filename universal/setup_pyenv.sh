#!/usr/bin/env bash



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
pyenv global default
pip install --upgrade pip wheel
pip install jupyter ipdb

mkdir -p ~/.jupyter
cp ./jupyter_notebook_config.py ~/.jupyter/
