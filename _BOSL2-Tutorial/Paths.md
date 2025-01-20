---
layout: post
title:  "路径与区域"
nav_order: 2.1
---
# 路径与区域

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 路径/Paths

BOSL2 中的许多高级功能依赖于路径，它们只是点的有序列表。

首先，一些术语：
- 2D 点是由 X 和 Y 轴位置值组成的向量。例如：`[3,4]` 或 `[7,-3]`。
- 3D 点是由 X、Y 和 Z 轴位置值组成的向量。例如：`[3,4,2]` 或 `[-7,5,3]`。
- 2D 路径只是由两个或更多 2D 点组成的列表。例如：`[[5,7], [1,-5], [-5,6]]`
- 3D 路径只是由两个或更多 3D 点组成的列表。例如：`[[5,7,-1], [1,-5,3], [-5,6,1]]`
- 多边形是一个 2D（或平面 3D）路径，其中最后一个点默认连接到第一个点。
- 区域是由 2D 多边形组成的列表，每个多边形与其他多边形进行 XOR 操作。例如：如果一个多边形在另一个多边形内，则会在第一个多边形中创建一个孔。

### 描边/Stroke

路径可能难以可视化，因为它在源代码中只是一些数字。可视化路径的一种方法是将其传递给 `polygon()`：


```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
polygon(path);
```

然而，有时直接查看路径本身会更容易。为此，您可以使用 `stroke()` 模块。在最基本的情况下，`stroke()` 仅显示路径的线段：


```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path);
```

您可以使用 `width=` 参数来调整绘制路径的宽度：

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, width=3);
```

您可以通过提供一个宽度列表（每个点对应一个宽度）来调整路径上线段的长度：

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, width=[3,2,1,2,3]);
```

如果路径表示一个封闭的多边形，您可以使用 `closed=true` 以这种方式显示：

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, closed=true);
```

绘制路径的两端通常以“圆形”端帽结束，但还有其他选项可供选择：

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcaps="round");
```

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcaps="butt");
```

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcaps="line");
```

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcaps="tail");
```

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcaps="arrow2");
```

