---
layout: post
title:  "2D形状"
nav_order: 1.1
---

# 2D形状

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## Primitives / 基本形状

OpenSCAD 提供了两种内置的 2D 基本形状：`square()` 和 `circle()`。您仍然可以按照 OpenSCAD 提供的常规方式使用它们：

```openscad
include <BOSL2/std.scad>
square([60,40], center=true);
```

```openscad
include <BOSL2/std.scad>
circle(r=50);
```

```openscad
include <BOSL2/std.scad>
circle(d=100, $fn=8);
```

这些模块在 BOSL2 库中得到了以下三种增强：锚定（Anchoring）、旋转（Spin）和可附加性（Attachability）。


## 锚定 / Anchoring:

当你创建一个 `square()` 时，你可以指定哪个角或边锚定在原点。  
这可以替代 `center=` 参数，并提供了更大的灵活性。  
`anchor=` 参数接受一个向量值，指向你希望对齐到原点的边或角的大致方向。  
例如，要将后边缘的中心对齐到原点，可以将锚点设置为 `[0,1]`：

```openscad
include <BOSL2/std.scad>
square([60,40], anchor=[0,1]);
```

要将前右角对齐到原点：

```openscad
include <BOSL2/std.scad>
square([60,40], anchor=[1,-1]);
```

到中心:

```openscad
include <BOSL2/std.scad>
square([60,40], anchor=[0,0]);
```

为了在指定向量时更加清晰，定义了一些标准向量常量：

常量 | 方向 | 值  
-------- | --------- | -----------  
`LEFT`   | X-        | `[-1, 0, 0]`  
`RIGHT`  | X+        | `[ 1, 0, 0]`  
`FRONT`/`FORWARD`/`FWD` | Y- | `[ 0,-1, 0]`  
`BACK`   | Y+        | `[ 0, 1, 0]`  
`BOTTOM`/`BOT`/`BTM`/`DOWN` | Z- | `[ 0, 0,-1]`（仅适用于3D）  
`TOP`/`UP` | Z+      | `[ 0, 0, 1]`（仅适用于3D）  
`CENTER`/`CTR` | 居中 | `[ 0, 0, 0]`  

请注意，即使这些是 3D 向量，你仍然可以在 2D 形状中使用大多数它们（当然，`UP` 和 `DOWN` 除外）：


```openscad
include <BOSL2/std.scad>
square([60,40], anchor=BACK);
```

```openscad
include <BOSL2/std.scad>
square([60,40], anchor=CENTER);
```

You can add vectors together to point to corners:

```openscad
include <BOSL2/std.scad>
square([60,40], anchor=FRONT+RIGHT);
```

对于 `circle()`，锚点向量可以指向圆周的任何部分：

```openscad
include <BOSL2/std.scad>
circle(d=50, anchor=polar_to_xy(1,150));
```

请注意，锚点的半径无关紧要，因为只有锚点的方向会影响结果。  
你可以通过将 `show_anchors()` 作为形状的子模块来查看典型的锚点位置：

```openscad
include <BOSL2/std.scad>
square([60,40], center=true)
    show_anchors();
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    show_anchors();
```

## 旋转 / Spin:

`square()` 和 `circle()` 的第二个增强功能是支持旋转（Spin）。  
创建形状时，可以通过 `spin=` 参数使其在原地旋转。  
只需传递一个以度数为单位的值，用于顺时针旋转：


```openscad
include <BOSL2/std.scad>
square([60,40], anchor=CENTER, spin=30);
```

锚定或居中操作会在旋转之前执行：


```openscad
include <BOSL2/std.scad>
square([60,40], anchor=BACK, spin=30);
```

对于圆形，当同时指定 `$fn=` 时，旋转（spin）会非常有用：

```openscad
include <BOSL2/std.scad>
circle(d=50, $fn=6, spin=15);
```

由于锚定是在旋转之前执行的，因此你可以将两者结合使用，以围绕锚点旋转：

```openscad
include <BOSL2/std.scad>
circle(d=50, $fn=6, anchor=LEFT, spin=15);
```


## 可附加性 / Attachability:

`square()` 和 `circle()` 的第三个增强功能是可以通过锚点以多种方式将它们连接在一起。  
这可以通过将一个形状设为你想要连接的另一个形状的子模块来实现。  
默认情况下，只需将一个形状作为另一个形状的子模块，就会将子形状定位到父形状的中心位置。


