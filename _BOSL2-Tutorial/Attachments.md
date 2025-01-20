---
layout: post
title:  "附加"
nav_order: 1.6
---
# 附加

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 可附加对象/Attachables

BOSL2 引入了可附加对象的概念。您可以对可附加形状执行以下操作：

* 通过锚定和指定方向及旋转来控制形状的位置和方向
* 相对于父对象定位或附加形状
* 标记对象并根据其标记控制布尔运算
* 更改对象的颜色，使子对象的颜色与其父对象不同

各种附加功能起初可能看起来很复杂，但附加性是 BOSL2 库最重要的功能之一。  
它使您能够将对象相对于模型中的其他对象进行定位，而无需跟踪绝对位置。  
这使得模型更简单、更直观且更易于维护。

BOSL2 定义的几乎所有对象都是可附加的。此外，BOSL2 覆盖了内置的 `cube()`、`cylinder()`、`sphere()`、`square()`、`circle()` 和 `text()` 定义，并使它们也变得可附加。  
然而，一些基本的 OpenSCAD 内置定义是不可附加的，无法使用本教程中描述的功能。这些不可附加的对象包括：`polyhedron()`、`linear_extrude()`、`rotate_extrude()`、`surface()`、`projection()` 和 `polygon()`。  
其中一些具有可附加的替代方案，例如：`vnf_polyhedron()`、`linear_sweep()`、`rotate_sweep()` 和 `region()`。

## 锚定/Anchoring

锚定允许您将对象的指定部分或点与原点对齐。  
对齐点可以是侧面的中心、边的中心、角点或对象上的其他特定点。  
通过将一个向量或文本字符串传递给 `anchor=` 参数即可完成此操作。  
对于大致立方或棱柱形的形状，该向量指向将对齐的侧面、边或角的大致方向。例如，向量 `[1,0,-1]` 指代形状的右下边。  
每个向量分量的值应为 -1、0 或 1：

```openscad
include <BOSL2/std.scad>
// Anchor at upper-front-left corner
cube([40,30,50], anchor=[-1,-1,1]);
```

```openscad
include <BOSL2/std.scad>
// Anchor at upper-right edge
cube([40,30,50], anchor=[1,0,1]);
```

```openscad
include <BOSL2/std.scad>
// Anchor at bottom face
cube([40,30,50], anchor=[0,0,-1]);
```

由于手动编写向量并不直观，BOSL2 定义了一些可以组合的标准方向向量常量：

常量 | 方向 | 值
-------- | --------- | -----------
`LEFT`   | X-        | `[-1, 0, 0]`
`RIGHT`  | X+        | `[ 1, 0, 0]`
`FRONT`/`FORWARD`/`FWD` | Y− | `[ 0, −1, 0]`
`BACK`   | Y+        | `[ 0, 1, 0]`
`BOTTOM`/`BOT`/`DOWN` | Z−（2D 中为 Y−）| `[ 0, 0, −1]`（2D 中为 `[0, −1]`）
`TOP`/`UP` | Z+（2D 中为 Y+）| `[ 0, 0, 1]`（2D 中为 `[0, 1]`）
`CENTER`/`CTR` | 居中 | `[ 0, 0, 0]`

如果您需要一个指向左下边缘的向量，只需将 `BOTTOM` 和 `LEFT` 向量常量相加，例如 `BOTTOM + LEFT`。  
这将得到一个向量 `[−1,0,−1]`。您可以将其传递给 `anchor=` 参数，以实现清晰可理解的锚定：

```openscad
include <BOSL2/std.scad>
cube([40,30,50], anchor=BACK+TOP);
```

```openscad
include <BOSL2/std.scad>
cube([40,30,50], anchor=FRONT);
```

---

对于圆柱类型的可附加对象，向量的 Z 分量将为 −1、0 或 1，分别指代圆柱或圆锥形状的底边、中间侧面或顶边。  
X 和 Y 分量可以是任意值，指向圆锥的圆周边缘。  
通过组合这些分量，您可以指向底边或顶边的任意位置，或指向任意侧壁。

```openscad
include <BOSL2/std.scad>
cylinder(r1=25, r2=15, h=60, anchor=TOP+LEFT);
```

```openscad
include <BOSL2/std.scad>
cylinder(r1=25, r2=15, h=60, anchor=BOTTOM+FRONT);
```

