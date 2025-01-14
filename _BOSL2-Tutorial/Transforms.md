---
layout: post
title:  "变换"
nav_order: 1.3
---
# 变换

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 平移 / Translation

`translate()` 命令非常简单：

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
translate([0,0,30]) sphere(d=20);
```

但是，在快速浏览时或当用于计算移动的公式较为复杂时，很难看出沿哪个轴移动以及移动的方向。此外，对于如此常用的命令来说，它也显得有些繁琐。因此，BOSL2 为每个方向提供了快捷命令：`up()`、`down()`、`fwd()`、`back()`、`left()` 和 `right()`：

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
up(30) sphere(d=20);
```

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
down(30) sphere(d=20);
```

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
fwd(30) sphere(d=20);
```

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
back(30) sphere(d=20);
```

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
left(30) sphere(d=20);
```

```openscad
include <BOSL2/std.scad>
#sphere(d=20);
right(30) sphere(d=20);
```

还有一个更通用的命令 `move()`，它的作用与 `translate()` 相同：
```openscad
include <BOSL2/std.scad>
#sphere(d=20);
move([30,-10]) sphere(d=20);
```

## 缩放 / Scaling

`scale()` 命令也相当简单：

```openscad
include <BOSL2/std.scad>
scale(2) cube(10, center=true);
```

```openscad
include <BOSL2/std.scad>
scale([1,2,3]) cube(10, center=true);
```

如果你只想更改某个轴上的缩放比例，BOSL2 提供了更直观的命令来实现：`xscale()`、`yscale()` 和 `zscale()`：

```openscad
include <BOSL2/std.scad>
xscale(2) cube(10, center=true);
```
```openscad
include <BOSL2/std.scad>
yscale(2) cube(10, center=true);
```
```openscad
include <BOSL2/std.scad>
zscale(2) cube(10, center=true);
```


## 旋转 / Rotation

`rotate()` 命令非常直观：

```openscad
include <BOSL2/std.scad>
rotate([0,30,0]) cube(20, center=true);
```

它也显得有些冗长，并且在快速浏览时可能难以判断旋转的具体方向。为了更清晰，BOSL2 提供了用于绕各轴旋转的快捷命令：`xrot()`、`yrot()` 和 `zrot()`：

```openscad
include <BOSL2/std.scad>
xrot(30) cube(20, center=true);
```

```openscad
include <BOSL2/std.scad>
yrot(30) cube(20, center=true);
```

```openscad
include <BOSL2/std.scad>
zrot(30) cube(20, center=true);
```

`rot()` 是一个更通用的旋转命令，比 `rotate()` 更简短易用：

```openscad
include <BOSL2/std.scad>
rot([0,30,15]) cube(20, center=true);
```

所有旋转快捷命令都可以接受一个 `cp=` 参数，用于指定旋转的中心点：

```openscad
include <BOSL2/std.scad>
cp = [0,0,40];
color("blue") move(cp) sphere(d=3);
#cube(20, center=true);
xrot(45, cp=cp) cube(20, center=true);
```

```openscad
include <BOSL2/std.scad>
cp = [0,0,40];
color("blue") move(cp) sphere(d=3);
#cube(20, center=true);
yrot(45, cp=cp) cube(20, center=true);
```

```openscad
include <BOSL2/std.scad>
cp = [0,40,0];
color("blue") move(cp) sphere(d=3);
#cube(20, center=true);
zrot(45, cp=cp) cube(20, center=true);
```

你还可以使用一个新技巧：从一个方向旋转到另一个方向。你可以使用向量来指定这些方向：

```openscad
include <BOSL2/std.scad>
#cylinder(d=10, h=50);
rot(from=[0,0,1], to=[1,0,1]) cylinder(d=10, h=50);
```

以下是一些可用的方向向量常量和别名，以便更清晰地表示方向：

