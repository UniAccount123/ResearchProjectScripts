#!/bin/bash

[ "$#" -lt 1 ] && { echo "Usage: create_env.sh <name> <py ver>"; exit 1; }

base=$(pwd)
env=$1

# Newest python
if [ "$#" -ge 2 ]; then
	module load "python/$2"
fi

python -m venv "envs/$env"

source "envs/$env/bin/activate"
pip install ipykernel ipywidgets wheel setuptools

if [ -e "$base/envs/$env.txt" ]; then
	pip install -r "envs/$env.txt"
fi

pip install -e package/

python -m ipykernel install --user --name=$env
rm -r "$base/envs/jupyter/share/jupyter/kernels/$env"
mv "$HOME/.local/share/jupyter/kernels/$env" "$base/envs/jupyter/share/jupyter/kernels/"

echo "... And moved to $base/envs/jupyter/share/jupyter/kernels/"
