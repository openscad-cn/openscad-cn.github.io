---
layout: post
title:  "初学者的贝塞尔曲线"
nav_order: 2.4
---
# 初学者的贝塞尔曲线

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

Bézier 曲线是由多项式方程定义的参数曲线。为了在 OpenSCAD 中使用 Bézier 曲线，我们需要加载 Bézier 扩展 BOSL2/beziers.scad 和 BOSL2/std.scad。

Bézier 曲线的形式根据定义曲线的多项式的度数而有所不同。

二次 Bézier 曲线，即度数为 2 的 Bézier 曲线，定义由 [二次多项式](https://en.wikipedia.org/wiki/Quadratic_polynomial)。  
二次 Bézier 曲线有一个起始控制点、一个结束控制点，以及一个通常不在曲线上的中间控制点。曲线从起始点开始，朝向中间控制点，然后转向，最终从中间控制点的方向到达结束点。

![图片来源于 Wikipedia](images/bezier_2_big.gif "Quadratic Bézier 动画，图片来源于 Wikipedia")

为了可视化 Bézier 曲线，我们可以使用模块 [debug_bezier()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#module-debug_bezier)。  
参数 N 告诉 `debug_bezier` Bézier 曲线的度数。

```openscad
include<BOSL2/std.scad> 
include<BOSL2/beziers.scad>

bez = [[0,0], [30,60], [0,100]];
debug_bezier(bez, N = 2);
```

如果我们移动任何一个控制点，曲线的形状就会发生变化。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[0,0], [100,50], [0,100]];
debug_bezier(bez, N = 2);
```

三次 Bézier 曲线（度数为 3）由三次多项式定义。三次 Bézier 曲线有四个控制点。  
第一个和最后一个控制点是曲线的端点。曲线从第二个控制点开始，然后转向，使其从第三个控制点的方向到达终点。

![图片来源于 Wikipedia](images/bezier_3_big.gif "Cubic Bézier 动画，图片来源于 Wikipedia")


```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[20,0], [100,40], [50,90], [25,80]];
debug_bezier(bez, N = 3);
```

通过移动列表中的第二个和第三个控制点，我们可以改变曲线的形状。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[20,0], [60,40], [-20,50], [25,80]];
debug_bezier(bez, N = 3);
```

