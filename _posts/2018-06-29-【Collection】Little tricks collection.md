---
layout: post
title: Little tricks collection
excerpt_separator: <!--more-->
---

- [Interactive data visualization in Jupyternotebook](#interactive-data-visualization-in-jupyternotebook)
- [Edit Complex Matlab Figures in Illustrator](#edit-complex-matlab-figures-in-illustrator)
- [Load 16bit tiff images in python](#load-16bit-tiff-images-in-python) 


<!--more-->
## Load 16bit tiff images in python
Many high resolution scitific images are stored in the format of 16 bit tiff. The most famous python package in handling images are Pillow. However, pillow only support 8bit tiff images. I have explored two solutions that can load 16bit tiff in python. One is openCV and one is scikit-image.

#### Scikit-image
The following commands will give us a 2D numpy array.
```python
import skimage.io
im = skimage.io.imread(filename, plugin='tifffile')
````
The skimage is short for scikit-image. It can be installed in conda envirenment by 
```bash
conda install scikit-image
```
#### OpenCV solution
The following commands will give us a 2D numpy array.
```python
import cv2
im = cv2.imread(filename)
```
As openCV is not well-maintained in conda envirenment of python 3.6, I personally recommend scikit-image solution. 

## Interactive data visualization in Jupyternotebook
Data visualization in Jupyter Notebook lacks support for interactive feature. Recently, a python library named plotly.py solves the problem.


A introduction of pltly.py is avaliable [here](https://medium.com/@plotlygraphs/introducing-plotly-py-3-0-0-7bb1333f69c6)




## Edit Complex Matlab Figures in Illustrator

If a figure is too complex, MATLAB will generate an embedded version of the origin image even when we export them as svg or eps. 
The embedded version is just like bmp image and lose the rich editable feature of vector image. Here, I'll describe some simple steps that can export the editable vector version of MATLAB figures into Illustrator. 

In figure window, choose the export setup. 
![Export1](/images/Matlab2Illustrator_1.png "Export Setting")


In export setup window,go to rendering and check "Custom renderer" as shown in image below.
![Export2](/images/Matlab2Illustrator_2.png "Export Setting")

After doing this, either copying or exporting figure to svg/eps will generate fully editable vector image. 