常量                       | 值          | 方向  
-------------------------- | ----------- | --------------  
`CENTER`, `CTR`            | `[ 0, 0, 0]` | 居中  
`LEFT`                     | `[-1, 0, 0]` | 指向 X-  
`RIGHT`                    | `[ 1, 0, 0]` | 指向 X+  
`FWD`, `FORWARD`, `FRONT`  | `[ 0,-1, 0]` | 指向 Y-  
`BACK`                     | `[ 0, 1, 0]` | 指向 Y+  
`DOWN`, `BOTTOM`, `BOT`    | `[ 0, 0,-1]` | 指向 Z-  
`UP`, `TOP`                | `[ 0, 0, 1]` | 指向 Z+  

这使你可以更清晰地重写上述的向量旋转操作：

```openscad
include <BOSL2/std.scad>
#cylinder(d=10, h=50);
rot(from=UP, to=UP+RIGHT) cylinder(d=10, h=50);
```

## 镜像 / Mirroring

标准的 `mirror()` 命令的用法如下：

```openscad
include <BOSL2/std.scad>
#yrot(60) cylinder(h=50, d1=20, d2=10);
mirror([1,0,0]) yrot(60) cylinder(h=50, d1=20, d2=10);
```

BOSL2 提供了绕标准轴镜像的快捷命令：`xflip()`、`yflip()` 和 `zflip()`：

```openscad
include <BOSL2/std.scad>
#yrot(60) cylinder(h=50, d1=20, d2=10);
xflip() yrot(60) cylinder(h=50, d1=20, d2=10);
```

```openscad
include <BOSL2/std.scad>
#xrot(60) cylinder(h=50, d1=20, d2=10);
yflip() xrot(60) cylinder(h=50, d1=20, d2=10);
```

```openscad
include <BOSL2/std.scad>
#cylinder(h=50, d1=20, d2=10);
zflip() cylinder(h=50, d1=20, d2=10);
```

所有镜像命令都可以通过偏移来指定镜像操作的位置：

```openscad
include <BOSL2/std.scad>
#zrot(30) cube(20, center=true);
xflip(x=-20) zrot(30) cube(20, center=true);
color("blue",0.25) left(20) cube([0.1,50,50], center=true);
```

```openscad
include <BOSL2/std.scad>
#zrot(30) cube(20, center=true);
yflip(y=20) zrot(30) cube(20, center=true);
color("blue",0.25) back(20) cube([40,0.1,40], center=true);
```

```openscad
include <BOSL2/std.scad>
#xrot(30) cube(20, center=true);
zflip(z=-20) xrot(30) cube(20, center=true);
color("blue",0.25) down(20) cube([40,40,0.1], center=true);
```


## 倾斜 / Skewing

OpenSCAD 原生并不支持倾斜变换。BOSL2 提供了 `skew()` 命令来实现这一功能。你可以为所需的倾斜操作提供倍率参数。这些参数的命名规则是以 `s` 开头，后接倾斜所在的轴，然后是倾斜随之增加的轴。例如，如果想沿着 X 轴倾斜，随着 Y 轴的距离增加，使用 `sxy=` 参数。如果设置倍率为 `0.5`，那么每沿 Y 轴增加一个单位，X 轴就会增加 `0.5` 单位的倾斜。如果给出负倍率，倾斜方向将会反转：

```openscad
include <BOSL2/std.scad>
skew(sxy=0.5) cube(10,center=false);
```

```openscad
include <BOSL2/std.scad>
skew(sxz=-0.5) cube(10,center=false);
```

```openscad
include <BOSL2/std.scad>
skew(syx=-0.5) cube(10,center=false);
```

```openscad
include <BOSL2/std.scad>
skew(syz=0.5) cube(10,center=false);
```

```openscad
include <BOSL2/std.scad>
skew(szx=-0.5) cube(10,center=false);
```

```openscad
include <BOSL2/std.scad>
skew(szy=0.5) cube(10,center=false);
```