要查看三次 Bézier 曲线的实时示例，请访问 [Desmos Graphing Calculator](https://www.desmos.com/calculator/cahqdxeshd)。

更高阶的 Bézier 曲线，如四次（度数为 4）和五次（度数为 5）Bézier 曲线也存在。  
度数为 4 的 Bézier 曲线用于 [round_corners()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#function-round_corners) 和 [rounded_prism()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-rounded_prism) 的连续圆角操作。

![图片来源于 Wikipedia](images/bezier_4_big.gif "Quartic Bézier 动画，图片来源于 Wikipedia")

更高阶的 Bézier 曲线，因此具有更多的控制点，提供了更多的形状控制。如果您需要精细调整曲线的形状，可以向 Bézier 曲线中添加更多控制点。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez =  [
    [[0,0], [100,100], [0,80]],
    [[0,0], [10,30], [100,100], [0,80]],
    [[0,0], [10,30], [40,30], [100,100], [0,80]],
    [[0,0], [10,30], [40,30], [100,100], [30,100], [0,80]]
];
debug_bezier(bez[$t*4], N=$t*4+2);
move([60,30]) color("blue") text(str("N = ",($t*4+2)));
```

### 3D Bézier 曲线/3D Bézier Curves

Bézier 曲线不仅限于 XY 平面。我们可以像定义 2D Bézier 曲线一样轻松地定义 3D Bézier 曲线。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 

bez = [[10,0,10], [30,30,-10], [-30,30,40], [-10,0,30]];
debug_bezier(bez, N = 3);
```

## Bézier 路径/Bézier Paths

Bézier 路径是将一系列 Bézier 曲线连接在一起，且它们的端点重合。

点的数量是 Bézier 路径的自然结果。如果您有 k 个度数为 N 的 Bézier 曲线，那么总共有 k(N+1) 个点，  
除了有 k-1 个重叠点，因此实际上是：

```math
k(N+1)-(k-1) = kN +k -k+1 = kN+1.
```

Bézier 的控制点列表并不是 OpenSCAD 路径。如果我们将列表 bez[] 作为路径来处理，得到的形状将与预期大相径庭。  
这里，绿色的是 Bézier 曲线，而通过控制点的 OpenSCAD 路径是红色的。


```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[0,0], [30,30], [0,50], {70,30]  [0,100]];
debug_bezier(bez, N = 2);
```

虽然这些示例中的 `bez` 变量是一个点的列表，但它与 OpenSCAD 路径不同，后者也是一个点的列表。  
这里展示的是绿色的 Bézier 曲线和通过相同点列表绘制的 OpenSCAD 路径，后者为红色。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[20,0], [60,40], [-20,50], [25,80]];
debug_bezier(bez, N = 3);
color("red") stroke(bez);
```

要将 Bézier 曲线转换为 OpenSCAD 路径，请使用 [bezpath_curve()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_curve) 函数。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[20,0], [60,40], [-20,50], [25,80]];
path = bezpath_curve(bez, N = 3);
stroke(path);
```

Bézier 路径可以由多个 Bézier 曲线组成。  
二次 Bézier 路径的点数是 2 的倍数加 1，三次 Bézier 路径的点数是 3 的倍数加 1。

这意味着一系列 7 个控制点可以分为三个（重叠的）3 点组，并作为三个二次 Bézier 曲线的序列来处理。  
同样的 7 个点也可以分为两个重叠的 4 点组，并作为两个三次 Bézier 曲线的序列来处理。  
这两条路径的形状会有显著的不同。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez =  [[0,0], [10,30], [20,0], [30,-30], [40,0], [50,30],[60,0]];
path = bezpath_curve(bez, N = 2);  //make a quadratic Bézier path
stroke(path);
```

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez =  [[0,0], [10,30], [20,0], [30,-30], [40,0], [50,30],[60,0]];
path = bezpath_curve(bez, N=3);  //make a cubic Bézier path
stroke(path);
```

默认情况下， [bezpath_curve()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_curve) 将 Bézier 路径转换为 OpenSCAD 路径，通过将每个 Bézier 曲线拆分为 16 个直线段。  
这些段的长度不一定相等。请注意，特殊变量 `$fn` 对步骤数量没有影响。您可以通过 **splinesteps** 参数来控制此数量。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[20,0], [60,40], [-20,50], [25,80]];
path = bezpath_curve(bez, splinesteps = 6);
stroke(path);
```

要将路径闭合到 y 轴，我们可以使用 [bezpath_close_to_axis()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_close_to_axis) 函数。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = [[20,0], [60,40], [-20,50], [25,80]];
closed = bezpath_close_to_axis(bez, axis = "Y");
path = bezpath_curve(closed);
stroke(path, width = 2);
```

