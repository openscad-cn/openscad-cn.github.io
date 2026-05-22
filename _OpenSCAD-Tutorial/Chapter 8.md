---
layout: post
title:  "第八章 拉伸"
nav_order: 8
---

# 第八章 拉伸
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 通过旋转拉伸从2D对象创建3D对象

到目前为止，您已经创建了许多模型并定制了汽车设计，同时培养了扎实的参数化建模技能并探索了 OpenSCAD 的不同功能。令人印象深刻的是，您所创建的每个模型都只使用了三个基本原始体：球体、立方体和圆柱体。通过将这些原始体与变换命令相结合，您可以创建大量模型，但仍有一些模型无法仅通过这些原始体创建。例如，下图所示的轮子设计。

![甜甜圈形状的对象](/assets/images/Donut_shaped_object.jpg)

该轮子设计需要创建一个看起来像甜甜圈的对象。这种甜甜圈形状的对象无法通过球体、立方体和圆柱体创建。相反，它需要使用2D原始体和一种可以从2D轮廓生成3D形状的新命令。

---

{: .code-title }
>**文件名：** `circular_profile.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 12;
>tire_diameter = 6;
>translate([wheel_radius - tire_diameter/2, 0])
>    circle(d=tire_diameter);
>```

![圆形轮廓](/assets/images/Circular_profile.jpg)

---

{: .code-title }
>**文件名：** `extruded_donut.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 12;
>tire_diameter = 6;
>rotate_extrude(angle=360) {
>    translate([wheel_radius - tire_diameter/2, 0])
>        circle(d=tire_diameter);
>}
>```

![拉伸的甜甜圈](/assets/images/Extruded_donut.jpg)

![60度拉伸甜甜圈](/assets/images/Extruded_donut_60_degrees.jpg)

![270度拉伸甜甜圈](/assets/images/Extruded_donut_270_degrees.jpg)

---

{: .new }
>- 2D轮廓通常位于 X-Y 平面，并定义在 X ≥ 0 且 Z = 0 的区域。
>- `rotate_extrude` 命令接受一个2D轮廓作为输入，并通过围绕 Y 轴旋转该轮廓生成3D对象。

---

{: .ex }
完成新的轮子设计，定义缺失的圆柱体对象。

![完整轮廓](/assets/images/Complete_profile.jpg)

---

{: .ex }
为了使该轮子与之前章节中的模型兼容，将其绕 X 轴旋转 90 度。

---

{: .ex }
上述轮子是轴对称对象。通过提供整个对象的2D轮廓并使用单个 `rotate_extrude` 创建轴对称对象。

![机器人轮辋](/assets/images/Robot_rim.jpg)

![从轮廓差集创建的机器人轮辋](/assets/images/Robot_rim_from_profile_difference.jpg)

![从3D对象差集创建的机器人轮辋](/assets/images/Robot_rim_from_3d_object_difference.jpg)

---

## 从2D对象线性拉伸创建3D对象

OpenSCAD 还提供了 `linear_extrude` 命令，可用于从提供的2D轮廓创建3D对象。与 `rotate_extrude` 命令不同，`linear_extrude` 通过沿 Z 轴拉伸位于 XY 平面的2D轮廓来创建3D对象。

![椭圆轮廓](/assets/images/Ellipse_profile.jpg)

![拉伸的椭圆](/assets/images/Extruded_ellipse.jpg)

![居中拉伸](/assets/images/Centered_extrusion.jpg)

![带扭曲的拉伸](/assets/images/Extrusion_with_twist.jpg)

![带扭曲和缩放的拉伸](/assets/images/Extrusion_with_twist_and_scale.jpg)

---

{: .ex }
使用 `linear_extrude` 命令创建汽车车身。

![拉伸的汽车车身](/assets/images/Extruded_car_body.jpg)

![圆角拉伸汽车车身](/assets/images/Rounded_extruded_car_body.jpg)

![使用圆角拉伸车身的汽车](/assets/images/Car_with_rounded_extruded_body.jpg)

---

如前所述，`rotate_extrude` 和 `linear_extrude` 命令还可用于创建更抽象的对象。这种能力可以通过使用 `polygon` 2D原始体实现，您将在下一章学习到。
