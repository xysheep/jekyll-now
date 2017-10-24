---
layout: post
title: Set up deep learning system for Windows 
excerpt_separator: <!--more-->
---
To prepare deep learning system in Windows with Nvidia GPU, we need to install the following prerequisite with **Administrator access**.
<!--more-->


- [Nvidia driver](#install-nvidia-driver)
- [Microsoft Visual C++ Redistributable](#Visual-C-Redistributable)
- [Cuda toolkit](#install-cuda-toolkit)
- [CuDNN](#install-cudnn)
- [Install conda: Anaconda/miniconda](#install-conda)

**Above prerequisite is for all users** and just need to do once for each PC.

Then, we set up conda for **each user** without administrator access:
- [Create a conda environment](#create-a-conda-environment)
+ [Install deep learning platforms](#install-deep-learning-platforms)
  - [Tensorflow](#tensorflow)
  - [Keras](#keras)
  - [pytorch](#pytorch)
  - [cntk (used as backend of Keras)](#cntk)
+ [Trouble Shooting](#trouble-shooting)
  - [unexpected keyword argument error in pip](#unexpected-keyword-argument-error-in-pip)
  - [opencv](#opencv)


## Install Prerequisite
This section is for all account and require **administrator access**.
### Install Nvidia driver
To download GPU driver, we can 
- Go to this [link](http://www.nvidia.com/Download/index.aspx "link")
- Choose our GPU/operation, and click serach.
- Download the correspond driver. For a Windows 10 with GTX Titan X, the newest driver name should be **388.00-desktop-win10-64bit-international-whql.exe** as date of 2017-10-24.
- Move to the folder that the driver downloaded and double click it to install.

### Install Visual C Redistributable
Download [this link](https://go.microsoft.com/fwlink/?LinkId=746572) and double click it to install. Restart the Operation system after installation complete.
### Install Cuda toolkit
Cuda 9.0 is recently released, unfortunately however, most **dl platform currently only support cuda 8.0**. Therefore, we need to install older verion. 
- Download the archived release from [here](https://developer.nvidia.com/cuda-toolkit-archive). 
- Pick up the operation system. As date of 2017-10-24, we can choose **cuda 8.0 GA2** and download both files. Their filename should be **cuda_8.0.61_win10.exe** and **cuda_8.0.61.2_windows.exe**. 
- Double click them to install. Install **cuda_8.0.61_win10.exe** first and then **cuda_8.0.61.2_windows.exe**.
- We might encouter a warning saying the cuda version is not compatible with our driver, just ignore it.

More details about installing cuda is avaliable [here](http://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html)
### Install cuDNN
After downloaded Nvidia driver and Cuda toolkit, we can install cnDNN. 
- Newest version of cuDNN can be downloaded from [here](https://developer.nvidia.com/cudnn), people need to register before downloading them. We can download the **cuDNN v7.0 Library for CUDA 8.0 for Windows 10**, this link will give us a file named "**cudnn-8.0-windows10-x64-v7.zip**". 
- Unzip and you will get three folders "bin", "include", and "lib". 
- Copy the three folders to "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v8.0". 
- Go the the "bin" folder and copy "cudnn64_7.dll" file. Rename the copied file to "cudnn64_6.dll". 

More details about installing cuDNN is avaliable [here](http://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#install-windows). 

### Install Conda
Usually, to avoid any package conflictions between different platforms or users, we expect to establish independent environment for different users, platforms, or projects. Conda is a **package**, **dependency**, and **environment** management platform that can easily achieve this goal. We also can use it to easily manage and use different version of softwares.

To install conda, we have two options: **anaconda** and **miniconda**. Compare to miniconda, anaconda has more preinstalled packages. Here, take miniconda as an example: 
- Download miniconda from [this link](https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe),
- Double click to install it.
- During installation, choose install conda for all users.
- During installation, choose include conda in PATH to use it in cmd (ignore the warning).

## Set up deep learning environment
This section is user specific.

### Create a conda environment
Then, we can create a new conda environment. As an example, we create a environment named "**tf**"(any other name is OK) using the following script.
```
conda create -name tf python=3.6
```
After creating a env, we can enter this env by:
```
activate tf
```
After entering the env, we can install packages (take installing numpy as an example) for this env by:
```
conda install numpy
```
We can install most other python packages like scipy, scikit-learn in this way without warrying about dependencies. 
Install through **conda** is usually **better than** from **pip** because of less conflicts and more comprehensize dependencies.
### Install deep learning platforms
We can install any of the following platforms we like. I recommend to create an independent conda env for each platform (except Keras).
#### Tensorflow
After creating a env named **tf** in [above section](#create-a-conda-environment), we can enter that environment by the following command:
```
activate tf
```
And install the newest GPU version of tensorlfow by following script. For tensorflow, we have to use "pip install" instead of "conda install".
```
pip install --ignore-installed tensorflow-gpu
```
#### pytorch
Pytorch is community-supported in Windows. After entering a conda env, simply type the following command:
```
conda install -c peterjc123 pytorch
```
#### Keras
Before installing Keras, we need to have at least one of [tensorflow](#Tensorflow) or [CNTK](#CNTK) installed as backend (Theano is not recommended) in our conda env. At the same conda env, we can use the following command to install Keras.
```
pip install keras
```
If this doesn't work (for any reason), try the alternative command:
```
conda install -c conda-forge keras
```
After installing keras, we need to pick a backend. Keras use tensorflow by default. We can change it by editing the "~/.keras/keras.json" file. ~ is the path of user folder.
#### CNTK
CNTK, though not very popular, is a great option for Keras backend because it runs faster than current version of tensorflow. It can be downloaded and installed by the following commands (after entering a conda env).
```
pip install https://cntk.ai/PythonWheel/GPU/cntk-2.2-cp36-cp36m-win_amd64.whl
```
### Trouble Shooting
#### Unexpected keyword argument error in pip
This occurs after installing tensorflow because tensorflow downgrade html5lib to an older version. Need to update html5lib to fix this issue. Run the following command:
```
conda install html5lib
```
#### opencv
For python 3.6, opencv cannot be directly installed by using
```
conda install opencv
```
Instead, we need to the following script.
```
conda install -c menpo opencv3
```
However, this is still not guranteed to work, we might want to do some Google to search for new options, for example, install a pre-complied whl file by pip.

