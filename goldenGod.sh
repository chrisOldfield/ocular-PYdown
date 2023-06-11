#!/bin/bash

# Check if WSL is installed
if [ -n "$(command -v wsl.exe)" ]; then
    echo "WSL is installed. Please run this script from the Windows host environment, not from WSL."
    exit 1
fi

# Update WSL version to WSL 2
wsl --set-default-version 2

# Install Ubuntu from Microsoft Store (if not installed)
if [ -z "$(wsl.exe -l | grep Ubuntu)" ]; then
    echo "Ubuntu is not installed. Please install Ubuntu from the Microsoft Store."
    exit 1
fi

# Update Ubuntu packages
wsl.exe --distribution Ubuntu --exec "sudo apt update && sudo apt upgrade -y"

# Install Python 3
wsl.exe --distribution Ubuntu --exec "sudo apt install -y python3 python3-pip"

# Download and install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/miniconda
echo 'export PATH=~/miniconda/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install GCC and other build dependencies
wsl.exe --distribution Ubuntu --exec "sudo apt install -y build-essential"

# Install CUDA Toolkit for WSL 2
wget https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/cuda_11.5.0_495.29.05_linux.run -O ~/cuda_installer.run
chmod +x ~/cuda_installer.run
wsl.exe --distribution Ubuntu --exec "~/cuda_installer.run --toolkit --override --silent"
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# Install TensorFlow
pip install tensorflow

# Clean up installer files
rm ~/miniconda.sh
rm ~/cuda_installer.run
