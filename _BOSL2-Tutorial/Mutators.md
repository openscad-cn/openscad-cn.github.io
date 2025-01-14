---
layout: post
title:  "变异器"
nav_order: 1.5
---
# 变异器

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 3D 空间分割/3D Space Halving

有时您可能希望将一个3D形状（如球体）切成两半。  
BOSL2库提供了多种方法来实现这一点：


```openscad
include <BOSL2/std.scad>
left_half()
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
right_half()
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
front_half()
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
back_half()
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
bottom_half()
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
top_half()
  sphere(d=100);
```

您可以使用 `half_of()` 模块，如果您希望以非轴对齐的方式分割空间：

```openscad
include <BOSL2/std.scad>
half_of([-1,0,-1])
  sphere(d=100);
```

这些操作符的轴方向上可以移动分割平面：

```openscad
include <BOSL2/std.scad>
left_half(x=20)
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
back_half(y=-20)
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
bottom_half(z=20)
  sphere(d=100);
```

```openscad
include <BOSL2/std.scad>
half_of([-1,0,-1], cp=[20,0,20])
  sphere(d=100);
```

默认情况下，这些操作符可以应用于边长为1000的立方体内的对象。如果需要将这些分割操作符应用于更大的对象，可以通过 `s=` 参数指定大小：

```openscad
include <BOSL2/std.scad>
bottom_half(s=2000)
  sphere(d=1500);
```

## 2D 平面分割/2D Plane Halving

要将2D形状切成两半，您需要添加 `planar=true` 参数：

```openscad
include <BOSL2/std.scad>
left_half(planar=true)
  circle(d=100);
```

```openscad
include <BOSL2/std.scad>
right_half(planar=true)
  circle(d=100);
```

```openscad
include <BOSL2/std.scad>
front_half(planar=true)
  circle(d=100);
```

```openscad
include <BOSL2/std.scad>
back_half(planar=true)
  circle(d=100);
```

## 链式变换器/Chained Mutators

如果您有一组形状需要进行两两包络操作，可以使用 `chain_hull()`：

```openscad
include <BOSL2/std.scad>
chain_hull() {
  cube(5, center=true);
  translate([30, 0, 0]) sphere(d=15);
  translate([60, 30, 0]) cylinder(d=10, h=20);
  translate([60, 60, 0]) cube([10,1,20], center=false);
}
```

## 拉伸变换器/Extrusion Mutators

OpenSCAD 的 `linear_extrude()` 模块可以将2D形状沿垂直方向拉伸成一条直线：

```openscad
include <BOSL2/std.scad>
linear_extrude(height=30)
  zrot(45)
    square(40,center=true);
```

`rotate_extrude()` 模块可以将2D形状绕Z轴旋转。

```openscad
include <BOSL2/std.scad>
rotate_extrude()
  left(50) zrot(45)
    square(40,center=true);
```

类似地，BOSL2 的 `cylindrical_extrude()` 模块可以将2D形状从圆柱的中心向外径向拉伸：

```openscad
include <BOSL2/std.scad>
cylindrical_extrude(or=40, ir=35)
  text(text="Hello World!", size=10, halign="center", valign="center");
```


## 偏移变换器/Offset Mutators

### Minkowski 差集/Minkowski Difference
OpenSCAD 提供了 `minkowski()` 模块，用于在另一个形状的整个表面上追踪一个形状：

```openscad
include <BOSL2/std.scad>
minkowski() {
  union() {
	cube([100,33,33], center=true);
	cube([33,100,33], center=true);
	cube([33,33,100], center=true);
  }
  sphere(r=8);
}
```

然而，它并不提供该操作的逆操作，即从另一个对象的整个表面移除一个形状。对此，BOSL2 库提供了 `minkowski_difference()` 模块：

```openscad
include <BOSL2/std.scad>
minkowski_difference() {
  union() {
    cube([100,33,33], center=true);
    cube([33,100,33], center=true);
    cube([33,33,100], center=true);
  }
  sphere(r=8);
}
```

要对2D形状执行 `minkowski_difference()` 操作，您需要提供 `planar=true` 参数：

