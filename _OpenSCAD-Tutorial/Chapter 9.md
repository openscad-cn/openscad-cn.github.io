---
layout: post
title:  "第九章 数学与几何建模"
nav_order: 9
---

# 第九章 数学与几何建模
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 在 OpenSCAD 中进行数学计算

到目前为止，您已经了解到 OpenSCAD 中的变量在脚本执行期间只能保存一个值，即最后分配给它们的值。您还学会了 OpenSCAD 变量的一个常见用途是为模型提供参数化功能。

---

{: .code-title }
>**文件名：** `axle_with_wheelset.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>
>wheelbase = 40;
>track = 35;
>
>translate([-wheelbase/2, track/2])
>    simple_wheel();
>translate([-wheelbase/2, -track/2])
>    simple_wheel();
>translate([-wheelbase/2, 0, 0])
>    axle(track=track);
>```

![带轮组的车轴](/assets/images/Axle_with_wheelset.jpg)

---

在 OpenSCAD 中，您可以使用正弦和余弦函数将极坐标转换为直角坐标，从而在圆形模式中正确放置汽车。

![圆形排列的汽车](/assets/images/Circular_pattern_of_cars.jpg)

![汽车模型](/assets/images/Car_model.jpg)

---

## 使用 polygon 原始体创建任意 2D 对象

除了 `circle` 和 `square` 2D 原始体外，OpenSCAD 还提供了一个 `polygon` 原始体，可以用来设计几乎任何 2D 对象。

![Profile 1 图纸](/assets/images/Profile_1_drawing.jpg)

![Profile 1 多边形](/assets/images/Profile_1_polygon.jpg)

---

{: .ex }
使用 `polygon` 原始体创建以下 2D 对象。

![Profile 2 图纸](/assets/images/Profile_2_drawing.jpg)

![Profile 2 多边形](/assets/images/Profile_2_polygon.jpg)

---

{: .ex }
使用 `linear_extrude` 和 `rotate_extrude` 命令分别创建一个管和一个环。

![线性拉伸的多边形](/assets/images/Linearly_extruded_polygon.jpg)

![旋转拉伸的多边形](/assets/images/Rotationaly_extruded_polygon.jpg)

---

接下来，使用您的新技能创建一个 UwU 赛车！

![赛车车身](/assets/images/Racing_car_body.jpg)

![赛车](/assets/images/Racing_car.jpg)

![爱心模型](/assets/images/Heart_model.jpg)

![低多边形爱心](/assets/images/Heart_low_poly.jpg)

---
