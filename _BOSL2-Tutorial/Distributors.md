---
layout: post
title:  "分布器"
nav_order: 1.4
---
# 分布器

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 分布器 / Distributors

分布器是一类模块，用于在直线、区域、体积或环形上放置多个子对象的副本。  
许多变换操作都有一个或多个对应的分布变体。

变换操作               | 相关的分布器  
--------------------- | ---------------------  
`left()`，`right()`     | `xcopies()`  
`fwd()`，`back()`       | `ycopies()`  
`down()`，`up()`        | `zcopies()`  
`move()`，`translate()` | `move_copies()`，`line_copies()`，`grid_copies()`  
`xrot()`                | `xrot_copies()`  
`yrot()`                | `yrot_copies()`  
`zrot()`                | `zrot_copies()`  
`rot()`，`rotate()`     | `rot_copies()`，`arc_copies()`  
`xflip()`               | `xflip_copy()`  
`yflip()`               | `yflip_copy()`  
`zflip()`               | `zflip_copy()`  
`mirror()`              | `mirror_copy()`  



### 变换分布器 / Transform Distributors

使用 `xcopies()`，你可以沿 X 轴生成一排均匀间隔的形状副本。 例如，要沿 X 轴生成 5 个球体，每个球体间隔 20 个单位，可以这样写：

```openscad
include <BOSL2/std.scad>
xcopies(20, n=5) sphere(d=10);
```

请注意，`xcopies()` 的第一个参数是间隔参数，因此你无需提供 `spacing=` 参数名称。

类似地，`ycopies()` 会沿 Y 轴生成一排均匀间隔的形状副本。例如，要沿 Y 轴生成 5 个球体，每个球体间隔 20 个单位，可以这样写：

```openscad
include <BOSL2/std.scad>
ycopies(20, n=5) sphere(d=10);
```

同样地，`zcopies()` 会沿 Z 轴生成一排均匀间隔的形状副本。例如，要沿 Z 轴生成 5 个球体，每个球体间隔 20 个单位，可以这样写：

```openscad-3D
include <BOSL2/std.scad>
zcopies(20, n=5) sphere(d=10);
```

如果你未为 `xcopies()`、`ycopies()` 或 `zcopies()` 提供 `n=` 参数，它们的默认值是 2（两个）副本。实际上，这是最常见的用法：

```openscad
include <BOSL2/std.scad>
xcopies(20) sphere(d=10);
```

```openscad
include <BOSL2/std.scad>
ycopies(20) sphere(d=10);
```

```openscad-3D
include <BOSL2/std.scad>
zcopies(20) sphere(d=10);
```

如果你不确定想要的间隔，但知道希望副本分布的总长度，可以使用 `l=` 参数代替 `spacing=` 参数：

```openscad
include <BOSL2/std.scad>
xcopies(l=100, n=5) sphere(d=10);
```

```openscad
include <BOSL2/std.scad>
ycopies(l=100, n=5) sphere(d=10);
```

```openscad-3D
include <BOSL2/std.scad>
zcopies(l=100, n=5) sphere(d=10);
```

如果你不希望副本的直线排列以原点为中心，可以通过 `sp=` 参数指定起始点。对于 `xcopies()`，副本的排列将从起始点向右延伸：

```openscad
include <BOSL2/std.scad>
xcopies(20, n=5, sp=[0,0,0]) sphere(d=10);
```

对于 `ycopies()`，副本的排列将从起始点向后延伸：

```openscad
include <BOSL2/std.scad>
ycopies(20, n=5, sp=[0,0,0]) sphere(d=10);
```

对于 `zcopies()`，副本的排列将从起始点向上延伸：

```openscad-3D
include <BOSL2/std.scad>
zcopies(20, n=5, sp=[0,0,0]) sphere(d=10);
```

如果你需要沿任意直线分布副本，可以使用 `line_copies()` 命令。你可以通过 `spacing=` 参数同时指定直线的方向向量和副本的间隔：

```openscad-3D
include <BOSL2/std.scad>
line_copies(spacing=(BACK+RIGHT)*20, n=5) sphere(d=10);
```

通过 `p1=` 参数，你可以指定直线的起点：

```openscad-3D
include <BOSL2/std.scad>
line_copies(spacing=(BACK+RIGHT)*20, n=5, p1=[0,0,0]) sphere(d=10);
```

如果同时提供 `p1=` 和 `p2=` 参数，你可以同时确定副本

```openscad
include <BOSL2/std.scad>
line_copies(p1=[0,100,0], p2=[100,0,0], n=4)
    sphere(d=10);
```

`grid_copies()` 命令允许你同时在 X 和 Y 轴上分布副本：

```openscad
include <BOSL2/std.scad>
grid_copies(20, n=6) sphere(d=10);
```

你可以分别为 X 轴和 Y 轴指定间隔，同时也可以指定行数和列数：

```openscad
include <BOSL2/std.scad>
grid_copies([20,30], n=[6,4]) sphere(d=10);
```

`grid_copies()` 的另一个巧妙功能是可以使输出呈现交错排列：

```openscad
include <BOSL2/std.scad>
grid_copies(20, n=[12,6], stagger=true) sphere(d=10);
```

如果将 `stagger="alt"`，可以获得另一种交错模式：

```openscad
include <BOSL2/std.scad>
grid_copies(20, n=[12,6], stagger="alt") sphere(d=10);
```

默认情况下，如果为间隔值提供一个标量，交错排列将生成一个六边形网格，此间隔表示从一个项目到周围六个项目的距离。如果将间隔值设置为包含两个元素的向量，则会分别指定列间和行间的 X 和 Y 间隔。

```openscad
include <BOSL2/std.scad>
grid_copies([20,20], n=6, stagger=true) sphere(d=10);
```

或者，你可以通过指定网格的尺寸和间隔来定义网格：

```openscad
include <BOSL2/std.scad>
grid_copies(20, size=100) sphere(d=10);
```

```openscad
include <BOSL2/std.scad>
grid_copies(20, size=[100,80]) sphere(d=10);
```

```openscad
include <BOSL2/std.scad>
grid_copies(20, size=[100,80], stagger=true) sphere(d=10);
```

你还可以通过指定网格的尺寸以及列数和行数来创建网格：

```openscad
include <BOSL2/std.scad>
grid_copies(n=5, size=100) sphere(d=10);
```

```openscad
include <BOSL2/std.scad>
grid_copies(n=[4,5], size=100) sphere(d=10);
```

```openscad
include <BOSL2/std.scad>
grid_copies(n=[4,5], size=[100,80]) sphere(d=10);
```

最后，`grid_copies()` 命令还允许你提供一个多边形或区域形状，用于填充项目。只有网格中中心点位于该多边形或区域内的项目才会被创建。例如，要用项目填充一个星形区域，可以这样实现：

```openscad-3D
include <BOSL2/std.scad>
poly = [for (i=[0:11]) polar_to_xy(50*(i%2+1), i*360/12-90)];
grid_copies(5, stagger=true, inside=poly) {
    cylinder(d=4,h=10,spin=90,$fn=6);
}
```


### Rotational Distributors
You can make six copies of a cone, rotated around a center:
```openscad-3D
include <BOSL2/std.scad>
zrot_copies(n=6) yrot(90) cylinder(h=50,d1=0,d2=20);
```

To Be Completed


