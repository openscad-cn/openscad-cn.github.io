---
layout: post
title:  "3D形状"
nav_order: 1.2
---
# 3D形状

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 基本形状 / Primitives

OpenSCAD 提供了三种内置的 3D 基本形状：`cube()`、`cylinder()` 和 `sphere()`。  
BOSL2 库对这些形状进行了扩展，并提供了替代方案，使其支持更多功能以及更简单的重新定位方式。



## 3D 立方体 / 3D Cubes

BOSL2 重写了内置的 `cube()` 模块。你仍然可以按照内置模块的方式使用它：


```openscad
include <BOSL2/std.scad>
cube(100);
```

```openscad
include <BOSL2/std.scad>
cube(100, center=true);
```

```openscad
include <BOSL2/std.scad>
cube([50,40,20], center=true);
```

它还被增强，允许你对其进行锚定（anchor）、旋转（spin）、定向（orient）和附加（attach）。

你可以像在 `rect()` 或 `oval()` 中使用 `anchor=` 一样使用它，不同之处在于，你还可以在 3D 中垂直锚定，从而支持锚定到面、边和角：


```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=BOTTOM);
```

```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=TOP+BACK);
```

```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=TOP+FRONT+LEFT);
```

你可以使用 `spin=` 参数在锚定后围绕 Z 轴旋转：

```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=FRONT, spin=30);
```

3D 对象还可以通过 `orient=` 参数指定一个向量，用于指向形状顶部应该旋转到的位置。

```openscad
include <BOSL2/std.scad>
cube([50,40,20], orient=UP+BACK+RIGHT);
```

如果同时使用 `anchor=`、`spin=` 和 `orient=`，操作顺序是：先执行锚定（anchor），然后旋转（spin），最后定向（orient）：

```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=FRONT);
```

```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=FRONT, spin=45);
```

```openscad
include <BOSL2/std.scad>
cube([50,40,20], anchor=FRONT, spin=45, orient=UP+FWD+RIGHT);
```

BOSL2 提供了一个 `cuboid()` 模块，在 `cube()` 的基础上进行了扩展，增加了边缘圆角和斜切功能。你可以像使用 `cube()` 一样使用它，不同的是 `cuboid()` 默认是居中的。

你可以通过 `rounding=` 参数为边缘添加圆角：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20);
```

同样地，你可以通过 `chamfer=` 参数对边缘进行斜切：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], chamfer=10);
```

你可以通过使用 `edges=` 参数仅对某些边进行圆角处理。该参数可以接受多种类型的值。如果传递的是指向某个面的向量，那么它将只对该面周围的边进行圆角处理：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges=TOP);
```

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges=RIGHT);
```

如果你为 `edges=` 提供一个指向角的向量，它将对该角处交汇的所有边进行圆角处理：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges=RIGHT+FRONT+TOP);
```

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges=LEFT+FRONT+TOP);
```

如果你为 `edges=` 提供一个指向某条边的向量，它将仅对那条边进行圆角处理：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges=FRONT+TOP);
```

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges=RIGHT+FRONT);
```

如果你传递字符串 "X"、"Y" 或 "Z" 给 `edges=`，则所有与指定轴对齐的边都将被圆角处理：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges="X");
```

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges="Y");
```

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges="Z");
```

如果你提供一个边规格的列表给 `edges=`，则列表中引用的所有边都会被圆角处理：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges=[TOP,"Z",BOTTOM+RIGHT]);
```

`edges=` 的默认值是 `EDGES_ALL`，即对所有边进行圆角处理。你还可以使用 `except_edges=` 参数，指定不需要进行圆角处理的边：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, except_edges=BOTTOM+RIGHT);
```

你可以为 `except_edges=` 参数提供任何 `edges=` 参数支持的类型：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, except_edges=[BOTTOM,"Z",TOP+RIGHT]);
```

你可以同时使用 `edges=` 和 `except_edges=`，以简化边的规格定义：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=10, edges=[TOP,FRONT], except_edges=TOP+FRONT);
```

你也可以用类似的方法指定需要斜切的边：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], chamfer=10, edges=[TOP,FRONT], except_edges=TOP+FRONT);
```

## 3D 圆柱 / 3D Cylinder

BOSL2 重写了内置的 `cylinder()` 模块。 你仍然可以按照内置模块的方式使用它：

```openscad
include <BOSL2/std.scad>
cylinder(r=50,h=50);
```