有关更多标准支持的端帽选项，请参阅 [`stroke()`](shapes2d.scad#stroke) 的文档。

起始端帽和结束端帽可以分别通过 `endcap1=` 和 `endcap2=` 单独指定：


```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcap1="butt", endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
stroke(path, endcap1="tail", endcap2="arrow");
```

端帽的大小将相对于放置端帽的线段宽度：

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
widths = [1, 1.25, 1.5, 1.75, 2];
stroke(path, width=widths, endcaps="arrow2");
```

如果标准端帽对您没有用处，您可以通过将路径传递给 `endcaps=`、`endcap1=` 或 `endcap2=` 参数来设计自己的端帽。  
您可能还需要提供 `trim=` 参数，以指定主线需要修剪的长度，从而使其呈现效果更好。  
端帽多边形中的值和 `trim=` 参数中的值相对于线宽，其中 1 表示一个线宽大小。

未修剪：


```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
dblarrow = [[0,0], [2,-3], [0.5,-2.3], [2,-4], [0.5,-3.5], [-0.5,-3.5], [-2,-4], [-0.5,-2.3], [-2,-3]];
stroke(path, endcaps=dblarrow);
```

已修剪：

```openscad
include <BOSL2/std.scad>
path = [[0,0], [-10,10], [0,20], [10,20], [10,10]];
dblarrow = [[0,0], [2,-3], [0.5,-2.3], [2,-4], [0.5,-3.5], [-0.5,-3.5], [-2,-4], [-0.5,-2.3], [-2,-3]];
stroke(path, trim=3.5, endcaps=dblarrow);
```

### 标准2D形状多边形/Standard 2D Shape Polygons

通过像调用函数一样调用它们，BOSL2 可以为几乎所有的标准2D形状生成其外边界多边形：


```openscad
include <BOSL2/std.scad>
path = square(40, center=true);
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = rect([40,30], rounding=5);
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = trapezoid(w1=40, w2=20, h=30);
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = circle(d=50);
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = ellipse(d=[50,30]);
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = pentagon(d=50);
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = star(n=5, step=2, d=50);
stroke(list_wrap(path), endcap2="arrow2");
```
### 弧形/Arcs

在构建路径时，您经常需要添加一个弧形。`arc()` 命令可以实现这一点：


```openscad
include <BOSL2/std.scad>
path = arc(r=30, angle=120);
stroke(path, endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = arc(d=60, angle=120);
stroke(path, endcap2="arrow2");
```

如果您提供 `n=` 参数，可以精确控制弧形被分成的点数：

```openscad
include <BOSL2/std.scad>
path = arc(n=5, r=30, angle=120);
stroke(path, endcap2="arrow2");
```

使用 `start=` 参数，您可以从 X+ 轴以外的其他位置开始绘制弧形：

```openscad
include <BOSL2/std.scad>
path = arc(start=45, r=30, angle=120);
stroke(path, endcap2="arrow2");
```

或者，您可以在 `angle=` 参数中以列表形式指定起始和结束角度：

```openscad
include <BOSL2/std.scad>
path = arc(angle=[120,45], r=30);
stroke(path, endcap2="arrow2");
```

`cp=` 参数允许您将弧的中心设置在原点以外的位置：

```openscad
include <BOSL2/std.scad>
path = arc(cp=[10,0], r=30, angle=120);
stroke(path, endcap2="arrow2");
```

弧形还可以通过弧上的三个点来定义：

```openscad
include <BOSL2/std.scad>
pts = [[-15,10],[0,20],[35,-5]];
path = arc(points=pts);
stroke(path, endcap2="arrow2");
```


### 乌龟绘图/Turtle Graphics

另一种创建路径的方法是使用 `turtle()` 命令。它实现了一种类似于 LOGO 乌龟绘图的简单路径描述语言。  
其概念是有一个虚拟的乌龟或光标沿路径行进。它可以向前或向后“移动”，或者原地“左转”或“右转”：


```openscad
include <BOSL2/std.scad>
path = turtle([
    "move", 10,
    "left", 90,
    "move", 20,
    "left", 135,
    "move", 10*sqrt(2),
    "right", 90,
    "move", 10*sqrt(2),
    "left", 135,
    "move", 20
]);
stroke(path, endcap2="arrow2");
```

乌龟/光标的位置和朝向会在每个命令之后更新。运动和转向命令还可以设置默认的距离或角度：


```openscad
include <BOSL2/std.scad>
path = turtle([
    "angle",360/6,
    "length",10,
    "move","turn",
    "move","turn",
    "move","turn",
    "move","turn",
    "move"
]);
stroke(path, endcap2="arrow2");
```

您可以使用 "scale" 来相对放大默认的运动长度：

```openscad
include <BOSL2/std.scad>
path = turtle([
    "angle",360/6,
    "length",10,
    "move","turn",
    "move","turn",
    "scale",2,
    "move","turn",
    "move","turn",
    "scale",0.5,
    "move"
]);
stroke(path, endcap2="arrow2");
```

可以使用 "repeat" 命令重复一系列命令：

```openscad
include <BOSL2/std.scad>
path=turtle([
    "angle",360/5,
    "length",10,
    "repeat",5,["move","turn"]
]);
stroke(path, endcap2="arrow2");
```

还有更复杂的命令，包括用于绘制弧形的命令：

```openscad
include <BOSL2/std.scad>
path = turtle([
    "move", 10,
    "left", 90,
    "move", 20,
    "arcleft", 10, 180,
    "move", 20
]);
stroke(path, endcap2="arrow2");
```

支持的乌龟命令的完整列表可以在 [`turtle()`](shapes2d.scad#turtle) 的文档中找到。

### 转换路径和多边形/Transforming Paths and Polygons

要平移路径，只需将其作为 `p=` 参数传递给 `move()`（或 up/down/left/right/fwd/back）函数：

```openscad
include <BOSL2/std.scad>
path = move([-15,-30], p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = fwd(30, p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = left(30, p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

要缩放路径，只需将其作为 `p=` 参数传递给 `scale()`（或 [xyz]scale）函数：

```openscad
include <BOSL2/std.scad>
path = scale([1.5,0.75], p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = xscale(1.5, p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = yscale(1.5, p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

要旋转路径，只需将其作为 `p=` 参数传递给 `rot()`（或 [xyz]rot）函数：

```openscad
include <BOSL2/std.scad>
path = rot(30, p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = zrot(30, p=square(50,center=true));
stroke(list_wrap(path), endcap2="arrow2");
```

要镜像路径，只需将其作为 `p=` 参数传递给 `mirror()`（或 [xyz]flip）函数：

```openscad
include <BOSL2/std.scad>
path = mirror([1,1], p=trapezoid(w1=40, w2=10, h=25));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = xflip(p=trapezoid(w1=40, w2=10, h=25));
stroke(list_wrap(path), endcap2="arrow2");
```

```openscad
include <BOSL2/std.scad>
path = yflip(p=trapezoid(w1=40, w2=10, h=25));
stroke(list_wrap(path), endcap2="arrow2");
```

您可以通过在没有 `p=` 参数的情况下调用它们（就像调用函数一样），获取各种变换的原始变换矩阵：

```openscad
include <BOSL2/std.scad>
mat = move([5,10,0]);
multmatrix(mat) square(50,center=true);
```

```openscad
include <BOSL2/std.scad>
mat = scale([1.5,0.75,1]);
multmatrix(mat) square(50,center=true);
```

```openscad
include <BOSL2/std.scad>
mat = rot(30);
multmatrix(mat) square(50,center=true);
```

原始变换矩阵可以相乘以预先计算复合变换。例如，要先缩放一个形状，然后旋转它，最后平移结果，您可以这样操作：

```openscad
include <BOSL2/std.scad>
mat = move([5,10,0]) * rot(30) * scale([1.5,0.75,1]);
multmatrix(mat) square(50,center=true);
```

要将复合变换矩阵应用于路径，可以使用 `apply()` 函数：

```openscad
include <BOSL2/std.scad>
mat = move([5,10]) * rot(30) * scale([1.5,0.75]);
path = square(50,center=true);
tpath = apply(mat, path);
stroke(tpath, endcap2="arrow2");
```


### 区域/Regions

多边形适合表示没有孔的单一封闭2D形状。对于更复杂的2D形状，您需要使用区域。  
区域是一个2D多边形的列表，其中每个多边形与其他多边形进行 XOR 操作。您可以使用 `region()` 模块显示一个区域。

如果一个区域中有一个多边形完全位于另一个多边形内部，就会形成一个孔：

```openscad
include <BOSL2/std.scad>
rgn = [square(50,center=true), circle(d=30)];
region(rgn);
```

如果一个区域包含多个彼此不包含的多边形，它们将形成多个不连续的形状：

```openscad
include <BOSL2/std.scad>
rgn = [
    move([-30, 20], p=square(20,center=true)),
    move([  0,-20], p=trapezoid(w1=20, w2=10, h=20)),
    move([ 30, 20], p=square(20,center=true)),
];
region(rgn);
```

区域中的多边形可以任意嵌套，形成多个不连续的形状：

```openscad
include <BOSL2/std.scad>
rgn = [
    for (d=[50:-10:10]) left(30, p=circle(d=d)),
    for (d=[50:-10:10]) right(30, p=circle(d=d))
];
region(rgn);
```

带有交叉多边形的区域构造不佳，但多边形的交叉部分会成为孔：

```openscad
include <BOSL2/std.scad>
rgn = [
    left(15, p=circle(d=50)),
    right(15, p=circle(d=50))
];
region(rgn);
```

### 布尔区域几何/Boolean Region Geometry

类似于 OpenSCAD 可以对形状几何体执行联合/差集/交集/偏移等操作，  
BOSL2 库也允许您对区域执行相同的操作：

```openscad
include <BOSL2/std.scad>
rgn1 = [for (d=[40:-10:10]) circle(d=d)];
rgn2 = [square([60,12], center=true)];
rgn = union(rgn1, rgn2);
region(rgn);
```

```openscad
include <BOSL2/std.scad>
rgn1 = [for (d=[40:-10:10]) circle(d=d)];
rgn2 = [square([60,12], center=true)];
rgn = difference(rgn1, rgn2);
region(rgn);
```

```openscad
include <BOSL2/std.scad>
rgn1 = [for (d=[40:-10:10]) circle(d=d)];
rgn2 = [square([60,12], center=true)];
rgn = intersection(rgn1, rgn2);
region(rgn);
```

```openscad
include <BOSL2/std.scad>
rgn1 = [for (d=[40:-10:10]) circle(d=d)];
rgn2 = [square([60,12], center=true)];
rgn = exclusive_or(rgn1, rgn2);
region(rgn);
```

```openscad
include <BOSL2/std.scad>
orig_rgn = [star(n=5, step=2, d=50)];
rgn = offset(orig_rgn, r=-3, closed=true);
color("blue") region(orig_rgn);
region(rgn);
```

您可以将区域用于多种有用的功能。如果您希望在对象中创建一个孔的网格，并且这些孔的形状由区域定义，可以使用 `grid_copies()` 来实现：


```openscad
include <BOSL2/std.scad>
rgn = [
    circle(d=100),
    star(n=5,step=2,d=100,spin=90)
];
difference() {
    cyl(h=5, d=120);
    grid_copies(size=[120,120], spacing=[4,4], inside=rgn) cyl(h=10,d=2);
}
```

您还可以通过三维空间扫掠一个区域来生成一个实体：

```openscad
include <BOSL2/std.scad>
$fa=1; $fs=1;
rgn = [ for (d=[50:-10:10]) circle(d=d) ];
tforms = [
    for (a=[90:-5:0]) xrot(a, cp=[0,-70]),
    for (a=[0:5:90]) xrot(a, cp=[0,70]),
    move([0,150,-70]) * xrot(90),
];
sweep(rgn, tforms, closed=false, caps=true);
```



