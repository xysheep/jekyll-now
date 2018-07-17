---
layout: post
title: Edit Complex Matlab Figures in Illustrator
excerpt_separator: <!--more-->
---
If a figure is too complex, MATLAB will generate an embedded version of the origin image even when we export them as svg or eps. 
The embedded version is just like bmp image and lose the rich editable feature of vector image. Here, I'll describe some simple steps that can export the editable vector version of MATLAB figures into Illustrator. 
<!--more-->

In figure window, choose the export setup. 
![Export Setting](/images/Matlab2Illustrator_1.png"Export Setting")


In export setup window,go to rendering and check "Custom renderer" as shown in image below.
![Export Setting](/images/Matlab2Illustrator_2.png"Export Setting")

After doing this, either copying or exporting figure to svg/eps will generate fully editable vector image. 