```openscad
include <BOSL2/std.scad>
square(50, center=true)
    #square(50, spin=45, center=true);
```

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    #square([20,40], anchor=FWD);
```

通过添加 `position()` 模块，你可以将子形状定位到父形状上的任意锚点位置：

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    position(BACK)
        #square(25, spin=45, center=true);
```

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    position(FWD+RIGHT)
        #square(25, spin=45, center=true);
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    position(polar_to_xy(1,60))
        #circle(d=10);
```


然而，锚点不仅仅是父形状上的位置，它们还具有方向性。在大多数情况下，锚点的方向是朝外远离墙面的，一般远离形状的中心。  你可以通过使用 `show_anchors()` 模块查看锚点的方向：


```openscad
include <BOSL2/std.scad>
square(50, center=true)
    show_anchors();
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    show_anchors();
```

如果你希望让子形状的方向与某个锚点的方向匹配，可以使用 `orient()` 模块。它不会定位子形状，只会旋转它：


```openscad
include <BOSL2/std.scad>
square(50, center=true)
    orient(anchor=LEFT)
        #square([10,40], anchor=FWD);
```

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    orient(anchor=FWD)
        #square([10,40], anchor=FWD);
```

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    orient(anchor=RIGHT)
        #square([10,40], anchor=FWD);
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    orient(polar_to_xy(1,30))
        #square([10,40], anchor=FWD);
```

你可以将 `position()` 和 `orient()` 一起使用，以同时定位

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    position(RIGHT+BACK)
        orient(anchor=RIGHT+BACK)
            #square([10,40], anchor=FWD);
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    position(polar_to_xy(1,30))
        orient(polar_to_xy(1,30))
            #square([10,40], anchor=FWD);
```

但更简单的方法是直接使用 `attach()` 模块，一次性完成这两项操作：

```openscad
include <BOSL2/std.scad>
square(50, center=true)
    attach(LEFT+BACK)
        #square([10,40], anchor=FWD);
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    attach(polar_to_xy(1,30))
        #square([10,40], center=true);
```

与其在子形状中指定 `anchor=`，你可以向 `attach()` 传递第二个参数，用于指定子形状的哪一侧附加到父形状：


```openscad
include <BOSL2/std.scad>
square([10,50], center=true)
    attach(BACK, LEFT)
        #square([10,40], center=true);
```

```openscad
include <BOSL2/std.scad>
circle(d=50)
    attach(polar_to_xy(1,30), LEFT)
        #square([10,40], center=true);
```

## 矩形 / Rectangles

BOSL2 库提供了 `square()` 的替代模块，名为 `rect()`，它支持更多功能。  
你可以像使用 `square()` 一样使用它，但它还提供了扩展功能。  
例如，它允许你为矩形的角添加圆角：

```openscad
include <BOSL2/std.scad>
rect([60,40], rounding=10);
```

或者对角进行斜切：

```openscad
include <BOSL2/std.scad>
rect([60,40], chamfer=10);
```

你甚至可以指定**哪些**角需要圆角或斜切。如果你向 `rounding=` 或 `chamfer=` 参数传递一个包含四个数值的列表，每个角都会有自己对应的大小。顺序从右后角（第一象限）开始，逆时针依次是左后角（第二象限）、左前角（第三象限）和右前角（第四象限）：

```openscadImgOnly
include <BOSL2/std.scad>
module text3d(text) color("black") text(
    text=text, font="Times", size=10,
    halign="center", valign="center"
);
translate([ 50, 50]) text3d("I");
translate([-50, 50]) text3d("II");
translate([-50,-50]) text3d("III");
translate([ 50,-50]) text3d("IV");
rect([90,80]);
```
如果某个尺寸设置为 `0`，则该象限的角不会进行圆角或斜切处理：

```openscad
include <BOSL2/std.scad>
rect([60,40], rounding=[0,5,10,15]);
```

```openscad
include <BOSL2/std.scad>
rect([60,40], chamfer=[0,5,10,15]);
```

你可以同时设置 `rounding=` 和 `chamfer=` 参数，以混合使用圆角和斜切效果，但前提是需要为每个角分别指定参数。如果你希望某个角是圆角，则需要为该角的斜切设置为 0，反之亦然：


```openscad
include <BOSL2/std.scad>
rect([60,40], rounding=[5,0,10,0], chamfer=[0,5,0,15]);
```