```openscad
include <BOSL2/std.scad>
minkowski_difference(planar=true) {
  union() {
    square([100,33], center=true);
    square([33,100], center=true);
  }
  circle(r=8);
}
```

### 2D圆角/Round2d

`round2d()` 模块允许您对2D形状的内外角进行圆角处理。内侧凹角通过半径 `ir=` 进行圆角处理，而外侧凸角通过半径 `or=` 进行圆角处理：


```openscad
include <BOSL2/std.scad>
round2d(or=8)
  star(6, step=2, d=100);
```

```openscad
include <BOSL2/std.scad>
round2d(ir=12)
  star(6, step=2, d=100);
```

```openscad
include <BOSL2/std.scad>
round2d(or=8,ir=12)
  star(6, step=2, d=100);
```

您可以使用 `r=` 来同时将 `ir=` 和 `or=` 设置为相同的值：

```openscad
include <BOSL2/std.scad>
round2d(r=8)
  star(6, step=2, d=100);
```

### 2D外壳/Shell2d

使用 `shell2d()` 模块，您可以获取任意形状的外壳轮廓。对于正厚度，外壳会从原始形状向外偏移：


```openscad
include <BOSL2/std.scad>
shell2d(thickness=5)
  star(5,step=2,d=100);
color("blue")
  stroke(star(5,step=2,d=100),closed=true);
```

对于负厚度，外壳将从原始形状向内偏移：

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5)
  star(5,step=2,d=100);
color("blue")
  stroke(star(5,step=2,d=100),closed=true);
```

如果您希望外壳同时向内和向外偏移，可以提供一对厚度值：

```openscad
include <BOSL2/std.scad>
shell2d(thickness=[-5,5])
  star(5,step=2,d=100);
color("blue")
  stroke(star(5,step=2,d=100),closed=true);
```

您可以通过向 `or=` 参数传递一个半径值来为外部添加圆角。

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,or=5)
  star(5,step=2,d=100);
```

如果您需要为外部的凸角和凹角传递不同的半径，可以将它们作为 `or=[CONVEX,CONCAVE]` 传递：

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,or=[5,10])
  star(5,step=2,d=100);
```

半径为 0 可用于指定不进行圆角处理：

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,or=[5,0])
  star(5,step=2,d=100);
```

您可以通过向 `ir=` 参数传递一个半径值来为内部添加圆角。

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,ir=5)
  star(5,step=2,d=100);
```

如果您需要为内部的凸角和凹角传递不同的半径，可以将它们作为 `ir=[CONVEX,CONCAVE]` 传递：

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,ir=[8,3])
  star(5,step=2,d=100);
```

您可以同时使用 `or=` 和 `ir=` 来获得良好的组合圆角效果：

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,or=[7,2],ir=[7,2])
  star(5,step=2,d=100);
```

```openscad
include <BOSL2/std.scad>
shell2d(thickness=-5,or=[5,0],ir=[5,0])
  star(5,step=2,d=100);
```


### Round3d
### Offset3d
(To be Written)


## 颜色操作器/Color Manipulators

内置的 OpenSCAD `color()` 模块允许您设置对象的 RGB 颜色，但使用其他颜色模式通常更简单。  
您可以使用 `hsl()` 模块通过 HSL（色相-饱和度-亮度）颜色模式选择颜色：

```openscad
include <BOSL2/std.scad>
n = 10; size = 100/n;
for (a=count(n), b=count(n), c=count(n)) {
  let( h=360*a/n, s=1-b/(n-1), l=c/(n-1))
  translate(size*[a,b,c]) {
    hsl(h,s,l) cube(size);
  }
}
```

您可以使用 `hsv()` 模块通过 HSV（色相-饱和度-明度）颜色模式选择颜色：

```openscad
include <BOSL2/std.scad>
n = 10; size = 100/n;
for (a=count(n), b=count(n), c=count(n)) {
  let( h=360*a/n, s=1-b/(n-1), v=c/(n-1))
  translate(size*[a,b,c]) {
    hsv(h,s,v) cube(size);
  }
}
```