```openscad
include <BOSL2/std.scad>
cylinder(r=50,h=50,center=true);
```

```openscad
include <BOSL2/std.scad>
cylinder(d=100,h=50,center=true);
```

```openscad
include <BOSL2/std.scad>
cylinder(d1=100,d2=80,h=50,center=true);
```

你还可以像使用 `cuboid()` 模块一样，对其进行锚定（anchor）、旋转（spin）、定向（orient）和附加（attach）：

```openscad
include <BOSL2/std.scad>
cylinder(r=50, h=50, anchor=TOP+FRONT);
```

```openscad
include <BOSL2/std.scad>
cylinder(r=50, h=50, anchor=BOTTOM+LEFT);
```

```openscad
include <BOSL2/std.scad>
cylinder(r=50, h=50, anchor=BOTTOM+LEFT, spin=30);
```

```openscad
include <BOSL2/std.scad>
cylinder(r=50, h=50, anchor=BOTTOM, orient=UP+BACK+RIGHT);
```

BOSL2 提供了一个 `cyl()` 模块，在 `cylinder()` 的基础上进行了扩展，增加了边缘圆角和斜切功能。你可以像使用 `cylinder()` 一样使用它，不同的是 `cyl()` 默认将圆柱居中。


```openscad
include <BOSL2/std.scad>
cyl(r=60, l=100);
```

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100);
```

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, anchor=TOP);
```

你可以通过 `rounding=` 参数对边缘进行圆角处理：

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, rounding=20);
```

同样地，你可以通过 `chamfer=` 参数对边缘进行斜切处理：

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, chamfer=10);
```

你可以分别为圆柱的每个端面单独指定圆角和斜切：

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, rounding1=20);
```

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, rounding2=20);
```

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, chamfer1=10);
```

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, chamfer2=10);
```

你甚至可以将圆角和斜切混合使用：

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, rounding1=20, chamfer2=10);
```

```openscad
include <BOSL2/std.scad>
cyl(d=100, l=100, rounding2=20, chamfer1=10);
```


## 3D 球体 / 3D Spheres

BOSL2 重写了内置的 `sphere()` 模块。  你仍然可以按照内置模块的方式使用它：


```openscad
include <BOSL2/std.scad>
sphere(r=50);
```

```openscad
include <BOSL2/std.scad>
sphere(d=100);
```

你可以像使用 `cylinder()` 和 `cube()` 一样，对 `sphere()` 进行锚定（anchor）、旋转（spin）和定向（orient）：

```openscad
include <BOSL2/std.scad>
sphere(d=100, anchor=FRONT);
```

```openscad
include <BOSL2/std.scad>
sphere(d=100, anchor=FRONT, spin=30);
```

```openscad
include <BOSL2/std.scad>
sphere(d=100, anchor=BOTTOM, orient=RIGHT+TOP);
```

BOSL2 还提供了 `spheroid()` 模块，它在 `sphere()` 的基础上增加了一些功能，如 `circum=` 和 `style=` 参数：

你可以使用 `circum=true` 参数强制让球体外接理想球体，而不是默认的内接：

```openscad
include <BOSL2/std.scad>
spheroid(d=100, circum=true);
```

`style=` 参数可以选择球体的构造方式："orig" 样式与内置的 `sphere()` 构造方式一致。

```openscad
include <BOSL2/std.scad>
spheroid(d=100, style="orig", $fn=20);
```

"aligned" 样式会确保在每个坐标轴的极值点都有一个顶点，前提是 `$fn` 是 4 的倍数。

```openscad
include <BOSL2/std.scad>
spheroid(d=100, style="aligned", $fn=20);
```

"stagger" 样式会使垂直行的三角化呈交错排列：

```openscad
include <BOSL2/std.scad>
spheroid(d=100, style="stagger", $fn=20);
```

"icosa" 样式通过细分二十面体来生成整个球体表面近似等大的三角形。在构建球体时，此样式会将有效的 `$fn` 调整为 5 的倍数：

```openscad
include <BOSL2/std.scad>
spheroid(d=100, style="icosa", $fn=20);
```

"octa" 样式同样会为整个球体表面生成近似等大的三角形，但它是通过细分八面体实现的。这一样式的好处是能确保顶点位于坐标轴的极值点。在构建球体时，此样式会将有效的 `$fn` 调整为 4 的倍数：

```openscad
include <BOSL2/std.scad>
spheroid(d=100, style="octa", $fn=20);
```