## 椭圆 / Ellipses

BOSL2 库还提供了 `circle()` 的增强版本，称为 `ellipse()`。你可以像使用 `circle()` 一样使用它，但它还提供了扩展功能。例如，它允许你对尺寸进行更多的控制。

由于 OpenSCAD 中的圆只能用具有一定数量直边的正多边形近似表示，这可能会导致尺寸和形状的不精确。为了解决这个问题，`ellipse()` 提供了 `realign=` 和 `circum=` 参数。

如果将 `realign=` 参数设置为 `true`，则会将 `ellipse()` 的多边形边之间的角度旋转一半：

```openscad
include <BOSL2/std.scad>
ellipse(d=100, $fn=8);
#ellipse(d=100, $fn=8, realign=true);
```

如果 `circum=` 参数为 `true`，则生成 `ellipse()` 的多边形会外接理想的圆，而不是内接。

内接理想圆的效果：

```openscad
include <BOSL2/std.scad>
color("green") ellipse(d=100, $fn=360);
ellipse(d=100, $fn=6);
```

外接理想圆的效果：

```openscad
include <BOSL2/std.scad>
ellipse(d=100, $fn=6, circum=true);
color("green") ellipse(d=100, $fn=360);
```

顾名思义，`ellipse()` 模块可以分别指定 X 和 Y 方向的半径或直径。为此，只需为 `r=` 或 `d=` 提供一个包含两个半径或直径的列表：

```openscad
include <BOSL2/std.scad>
ellipse(r=[30,20]);
```

```openscad
include <BOSL2/std.scad>
ellipse(d=[60,40]);
```

与 `circle()` 类似，你可以对 `ellipse()` 形状进行锚定（anchor）、旋转（spin）和附加（attach）操作：

```openscad
include <BOSL2/std.scad>
ellipse(d=50, anchor=BACK);
```

```openscad
include <BOSL2/std.scad>
ellipse(d=50, anchor=FRONT+RIGHT);
```

```openscad
include <BOSL2/std.scad>
ellipse(d=50)
    attach(BACK+RIGHT, FRONT+LEFT)
        ellipse(d=30);
```

## 直角三角形 / Right Triangles

BOSL2 库通过 `right_triangle()` 模块提供了一种简单的方法来创建 2D 直角三角形：

```openscad
include <BOSL2/std.scad>
right_triangle([40,30]);
```

你可以使用 `xflip()` 和 `yflip()` 来更改三角形所在的象限：

```openscad
include <BOSL2/std.scad>
xflip() right_triangle([40,30]);
```

```openscad
include <BOSL2/std.scad>
yflip() right_triangle([40,30]);
```

```openscad
include <BOSL2/std.scad>
xflip() yflip() right_triangle([40,30]);
```

或者，你也可以通过 `spin=` 参数将其旋转到正确的象限：

```openscad
include <BOSL2/std.scad>
right_triangle([40,30], spin=90);
```

```openscad
include <BOSL2/std.scad>
right_triangle([40,30], spin=-90);
```

你还可以对直角三角形使用锚定功能：

```openscad
include <BOSL2/std.scad>
right_triangle([40,30], anchor=FWD+RIGHT);
```

## 梯形 / Trapezoids

OpenSCAD 并未提供简单的方法来创建一般的 2D 三角形、梯形或平行四边形。  
BOSL2 库通过 `trapezoid()` 模块可以生成这些形状。

要创建一个简单的三角形，只需将其中一个宽度设为零：

```openscad
include <BOSL2/std.scad>
trapezoid(w1=50, w2=0, h=40);
```

要创建一个直角三角形，你需要使用 `shift=` 参数，将梯形的后边沿 X 轴平移：

```openscad
include <BOSL2/std.scad>
trapezoid(w1=50, w2=0, h=50, shift=-25);
```

```openscad
include <BOSL2/std.scad>
trapezoid(w1=50, w2=0, h=50, shift=25);
```

```openscad
include <BOSL2/std.scad>
trapezoid(w1=0, w2=50, h=50, shift=-25);
```

```openscad
include <BOSL2/std.scad>
trapezoid(w1=0, w2=50, h=50, shift=25);
```

通过为前边（`w1=`）和后边（`w2=`）指定非零宽度，可以创建一个梯形：

```openscad
include <BOSL2/std.scad>
trapezoid(w1=30, w2=50, h=50);
```

