---
layout: post
title:  "立方体圆角"
nav_order: 2.3
---

# 立方体圆角

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

在您的 OpenSCAD 设计中，最常使用的形状原语之一是立方体。圆化类似立方体对象的边缘不仅影响最终设计的视觉效果，还会影响其功能。BOSL2 库提供了多种方法来圆化边缘和角落。

您可以使用四种不同的 3D 形状原语来创建类似立方体的对象：

* [**cuboid()**](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-cuboid) - 创建一个带有倒角和圆角的立方体。

* [**cube()**](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-cube) - OpenSCAD 的 [cube()](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#cube) 的扩展版本，具有附加子对象的锚点。（请参见 [附件教程](https://github.com/BelfrySCAD/BOSL2/wiki/Tutorial-Attachments)）

* [**prismoid()**](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid) - 创建一个矩形棱柱形状，支持可选的圆角和倒角。

* [**rounded_prism()**](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) - 通过连接两个具有相同顶点数的多边形，创建一个圆角 3D 对象。`rounded_prism` 支持连续曲率圆角。（请参见 [圆角类型](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#section-types-of-roundovers)）

BOSL2 提供了两种不同的方法来圆化这些类似立方体的原语的边缘。

* **内建圆角** - [cuboid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-cuboid)、[prismoid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid) 和 [rounded_prism()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) 都有内建的参数来圆化它们的一些或所有边缘。

* **蒙版** -  BOSL2 包含多种选项，用于蒙版对象的边缘和角落。蒙版可以实现内建圆角参数无法完成的圆角任务。例如，使用蒙版，您可以让立方体的顶部边缘具有不同的圆角半径，底部边缘则使用不同的圆角半径。

类似立方体的对象有六个命名面：**LEFT, RIGHT, TOP, BOT, FWD, BACK**。

![](https://github.com/BelfrySCAD/BOSL2/wiki/images/attachments/subsection-specifying-edges_fig2.png)

这些面名称每个都是指向该面的向量。例如，UP 是 [0,0,1]，FWD 是 [0,-1,0]。通过将这两个向量相加，我们可以指定一个边缘。例如，TOP + RIGHT 就等同于 [0,0,1] + [0,1,0] = [0,1,1]。

![](https://github.com/BelfrySCAD/BOSL2/wiki/images/attachments/subsection-specifying-edges_fig1.png)

有关更多详细信息，请参见 [指定边缘](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#subsection-specifying-edges)。

## 长方体圆角/Cuboid Rounding

您可以通过指定圆角半径，使用 `rounding` 参数来圆化 [cuboid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-cuboid) 的边缘：

```openscad
include <BOSL2/std.scad>
cuboid(100, rounding=20);
```

我们可以圆化与某一轴对齐的边缘，如 X、Y 或 Z 轴：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges = "Z");
```

您可以圆化一个面上的所有边缘。这里我们只圆化顶部边缘：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges = TOP);
```

...或者只圆化底部边缘。这里我们使用 `teardrop` 参数将悬垂角度限制，以便在 FDM 打印机上进行 3D 打印而无需支撑：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, teardrop = 45, edges = BOTTOM);
```

可以圆化一个或多个边缘，同时保留其他边缘不圆化：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges = TOP+FRONT);
```

...或者在圆化所有其他边缘的同时，排除一个或多个边缘的圆角：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, except = TOP+FRONT);
```

多个边缘可以以列表的形式指定：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges=[FWD,TOP], except=[TOP+LEFT,FWD+RIGHT]);
```

您还可以使用一个 3x4 数组来指定要圆化的边缘，其中每个条目对应于 12 个边缘之一，如果该边缘被包含，则设置为 1，如果未包含，则设置为 0。边缘的顺序是：

[  
    [Y-Z-, Y+Z-, Y-Z+, Y+Z+],
    [X-Z-, X+Z-, X-Z+, X+Z+],  
    [X-Y-, X+Y-, X-Y+, X+Y+]  
]

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, edges = [[1,0,1,0],[0,1,0,1],[1,0,0,1]]);
```

类似地，您可以使用一个数组来排除选定的边缘不进行圆化：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=20, except = [[1,0,1,0],[0,1,0,1],[1,0,0,1]]);
```

### 负圆角/Negative Rounding

您可以通过使用负圆角值来倒角顶部或底部边缘。请注意，不能在 Z 对齐（侧面）边缘上使用负圆角值。如果您需要在 Z 对齐的边缘上添加倒角，请使用 [fillet()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-fillet)：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], rounding=-20, edges = BOTTOM);
```

### 倒角/Chamfering

对 `cuboid()` 的边缘进行倒角可以采用类似于圆角的方式：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], chamfer=20);
```

