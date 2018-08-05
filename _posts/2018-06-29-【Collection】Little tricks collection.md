---
layout: post
title: Little tricks collection
excerpt_separator: <!--more-->
---

- [Interactive data visualization in Jupyternotebook](#interactive-data-visualization-in-jupyternotebook)
- [Edit Complex Matlab Figures in Illustrator](#edit-complex-matlab-figures-in-illustrator)

<!--more-->
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