平行四边形只需前边和后边的宽度相同，同时沿 X 轴平移即可：

```openscad
include <BOSL2/std.scad>
trapezoid(w1=50, w2=50, shift=20, h=50);
```

通过设置不相等的非零前宽度（`w1=`）和后宽度（`w2=`），并将后边沿 X 轴平移，可以创建一个四边形：

```openscad
include <BOSL2/std.scad>
trapezoid(w1=50, w2=30, shift=20, h=50);
```

你可以像使用其他可附加形状一样使用 `anchor=` 和 `spin=`。然而，锚点的方向取决于各边的角度，这可能与你的预期不一致：

```openscad
include <BOSL2/std.scad>
trapezoid(w1=30, w2=50, h=50)
    show_anchors();
```

## 正N 边形 / Regular N-Gons

OpenSCAD 允许你通过将 `circle()` 与 `$fn` 参数结合使用来创建规则的 N 边形（如五边形、六边形等）。尽管这种方法简洁，但初看可能不太直观：

```openscad
include <BOSL2/std.scad>
circle(d=50, $fn=5);
```

对于常见的 N 边形，BOSL2 库提供了名称更直观的模块：

```openscad
include <BOSL2/std.scad>
pentagon(d=50);
```

```openscad
include <BOSL2/std.scad>
hexagon(d=50);
```

```openscad
include <BOSL2/std.scad>
octagon(d=50);
```

```openscad
include <BOSL2/std.scad>
regular_ngon(n=7, d=50);
```

这些模块还提供了额外的功能。你可以通过边长来设置它们的大小：

```openscad
include <BOSL2/std.scad>
pentagon(side=20);
```

它们可以通过外接圆的半径或直径来设置大小：

```openscad
include <BOSL2/std.scad>
pentagon(ir=25);
pentagon(id=50);
```

它们可以旋转半个边长的角度：

```openscad
include <BOSL2/std.scad>
left(30)  pentagon(d=50, realign=true);
right(30) pentagon(d=50, realign=false);
```

它们可以添加圆角：

```openscad
include <BOSL2/std.scad>
pentagon(d=50, rounding=10);
```

```openscad
include <BOSL2/std.scad>
hexagon(d=50, rounding=10);
```

它们的附加行为也有所不同。一个带有较小 `$fn=` 的圆将把对象附加在理想圆周上，而不是生成的多边形边上：


```openscad
include <BOSL2/std.scad>
color("green") stroke(circle(d=50), closed=true);
circle(d=50,$fn=6)
    show_anchors();
```

而 N 边形将沿着多边形本身进行附加：

```openscad
include <BOSL2/std.scad>
hexagon(d=50)
    show_anchors(custom=false);
```

你可以像使用其他可附加形状一样使用 `anchor=` 和 `spin=`。然而，锚点基于锚点向量与 N 边形边的交点，可能并非你所期望的位置：


```openscad
include <BOSL2/std.scad>
pentagon(d=50)
    show_anchors(custom=false);
```

N 边形还为其边和顶点提供了命名锚点：

```openscad,Med
include <BOSL2/std.scad>
pentagon(d=30)
    show_anchors(std=false);
```


## 星形 / Stars

BOSL2 库将星形作为一种基本支持的形状。  
星形可以有任意数量的点。  
你可以通过点的数量以及内外顶点的半径或直径来定义星形的形状：

```openscad
include <BOSL2/std.scad>
star(n=3, id=10, d=50);
```

```openscad
include <BOSL2/std.scad>
star(n=5, id=15, r=25);
```

```openscad
include <BOSL2/std.scad>
star(n=10, id=30, d=50);
```

或者，你可以通过点的数量以及步进点数来定义星形的形状：

```openscad
include <BOSL2/std.scad>
star(n=7, step=2, d=50);
```

```openscad
include <BOSL2/std.scad>
star(n=7, step=3, d=50);
```

如果将 `realign=` 参数设置为 `true`，星形将旋转半个点角度：

```openscad
include <BOSL2/std.scad>
left(30) star(n=5, step=2, d=50);
right(30) star(n=5, step=2, d=50, realign=true);
```

`align_tip=` 参数可以接受一个向量，以便将第一个顶点对齐到特定方向：

```openscad
include <BOSL2/std.scad>
star(n=5, ir=15, or=30, align_tip=BACK)
    attach("tip0") color("blue") anchor_arrow2d();
```