您可以像圆角一样指定边缘：

```openscad
include <BOSL2/std.scad>
cuboid([100,80,60], chamfer=20, edges = "Z", except = FWD+RIGHT);
```

## 棱柱形圆角/Prismoid Rounding

与 `cuboid()` 和 `cube()` 不同，`prismoid()`（[prismoid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid)）只能使用内建参数圆化或倒角垂直（或接近垂直）边缘。对于这些边缘，您可以分别为顶部和底部指定圆角和/或倒角：

```openscad
include <BOSL2/std.scad>
prismoid(size1=[35,50], size2=[20,30], h=20, rounding1 = 8, rounding2 = 1);
```

您还可以按边缘逐个指定垂直（或接近垂直）边缘的圆角，通过以逆时针顺序列出边缘，从 BACK+RIGHT（X+Y+）边缘开始：

```openscad
include <BOSL2/std.scad>
prismoid(100, 80, rounding1=[0,50,0,50], rounding2=[40,0,40,0], h=50);
```

## 长方体、立方体和棱柱形的边缘蒙版/Masking Edges of the Cuboid, Cube and Prismoid

### 使用 [edge_profile()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile) 和 [edge_profile_asym()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile_asym) 进行 2D 边缘蒙版

在 [cuboid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-cuboid) 中使用圆角参数的一个限制是，所有圆角边缘必须具有相同的圆角半径。通过使用蒙版，我们可以灵活地对同一个立方体应用不同的边缘处理。蒙版还可以用于 [cube()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-cube) 和 [prismoid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid) 形状。

2D 边缘蒙版通过 [edge_profile()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile) 附加到边缘。它们默认使用 "remove" 标签，使得您可以通过 [diff()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-diff) 从立方体中去除它们。

我们可以使用负圆角值来倒角长方体的底部，并使用 [edge_profile()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile) 来圆化顶部。这里，[edge_profile()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile) 将 2D 圆角蒙版应用于长方体的顶部边缘。

```openscad
include <BOSL2/std.scad>
diff()
    cuboid([50,60,70], rounding = -10, edges = BOT)
        edge_profile(TOP)
            mask2d_roundover(r=10);
```