这里我们使用 [cylindrical_to_xyz()](https://github.com/BelfrySCAD/BOSL2/wiki/coords.scad#function-cylindrical_to_xyz) 将30度角转换为一个锚点。

```openscad
include <BOSL2/std.scad>
cylinder(r1=25, r2=15, h=60, anchor=cylindrical_to_xyz(1,30,1));
```

---

对于球形类型的可附加对象，您可以传递一个指向球体表面任意位置的向量：

```openscad
include <BOSL2/std.scad>
sphere(r=50, anchor=TOP);
```

```openscad
include <BOSL2/std.scad>
sphere(r=50, anchor=TOP+FRONT);
```

这里 [spherical_to_xyz()](https://github.com/BelfrySCAD/BOSL2/wiki/coords.scad#function-spherical_to_xyz) 函数将球坐标转换为一个可用作锚点的向量：

```openscad
include <BOSL2/std.scad>
sphere(r=50, anchor=spherical_to_xyz(1,-30,60));
```

---

某些可附加形状可能会提供特定的命名锚点，用于形状特定的锚定。这些锚点将以字符串形式提供，并特定于该类型的可附加对象。当支持命名锚点时，它们会列在模块文档的“Named Anchors”部分中。例如，`teardrop()` 可附加对象具有一个名为 "cap" 的命名锚点，而在2D中，`star()` 可附加对象的锚点以顶点编号标记：


```openscad
include <BOSL2/std.scad>
teardrop(d=100, l=20, anchor="cap");
```

```openscad
include <BOSL2/std.scad>
star(n=7, od=30, id=20, anchor="tip2");
```

---

出于向后兼容的原因，某些形状可以接受一个 `center=` 参数。这仅覆盖 `anchor=` 参数。`center=true` 参数等同于 `anchor=CENTER`。`center=false` 参数选择锚点以匹配内置版本的行为：对于立方体，等同于 `anchor=[-1,-1,-1]`；而对于圆柱体，等同于 `anchor=BOTTOM`。

```openscad
include <BOSL2/std.scad>
cube([50,40,30],center=true);
```

```openscad
include <BOSL2/std.scad>
cube([50,40,30],center=false);
```

---

BOSL2 提供的大多数2D形状也支持锚定。内置的 `square()` 和 `circle()` 模块已被重写，使它们成为可附加对象。2D 形状的 `anchor=` 选项会按照预期处理2D向量。对于3D向量会进行特殊处理：如果 Y 坐标为零而 Z 坐标不为零，则会使用 Z 坐标替换 Y 坐标。这样处理的目的是使您可以使用 TOP 和 BOTTOM 作为2D形状的锚点。


```openscad
include <BOSL2/std.scad>
square([40,30], anchor=BACK+LEFT);
```

```openscad
include <BOSL2/std.scad>
circle(d=50, anchor=BACK);
```

```openscad
include <BOSL2/std.scad>
hexagon(d=50, anchor=LEFT);
```

```openscad
include <BOSL2/std.scad>
ellipse(d=[50,30], anchor=FRONT);
```

以下2D示例展示了如何在2D对象中使用3D锚点 TOP。同时注意五边形如何锚定到其 Y+ 轴上最突出的点。

```openscad
include <BOSL2/std.scad>
pentagon(d=50, anchor=TOP);
```


## 旋转/Spin

您可以使用 `spin=` 参数围绕原点旋转可附加对象。旋转在**锚定之后**应用，因此取决于您如何锚定对象，其旋转可能不是围绕其中心进行的。这意味着即使是像球体和圆柱体这样具有旋转对称性的对象，旋转也可能产生影响。您可以用角度指定旋转：正数表示围绕 Z 轴逆时针旋转（从上方看），负数表示顺时针旋转。


```openscad
include <BOSL2/std.scad>
cube([20,20,40], center=true, spin=45);
```

此示例展示了一个锚定在 FRONT 的圆柱，以及一个灰色的旋转副本。旋转是围绕原点进行的，但圆柱偏离了原点，因此即使圆柱具有旋转对称性，旋转**确实**对其产生了影响。


```openscad
include <BOSL2/std.scad>
cylinder(h=40,d=20,anchor=FRONT+BOT);
%cylinder(h=40.2,d=20,anchor=FRONT+BOT,spin=40);
```

您也可以对 BOSL2 提供的 2D 形状应用旋转，但只能使用标量角度：

```openscad
include <BOSL2/std.scad>
square([40,30], spin=30);
```

```openscad
include <BOSL2/std.scad>
ellipse(d=[40,30], spin=30);
```

## 方向/Orientation

另一种为可附加形状指定旋转的方法是通过 `orient=` 参数传递一个3D向量。  这允许您指定形状顶部的倾斜方向。例如，您可以制作一个向上并向右倾斜的圆锥，如下所示：

```openscad
include <BOSL2/std.scad>
cylinder(h=100, r1=50, r2=20, orient=UP+RIGHT);
```

更准确地说，形状的 Z 方向将旋转以与您指定的向量对齐。对于没有 Z 向量的二维可附加对象，它们不接受 `orient=` 参数。

## 混合使用锚定、旋转和方向/Mixing Anchoring, Spin, and Orientation

当同时指定 `anchor=`、`spin=` 和 `orient=` 时，它们的应用顺序是先锚定，再旋转，最后设置方向。 例如，这里是一个立方体：


```openscad
include <BOSL2/std.scad>
cube([20,20,50]);
```

您可以通过 `anchor=CENTER` 参数使其居中：

```openscad
include <BOSL2/std.scad>
cube([20,20,50], anchor=CENTER);
```

添加 45 度旋转：

```openscad
include <BOSL2/std.scad>
cube([20,20,50], anchor=CENTER, spin=45);
```

现在将顶部向上和向前倾斜：

```openscad
include <BOSL2/std.scad>
cube([20,20,50], anchor=CENTER, spin=45, orient=UP+FWD);
```

对于 2D 形状，您可以混合使用 `anchor=` 和 `spin=`，但不能与 `orient=` 一起使用。

```openscad
include <BOSL2/std.scad>
square([40,30], anchor=BACK+LEFT, spin=30);
```

## 子对象定位/Positioning Children

定位是一种强大的方法，用于将一个对象相对于另一个对象放置。  
您可以通过将第二个对象作为第一个对象的子对象来实现这一点。  
默认情况下，子对象的锚点将与父对象的中心对齐。  
对于 `cyl()` 的默认锚点是 CENTER，在这种情况下，圆柱体的中心与立方体的中心对齐。


```openscad
include <BOSL2/std.scad>
up(13) cube(50)
    cyl(d=25,l=95);
```

对于 `cylinder()`，默认锚点是 BOTTOM。虽然不容易看出，但圆柱体的底部放置在立方体的中心。

```openscad
include <BOSL2/std.scad>
cube(50)
    cylinder(d=25,h=75);
```

如果您显式地为子对象设置锚点，则所选的锚点将与父对象的中心对齐。在此示例中，圆柱体的右侧与立方体的中心对齐。


```openscad
include <BOSL2/std.scad>
cube(50,anchor=FRONT)     
    cylinder(d=25,h=95,anchor=RIGHT);
```

`position()` 模块使您能够指定子对象在父对象上的放置位置。您可以为 `position()` 提供父对象的一个锚点，然后子对象的锚点将与指定的父锚点对齐。在此示例中，圆柱体的 LEFT 锚点被放置在立方体的 RIGHT 锚点上。


```openscad
include <BOSL2/std.scad>
cube(50,anchor=FRONT)     
    position(RIGHT) cylinder(d=25,h=75,anchor=LEFT);
```

通过这种机制，您可以将对象相对于其他对象进行定位，而这些对象又相对于其他对象定位，无需跟踪复杂的变换数学计算。


```openscad
include <BOSL2/std.scad>
cube([50,50,30],center=true)
    position(TOP+RIGHT) cube([25,40,10], anchor=RIGHT+BOT)
       position(LEFT+FRONT+TOP) cube([12,12,8], anchor=LEFT+FRONT+BOT)
         cylinder(h=10,r=3);
```

定位机制并不是神奇的：它只是对子对象应用了一个 `translate()` 操作。如果需要，您仍然可以添加自己的额外平移或其他变换。例如，您可以将对象定位在距离右边缘 5 个单位的位置：


```openscad
include<BOSL2/std.scad>
cube([50,50,20],center=true)
    position(TOP+RIGHT) left(5) cube([4,50,10], anchor=RIGHT+BOT);
```

在 2D 中，对象定位的工作方式相同。

```openscad
include<BOSL2/std.scad>
square(10)
    position(RIGHT) square(3,anchor=LEFT);
```

## 在 position() 中使用 orient()/Using position() with orient()

当将对象定位在边缘或角落附近时，您可能希望相对于该边缘或角落所在的面（而不是 TOP 面）对对象进行方向调整。  
您始终可以使用 `rot()` 更改子对象的方向，但为了做到这一点，您需要计算出正确的旋转角度。  
`orient()` 模块提供了一种重新定位子对象方向的机制，从而简化了这一过程：  
它可以根据父锚点的方向调整子对象的方向。  
这与为子对象提供 `orient=` 参数不同，因为后者是直接使用向量相对于父对象的全局坐标系进行方向调整，而不是基于父锚点的方向（考虑了面的方向）进行调整。  

以下三个示例展示了不同的结果：
- 在第一个示例中，仅使用 `position()`。子立方体竖立在 Z 方向上。
- 在第二个示例中，对子对象使用了 `orient=RIGHT`，结果是子对象指向 X+ 方向，而不考虑父对象的形状。
- 在最后一个示例中，使用 `orient(RIGHT)`，子对象根据父对象的 RIGHT 锚点，相对于父对象的倾斜右面调整了方向。


```openscad
include<BOSL2/std.scad>
prismoid([50,50],[30,30],h=40)
  position(RIGHT+TOP)
     cube([15,15,25],anchor=RIGHT+BOT);
```


```openscad
include<BOSL2/std.scad>
prismoid([50,50],[30,30],h=40)
  position(RIGHT+TOP)
     cube([15,15,25],orient=RIGHT,anchor=LEFT+BOT);
```


```openscad
include<BOSL2/std.scad>
prismoid([50,50],[30,30],h=40)
  position(RIGHT+TOP)
     orient(RIGHT)
        cube([15,15,25],anchor=BACK+BOT);
```

您可能已经注意到，上述三个示例中的子对象具有不同的锚点。这是为什么呢？第一个和第二个示例的区别在于，向上锚定和向右锚定需要锚定在子对象的相对两侧。而第三种情况的不同之处在于旋转（spin）发生了变化。  

下面的示例展示了相同的模型，但用箭头代替了子立方体。箭头上的红旗标记了零旋转方向。观察红旗可以看到旋转方向的变化。子对象的 Y+ 方向将指向那个红旗。

```openscad
include<BOSL2/std.scad>
prismoid([50,50],[30,30],h=40)
  position(RIGHT+TOP)
     anchor_arrow(40);
```


```openscad
include<BOSL2/std.scad>
prismoid([50,50],[30,30],h=40)
  position(RIGHT+TOP)
     anchor_arrow(40, orient=RIGHT);
```

```openscad
include<BOSL2/std.scad>
prismoid([50,50],[30,30],h=40)
  position(RIGHT+TOP)
     orient(RIGHT)
        anchor_arrow(40);
```


## 使用 align() 对齐子对象/Aligning children with align()

您可能已经注意到，在使用 `position()` 和 `orient()` 时，为了让子对象与父对象齐平，指定子对象的锚点可能会很麻烦，有时甚至很棘手。  
您可以通过使用 `align()` 模块来简化此任务。  
该模块将子对象放置在父对象的表面上，并与边缘或角落对齐，同时选择子对象上的正确锚点，使其与父对象正确对齐。

最简单的情况下，如果您希望将子对象放置在父对象的 RIGHT 一侧，则需要将子对象锚定到其 LEFT 锚点：


```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    position(RIGHT)
        color("lightblue")cuboid(5,anchor=LEFT);
```

当您使用 `align()` 时，它会自动为子对象确定正确的锚点，并覆盖为子对象指定的任何锚点：您为子对象指定的任何锚点都会被忽略。

```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(RIGHT)
        color("lightblue")cuboid(5);
```

要将子对象放置在父对象顶部的角落，您可以使用如下所示的 `align()`，而不是通过 `position()` 指定 `RIGHT+FRONT+BOT` 锚点：


```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(TOP,RIGHT+FRONT)
        color("lightblue")prismoid([10,5],[7,4],height=4);
```

`position()` 和 `align()` 都可以接受一个锚点位置的列表并生成子对象的多个副本，但如果您希望这些子对象齐平放置，则每个副本需要不同的锚点，因此无法通过单次调用 `position()` 实现，但使用 `align()` 则可以轻松完成：


```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(TOP,[RIGHT,LEFT])
        color("lightblue")prismoid([10,5],[7,4],height=4);
```

如果您希望子对象靠近边缘但不完全齐平，可以使用 `align` 的 `inset=` 参数来实现：

```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(TOP,[FWD,RIGHT,LEFT,BACK],inset=3)
        color("lightblue")prismoid([10,5],[7,4],height=4);
```

如果您旋转了子对象，`align` 仍然会正确对齐。

```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(TOP,[RIGHT,LEFT])
        color("lightblue")prismoid([10,5],[7,4],height=4,spin=90);
```

如果您将对象方向设置为 DOWN，它将从顶部锚点附加，并正确对齐。

```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(TOP,RIGHT)
        color("lightblue")prismoid([10,5],[7,4],height=4,orient=DOWN);
```

请注意，`align()` 从不会更改子对象的方向。如果您将蓝色棱柱体放在右侧，锚点会对齐，但子对象和父对象的边缘不会对齐。

```openscad
include<BOSL2/std.scad>
prismoid(50,30,25){
  align(RIGHT,TOP)
    color("lightblue")prismoid([10,5],[7,4],height=4);
}
```

如果您应用的旋转角度不是 90 度的倍数，则对齐将对准角落。

```openscad
include<BOSL2/std.scad>
cuboid([50,40,15])
    align(TOP,RIGHT)
        color("lightblue")cuboid(8,spin=33);
```

您还可以将对象附加到圆柱体上。如果您使用常规的立方锚点，那么立方体将如图所示附加到一个面上：

```openscad
include<BOSL2/std.scad>
cyl(h=20,d=10,$fn=128)
  align(RIGHT,TOP)
    color("lightblue")cuboid(5);
```

但对于圆柱体，您可以为锚点选择任意水平角度。如果这样做，与任意旋转的情况类似，立方体将附加到最近的角落。

```openscad
include<BOSL2/std.scad>
cyl(h=20,d=10,$fn=128)
  align([1,.3],TOP)
    color("lightblue")cuboid(5);
```

## 附加概述/Attachment Overview

可附加对象因其可以彼此附加的能力而得名。与定位不同，附加会改变子对象的方向。可以将其想象为将两个对象粘在一起：当您附加一个对象时，它会出现在父对象上，并相对于父对象锚点处的局部坐标系进行定位。  

为了理解这意味着什么，可以想象一只蚂蚁在球体上行走的视角。“UP”的含义会因蚂蚁在球体上的位置而变化。如果您将一个圆柱体**附加**到球体上，那么从蚂蚁的视角看，圆柱体的“UP”方向就是朝上的。  

第一个示例展示了使用 `position()` 放置的圆柱体，它在全局父坐标系中向上指向。第二个示例展示了 `attach()` 如何使圆柱体从球体锚点处蚂蚁的视角看“UP”方向指向上方。


```openscad
include<BOSL2/std.scad>
sphere(40)
    position(RIGHT+TOP) cylinder(r=8,h=20);
```


```openscad
include<BOSL2/std.scad>
sphere(40)
    attach(RIGHT+TOP) cylinder(r=8,h=20);
```

在上述示例中，圆柱体的中心点被附加到球体上，并从球体表面的视角指向“上方”。对于球体而言，表面法线在每个点都被定义，指定了“UP”的方向。但对于其他对象来说，这可能并不那么明显。通常在边缘和角落，方向是相交面的方向的平均值。

当您指定锚点时，实际上是在指定锚点的位置和方向。如果您希望可视化此方向，可以使用锚点箭头。

## 锚点方向和锚点箭头/Anchor Directions and Anchor Arrows

对于球体上的蚂蚁来说，显然“UP”方向是指向 Z+ 轴的方向。但 X 和 Y 轴的位置则不太明确，实际上它们可能是任意的。一种有用的方法是通过将锚点箭头附加到该锚点来显示锚点的位置和方向。如前所述，当旋转为零时，小红旗指向锚点的 Y+ 轴方向。

```openscad
include <BOSL2/std.scad>
cube(18, center=true)
    attach(LEFT+TOP)
        anchor_arrow();
```

对于较大的对象，您可以使用 `s=` 参数更改箭头的大小。

```openscad
include <BOSL2/std.scad>
sphere(d=100)
    attach(LEFT+TOP)
        anchor_arrow(s=50);
```

要显示所有标准的基准锚点，您可以使用 [show_anchors()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-show_anchors) 模块。

```openscad
include <BOSL2/std.scad>
cube(20, center=true)
    show_anchors();
```

```openscad
include <BOSL2/std.scad>
cylinder(h=25, d=25, center=true)
    show_anchors();
```

```openscad
include <BOSL2/std.scad>
sphere(d=40)
    show_anchors();
```

对于较大的对象，您可以再次使用 `s=` 参数更改箭头的大小。

```openscad
include <BOSL2/std.scad>
prismoid(150,60,100)
    show_anchors(s=45);
```


## 父子锚点附加（双参数附加）/Parent-Child Anchor Attachment (Double Argument Attachment)

`attach()` 模块有两种不同的操作模式，父子锚点附加和父锚点附加。这两种模式也被称为双参数附加和单参数附加。父子锚点附加（双参数附加）通常更易于使用，且功能更强大，因为它支持对齐。当您使用父子锚点附加时，您需要提供一个父锚点和一个子锚点。可以想象将两个对象的锚点箭头直接对准彼此，并在箭头的方向上将它们推到一起，直到它们接触。在下面的许多示例中，我们首先展示两个对象及其锚点箭头，然后展示使用这些锚点进行附加操作后的结果。

```openscad
include <BOSL2/std.scad>
cube(50,anchor=BOT) attach(TOP,BOT) anchor_arrow(30);
right(60)cylinder(d1=30,d2=15,h=25) attach(BOT,BOT) anchor_arrow(30);
```

```openscad
include <BOSL2/std.scad>
cube(50,anchor=BOT)
  attach(TOP,BOT) cylinder(d1=30,d2=15,h=25);
```

此示例产生的结果与使用 `align()` 相同，但如果父锚点不是水平的，则子对象会被重新定向：

```openscad
include <BOSL2/std.scad>
prismoid([50,50],[35,35],h=50,anchor=BOT) attach(RIGHT,BOT) anchor_arrow(30);
right(60)cylinder(d1=30,d2=15,h=25) attach(BOT,BOT) anchor_arrow(30);
```

```openscad
include <BOSL2/std.scad>
prismoid([50,50],[35,35],h=50,anchor=BOT)
  attach(RIGHT,BOT) cylinder(d1=30,d2=15,h=25);
```

在这种情况下，我们通过对齐锚点箭头将圆锥的弯曲面附加到立方体上：

```openscad
include <BOSL2/std.scad>
cube(50,center=true) attach(RIGHT,BOT) anchor_arrow(30);
right(80)cylinder(d1=30,d2=15,h=25) attach(LEFT,BOT) anchor_arrow(30);
```

```openscad
include <BOSL2/std.scad>
cube(50,center=true)
  attach(RIGHT,LEFT) cylinder(d1=30,d2=15,h=25);
```

请注意，这种附加形式会覆盖子对象中指定的任何锚点或方向：  
**在父子锚点附加中，`anchor=` 和 `orient=` 参数会被忽略。**

当您使用一对锚点指定附加时，附加的子对象可以围绕父锚点旋转，同时仍然保持在指定的锚点上：  
指定锚点时会留下一个未指定的自由度。如前所述，这种模糊性通过锚点具有定义的旋转角度来解决，该角度指定了 Y+ 轴的位置。  
通过查看上面显示的锚点箭头，您可以理解 BOSL2 如何定位对象，或者您可以记住以下规则：
1. 当附加到 TOP 或 BOTTOM 时：如果可能，子对象的 FRONT 会指向前方；否则，子对象的 TOP 会指向后方。
2. 当附加到其他面时，如果可能，子对象的 UP 锚点会指向 UP；否则，子对象的 BACK 会指向上方（即 FRONT 会指向下方）。

为了展示这一点，我们使用了一个棱柱体，其中蓝色箭头指向前方，绿色箭头指向上方。还请注意，前左边缘是唯一的直角。


```openscad
include <BOSL2/std.scad>
color_this("orange")
prismoid([8,8],[6,6],shift=-[1,1],h=8) {
     attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
     attach(FWD,BOT) anchor_arrow(s=12);     
}
```

如果我们将其附加到 TOP 的 LEFT 侧，那么我们会得到如下结果。注意绿色的 UP 箭头指向后方。


```openscad
include <BOSL2/std.scad>
cube(30) attach(TOP,LEFT)
color_this("orange")
  prismoid([8,8],[6,6],shift=-[1,1],h=8) {
    attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
    attach(FWD,BOT) anchor_arrow(s=12);     
  }
```

如果我们使用相同的 LEFT 侧锚点将其附加到 RIGHT，则会得到如下结果。请注意，绿色的 UP 锚点指向 UP，符合上面规则 2 的要求。

```openscad
include <BOSL2/std.scad>
cube(30) attach(RIGHT,LEFT)
color_this("orange")
  prismoid([8,8],[6,6],shift=-[1,1],h=8) {
    attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
    attach(FWD,BOT) anchor_arrow(s=12);     
  }
```

绿色的 UP 箭头始终可以安排指向 UP，除非我们将顶部或底部附加到立方体的垂直面之一。在这里，我们附加底部，因此仍然可以看到两个箭头。对象上的蓝色 FRONT 箭头指向下方，符合规则 2 的预期。

```openscad
include <BOSL2/std.scad>
cube(30) attach(RIGHT,BOT)
color_this("orange")
  prismoid([8,8],[6,6],shift=-[1,1],h=8) {
    attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
    attach(FWD,BOT) anchor_arrow(s=12);     
  }
```

如果子对象出现的方向不是您需要的方向，该怎么办？为了解决这个问题，`attach()` 提供了一个 `spin=` 参数，允许您围绕由连接的锚点向量定义的轴旋转附加的子对象。以下是上一个示例，应用旋转将前锚点重新指向前方：


```openscad
include <BOSL2/std.scad>
cube(30) attach(RIGHT,BOT,spin=-90)
color_this("orange")
  prismoid([8,8],[6,6],shift=-[1,1],h=8) {
    attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
    attach(FWD,BOT) anchor_arrow(s=12);     
  }
```

请注意，指定 `spin=` 给 `attach()` 并不等同于将 `spin=` 参数传递给子对象。与 `orient=` 和 `anchor=` 不同，后者会被忽略，子对象的 `spin=` 参数仍然会被尊重，但可能很难弄清楚它将绕哪个轴旋转。更直观的做法是忽略子对象的旋转参数，只使用 `attach()` 中的 `spin=` 参数。旋转角度必须是标量，但不必是 90 度的倍数。

```openscad
include <BOSL2/std.scad>
cube(30) attach(RIGHT,BOT,spin=-37)
color_this("orange")
  prismoid([8,8],[6,6],shift=-[1,1],h=8) {
    attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
    attach(FWD,BOT) anchor_arrow(s=12);     
  }
```

默认情况下，`attach()` 将子对象精确地放置在父对象的表面上。有时，将子对象通过平移到父对象内部使其与父对象重叠是很有用的。您可以通过 `attach()` 的 `overlap=` 参数来实现这一点。正值会导致子对象与父对象重叠，而负值则会将子对象移离父对象，留下一个小间隙。在第一个示例中，我们使用了一个非常大的重叠值，使得立方体深深地沉入父对象中。在第二个示例中，一个较大的负重叠值将子对象抬高，远高于父对象。


```openscad
include <BOSL2/std.scad>
cuboid(50)
    attach(TOP,BOT,overlap=15)
        color("green")cuboid(20);
```

```openscad
include <BOSL2/std.scad>
cube(50,center=true)
    attach(TOP,BOT,overlap=-20)
        cyl(d=20,h=20);
```

`attach()` 的双参数形式提供的另一个功能是对齐，它的工作方式类似于 `align()`。您可以指定 `align=` 来将附加的子对象对齐到边缘或角落。下面的示例展示了五种不同的对齐方式。

```openscad
include <BOSL2/std.scad>
module thing(){
  color_this("orange")
    prismoid([8,8],[6,6],shift=-[1,1],h=8) {
      attach(TOP,BOT) anchor_arrow(color=[0,1,0],s=12);
      attach(FWD,BOT) anchor_arrow(s=12);     
    }
}
prismoid([50,50],[35,35],h=25,anchor=BOT){
  attach(TOP,BOT,align=FRONT) thing();
  attach(RIGHT,BOT,align=BOT) thing();    
  attach(RIGHT,BACK,align=FRONT) thing();
  attach(FRONT,BACK,align=BOT,spin=45) thing();
  attach(TOP,RIGHT,align=RIGHT,spin=90) thing();
}
```

与 `align()` 类似，如果您将对象旋转 90 度，它可以与平行边对齐，但如果您将其旋转一个任意角度，子对象的一个角落将接触到父对象的边缘。与 `align()` 相同，父对象和子对象的锚点会对齐，但这并不一定意味着当形状具有不同的角度时，边缘会整齐对齐。这种对不齐现象在附加到 RIGHT 并对齐到 FRONT 的对象中可见。

您可能会想，为什么需要这么多关于 `align` 的操作？难道不能直接将对象附加到边缘上的锚点吗？当您这样做时，对象将使用边缘锚点进行附加，而该边缘锚点并不垂直于对象的面。下面的示例展示了如何附加到边缘锚点和角落锚点。


```openscad
include <BOSL2/std.scad>
cube(30)
   color("orange"){
     attach(RIGHT+FRONT,BOT) 
        prismoid([8,8],[6,6],shift=-[1,1],h=8);
     attach(TOP+LEFT+FWD,BOT)
        prismoid([8,8],[6,6],shift=-[1,1],h=8);
   }
```

在使用 `attach()` 的 `align` 选项时，您还可以设置 `inset`，它与 `align()` 中的 `inset` 参数作用相同。它会将子对象从与其对齐的边缘或多个边缘上偏移指定的距离。


```openscad
include <BOSL2/std.scad>
prismoid([50,50],[50,25],25){
  attach(FWD,BOT,align=TOP,inset=3) color("lavender")cuboid(5);
  attach(FWD,BOT,align=BOT+RIGHT,inset=3) color("purple")cuboid(5);
}
```

`attach()` 提供的最后一个功能是将子对象**附加**到父对象**内部**。这对于您想从父对象中减去子对象时非常有用。执行此操作需要使用带标签的布尔操作与 `diff()`，详细内容将在下面进一步解释。在这里的示例中，注意出现的 `diff()` 和 `tag()` 操作会导致子对象被减去。我们回到本节开始时的示例，显示了两个对象的锚点箭头。


```openscad
include <BOSL2/std.scad>
cube(50,anchor=BOT) attach(TOP) anchor_arrow(30);
right(60)cylinder(d1=30,d2=15,h=25) attach(TOP) anchor_arrow(30);
```

内部附加通过使用 `inside=true` 激活，它使锚点箭头指向**相同**的方向，而不是像常规的外部附加那样指向相反的方向。  
在这种情况下，结果如下所示，我们已经切掉了前半部分以展示内部：


```openscad
include <BOSL2/std.scad>
back_half(s=200)
diff()
cube(50,anchor=BOT)
  attach(TOP,TOP,inside=true)
    cylinder(d1=30,d2=15,h=25);
```

空腔的顶部有一层薄薄的层，这是因为两个对象在差集操作中共享了一个面。  
为了解决这个问题，您可以使用 `attach()` 的 `shiftout` 参数。  
在这种情况下，您也可以使用负值的 `overlay`，但 `shiftout` 参数会在需要的每个方向上进行偏移，如果您将子对象对齐到一个角落，可能会涉及三个方向。  
带有 `shift` 的上述示例如下所示：


```openscad
include <BOSL2/std.scad>
back_half(s=200)
diff()
cube(50,anchor=BOT)
  attach(TOP,TOP,inside=true,shiftout=0.01)
    cylinder(d1=30,d2=15,h=25);
```

这是将相同对象连接到右侧的示例，但这次使用的是 BOTTOM 锚点。  
请注意，BOTTOM 锚点如何与 RIGHT 对齐，使其与 RIGHT 锚点平行并指向相同的方向。

```openscad
include <BOSL2/std.scad>
back_half(s=200)
diff()
cuboid(50)
  attach(RIGHT,BOT,inside=true,shiftout=0.01)
    cylinder(d1=30,d2=15,h=25);
```

这是一个示例，其中对齐将对象移动到角落，并且我们受益于 `shiftout` 提供的三维调整：


```openscad
include <BOSL2/std.scad>
diff()
cuboid(10)
  attach(TOP,TOP,align=RIGHT+FWD,inside=true,shiftout=.01)
    cuboid([2,5,9]);
```

与 `position()` 类似，在使用 `attach()` 时，即使在附加对象后，您仍然可以应用自己的平移和其他变换。  
然而，操作顺序现在变得重要。如果您在锚点外部应用平移，它将在父对象的全局坐标系统中起作用，因此子对象在此示例中会向上移动，浅灰色部分显示的是未进行平移的对象。


```openscad
include <BOSL2/std.scad>
cuboid(50){
  %attach(RIGHT,BOT)
    cyl(d1=30,d2=15,h=25);
  up(13)
    color("green") attach(RIGHT,BOT)
      cyl(d1=30,d2=15,h=25);
}
```

另一方面，如果您将平移操作放在 `attach` 和对象之间，那么它将在父对象的局部坐标系统中起作用，  
即相对于父对象的锚点进行平移。因此，在下面的示例中，子对象会向右移动。


```openscad
include <BOSL2/std.scad>
cuboid(50){
  %attach(RIGHT,BOT)
    cyl(d1=30,d2=15,h=25);
  color("green") attach(RIGHT,BOT)
    up(13)
      cyl(d1=30,d2=15,h=25);
}
```

使用 CENTER 锚点进行父子锚点附加时可能会令人惊讶，因为两个锚点都指向上方，因此在下面的示例中，子对象的 CENTER 锚点指向上方，  
所以它在附加到父圆锥时会被反转。请注意，这些锚点是 CENTER 锚点，因此锚点的基部隐藏在对象的中间。


```openscad
include <BOSL2/std.scad>
cylinder(d1=30,d2=15,h=25) attach(CENTER) anchor_arrow(40);
right(40)cylinder(d1=30,d2=15,h=25) attach(CENTER) anchor_arrow(40);
```

```openscad
include <BOSL2/std.scad>
cylinder(d1=30,d2=15,h=25)
    attach(CENTER,CENTER)
        cylinder(d1=30,d2=15,h=25);
```

也可以将对象附加到父对象的边缘和角落。边缘锚点会旋转子对象，使其 BACK 方向与边缘对齐。如果边缘属于顶部或底部的水平面，  
则 BACK 方向将顺时针指向该面（从外部看）。 （这是构建有效面所需的方向，在 OpenSCAD 中也是如此。）  
否则，BACK 方向将指向上方。

观察下面的红旗，这里只显示了一个棱柱体的边缘锚点。顶部面显示了红旗顺时针指向。  
倾斜的侧边沿着边缘指向，通常向上，而底边似乎指向逆时针，但如果我们从底部查看该形状，它们也会显得顺时针。


```openscad
include <BOSL2/std.scad>
prismoid([100,175],[55,88], h=55)
  for(i=[-1:1], j=[-1:1], k=[-1:1])
    let(anchor=[i,j,k])
       if (sum(v_abs(anchor))==2)
         attach(anchor,BOT)anchor_arrow(40);
```

在这个示例中，圆柱体沉入棱柱体顶部边缘的一半：

```openscad
include <BOSL2/std.scad>
$fn=16;
r=6;
prismoid([100,175],[55,88], h=55){
   attach([TOP+RIGHT,TOP+LEFT],LEFT,overlap=r/2) cyl(r=r,l=88+2*r,rounding=r);
   attach([TOP+FWD,TOP+BACK],LEFT,overlap=r/2) cyl(r=r,l=55+2*r, rounding=r);   
}
```

这种类型的边缘附加对于将 3D 边缘蒙版附加到边缘非常有用：


```openscad
include <BOSL2/std.scad>
$fn=32;
diff()
cuboid(75)
   attach([FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
          FWD+LEFT,inside=true)
     rounding_edge_mask(l=76, r1=8,r2=28);
```

## 父锚点附加（单参数附加）/Parent Anchor Attachment (Single Argument Attachment)

第二种附加形式是父锚点附加，它只使用一个参数。这种附加形式通常不太有用，也不提供对齐功能。  
当您给 `attach()` 一个父锚点，但没有提供子锚点时，它会根据父锚点的方向对齐子对象，但然后只是根据子对象内部定义的锚点将其放置在父锚点位置。  
对于大多数对象，默认的锚点是 CENTER 锚点，因此对象会看起来半埋在父对象内部。

```openscad
include <BOSL2/std.scad>
cuboid(30)
    attach(TOP)
        color("green")cuboid(10);
```

某些对象，如 `cylinder()`、`prismoid()` 和 `anchor_arrow()`，默认的锚点位于底部，因此它们会显示在表面上。  
对于这些对象，您可以通过使用父锚点附加来节省一些输入。但是在 `cube()` 的情况下，锚点不是居中的，所以结果是：


```openscad
include <BOSL2/std.scad>
cube(30)
    attach(TOP)
        color("green")cube(10);
```

为了使单参数附加产生所需的结果，您可能需要更改子对象的锚点。请注意，与父子锚点附加不同，  
**在父锚点附加中，`anchor=` 和 `orient=` 参数会被尊重。**  
因此，我们可以像这样放置一个长方体：

```openscad
include <BOSL2/std.scad>
cuboid(30)
  attach(RIGHT)
      color("green")cuboid(10,anchor=BOT);
```

如果您需要将长方体放置在锚点上，但需要相对于底部边缘或角落锚点进行定位，那么您可以使用父锚点附加来实现：

```openscad
include <BOSL2/std.scad>
cuboid(30)
  attach(RIGHT)
      color("green")cuboid(10,anchor=BOT+FWD);
```

单参数附加的另一个有用场景是当子对象没有正确的附加支持时。如果在这种情况下使用双参数附加，结果将不正确，因为子对象无法正确响应内部传播的锚点指令。  
使用单参数附加时，这就不是问题：子对象的原点将被放置在父锚点位置。  
一个没有附加支持的模块是 `linear_extrude()`。


```openscad
include <BOSL2/std.scad>
cuboid(20)
  attach(RIGHT)
     color("red")linear_extrude(height=2) star(n=7,ir=3,or=7);
```

如前所述，您可以在父锚点附加中为子对象设置 `orient=`，尽管行为可能不太直观，因为附加过程会变换坐标系，方向调整是在附加后的坐标系中进行的。  
从将对象附加到 TOP 开始，并回顾前面一节中关于方向如何工作的规则，可能会有所帮助。相同的规则适用于此处。  
请注意，在将对象附加到 RIGHT 面后，前进箭头指向下方。


```openscad
include <BOSL2/std.scad>
cuboid(20){
  attach(RIGHT)
     color_this("red")cuboid([2,4,8],orient=RIGHT,anchor=RIGHT)
        attach(FWD) anchor_arrow();
  attach(TOP)
     color_this("red")cuboid([2,4,8],orient=RIGHT,anchor=RIGHT)
            attach(FWD) anchor_arrow();
}
```



## 定位和附加多个子对象/Positioning and Attaching Multiple Children

您可以通过将多个子对象括在大括号中，同时附加或定位它们：

```openscad
include <BOSL2/std.scad>
cube(50, center=true) {
    attach(TOP) cylinder(d1=50,d2=20,h=20);
    position(RIGHT) cylinder(d1=50,d2=20,h=20);
}
```

如果您希望将相同的形状附加到同一个父对象的多个位置，您可以将所需的锚点作为列表传递给 `attach()` 或 `position()` 模块：

```openscad
include <BOSL2/std.scad>
cube(50, center=true)
    attach([RIGHT,FRONT],TOP) cylinder(d1=35,d2=20,h=25);
```

```openscad
include <BOSL2/std.scad>
cube(50, center=true)
    position([TOP,RIGHT,FRONT]) cylinder(d1=35,d2=20,h=25);
```


## 附加 2D 子对象/Attaching 2D Children

您也可以在 2D 中使用附加。对于 2D 情况，您可以使用 TOP 和 BOTTOM 代替 BACK 和 FORWARD。  
在父子锚点附加中，您不能使用 `attach()` 的旋转参数，也不能为子对象指定旋转。  
在 Z 轴上旋转子对象会使锚点箭头失去对齐。


```openscad
include <BOSL2/std.scad>
rect(50){
    attach(RIGHT,FRONT)
        color("red")trapezoid(w1=30,w2=0,h=30);
    attach(LEFT,FRONT,align=[FRONT,BACK],inset=3)
        color("green") trapezoid(w1=25, w2=0,h=30);
}
```

```openscad
include <BOSL2/std.scad>
diff()
circle(d=50){
    attach(TOP,BOT,overlap=5)
        trapezoid(w1=30,w2=0,h=30);
    attach(BOT,BOT,inside=true)
        tag("remove")
        trapezoid(w1=30,w2=0,h=30);
}        
```


## 标签操作/Tagged Operations

BOSL2 引入了标签的概念。标签是可以分配给可附加对象的名称，以便在执行 `diff()`、`intersect()` 和 `conv_hull()` 操作时引用它们。  
每个对象一次只能有一个标签。

### `diff([remove], [keep])`
`diff()` 操作符用于从其他形状中去除所有带有 `remove` 标签的形状。

例如，要从父立方体的中间去除一个子圆柱体，您可以这样做：

```openscad
include <BOSL2/std.scad>
diff("hole")
cube(100, center=true)
    tag("hole")cylinder(h=101, d=50, center=true);
```

`keep=` 参数用于指定您希望保留在输出中的形状标签。

```openscad
include <BOSL2/std.scad>
diff("dish", keep="antenna")
cube(100, center=true)
    attach([FRONT,TOP], overlap=33) {
        tag("dish") cylinder(h=33.1, d1=0, d2=95);
        tag("antenna") cylinder(h=33.1, d=10);
    }
```

请记住，使用 `tag()` 应用的标签会被子对象继承。在这种情况下，我们需要显式地移除第一个圆柱体的标签（或将其标签更改为其他标签），  
否则它会继承 "keep" 标签并被保留。


```openscad
include <BOSL2/std.scad>
diff("hole", "keep")
tag("keep")cube(100, center=true)
    attach([RIGHT,TOP]) {
        tag("") cylinder(d=95, h=5);
        tag("hole") cylinder(d=50, h=11, anchor=CTR);
    }
```

您可以使用 `tag_this()` 应用一个不会传播到子对象的标签。然后，以上示例可以重新编写为：

```openscad
diff("hole", "keep")
tag_this("keep")cube(100, center=true)
    attach([RIGHT,TOP]) {
        cylinder(d=95, h=5);
        tag("hole") cylinder(d=50, h=11, anchor=CTR);
    }
```
当然，您也可以将`tag()`应用到多个子对象。

```openscad
include <BOSL2/std.scad>
diff("hole")
cube(100, center=true)
    attach([FRONT,TOP], overlap=20)
        tag("hole") {
            cylinder(h=20.1, d1=0, d2=95);
            down(10) cylinder(h=30, d=30);
        }
```

许多使用标签的模块都有默认的标签值。对于 `diff`，默认的移除标签是 "remove"，默认的保留标签是 "keep"。  
在这个示例中，我们依赖于默认值：

```openscad
include <BOSL2/std.scad>
diff()
sphere(d=100) {
    tag("keep")xcyl(d=40, l=120);
    tag("remove")cuboid([40,120,100]);
}
```


父对象可以从其他形状中去除。不过，标签会被子对象继承，因此您需要为子对象和父对象设置标签。

```openscad
include <BOSL2/std.scad>
diff("hole")
tag("hole")cube([20,11,45], center=true)
    tag("body")cube([40,10,90], center=true);
```

标签（因此包括基于标签的操作，如 `diff()`）仅在可附加的子对象上正确工作。  
然而，一些用于创建形状的内置模块是*不可附加*的。  
一些显著的不可附加模块包括 `text()`、`linear_extrude()`、`rotate_extrude()`、`polygon()`、`polyhedron()`、`import()`、`surface()`、`union()`、`difference()`、`intersection()`、`offset()`、`hull()` 和 `minkowski()`。

为了让您在不可附加的形状上使用基于标签的操作，您可以通过 `force_tag()` 模块将它们包装起来以指定其标签。例如：

```openscad
include <BOSL2/std.scad>
diff("hole")
cuboid(50)
  attach(TOP)
    force_tag("hole")
      rotate_extrude()
        right(15)
          square(10,center=true);
```

### `intersect([intersect], [keep])`

要执行可附加对象的交集操作，您可以使用 `intersect()` 模块。  
这个模块专门用于处理需要涉及父对象和子对象的交集的情况，这是原生的 `intersection()` 模块无法做到的。  
该模块将子对象分为三组：匹配 `intersect` 标签的对象、匹配 `keep` 中列出的标签的对象，以及不匹配任何列出标签的其余对象。  
交集是通过 `intersect` 标签对象的并集与不匹配任何标签的对象的并集进行计算的。最后，将 `keep` 中列出的对象与结果进行并集操作。

在这个示例中，父对象（未标记）与一个圆锥形边界对象相交，圆锥形边界对象被标记为 `intersect` 标签。

```openscad
include <BOSL2/std.scad>
intersect("bounds")
cube(100, center=true)
    tag("bounds") cylinder(h=100, d1=120, d2=95, center=true, $fn=72);
```

在这个示例中，子对象与边界框父对象相交。

```openscad
include <BOSL2/std.scad>
intersect("pole cap")
cube(100, center=true)
    attach([TOP,RIGHT]) {
        tag("pole")cube([40,40,80],center=true);
        tag("cap")sphere(d=40*sqrt(2));
    }
```

默认的 `intersect` 标签是 "intersect"，默认的 `keep` 标签是 "keep"。这是一个示例，在这个示例中使用了 "keep" 来防止极点在交集操作中被移除。


```openscad
include <BOSL2/std.scad>
intersect()
cube(100, center=true) {
    tag("intersect")cylinder(h=100, d1=120, d2=95, center=true, $fn=72);
    tag("keep")zrot(45) xcyl(h=140, d=20, $fn=36);
}
```

### `conv_hull([keep])`

您可以使用 `conv_hull()` 模块将形状合并成外包络。  
标记为 `keep` 标签的对象会被排除在外包络之外，并与最终结果进行并集操作。  
默认的 `keep` 标签是 "keep"。


```openscad
include <BOSL2/std.scad>
conv_hull()
cube(50, center=true) {
    cyl(h=100, d=20);
    tag("keep")xcyl(h=100, d=20);
}
```
## 3D 边缘蒙版附加/3D Masking Attachments

为了更方便地从可附加父形状的各个边缘去除形状，提供了一些专门的替代模块来代替 `attach()` 和 `position()`。

### `edge_mask()`

如果您有一个 3D 蒙版形状，并希望将其从多个边缘中去除，可以使用 `edge_mask()` 模块。  
该模块会将一个垂直方向的形状旋转并移动，使得形状的 BACK、RIGHT（X+，Y+）面与给定的边缘对齐。  
该形状会被标记为 "remove"，以便您可以使用 `diff()` 和其默认的 "remove" 标签。  
例如，下面是一个用于圆化边缘的形状：


```openscad
include <BOSL2/std.scad>
module round_edge(l,r) difference() {
    translate([-1,-1,-l/2])
        cube([r+1,r+1,l]);
    translate([r,r])
        cylinder(h=l+1,r=r,center=true, $fn=quantup(segs(r),4));
}
round_edge(l=30, r=19);
```

您可以使用该蒙版来圆化立方体的多个边缘：

```openscad
include <BOSL2/std.scad>
module round_edge(l,r) difference() {
    translate([-1,-1,-l/2])
        cube([r+1,r+1,l]);
    translate([r,r])
        cylinder(h=l+1,r=r,center=true, $fn=quantup(segs(r),4));
}
diff()
cube([50,60,70],center=true)
    edge_mask([TOP,"Z"],except=[BACK,TOP+LEFT])
        round_edge(l=71,r=10);
```

### `corner_mask()`

如果您有一个 3D 蒙版形状，并希望将其从多个角落中去除，可以使用 `corner_mask()` 模块。  
该模块会将形状旋转并移动，使得形状的 BACK RIGHT TOP（X+，Y+，Z+）面与给定的角落对齐。  
该形状会被标记为 "remove"，以便您可以使用 `diff()` 和其默认的 "remove" 标签。  
例如，下面是一个用于圆化角落的形状：


```openscad
include <BOSL2/std.scad>
module round_corner(r) difference() {
    translate(-[1,1,1])
        cube(r+1);
    translate([r,r,r])
        spheroid(r=r, style="aligned", $fn=quantup(segs(r),4));
}
round_corner(r=10);
```

您可以使用该蒙版来圆化立方体的多个角落：

```openscad
include <BOSL2/std.scad>
module round_corner(r) difference() {
    translate(-[1,1,1])
        cube(r+1);
    translate([r,r,r])
        spheroid(r=r, style="aligned", $fn=quantup(segs(r),4));
}
diff()
cube([50,60,70],center=true)
    corner_mask([TOP,FRONT],LEFT+FRONT+TOP)
        round_corner(r=10);
```

### 混合使用蒙版/Mix and Match Masks

您也可以将 `edge_mask()` 和 `corner_mask()` 一起使用：


```openscad
include <BOSL2/std.scad>
module round_corner(r) difference() {
    translate(-[1,1,1])
        cube(r+1);
    translate([r,r,r])
        spheroid(r=r, style="aligned", $fn=quantup(segs(r),4));
}
module round_edge(l,r) difference() {
    translate([-1,-1,-l/2])
        cube([r+1,r+1,l]);
    translate([r,r])
        cylinder(h=l+1,r=r,center=true, $fn=quantup(segs(r),4));
}
diff()
cube([50,60,70],center=true) {
    edge_mask("ALL") round_edge(l=71,r=10);
    corner_mask("ALL") round_corner(r=10);
}
```

## 2D 外形蒙版附加/2D Profile Mask Attachments

虽然 3D 蒙版形状提供了很大的控制能力，但您需要确保它们的大小正确，并且需要为角落和边缘提供不同的蒙版形状。  
通常，可以使用单个 2D 外形来描述边缘蒙版形状（通过 `linear_extrude()`）和角落蒙版形状（通过 `rotate_extrude()`）。  
这就是 `edge_profile()`、`corner_profile()` 和 `face_profile()` 的用途。

### `edge_profile()`

使用 `edge_profile()` 模块，您可以提供一个 2D 外形，并将其线性拉伸为适当长度的蒙版，以适应每个给定的边缘。  
生成的蒙版将被标记为 "remove"，以便您可以使用默认的 "remove" 标签通过 `diff()` 将其去除。  
假设 2D 外形与 BACK、RIGHT（X+，Y+）象限对齐，作为“切割边缘”，该边缘将重新定向到父形状的边缘。  
一个典型的用于倒角的蒙版外形可能是：

```openscad
include <BOSL2/std.scad>
mask2d_roundover(10);
```

使用该蒙版外形，您可以像这样对立方体的边缘进行蒙版处理：

```openscad
include <BOSL2/std.scad>
diff()
cube([50,60,70],center=true)
   edge_profile("ALL")
       mask2d_roundover(10);
```
### `corner_profile()`

您也可以使用相同的外形来制作圆角蒙版：

```openscad
include <BOSL2/std.scad>
diff()
cube([50,60,70],center=true)
   corner_profile("ALL", r=10)
       mask2d_roundover(10);
```

### `face_profile()`

作为将外形蒙版应用于面上所有边缘和角落的简便方法，您可以使用 `face_profile()` 模块：


```openscad
include <BOSL2/std.scad>
diff()
cube([50,60,70],center=true)
   face_profile(TOP, r=10)
       mask2d_roundover(10);
```


## 颜色附加对象/Coloring Attachables

通常，当使用 `color()` 模块为形状着色时，父对象的颜色会覆盖所有子对象的颜色。  
这通常不是您想要的效果：


```openscad
include <BOSL2/std.scad>
$fn = 24;
color("red") spheroid(d=3) {
    attach(CENTER,BOT) color("white") cyl(h=10, d=1) {
        attach(TOP,BOT) color("green") cyl(h=5, d1=3, d2=0);
    }
}
```

然而，如果您使用 `recolor()` 模块，子对象的颜色会覆盖父对象的颜色。  
通过示例可能更容易理解：


```openscad
include <BOSL2/std.scad>
$fn = 24;
recolor("red") spheroid(d=3) {
    attach(CENTER,BOT) recolor("white") cyl(h=10, d=1) {
        attach(TOP,BOT) recolor("green") cyl(h=5, d1=3, d2=0);
    }
}
```

请注意，`recolor()` 仅在避免使用原生的 `color()` 模块时有效。  
另外，`recolor()` 仍会影响所有子对象。如果您想为一个对象着色而不影响其子对象，可以使用 `color_this()`。  
请参阅下面的区别：

```openscad
include <BOSL2/std.scad>
$fn = 24;
recolor("red") spheroid(d=3) {
    attach(CENTER,BOT) recolor("white") cyl(h=10, d=1) {
        attach(TOP,BOT)  cyl(h=5, d1=3, d2=0);
    }
}
right(5)
recolor("red") spheroid(d=3) {
    attach(CENTER,BOT) color_this("white") cyl(h=10, d=1) {
        attach(TOP,BOT)  cyl(h=5, d1=3, d2=0);
    }
}
```

与所有可附加功能一样，这些颜色模块仅适用于可附加对象，因此它们不会影响您使用 `linear_extrude()` 或 `rotate_extrude()` 创建的对象。

## 制作可附加对象/Making Attachables

要使形状成为可附加对象，您只需使用 `attachable()` 模块将其包装，并提供形状几何的基本描述。  
默认情况下，形状应以原点为中心。  
`attachable()` 模块要求恰好有两个子对象。第一个是要使其成为可附加对象的形状，第二个是 `children()`，字面意义上。

### 透传可附加对象/Pass-through Attachables

制作自己可附加模块的最简单方法是直接透传到现有的可附加子模块。  
如果您想重命名模块，或者现有模块的锚点适合（或足够好）您的对象，这可能是合适的做法。  
为了确保您的可附加模块正常工作，您需要接受 `anchor`、`spin` 和 `orient` 参数，给它们适当的默认值，并将它们传递给可附加子模块。  
别忘了也将子对象传递给可附加子模块，否则您的新模块会忽略它的子对象。

```openscad
include <BOSL2/std.scad>
$fn=32;
module cutcube(anchor=CENTER,spin=0,orient=UP)
{
   tag_scope(){
     diff()
       cuboid(15, rounding=2, anchor=anchor,spin=spin,orient=orient){
         tag("remove")attach(TOP)cuboid(5);
         children();
       }
   }
}
diff()
cutcube()
  tag("remove")attach(RIGHT) cyl(d=2,h=8);
```

### 棱柱形/长方体可附加对象/Prismoidal/Cuboidal Attachables

要使长方体或棱柱形状成为可附加对象，您需要使用 `attachable()` 的 `size`、`size2` 和 `offset` 参数。

在最基本的形式中，当形状完全是长方体，且顶部和底部大小相同并直接重叠时，您只需使用 `size=`。

```openscad
include <BOSL2/std.scad>
module cubic_barbell(s=100, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor,spin,orient, size=[s*3,s,s]) {
        union() {
            xcopies(2*s) cube(s, center=true);
            xcyl(h=2*s, d=s/4);
        }
        children();
    }
}
cubic_barbell(100) show_anchors(60);
```

当形状是棱柱形的，顶部与底部的大小不同时，您可以使用 `size2=` 参数。  
虽然 `size=` 参数包含所有三个轴的大小，但 `size2=` 参数只接受形状顶部的 [X, Y] 大小。

```openscad
include <BOSL2/std.scad>
module prismoidal(size=[100,100,100], scale=0.5, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor,spin,orient, size=size, size2=[size.x, size.y]*scale) {
        hull() {
            up(size.z/2-0.005)
                linear_extrude(height=0.01, center=true)
                    square([size.x,size.y]*scale, center=true);
            down(size.z/2-0.005)
                linear_extrude(height=0.01, center=true)
                    square([size.x,size.y], center=true);
        }
        children();
    }
}
prismoidal([100,60,30], scale=0.5) show_anchors(20);
```

当棱柱体的顶部可以从底部正上方偏移时，您可以使用 `shift=` 参数。  
`shift=` 参数接受一个 [X, Y] 向量，表示顶部中心相对于形状底部 XY 中心的偏移。

```openscad
include <BOSL2/std.scad>
module prismoidal(size=[100,100,100], scale=0.5, shift=[0,0], anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor,spin,orient, size=size, size2=[size.x, size.y]*scale, shift=shift) {
        hull() {
            translate([shift.x, shift.y, size.z/2-0.005])
                linear_extrude(height=0.01, center=true)
                    square([size.x,size.y]*scale, center=true);
            down(size.z/2-0.005)
                linear_extrude(height=0.01, center=true)
                    square([size.x,size.y], center=true);
        }
        children();
    }
}
prismoidal([100,60,30], scale=0.5, shift=[-30,20]) show_anchors(20);
```

如果棱柱体不是垂直定向的（即，`shift=` 或 `size2=` 参数应该引用除 XY 外的其他平面），您可以使用 `axis=` 参数。  
这使得您可以将棱柱体自然地定向为前后或侧向。

```openscad
include <BOSL2/std.scad>
module yprismoidal(
    size=[100,100,100], scale=0.5, shift=[0,0],
    anchor=CENTER, spin=0, orient=UP
) {
    attachable(
        anchor, spin, orient,
        size=size, size2=point2d(size)*scale,
        shift=shift, axis=BACK
    ) {
        xrot(-90) hull() {
            translate([shift.x, shift.y, size.z/2-0.005])
                linear_extrude(height=0.01, center=true)
                    square([size.x,size.y]*scale, center=true);
            down(size.z/2-0.005)
                linear_extrude(height=0.01, center=true)
                    square([size.x,size.y], center=true);
        }
        children();
    }
}
yprismoidal([100,60,30], scale=1.5, shift=[20,20]) show_anchors(20);
```

### 圆柱形可附加对象/Cylindrical Attachables

要使圆柱形状成为可附加对象，您需要使用 `attachable()` 的 `l` 和 `r`/`d` 参数。

```openscad
include <BOSL2/std.scad>
module twistar(l,r,d, anchor=CENTER, spin=0, orient=UP) {
    r = get_radius(r=r,d=d,dflt=1);
    attachable(anchor,spin,orient, r=r, l=l) {
        linear_extrude(height=l, twist=90, slices=20, center=true, convexity=4)
            star(n=20, r=r, ir=r*0.9);
        children();
    }
}
twistar(l=100, r=40) show_anchors(20);
```

如果圆柱体是椭圆形的，您可以将不相等的 X/Y 尺寸作为一个包含两个元素的向量传递给 `r=` 或 `d=` 参数。

```openscad
include <BOSL2/std.scad>
module ovalstar(l,rx,ry, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor,spin,orient, r=[rx,ry], l=l) {
        linear_extrude(height=l, center=true, convexity=4)
            scale([1,ry/rx,1])
                star(n=20, r=rx, ir=rx*0.9);
        children();
    }
}
ovalstar(l=100, rx=50, ry=30) show_anchors(20);
```

对于非垂直定向的圆柱形状，使用 `axis=` 参数。

```openscad
include <BOSL2/std.scad>
module ytwistar(l,r,d, anchor=CENTER, spin=0, orient=UP) {
    r = get_radius(r=r,d=d,dflt=1);
    attachable(anchor,spin,orient, r=r, l=l, axis=BACK) {
        xrot(-90)
            linear_extrude(height=l, twist=90, slices=20, center=true, convexity=4)
                star(n=20, r=r, ir=r*0.9);
        children();
    }
}
ytwistar(l=100, r=40) show_anchors(20);
```

### 锥形可附加对象/Conical Attachables

要使锥形状成为可附加对象，您需要使用 `attachable()` 的 `l`、`r1`/`d1` 和 `r2`/`d2` 参数。


```openscad
include <BOSL2/std.scad>
module twistar(l, r,r1,r2, d,d1,d2, anchor=CENTER, spin=0, orient=UP) {
    r1 = get_radius(r1=r1,r=r,d1=d1,d=d,dflt=1);
    r2 = get_radius(r1=r2,r=r,d1=d2,d=d,dflt=1);
    attachable(anchor,spin,orient, r1=r1, r2=r2, l=l) {
        linear_extrude(height=l, twist=90, scale=r2/r1, slices=20, center=true, convexity=4)
            star(n=20, r=r1, ir=r1*0.9);
        children();
    }
}
twistar(l=100, r1=40, r2=20) show_anchors(20);
```

如果锥体是椭圆形的，您可以将不相等的 X/Y 尺寸作为包含两个元素的向量传递给 `r1=`/`r2=` 或 `d1=`/`d2=` 参数。

```openscad
include <BOSL2/std.scad>
module ovalish(l,rx1,ry1,rx2,ry2, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor,spin,orient, r1=[rx1,ry1], r2=[rx2,ry2], l=l) {
        hull() {
            up(l/2-0.005)
                linear_extrude(height=0.01, center=true)
                    ellipse([rx2,ry2]);
            down(l/2-0.005)
                linear_extrude(height=0.01, center=true)
                    ellipse([rx1,ry1]);
        }
        children();
    }
}
ovalish(l=100, rx1=50, ry1=30, rx2=30, ry2=50) show_anchors(20);
```

对于非垂直定向的锥形状，使用 `axis=` 参数来指示主要形状轴的方向：

```openscad
include <BOSL2/std.scad>
module ytwistar(l, r,r1,r2, d,d1,d2, anchor=CENTER, spin=0, orient=UP) {
    r1 = get_radius(r1=r1,r=r,d1=d1,d=d,dflt=1);
    r2 = get_radius(r1=r2,r=r,d1=d2,d=d,dflt=1);
    attachable(anchor,spin,orient, r1=r1, r2=r2, l=l, axis=BACK) {
        xrot(-90)
            linear_extrude(height=l, twist=90, scale=r2/r1, slices=20, center=true, convexity=4)
                star(n=20, r=r1, ir=r1*0.9);
        children();
    }
}
ytwistar(l=100, r1=40, r2=20) show_anchors(20);
```

### 球形可附加对象/Spherical Attachables

要使球形状成为可附加对象，您需要使用 `attachable()` 的 `r`/`d` 参数。


```openscad
include <BOSL2/std.scad>
module spikeball(r, d, anchor=CENTER, spin=0, orient=UP) {
    r = get_radius(r=r,d=d,dflt=1);
    attachable(anchor,spin,orient, r=r*1.1) {
        union() {
            sphere_copies(r=r, n=512, cone_ang=180) cylinder(r1=r/10, r2=0, h=r/10);
            sphere(r=r);
        }
        children();
    }
}
spikeball(r=50) show_anchors(20);
```

如果形状是椭球体，您可以将一个包含三个元素的尺寸向量传递给 `r=` 或 `d=` 参数。

```openscad
include <BOSL2/std.scad>
module spikeball(r, d, scale, anchor=CENTER, spin=0, orient=UP) {
    r = get_radius(r=r,d=d,dflt=1);
    attachable(anchor,spin,orient, r=r*1.1*scale) {
        union() {
            sphere_copies(r=r, n=512, scale=scale, cone_ang=180) cylinder(r1=r/10, r2=0, h=r/10);
            scale(scale) sphere(r=r);
        }
        children();
    }
}
spikeball(r=50, scale=[0.75,1,1.5]) show_anchors(20);
```

### VNF 可附加对象/VNF Attachables

如果形状不适合上述任何类别，并且您将其构建为 [VNF](vnf.scad)，  
您可以使用 VNF 本身通过 `vnf=` 参数来描述几何形状。

VNF 的锚定方式有两种变体。当 `extent=true`（默认值）时，  
一个平面将从原点垂直投影，沿着锚点的方向延伸，直到与 VNF 形状相交的最远距离。  
锚点然后是仍与该平面相交的点的中心。

```openscad-FlatSpin,VPD=500
include <BOSL2/std.scad>
module stellate_cube(s=100, anchor=CENTER, spin=0, orient=UP) {
    s2 = 3 * s;
    verts = [
        [0,0,-s2*sqrt(2)/2],
        each down(s/2, p=path3d(square(s,center=true))),
        each zrot(45, p=path3d(square(s2,center=true))),
        each up(s/2, p=path3d(square(s,center=true))),
        [0,0,s2*sqrt(2)/2]
    ];
    faces = [
        [0,2,1], [0,3,2], [0,4,3], [0,1,4],
        [1,2,6], [1,6,9], [6,10,9], [2,10,6],
        [1,5,4], [1,9,5], [9,12,5], [5,12,4],
        [4,8,3], [4,12,8], [12,11,8], [11,3,8],
        [2,3,7], [3,11,7], [7,11,10], [2,7,10],
        [9,10,13], [10,11,13], [11,12,13], [12,9,13]
    ];
    vnf = [verts, faces];
    attachable(anchor,spin,orient, vnf=vnf) {
        vnf_polyhedron(vnf);
        children();
    }
}
stellate_cube(25) {
    attach(UP+RIGHT) {
        anchor_arrow(20);
        %cube([100,100,0.1],center=true);
    }
}
```

当 `extent=false` 时，锚点将是 VNF 与从原点发出的锚点射线的最远交点。  
锚点的方向将是交点处面的法线。如果交点位于边缘或角落，则方向将平分面之间的角度。

```openscad-VPD=1250
include <BOSL2/std.scad>
module stellate_cube(s=100, anchor=CENTER, spin=0, orient=UP) {
    s2 = 3 * s;
    verts = [
        [0,0,-s2*sqrt(2)/2],
        each down(s/2, p=path3d(square(s,center=true))),
        each zrot(45, p=path3d(square(s2,center=true))),
        each up(s/2, p=path3d(square(s,center=true))),
        [0,0,s2*sqrt(2)/2]
    ];
    faces = [
        [0,2,1], [0,3,2], [0,4,3], [0,1,4],
        [1,2,6], [1,6,9], [6,10,9], [2,10,6],
        [1,5,4], [1,9,5], [9,12,5], [5,12,4],
        [4,8,3], [4,12,8], [12,11,8], [11,3,8],
        [2,3,7], [3,11,7], [7,11,10], [2,7,10],
        [9,10,13], [10,11,13], [11,12,13], [12,9,13]
    ];
    vnf = [verts, faces];
    attachable(anchor,spin,orient, vnf=vnf, extent=false) {
        vnf_polyhedron(vnf);
        children();
    }
}
stellate_cube() show_anchors(50);
```

```openscad
include <BOSL2/std.scad>
$fn=32;
R = difference(circle(10), right(2, circle(9)));
linear_sweep(R,height=10,atype="hull")
    attach(RIGHT) anchor_arrow();
```

## 制作命名锚点/Making Named Anchors

虽然向量锚点通常很有用，但有时会有一些逻辑上额外的附加点，这些点不在形状的外周上。这就是命名字符串锚点的用途。  
例如，`teardrop()` 形状使用圆柱几何来定义它的向量锚点，但它还提供了一个名为 "cap" 的命名锚点，该锚点位于泪滴形状帽尖的位置。

命名锚点作为 `named_anchor()` 数组传递给 `attachable()` 的 `anchors=` 参数。  
`named_anchor()` 调用接受一个名称字符串、一个位置点、一个方向向量和一个旋转角度。  
名称是锚点的名称。位置点是锚点所在的位置。方向向量是附加在该锚点上的子对象应对齐的方向。  
旋转角度是附加子对象绕方向向量逆时针旋转的度数。旋转是可选的，默认值为 0。

要制作一个类似于 `teardrop()` 的简单可附加形状，并提供一个 "cap" 锚点，您可以这样定义：

```openscad
include <BOSL2/std.scad>
module raindrop(r, thick, anchor=CENTER, spin=0, orient=UP) {
    anchors = [
        named_anchor("cap", [0,r/sin(45),0], BACK, 0)
    ];
    attachable(anchor,spin,orient, r=r, l=thick, anchors=anchors) {
        linear_extrude(height=thick, center=true) {
            circle(r=r);
            back(r*sin(45)) zrot(45) square(r, center=true);
        }
        children();
    }
}
raindrop(r=25, thick=20, anchor="cap");
```

如果您想要多个命名锚点，只需将它们添加到锚点列表中：

```openscad-FlatSpin,VPD=150
include <BOSL2/std.scad>
module raindrop(r, thick, anchor=CENTER, spin=0, orient=UP) {
    anchors = [
        named_anchor("captop", [0,r/sin(45), thick/2], BACK+UP,   0),
        named_anchor("cap",    [0,r/sin(45), 0      ], BACK,      0),
        named_anchor("capbot", [0,r/sin(45),-thick/2], BACK+DOWN, 0)
    ];
    attachable(anchor,spin,orient, r=r, l=thick, anchors=anchors) {
        linear_extrude(height=thick, center=true) {
            circle(r=r);
            back(r*sin(45)) zrot(45) square(r, center=true);
        }
        children();
    }
}
raindrop(r=15, thick=10) show_anchors();
```

有时，您想添加的命名锚点可能位于通过一系列复杂的平移和旋转得到的点上。计算该点的一个快捷方法是通过在变换矩阵链中重现这些变换。通过使用几乎所有变换模块的函数形式获取变换矩阵，并通过矩阵乘法将它们链在一起，简化了这一过程。  
例如，如果您有：


```
scale([1.1, 1.2, 1.3]) xrot(15) zrot(25) right(20) sphere(d=1);
```

如果您想计算球体的中心点，可以像这样操作：

```
sphere_pt = apply(
    scale([1.1, 1.2, 1.3]) * xrot(15) * zrot(25) * right(20),
    [0,0,0]
);
```

## 重写标准锚点/Overriding Standard Anchors

有时您可能希望使用标准锚点，但重写其中一些。  
回到上面的方形杠铃示例，右侧和左侧的锚点位于每个端点的立方体上，但位于 x=0 处的锚点漂浮在空间中。  
对于 3D 中的棱柱形/立方体锚点和 2D 中的梯形/矩形锚点，我们可以通过指定重写选项并给出要重写的锚点，  
然后以 `[position, direction, spin]` 的形式给出替换值，从而重写单个锚点。  
通常，您只需要重写位置。如果省略其他列表项，则将使用从标准锚点推导出的值。  
下面我们重写了 FWD 锚点的位置：

```openscad
include<BOSL2/std.scad>
module cubic_barbell(s=100, anchor=CENTER, spin=0, orient=UP) {
    override = [
                 [FWD,  [[0,-s/8,0]]]
               ];
    attachable(anchor,spin,orient, size=[s*3,s,s],override=override) {
        union() {
            xcopies(2*s) cube(s, center=true);
            xcyl(h=2*s, d=s/4);
        }
        children();
    }
}
cubic_barbell(100) show_anchors(60);
```

请注意，FWD 锚点现在已固定在圆柱部分。如果您还想改变它的方向和旋转，可以像这样操作：

```openscad
include<BOSL2/std.scad>
module cubic_barbell(s=100, anchor=CENTER, spin=0, orient=UP) {
    override = [
                 [FWD,  [[0,-s/8,0], FWD+LEFT, 225]]
               ];
    attachable(anchor,spin,orient, size=[s*3,s,s],override=override) {
        union() {
            xcopies(2*s) cube(s, center=true);
            xcyl(h=2*s, d=s/4);
        }
        children();
    }
}
cubic_barbell(100) show_anchors(60);
```

在上述示例中，我们为重写提供了三个值。如之前所述，第一个值将锚点放置在圆柱体上。我们添加了第二个值，将锚点指向左侧。  
第三个值提供了旋转重写，其效果通过箭头上的红旗位置来显示。如果您想将所有 x=0 的锚点重写为放置在圆柱体上，并保持其标准方向，可以通过提供一个列表来实现：

```openscad
include<BOSL2/std.scad>
module cubic_barbell(s=100, anchor=CENTER, spin=0, orient=UP) {
    override = [
                 for(j=[-1:1:1], k=[-1:1:1])
                   if ([j,k]!=[0,0]) [[0,j,k], [s/8*unit([0,j,k])]]
               ];
    attachable(anchor,spin,orient, size=[s*3,s,s],override=override) {
        union() {
            xcopies(2*s) cube(s, center=true);
            xcyl(h=2*s, d=s/4);
        }
        children();
    }
}
cubic_barbell(100) show_anchors(30);
```

现在，中间的所有锚点都固定在圆柱体上。另一种实现相同效果的方法是使用函数字面量进行重写。该函数将以锚点作为参数调用，并需要返回 `undef` 以使用默认值，或者返回一个 `[position, direction, spin]` 三元组来重写默认值。如之前所述，您可以省略值以保留默认值。下面是使用函数字面量进行重写的相同示例：


```openscad
include<BOSL2/std.scad>
module cubic_barbell(s=100, anchor=CENTER, spin=0, orient=UP) {
    override = function (anchor) 
          anchor.x!=0 || anchor==CTR ? undef  // Keep these
        : [s/8*unit(anchor)];
    attachable(anchor,spin,orient, size=[s*3,s,s],override=override) {
        union() {
            xcopies(2*s) cube(s, center=true);
            xcyl(h=2*s, d=s/4);
        }
        children();
    }
}
cubic_barbell(100) show_anchors(30);
```
