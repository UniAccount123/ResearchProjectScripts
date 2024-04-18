#!/bin/bash

base=$(pwd)
PLSSVM="$base/plssvm-develop"
cmake="$base/cmake/bin/cmake"

module load python/3.10.4
module load cuda/12.0.1

# Setup Cmake
if [ ! -e "$base/cmake" ]; then
	wget "https://github.com/Kitware/CMake/releases/download/v3.28.3/cmake-3.28.3-linux-x86_64.tar.gz"
	tar -xzf "cmake-3.28.3-linux-x86_64.tar.gz"
	mv "cmake-3.28.3-linux-x86_64" "cmake"
	rm "cmake-3.28.3-linux-x86_64.tar.gz"
fi

# Setup PLSSVM
if [ ! -e "$base/PLSSVM" ]; then
	git clone --depth 1 -b develop https://github.com/SC-SGS/PLSSVM.git "PLSSVM"
	
	build="PLSSVM/build"
	mkdir -p "$build"
	
	# rm -fr "envs/plssvm-build"
	python -m venv "envs/plssvm-build"
	source "envs/plssvm-build/bin/activate"
	pip install wheel setuptools
	pip install -r "PLSSVM/install/python_requirements.txt"
	
	$cmake -B "$build" -DPLSSVM_TARGET_PLATFORMS="nvidia:sm_86" -DPLSSVM_ENABLE_LANGUAGE_BINDINGS=ON PLSSVM
	$cmake --build "$build" -j
	
	cp -r "$build/_deps/fmt-src/include/fmt" "PLSSVM/include" # Install bug workaround
	$cmake --install "$build" --prefix "$PLSSVM"

	deactivate
fi

# Setup LightGBM
if [ ! -e "$base/LightGBM" ]; then
	git clone --depth 1 --recursive https://github.com/microsoft/LightGBM "LightGBM"

	build="LightGBM/build"

	mkdir "$build"
	$cmake -B "$build" -DUSE_GPU=1 LightGBM
	$cmake --build "$build" -j
fi

# Setup Jupyter IDE
if [ ! -e "$base/envs/jupyter" ]; then
	python -m venv "envs/jupyter"
	source "envs/jupyter/bin/activate"
	pip install jupyterlab jupyterlab-optuna
	deactivate
fi

# Setup Envs
if [ ! -e "$base/envs/plssvm" ]; then
	./create_env.sh plssvm
fi
if [ ! -e "$base/envs/lightgbm" ]; then
	./create_env.sh lightgbm
	source "envs/lightgbm/bin/activate"
	cd LightGBM
	./build-python.sh install --precompile
	cd "$base"
	deactivate
fi
if [ ! -e "$base/envs/xgboost" ]; then
	./create_env.sh xgboost
fi
if [ ! -e "$base/envs/svm" ]; then
	./create_env.sh svm
fi