如果我们使用 [rotate_sweep()](https://github.com/BelfrySCAD/BOSL2/wiki/skin.scad#functionmodule-rotate_sweep) 将路径围绕 y 轴扫掠，就得到了一个实心的花瓶形状的物体。在这里，我们同时使用了 `$fn` 和 `splinesteps` 参数，以生成一个更光滑的物体。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>
$fn = 72;

bez = [[20,0], [60,40], [-20,50], [25,80]];
closed = bezpath_close_to_axis(bez, axis = "Y");
path = bezpath_curve(closed, splinesteps = 32);
rotate_sweep(path,360);
```

我们可以使用 [bezpath_offset()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_offset) 将路径向左偏移 5 个单位，而不是完全闭合路径到 y 轴，并在顶部和底部闭合这两条路径。  
请注意，`bezpath_offset` 接受一个 x, y 对作为偏移值。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>
$fn = 72;

bez = [[20,0], [60,40], [-20,50], [25,80]];
closed = bezpath_offset([-5,0], bez);
debug_bezier(closed);

```

请注意， [bezpath_offset()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_offset) 并不能确保均匀的壁厚。  
为了获得恒定宽度的墙壁，我们需要沿法线偏移路径。我们可以使用 [offset()](https://github.com/BelfrySCAD/BOSL2/wiki/regions.scad#function-offset) 来实现，但我们必须首先将 Bézier 曲线转换为 OpenSCAD 路径，然后反向偏移路径以创建一个封闭路径。

我们也可以使用 [offset_stroke()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-offset_stroke) 作为函数来完成此操作。  
[offset_stroke()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-offset_stroke) 函数可以在一步操作中自动完成路径偏移、反向和闭合路径。  
要使用 [offset_stroke()](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad#functionmodule-offset_stroke)，我们还必须包含文件 [rounding.scad](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad)。

您可以在这里看到三种方法之间的差异，其中 [bezpath_offset()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_offset) 为蓝色，  
[offset()](https://github.com/BelfrySCAD/BOSL2/wiki/regions.scad#function-offset) 为红色， [offset_stroke()]() 为绿色。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>
include<BOSL2/rounding.scad>
$fn = 72;

bez = [[40,0], [110,40], [-60,50], [45,80]];

bez2 = bezpath_offset([5,0], bez);
path= bezpath_curve(bez2, splinesteps = 32);
color("blue") stroke(path);

path2 = bezier_curve(bez, splinesteps = 32);
closed2 = concat(path2,reverse(offset(path2,delta=5)),[bez[0]]);
right(30) color("red") stroke(closed2);

path3 = offset_stroke(bezier_curve(bez, splinesteps = 32), [5,0]);
right(60) color("green") stroke(path3, closed= true);

```

使用这三种方法中的任何一种将 Bézier 路径沿 y 轴扫掠，会得到一个具有开放内部的形状。然而，正如这个横截面所示，我们的新路径并没有闭合花瓶的底部。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
include<BOSL2/rounding.scad>

$fn = 72;

bez = [[15,0], [60,40], [-25,50], [25,80]];
path = offset_stroke(bezier_curve(bez, splinesteps = 32), [2,0]);
back_half(s = 200) rotate_sweep(path,360);
```

我们将使用一个高度为 2 的圆柱体作为花瓶的底部。在花瓶底部，孔的半径是 `bez[0].x`，但我们需要找到在 y = 2 时的半径。  
函数 [bezier_line_intersection()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezier_line_intersection) 会返回一个 u 值列表，表示给定的线与 Bézier 曲线的交点。

u 值是介于 0 和 1 之间的数字，表示交点在曲线上的位置。在我们的例子中，线只在一个点交叉 Bézier 曲线，因此我们得到单元素列表 [0.0168783]。

函数 [bezier_points()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_points) 会将 u 值列表转换为 x,y 坐标列表。  
在 y = 2 时绘制一条线，得到单元素列表 [[17.1687, 2]]。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>


bez = [[15,0], [60,40], [-25,50], [25,80]];
debug_bezier(bez, N = 3);
line = [[0,2], [30,2]];
color("red") stroke(line);
u = bezier_line_intersection(bez,line);
echo(bezier_points(bez,u));  //    [[17.1687, 2]]

```

这意味着一个高度为 2，底部半径为 `bez[0].x`，顶部半径为 17.1687 的 `cyl()` 将适合我们的花瓶。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
include<BOSL2/rounding.scad>

$fn = 72;

bez = [[15,0], [60,40], [-25,50], [25,80]];
path = offset_stroke(bezier_curve(bez, splinesteps = 32), [0,2]);
back_half(s = 200) rotate_sweep(path,360);
line = [[0,2], [30,2]];
u = bezier_line_intersection(bez,line).x;
r2 = bezier_points(bez,u).x;
color("red") cyl(h = 2, r1 = bez[0].x, r2 = r2, anchor = BOT);
```

请记住，**$fn** 控制 [rotate_sweep()](https://github.com/BelfrySCAD/BOSL2/wiki/skin.scad#functionmodule-rotate_sweep) 操作的平滑度，而 Bézier 的平滑度由 **splinesteps** 参数控制。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 

$fn = 72;

bez = [[15,0], [40,40], [-20,50], [20,80]];
closed = bezpath_offset([2,0], bez);
path = bezpath_curve(closed, splinesteps = 64); 

rotate_sweep(path,360, $fn = 72);
right(60) rotate_sweep(path,360, $fn = 6);
right(120) rotate_sweep(path,360, $fn = 4);
```

## 2D 三次 Bézier 路径构建/2D Cubic Bézier Path Construction

作为一系列三次 Bézier 曲线构建的路径，用户在使用 Inkscape、Adobe Illustrator 和 Affinity Designer 时都非常熟悉。  
[The Bézier Game](https://bezier.method.ac) 演示了这些绘图程序的工作原理。

BOSL2 包含四个用于构建三次 Bézier 路径的函数：

[bez_begin()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_begin) 和 [bez_end()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_end) 定义了简单三次 Bézier 曲线的端点。

因为每个构造函数都会生成一个点的列表，所以我们将使用 [flatten()](https://github.com/BelfrySCAD/BOSL2/wiki/lists.scad#function-flatten) 函数将它们合并为一个单一的列表。

有三种不同的方式来指定端点和控制点的位置。

首先，您可以通过向量来指定端点，并通过角度（从 XY 平面中的 X+ 测量）和距离来指定控制点：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
bez = flatten([
    bez_begin([0,0], 45, 42.43),
    bez_end([100,0], 90, 30),
]);
debug_bezier(bez,N=3);
```

其次，您可以通过向量指定端点的 XY 位置，并将该端点的控制点作为从控制点出发的向量来指定：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
bez = flatten([
    bez_begin([0,0], [30,30]),
    bez_end([100,0], [0,30]),
]);
debug_bezier(bez,N=3);
```

第三，您可以通过向量指定端点，并通过方向向量和距离来指定控制点：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
bez = flatten([
    bez_begin([0,0], BACK+RIGHT, 42.43),
    bez_end([100,0], [0,1], 30),
]);
debug_bezier(bez,N=3);
```

BOSL2 包含 [bez_joint()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_joint) 构造函数，用于向 Bézier 路径添加角点。  
一个角点有三个控制点：路径上我们希望有角点的点，以及进入和离开的控制点。我们可以通过上面展示的三种方式中的任意一种来指定这些控制点。

以下是一个示例，使用角度和距离来指定角点。请注意，角度首先指定，然后是距离：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
bez = flatten([
    bez_begin([0,0], 45, 42.43),
    bez_joint([40,20], 90,0, 30,30),
    bez_end([100,0], 90, 30),
]);
debug_bezier(bez,N=3);
```

第四个三次 Bézier 路径构造函数是 [bez_tang()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_tang)。  
该构造函数用于创建平滑连接。它也有三个控制点，一个位于路径上，另两个是进入和离开的控制点。  
由于这三点位于同一条直线上，我们只需要指定离开控制点的角度。  
如在本示例中，您可以为进入和离开控制点指定不同的距离。如果只指定一个距离，则它将同时用于两个控制点。

我们可以在上一个示例中添加一个平滑连接：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
bez = flatten([
    bez_begin([0,0], 45, 42.43),
    bez_joint([40,20], 90,0, 30,30),
    bez_tang([80,50], 0, 20,40),
    bez_end([100,0], 90, 30),
]);
debug_bezier(bez,N=3);
```

描述整个 Bézier 路径时，不必使用相同的表示法。我们可以在单一路径中混合使用角度、向量和带距离的向量表示法：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad> 
bez = flatten([
    bez_begin([0,0], [30,30]),
    bez_joint([40,20], BACK,RIGHT, 30,30),
    bez_tang([80,50], 0, 20,40),
    bez_end([100,0], BACK, 30),
]);
debug_bezier(bez,N=3);
```

在使用三次 Bézier 构造函数时，我们的 Bézier 路径必须始终从 [bez_begin()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_begin) 和 [bez_end()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_end) 构造函数开始。

这可能会让 [The Bézier Game](https://bezier.method.ac) 中的一些示例看起来令人困惑。  
例如，考虑圆形。我们可以通过用我们的起始和结束点替换它们的起始切线控制点来复制这些结果。

将进入和离开控制点放置到正确的距离，以近似圆形的方式是：

```math
r * (4/3) * tan(180/2*n)
```

其中 r 是圆的半径，n 是需要的 `bez_tang()` 分段数以完成一个完整的圆。  
请记住，我们的 `bez_begin()` 和 `bez_end()` 分段加起来模拟了一个 `bez_tang()` 分段。  
对于我们这种情况，关闭圆形的 4 个分段，公式的计算结果是 r * 0.552284。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

r = 50;  // radius of the circle
n = 4;   //bezier segments to complete circle
d = r * (4/3) * tan(180/(2*n)); //control point distance

bez = flatten([
    bez_begin([-r,0],  90, d),
    bez_tang ([0,r],    0, d),
    bez_tang ([r,0],  -90, d),
    bez_tang ([0,-r], 180, d),
    bez_end  ([-r,0], -90, d)
]);

debug_bezier(bez, N=3);
```

类似地，对于心形路径，我们将用起始点和结束点替换角点：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = flatten([
    bez_begin([0,25],   40, 40),
    bez_joint([0,-25],  30, 150, 60, 60),
    bez_end  ([0,25],  140, 40)
]);
debug_bezier(bez, N=3);
```

在 [The Bézier Game](https://bezier.method.ac) 中，提示阶段之后的第一个形状是汽车的轮廓。  
下面是我们如何使用三次 Bézier 构造函数复制该形状的方式：

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = flatten([
    bez_begin([0,0], BACK, 15),
    bez_joint([0,9], FWD, RIGHT, 10,10),
    bez_joint([5,9], LEFT, 70, 9,20),
    bez_tang([80,65], 3, 35, 20),
    bez_joint([130,60], 160, -60, 10, 30),
    bez_joint([140,42], 120, 0, 20,55),
    bez_joint([208,9], BACK, RIGHT, 10,6),
    bez_joint([214,9], LEFT, FWD, 10,10),
    bez_joint([214,0], BACK, LEFT, 10,10),
    bez_joint([189,0], RIGHT, -95, 10,10),
    bez_tang([170,-17], LEFT, 10),
    bez_joint([152,0], -85, LEFT, 10,10),
    bez_joint([52,0], RIGHT, -95, 10,10),
    bez_tang([33,-17], LEFT, 10),
    bez_joint([16,0], -85,LEFT, 10,10),
    bez_end  ([0,0], RIGHT,10)
]);

debug_bezier(bez, N = 3);
```

### Bézier 碗形物体/A Bézier Dish

我们可以使用 2D Bézier 路径来定义一个心形碗。  
当我们使用 [bezpath_curve()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bezpath_curve) 将 Bézier 曲线转换为 Bézier 路径时，我们可以通过将 *splinesteps* 增加到 64 来平滑结果路径。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>
include<BOSL2/rounding.scad>

bez = flatten([
    bez_begin([0,50], 40, 100),
    bez_joint([0,-50], 30, 150, 120, 120),
    bez_end  ([0,50], 140, 100)
]);

path = bezpath_curve(bez, splinesteps = 64);
linear_sweep(h = 2, path);

region = offset_stroke(path, -3, closed = true);
linear_sweep(h = 20, region);
```

## 3D 三次 Bézier 路径构建/3D Cubic Bézier Path Construction

BOSL2 包含一组构造函数，用于创建三次 Bézier 路径。它们可以创建 2D 或 3D Bézier 曲线。  
这些构造函数适用于起始点和终点，以及 Bézier 曲线之间的角落和切线连接器。每个函数让您可以选择使用角度表示法、向量表示法或方向向量和距离来指定曲线。

### 通过角度表示法构建 3D 路径/3D Path by Angle Notation

通过角度构造函数可以通过指定曲线上的 3D 点，列出角度（从 X 轴开始）和距离到离开和/或进入控制点，然后添加一个 `p` 参数，该参数表示该控制点相对于 Z 轴的角度，来创建 3D Bézier 路径。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = flatten([
    bez_begin ([-50,0,0], 90, 25, p=90),
    bez_joint ([0,50,50], 180,0 , 50,50, p1=45, p2=45),
    bez_tang  ([50,0,0],  -90, 25, p=90),
    bez_joint ([0,-50,50], 0,180 , 25,25, p1=135,p2=135),    
    bez_end   ([-50,0,0], -90, 25, p=90)
]);

debug_bezier(bez, N=3);
```
## 通过向量表示法构建 3D 路径/3D Path by Vector Notation

三次 Bézier 路径构造函数也可以通过使用向量指定控制点来创建 3D Bézier 路径。第一个向量是位于 Bézier 路径上的控制点的位置，接下来是指向该控制点的进入和/或离开控制点的向量。

```openscad,FlatSpin,NoScales,VPR=[80,0,360*$t],,VPT=[0,0,20]
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = flatten([
    bez_begin([-50,0,0],  [0,25,0]),
    bez_joint([0,50,50],  [-35,0,35], [35,0,35]),
    bez_tang ([50,0,0],   [0,-25,0]),
    bez_joint([0,-50,50], [18,0,-18], [-18,0,-18]),
    bez_end  ([-50,0,0],  [0,-25,0])
]);

debug_bezier(bez, N=3);
```

## 通过方向向量和距离构建 3D 路径/3D Path by Direction Vector and Distance

指定 3D 三次 Bézier 路径的第三种方法是通过方向向量和距离。  
对于 [bez_tang()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_tang) 和 [bez_joint()](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad#function-bez_joint)，如果提供了 r1 而没有提供 r2，函数将使用 r1 的值作为 r2。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

bez = flatten([
     bez_begin([-50,0,0],  BACK, 25),
    bez_joint([0,50,50],  LEFT+UP, RIGHT+UP, 50,50),
    bez_tang ([50,0,0],   FWD, 25),
    bez_joint([0,-50,50], RIGHT+DOWN, LEFT+DOWN, 25,25),
    bez_end  ([-50,0,0],  FWD, 25)
]);

debug_bezier(bez, N=3);
```

### 使用 2D 和 3D Bézier 路径设计花蕾花瓶/A Bud Vase Design using both 2D and 3D Bézier Paths

我们可以使用 2D Bézier 路径来定义花蕾花瓶的形状，正如我们在上面的示例中所做的那样。  
我们将使用一个 3D Bézier 路径来定义花瓶的截面并使顶部更具趣味性，而不是使用 [rotate_sweep()](https://github.com/BelfrySCAD/BOSL2/wiki/skin.scad#functionmodule-rotate_sweep) 来制作一个圆形截面的花瓶。  
这个设计使用 [skin()](https://github.com/BelfrySCAD/BOSL2/wiki/skin.scad#functionmodule-skin) 模块来创建最终的几何形状。

```openscad
include<BOSL2/std.scad>
include<BOSL2/beziers.scad>

//Side Bézier Path
side_bez = [[20,0], [40,40], [-10,70], [20,100]];
side = bezpath_curve(side_bez, splinesteps = 32);
h = last(side).y;
steps = len(side)-1;
step = h/steps;
wall = 2;

//Layer Bézier Path
size = side_bez[0].x; // size of the base
d = size * 0.8;       // intermediate control point distance
theta = 65;           // adjusts layer "wavyness".
bz = 5 * cos(theta);  // offset to raise layer curve minima above z = 0;
                 
layer_bez = flatten([
    bez_begin ([-size,0,bz],  90, d, p=theta),
    bez_tang  ([0, size,bz],   0, d, p=theta),
    bez_tang  ([size, 0,bz], -90, d, p=theta),
    bez_tang  ([0,-size,bz], 180, d, p=theta),    
    bez_end   ([-size,0,bz], -90, d, p=180 - theta)
]);

layer = bezpath_curve(layer_bez);

function layer_xy_scale(z) =
    let (sample_z = side_bez[0].y + z * step) // the sampling height
    let (u = bezier_line_intersection(side_bez, [[0, sample_z],[1, sample_z]]))
    flatten(bezier_points(side_bez,u)).x / side_bez[0].x;

outside =[for(i=[0:steps]) scale([layer_xy_scale(i),layer_xy_scale(i),1],up(i*step, layer))];
inside = [for (curve = outside) hstack(offset(path2d(curve), delta = -2, same_length = true), column(curve,2))];

base = path3d(path2d(outside[0]));  //flatten the base but keep as a 3d path
floor = up(wall, path3d(offset(path2d(outside[0]), -wall)));

skin([ base, each outside, each reverse(inside), floor ], slices=0, refine=1, method="fast_distance");

```