```openscad
include <BOSL2/std.scad>
star(n=5, ir=15, or=30, align_tip=BACK+RIGHT)
    attach("tip0") color("blue") anchor_arrow2d();
```

同样，可以使用 `align_pit=` 参数将第一个凹点对齐到特定方向的向量：

```openscad
include <BOSL2/std.scad>
star(n=5, ir=15, or=30, align_pit=BACK)
    attach("pit0") color("blue") anchor_arrow2d();
```

```openscad
include <BOSL2/std.scad>
star(n=5, ir=15, or=30, align_pit=BACK+RIGHT)
    attach("pit0") color("blue") anchor_arrow2d();
```

你可以像使用其他可附加形状一样使用 `anchor=` 和 `spin=`。然而，锚点是基于形状的最远范围，可能并非你所期望的位置：

```openscad
include <BOSL2/std.scad>
star(n=5, step=2, d=50)
    show_anchors(custom=false);
```

星形还为其凹点、顶点以及顶点之间的中点提供了命名锚点：

```openscad,Med
include <BOSL2/std.scad>
star(n=5, step=2, d=40)
    show_anchors(std=false);
```

## 2D 水滴形 / Teardrop2D

在 3D 打印时，您可能需要在垂直墙上制作一个圆形孔。  
然而，如果孔太大，其顶部的悬垂可能会在 FDM/FFF 打印机上导致打印问题。  
如果您不想使用支撑材料，可以使用水滴形状代替。  
`teardrop2d()` 模块可以生成 2D 版本的水滴形状，以便之后对其进行拉伸：

```openscad
include <BOSL2/std.scad>
teardrop2d(r=20);
```

```openscad
include <BOSL2/std.scad>
teardrop2d(d=50);
```

默认的悬垂角为 45 度，但您可以通过 `ang=` 参数进行调整：

```openscad
include <BOSL2/std.scad>
teardrop2d(d=50, ang=30);
```

如果您希望将水滴顶部弄平以便于桥接，可以使用 `cap_h=` 参数：

```openscad
include <BOSL2/std.scad>
teardrop2d(d=50, cap_h=25);
```

```openscad
include <BOSL2/std.scad>
teardrop2d(d=50, ang=30, cap_h=30);
```

您可以像使用其他可附加形状一样使用 `anchor=` 和 `spin=`。然而，锚点是基于形状的最远范围，可能并非您所期望的位置：

```openscad
include <BOSL2/std.scad>
teardrop2d(d=50, ang=30, cap_h=30)
    show_anchors();
```

## 粘连圆形 / Glued Circles

BOSL2 提供了一种更不常见的形状：粘连圆形（Glued Circles）。  
它本质上是两圈圆形，通过类似胶水状的弯月形连接起来：

```openscad
include <BOSL2/std.scad>
glued_circles(d=30, spread=40);
```

`r=` / `d=` 参数可用于指定两个圆的半径或直径：

```openscad
include <BOSL2/std.scad>
glued_circles(r=20, spread=45);
```

```openscad
include <BOSL2/std.scad>
glued_circles(d=40, spread=45);
```

`spread=` 参数用于指定两个圆心之间的距离：

```openscad
include <BOSL2/std.scad>
glued_circles(d=30, spread=30);
```

```openscad
include <BOSL2/std.scad>
glued_circles(d=30, spread=40);
```

`tangent=` 参数指定弯月形在两个圆上的切线角度：

```openscad
include <BOSL2/std.scad>
glued_circles(d=30, spread=30, tangent=45);
```

```openscad
include <BOSL2/std.scad>
glued_circles(d=30, spread=30, tangent=20);
```

```openscad
include <BOSL2/std.scad>
glued_circles(d=30, spread=30, tangent=-20);
```

一个有用的操作是将几个 `glued_circle()` 排成一行，然后对它们进行拉伸，生成带肋的墙体：

```openscad-3D
include <BOSL2/std.scad>
$fn=36;  s=10;
linear_extrude(height=50,convexity=16,center=true)
    xcopies(s*sqrt(2),n=3)
        glued_circles(d=s, spread=s*sqrt(2), tangent=45);
```

您可以像使用其他可附加形状一样使用 `anchor=` 和 `spin=`。然而，锚点是基于形状的最远范围，可能并非您所期望的位置：

```openscad
include <BOSL2/std.scad>
glued_circles(d=40, spread=40, tangent=45)
    show_anchors();
```