我们还可以使用 [edge_profile_asym()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile_asym) 和 [xflip()](https://github.com/BelfrySCAD/BOSL2/wiki/transforms.scad#functionmodule-xflip) 来倒角立方体的底部。

```openscad
include<BOSL2/std.scad>
cuboid(50)
 edge_profile_asym(BOT, corner_type="round")
  xflip() mask2d_roundover(10);
```

[edge_profile_asym()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile_asym) 中的 `flip` 参数决定了倒角是向外扩展还是向上扩展。`corner_type` 参数用于塑造外部倒角的角部形状。

```openscad
include<BOSL2/std.scad>
cuboid(50){
 edge_profile_asym(TOP, flip = true)
  xflip() mask2d_roundover(10);
   edge_profile_asym(BOT, corner_type="round")
  xflip() mask2d_roundover(10);
   } 
```

请参见 [mask2d_roundover()](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_roundover) 获取更多蒙版参数。在这里，我们使用 *inset* 参数来制作一个圆珠。

```openscad
include <BOSL2/std.scad>
diff()
 cube([50,60,70],center=true)
     edge_profile(TOP, except=[BACK,TOP+LEFT])
        mask2d_roundover(h=12, inset=4);
```

您可以使用 [edge-profile()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile) 来圆化 [prismoid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid) 的顶部或底部。  
由于 [prismoid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid) 的侧面并非严格垂直，因此需要使用 [edge_profile()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_profile) 中的 *excess* 参数来增加蒙版的长度，并在 [mask2d_roundover()](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_roundover) 中将 mask_angle 设置为 $edge_angle。

```openscad
include<BOSL2/std.scad>
diff()
 prismoid(size1=[35,50], size2=[30,30], h=20, rounding1 = 8, rounding2 = 0)
     edge_profile([TOP+LEFT, TOP+RIGHT], excess = 5)
        mask2d_roundover(r = 15, mask_angle = $edge_angle, $fn = 64);
```

您可以指定边缘圆角的高度，而不是指定圆角半径。

```openscad
include<BOSL2/std.scad>
diff()
   cube(30)
      edge_profile([TOP+LEFT, TOP+RIGHT])
         mask2d_roundover(h = 12, $fn = 64);
```

圆角高度大于相邻边缘的一半将会在顶部表面产生一个脊线。

```openscad
include<BOSL2/std.scad>
diff()
   cube(30)
      edge_profile([TOP+LEFT, TOP+RIGHT])
         mask2d_roundover(h = 20, $fn = 64);
```

[mask2d_teardrop()](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_teardrop) 蒙版可以用来圆化类似立方体的对象的底部。  
它将悬垂角度限制为 45° 或您通过 **angle** 参数指定的值。

```
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [40,30], rounding = 2, h = 20, $fn = 64)
      edge_profile(BOT, excess = 15)
         mask2d_teardrop(h = 5, angle = 50, mask_angle = $edge_angle, $fn = 64);
```

```openscad; ImgOnly VPR=[88.5,0,6.4] VPT=[0,16,10] VPD=110
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [40,30], rounding = 2, h = 20, $fn = 64)
      edge_profile(BOT, excess = 15)
         mask2d_teardrop(h = 5, angle = 50, mask_angle = $edge_angle, $fn = 64);
```

除了简单的 [roundover](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_roundover) 蒙版和 [teardrop](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_teardrop) 蒙版外，还有用于 [cove](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_cove)、[chamfer](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_chamfer)、[rabbet](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_rabbet)、[dovetail](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_dovetail) 和 [ogee](https://github.com/BelfrySCAD/BOSL2/wiki/masks2d.scad#functionmodule-mask2d_ogee) 边缘的蒙版。

`mask2d_ogee()` 仅适用于 [cube()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-cube) 和 [cuboid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-cuboid) 形状，或适用于 [prismoid()](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#functionmodule-prismoid) 形状，其中 X 和 Y 维度的 `size2 >= size1`。

```openscad
include <BOSL2/std.scad>
diff()
 prismoid(size1 = [50,50],size2 = [80,80], rounding1 = 25, height = 80)
  edge_profile(TOP)
   mask2d_ogee([
            "xstep",8,  "ystep",5,  // Starting shoulder.
            "fillet",5, "round",5,  // S-curve.
            "ystep",3,  "xstep",3   // Ending shoulder.
        ]);
```

棱柱形，尤其是具有显著偏移的棱柱形，需要仔细选择 `mask2d_roundover()` 参数。 在这里，我们设置了 `radius = 5` 和 `mask_angle = $edge_angle`。

```
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(r=5, mask_angle=$edge_angle, $fn=128);
```

```openscad; ImgOnly VPT=[16,16,12] VPD=185 VPR=[84,0,82]
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(r=5, mask_angle=$edge_angle, $fn=128);
```

指定圆角高度而不是圆角半径会产生不同的形状。

```openscad; ImgOnly VPT=[16,16,12] VPD=185 VPR=[84,0,82]
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(h=5, mask_angle=$edge_angle, $fn=128);
```

```
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(h=5, mask_angle=$edge_angle, $fn=128);
```

`quarter_round` 参数适用于具有锐角的边缘，但会在具有钝角的边缘上留下台阶。

```openscad; ImgOnly VPT=[16,16,12] VPD=185 VPR=[84,0,82]
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(r=5, mask_angle=$edge_angle, quarter_round = true, $fn=128);
```

```
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(r=5, mask_angle=$edge_angle, quarter_round = true, $fn=128);
```

一种解决方法是仅在具有锐角的边缘上使用 `quarter_round`。

```openscad; ImgOnly VPT=[16,16,12] VPD=185 VPR=[84,0,82]
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(r=5, mask_angle=$edge_angle, quarter_round = $edge_angle<90, $fn=128);
```

```
include<BOSL2/std.scad>
diff()
   prismoid([30,20], [50,60], h=20, shift=[30,40])
      edge_profile(TOP, excess=35)
         mask2d_roundover(r=5, mask_angle=$edge_angle, quarter_round = $edge_angle<90, $fn=128);
```

### 3D 边缘和角落蒙版/3D Edge and Corner Masking

除了上面展示的 2D 边缘轮廓外，BOSL2 还包含了多个 3D 边缘和角落蒙版。

3D 边缘蒙版的优势在于可以沿边缘变化圆角半径。  
像 [rounding_edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad#module-rounding_edge_mask) 这样的 3D 边缘蒙版，可以使用 [edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_mask) 附加。  
这些 3D 边缘蒙版有一个默认标签 "remove"，以便您可以使用 [diff()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-diff) 从立方体中去除它们。

```openscad
include <BOSL2/std.scad>
diff()
 cuboid(80)
  edge_mask(TOP+FWD)
   rounding_edge_mask(r1 = 40, r2 = 0, l = 80);
```

虽然您可以使用 `l` 或 `h` 参数指定蒙版的长度，[edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_mask) 会将一个特殊变量 `$parent_size` 设置为父对象的大小。 
如果父对象不是完美的立方体，您需要单独为每个边缘添加蒙版：

```openscad
include <BOSL2/std.scad>
diff()
 cuboid([60,80,40])  {
  edge_mask(TOP+FWD)
   rounding_edge_mask(r = 10, l = $parent_size.x + 0.1);
  edge_mask(TOP+RIGHT)
   rounding_edge_mask(r = 10, l = $parent_size.y + 0.1);
  edge_mask(RIGHT+FWD)
   rounding_edge_mask(r = 10, l = $parent_size.z + 0.1);
 } 
```

如上所示，仅使用 [rounding_edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad#module-rounding_edge_mask) 来圆化立方体的顶部会留下未圆化的角落。  
使用 [corner_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-corner_mask) 和 [rounding_corner_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad#module-rounding_corner_mask) 可以获得更平滑的角落。


```openscad
include <BOSL2/std.scad>
diff()
 cuboid([60,80,40]) {
  edge_mask(TOP+FWD)
   rounding_edge_mask(r = 10, l = $parent_size.x + 0.1);
  edge_mask(TOP+RIGHT)
   rounding_edge_mask(r = 10, l = $parent_size.y + 0.1);
  edge_mask(RIGHT+FWD)
   rounding_edge_mask(r = 10, l = $parent_size.z + 0.1);
        corner_mask(TOP+RIGHT+FWD)
            rounding_corner_mask(r = 10);
 }
 
```

与内建圆角参数一样，您可以使用 [edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-edge_mask) 和 [corner_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad#module-corner_mask) 来应用悬垂圆角，  
通过使用 [teardrop_edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad#module-teardrop_edge_mask) 和 [teardrop_corner_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad#module-teardrop_corner_mask) 来限制悬垂角度，以便在 FDM 打印机上获得更好的打印效果。  
请注意，RIGHT_FWD 边缘上的垂直蒙版是 [rounding_edge_mask()](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad#module-rounding_edge_mask)。


```openscad
include <BOSL2/std.scad>
diff()
 cuboid([60,80,40]) {
  edge_mask(BOT+FWD)
   teardrop_edge_mask(r = 10, l = $parent_size.x + 0.1, angle = 40);
  edge_mask(BOT+RIGHT)
   teardrop_edge_mask(r = 10, l = $parent_size.y + 0.1, angle = 40);
  edge_mask(RIGHT+FWD)
   rounding_edge_mask(r = 10, l = $parent_size.z + 0.1);
        corner_mask(BOT+RIGHT+FWD)
            teardrop_corner_mask(r = 10, angle = 40);
 }
 
```
## 圆角棱柱/Rounded Prism

您可以使用 [rounded_prism()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) 来构建类似立方体的对象，以及各种其他棱柱体。在本教程中，我们专注于圆化立方体，但 [rounded_prism()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) 的功能远超类似立方体的对象。  
请查看 [rounded_prism()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) 示例以了解更多。

[rounded_prism()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) 独特的功能是它使用连续曲率圆角。  
与使用恒定半径弧线不同，连续曲率圆角使用 4 阶 Bezier 曲线。有关如何实现这一点的完整细节，请参见 [圆角类型](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#section-types-of-roundovers)。

两个参数控制圆角效果，分别是 k 和 joint。  
`joint` 参数是圆角开始位置到未圆角边缘的距离。`k` 参数的范围是 0 到 1，默认值为 0.5。较大的值会产生更急剧的过渡，而较小的值会产生更平滑的过渡。

以下是 "平滑" 圆角的参数，k=0.75。

![](https://github.com/BelfrySCAD/BOSL2/wiki/images/rounding/section-types-of-roundovers_fig3.png)

以下是 "平滑" 圆角的参数，k=0.15。过渡非常平缓，导致圆角看起来比指定的要小得多。对于相同的接头长度，切割长度更小。

![](https://github.com/BelfrySCAD/BOSL2/wiki/images/rounding/section-types-of-roundovers_fig4.png)

`joint` 参数可以分别为顶部、底部和侧边的边缘指定；分别为 `joint_top`、`joint_bot` 和 `joint_sides`。

如果您想要非常平滑的圆角，可以将 `joint` 参数设置为尽可能大，然后调整 `k` 值，使圆角足够大。  
`joint` 参数通常需要小于侧边的一半 (`side/2`)。

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
rounded_prism(rect(20), height=20, 
    joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.5);
```

在这里，我们使用相同的立方体大小和接头尺寸，但调整了 `k` 参数。

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
 left(30) {
    rounded_prism(rect(20), height=20, joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.15);
    move([0,-12,-12]) xrot(90) color("black") text3d("k=0.15", size=3, h = 0.01, anchor= CENTER);
}

right(0){
    rounded_prism(rect(20), height=20, joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.5);  
    move([0,-12,-12]) xrot(90) color("black") text3d("k=0.5", size=3, h = 0.01, anchor= CENTER); 
}

right(30){
    rounded_prism(rect(20), height=20, joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.75);
    move([0,-12,-12]) xrot(90) color("black") text3d("k=0.75", size=3, h = 0.01, anchor= CENTER);
}
```

另外，我们可以保持 `k` 常数为 k=0.5，并调整接头长度：

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
 left(30) {
    rounded_prism(rect(20), height=20, joint_top=1, joint_bot=1, joint_sides=1, k = 0.5);
    move([0,-13,-13]) xrot(90) color("black") text3d("joint=1", size=3, h = 0.01, anchor= CENTER);
}

right(0){
    rounded_prism(rect(20), height=20, joint_top=5, joint_bot=5, joint_sides=5, k = 0.5);  
    move([0,-13,-13]) xrot(90) color("black") text3d("joint=5", size=3, h = 0.01, anchor= CENTER); 
}

right(30){
    rounded_prism(rect(20), height=20, joint_top=9, joint_bot=9, joint_sides=9, k = 0.5);
    move([0,-13,-13]) xrot(90) color("black") text3d("joint=9", size=3, h = 0.01, anchor= CENTER);
}
```

您可以通过将接头值设置为 `cuboid()` 中使用的圆角值，并将 `k` 值设置为 0.93，来匹配 `cuboid()` 的圆形圆角：

```openscad: Med, VPR=[75,0,25], VPD=180
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
left(15) 
    rounded_prism(rect(20), height=20, joint_top=4, joint_bot=4, joint_sides=4, k = 0.93);
right(15)  
    cuboid(20, rounding = 4, $fn = 72);
```

与其他类似立方体的对象不同，圆角棱柱的平滑度不受特殊变量 `$fn` 的影响，而是由 `splinesteps` 参数控制。`splinesteps` 的默认值为 16。

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
 left(35) {
    rounded_prism(rect(20), height=20, joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.5, splinesteps = 4 )
    move([0,-12,-12]) xrot(90) color("black") text3d("splinesteps=4", size=3, h = 0.01, anchor= CENTER);
}

right(0){
    rounded_prism(rect(20), height=20, joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.5, splinesteps = 16)  
    move([0,-12,-12]) xrot(90) color("black") text3d("splinesteps=16", size=3, h = 0.01, anchor= CENTER); 
}

right(35){
    rounded_prism(rect(20), height=20, joint_top=9.99, joint_bot=9.99, joint_sides=9.99, k = 0.5, splinesteps = 64)
    move([0,-12,-12]) xrot(90) color("black") text3d("splinesteps=64", size=3, h = 0.01, anchor= CENTER);
}
```

接头大小可以为棱柱的每一侧设置不同的值：

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
rounded_prism(rect(20), height=20, 
    joint_top=4, joint_bot=3, joint_sides=[2, 10, 5, 10], k = 0.5);
```

同样，`k` 值也可以为棱柱的每一侧设置不同的值：

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
rounded_prism(rect(20), height=20, 
    joint_top=3, joint_bot=3, joint_sides=8, 
    k_top=0.5, k_bot=0.1, k_sides=[0,0.7,0.3,0.7]);
```

您可以为接头距离指定一个 2 元素向量，以产生不对称的圆角，使得边缘的两侧圆角不同。当多边形的一个边远大于另一个边时，这可能会很有用。

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
rounded_prism(rect([50.1,20.1]), height=6.1, 
   joint_top=[15,3], joint_bot=[15,3],
   joint_sides=[[10,25],[25,10],[10,25],[25,10]], 
   k_sides=0.3);
```

对于顶部和底部，您可以指定负的接头距离。如果您给出一个标量负值，那么圆角将向外扩展。

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
rounded_prism(rect(20), height=20, 
    joint_top=5, joint_bot=-5, joint_sides=8, k=0.5);
```

如果您给出一个 2 元素向量，那么如果 `joint_top[0]` 为负值，形状将向外扩展；  
但如果 `joint_top[1]` 为负值，形状将向上扩展。至少有一个值必须是非负的。对于 `joint_bot` 也适用相同的规则。  
`joint_sides` 参数必须完全是非负的。

将顶部向上扩展。底部具有不对称的圆角，边缘有一个小的外扩圆角，而侧面则有一个较大的圆角。

```openscad
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
rounded_prism(rect(20), height=20, 
joint_top=[3,-3], joint_bot=[-3,10], joint_sides=8, k=0.5);
```
