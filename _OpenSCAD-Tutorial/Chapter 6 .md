---
layout: "post"
title:  "第六章 条件"
nav_order: 6
---

# 第六章 条件
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## OpenSCAD 变量

在前几章中，您已经使用变量对设计进行了参数化，使其更易于定制。具体来说，您可以在脚本的某一部分为变量赋值，然后在脚本的其他部分使用这些存储的值。例如，您可以将 `wheel_radius` 变量设置为所需的车轮半径，并在生成汽车车轮的相应语句中使用该变量。通过这种方式，您可以轻松自定义汽车轮子的半径，而无需在脚本中搜索和更改多个值，只需直接更改 `wheel_radius` 变量的值即可。

您还学习了 OpenSCAD 变量的一个重要属性：**变量只能有一个具体值**。如果您为变量赋予一个值，然后在脚本的后续部分为其分配另一个值，则变量在整个设计执行过程中只会保留最后分配的值。以下示例演示了这一点：

---

{: .code-title }
> 示例代码 `two_cylinder_with_same_radius.scad`
>
>```openscad
>$fa=1;
>$fs=0.4;
>height=10;
>radius=5;
>cylinder(h=height,r=radius);
>radius=10;
>translate([30,0,0])
>    cylinder(h=height,r=radius);
>```

---

在上面的代码中，两个圆柱的半径都是 10 个单位，这是在脚本中为 `radius` 变量分配的最后一个值。

当变量存储数值时，它们可以用于指定不同对象的尺寸或定义变换命令。不过，数值并不是唯一可以分配给变量的值。变量还可以存储布尔值（`true` 或 `false`）以及字符（如 `a`、`b`、`c`、`d` 等）。在接下来的内容中，您将看到如何使用布尔值或字符变量进一步对模型和模块进行参数化。

---


## 条件变量赋值

在目前为止的例子中，您已经通过适当的赋值命令为变量赋予了特定值。然而，在某些情况下，您可能更希望赋值本身具有参数化特性，并依赖于设计的某些方面。

创建汽车车身需要定义各种参数。这些参数可以在调用 `body` 模块时通过脚本中定义的相应变量来指定。例如：

---

{: .code-title }
> 示例代码 `parameterized_car_body.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>base_length = 60;
>top_length = 30;
>top_offset = 5;
>body(base_length=base_length, top_length=top_length, top_offset=top_offset);
>```

---

上面版本的汽车车身被称为“短版本”。通过为变量选择不同的值，还可以创建一个“长版本”：

---

{: .code-title }
> 示例代码 `long_car_body.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>base_length = 80;
>top_length = 50;
>top_offset = 10;
>body(base_length=base_length, top_length=top_length, top_offset=top_offset);
>```

---

如果您目前只对这两个车身版本感兴趣，有没有办法快速在两者之间切换，而无需单独修改每个变量？

尽管修改三个变量的工作量不大，但在更复杂的模型中所需的变量数量可能会轻松变得难以管理。幸运的是，这个问题有一个解决方案，那就是**条件赋值**。

{: .new }
条件赋值

条件赋值是一种方法，您可以通过它指示 OpenSCAD 根据某些条件为变量分配不同的值。例如，在本例中，条件是汽车车身是否为长版本。您可以通过定义一个布尔变量 `long_body` 来表示该条件：

- 如果需要长车身，将 `long_body` 设为 `true`：
  ```openscad
  long_body = true;
  ```
- 如果需要短车身，将 `long_body` 设为 `false`：
  ```openscad
  long_body = false;
  ```

然后，使用条件赋值为 `base_length`、`top_length` 和 `top_offset` 变量分配值：

```openscad
base_length = (long_body) ? 80:60;
top_length = (long_body) ? 50:30;
top_offset = (long_body) ? 10:5;
```

上述语法的关键点：
1. `变量名 = (条件) ? 值1:值2;`
2. 条件为 `true` 时，变量被赋予 `值1`；条件为 `false` 时，变量被赋予 `值2`。

通过在脚本中引入条件赋值，您可以通过简单地更改 `long_body` 变量的值（从 `false` 到 `true` 或反之）来快速切换车身版本。

---

{: .code-title }
> 示例代码 `car_with_normal_conditional_body.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>// 条件赋值
>long_body = false;
>base_length = (long_body) ? 80:60;
>top_length = (long_body) ? 50:30;
>top_offset = (long_body) ? 10:5;
>
>// 创建车身
>body(base_length=base_length, top_length=top_length, top_offset=top_offset);
>
>// 创建车轮和车轴
>track = 30;
>wheelbase = 40;
>wheel_radius = 8;
>wheel_width = 4;
>// 前左轮
>translate([-wheelbase/2,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 前右轮
>translate([-wheelbase/2,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 后左轮
>translate([wheelbase/2,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 后右轮
>translate([wheelbase/2,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 前轴
>translate([-wheelbase/2,0,0])
>    axle(track=track);
>// 后轴
>translate([wheelbase/2,0,0])
>    axle(track=track);
>```

---

您还可以添加一个 `large_wheels` 变量作为条件，通过条件赋值控制车轮的半径和宽度。

---

{: .code-title }
> 示例代码 `car_with_short_body_and_large_wheels.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>// 条件赋值
>long_body = false;
>large_wheels = true;
>
>base_length = (long_body) ? 80:60;
>top_length = (long_body) ? 50:30;
>top_offset = (long_body) ? 10:5;
>
>wheel_radius = (large_wheels) ? 10:8;
>wheel_width = (large_wheels) ? 8:4;
>
>// 创建车身
>body(base_length=base_length, top_length=top_length, top_offset=top_offset);
>
>// 创建车轮和车轴
>track = 30;
>wheelbase = 40;
>// 前左轮
>translate([-wheelbase/2,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 前右轮
>translate([-wheelbase/2,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 后左轮
>translate([wheelbase/2,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 后右轮
>translate([wheelbase/2,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 前轴
>translate([-wheelbase/2,0,0])
>    axle(track=track);
>// 后轴
>translate([wheelbase/2,0,0])
>    axle(track=track);
>```

---

通过这种方式，您可以轻松创建不同版本的汽车，例如：
- 短车身 + 大车轮
- 短车身 + 小车轮
- 长车身 + 大车轮
- 长车身 + 小车轮

每个版本只需调整 `long_body` 和 `large_wheels` 的值。

---

## 更多条件变量赋值

在之前的示例中，条件变量赋值只有两个选项（短版或长版车身），使用布尔变量 `long_body` 在这两个选项之间切换。

如果需要在四个车身版本（短版、长版、矩形版和普通版）之间选择，该怎么办？布尔变量无法满足需求，因为它只能有两个值（`true` 或 `false`）。为此，可以使用字符变量来表示车身的选择。

短版车身使用字符 `s` 表示：

```openscad
body_version = "s";
```

长版车身使用字符 `l` 表示：

```openscad
body_version = "l";
```

矩形版车身使用字符 `r` 表示：

```openscad
body_version = "r";
```

普通版车身使用字符 `n` 表示：

```openscad
body_version = "n";
```

当有多个选项时，条件变量赋值的格式如下：

```openscad
// base_length
base_length =
(body_version == "l") ? 80:
(body_version == "s") ? 60:
(body_version == "r") ? 65:70;

// top_length
top_length =
(body_version == "l") ? 50:
(body_version == "s") ? 30:
(body_version == "r") ? 65:40;

// top_offset
top_offset =
(body_version == "l") ? 10:
(body_version == "s") ? 5:
(body_version == "r") ? 0:7.5;
```

{: .code-title }
>代码示例：长版车身
>
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>// 条件赋值车身变量
>body_version = "l";
>
>// base_length
>base_length =
>(body_version == "l") ? 80:
>(body_version == "s") ? 60:
>(body_version == "r") ? 65:70;
>
>// top_length
>top_length =
>(body_version == "l") ? 50:
>(body_version == "s") ? 30:
>(body_version == "r") ? 65:40;
>
>// top_offset
>top_offset =
>(body_version == "l") ? 10:
>(body_version == "s") ? 5:
>(body_version == "r") ? 0:7.5;
>
>// 创建车身
>body(base_length=base_length, top_length=top_length, top_offset=top_offset);
>
>// 创建轮子和车轴
>large_wheels = false;
>wheel_radius = (large_wheels) ? 10:6;
>wheel_width = (large_wheels) ? 8:4;
>track = 30;
>wheelbase = 40;
>
>// 前左轮
>translate([-wheelbase/2,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 前右轮
>translate([-wheelbase/2,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 后左轮
>translate([wheelbase/2,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 后右轮
>translate([wheelbase/2,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// 前车轴
>translate([-wheelbase/2,0,0])
>    axle(track=track);
>// 后车轴
>translate([wheelbase/2,0,0])
>    axle(track=track);
>```

{: .ex-title }
>练习：添加轮子版本变量
>
>在以上示例中，添加一个 `wheels_version` 变量。该变量只能取字符值，并为 `wheel_radius` 和 `wheel_width` 定义不同的值。`wheels_version` 应作为条件变量。若 `wheels_version` 为 `s`（小号），则 `wheel_radius` 和 `wheel_width` 分别为 8 和 4 单位；若为 `m`（中号），分别为 9 和 6 单位；若为 `l`（大号），分别为 10 和 8 单位。小号轮子作为默认情况。

{: .code-title }
>短版车身 - 中号轮子
>
>```openscad
>body_version = "s"; //s-短版, n-普通, l-长版, r-矩形版
>wheels_version = "m"; //s-小号, m-中号, l-大号
>wheel_radius =
>(wheels_version == "l") ? 10:
>(wheels_version == "m") ? 9:8;
>wheel_width =
>(wheels_version == "l") ? 8:
>(wheels_version == "m") ? 6:4;
>```

{: .code-title }
>矩形车身 - 大号轮子
>
>```openscad
>body_version = "r"; //s-短版, n-普通, l-长版, r-矩形版
>wheels_version = "l"; //s-小号, m-中号, l-大号
>```

{: .code-title }
>普通车身 - 小号轮子
>
>```openscad
>body_version = "n"; //s-短版, n-普通, l-长版, r-矩形版
>wheels_version = "s"; //s-小号, m-中号, l-大号
>```

## 条件创建对象 - If语句

条件变量赋值是轻松导航模型不同特定版本的强大工具。通过条件赋值，您能够为汽车定义不同的车身和轮子尺寸，并在不必每次手动提供所有变量值的情况下轻松选择它们。

如果您想对轮子的类型（例如简单、圆形、复杂）或车身的类型（例如方形、圆形）拥有相同的控制，这将需要对象的条件创建，而这可以通过使用`if`语句实现。


首先，让我们回顾一下之前创建的汽车车身模块。模块包含一些输入参数，用于创建两个立方体，一个是车身的底座，一个是车身的顶部。

{: .code-title }
>基本 If 语句示例
>
>```openscad
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5) {
>    // Car body base 
>    cube([base_length,width,base_height],center=true); 
>    // Car body top 
>    translate([top_offset,0,base_height/2+top_height/2])
>        cube([top_length,width,top_height],center=true);
>}
>$fa = 1;
>$fs = 0.4;
>body();
>```

现在，使用`if`语句，您可以看到如何参数化车身顶部的创建。首先，您需要为模块定义一个额外的输入参数。此参数命名为`top`，并存储布尔值。如果该参数为`false`，模块应仅创建车身的底座；如果为`true`，则还应创建车身的顶部。这可以通过以下方式实现：

{: .code }
>```openscad
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5, top) {
>    // Car body base 
>    cube([base_length,width,base_height],center=true); 
>    // Car body top
>    if (top) {
>        translate([top_offset,0,base_height/2+top_height/2])
>        cube([top_length,width,top_height],center=true);
>    }
>}
>$fa = 1;
>$fs = 0.4;
>```

当输入参数`top`设置为`false`时，仅创建车身的底座。

{: .code }
>```openscad
>body(top=false);
>```

当设置为`true`时，创建车身的底座和顶部。

{: .code }
>```openscad
>body(top=true);
>```


以下汽车车身模块已被修改，以包括创建后保险杠的功能。`color`命令用于为保险杠添加视觉效果，仅在预览时起作用。

{: .code-title }
>添加前后保险杠
>
>```openscad
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5, top) {
>    // Car body base 
>    cube([base_length,width,base_height],center=true); 
>    // Car body top
>    if (top) {
>        translate([top_offset,0,base_height/2+top_height/2])
>            cube([top_length,width,top_height],center=true);
>    }
>    // Rear bumper
>    color("blue") {
>        translate([base_length/2,0,0])rotate([90,0,0]) {
>            cylinder(h=width - base_height,r=base_height/2,center=true);
>            translate([0,0,(width - base_height)/2])
>                sphere(r=base_height/2);
>            translate([0,0,-(width - base_height)/2])
>                sphere(r=base_height/2);
>        }
>    }
>}
>$fa = 1;
>$fs = 0.4;
>body(top=true);
>```

通过复制并修改后保险杠的语句，可以创建前保险杠：

{: .code }
>```openscad
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5, top) {
>    // Car body base 
>    cube([base_length,width,base_height],center=true); 
>    // Car body top
>    if (top) {
>        translate([top_offset,0,base_height/2+top_height/2])
>            cube([top_length,width,top_height],center=true);
>    }
>    // Front bumper
>    color("blue") {
>        translate([-base_length/2,0,0])rotate([90,0,0]) {
>            cylinder(h=width - base_height,r=base_height/2,center=true);
>            translate([0,0,(width - base_height)/2])
>                sphere(r=base_height/2);
>            translate([0,0,-(width - base_height)/2])
>                sphere(r=base_height/2);
>        }
>    }
>    // Rear bumper
>    color("blue") {
>        translate([base_length/2,0,0])rotate([90,0,0]) {
>            cylinder(h=width - base_height,r=base_height/2,center=true);
>            translate([0,0,(width - base_height)/2])
>                sphere(r=base_height/2);
>            translate([0,0,-(width - base_height)/2])
>                sphere(r=base_height/2);
>        }
>    }
>}
>$fa = 1;
>$fs = 0.4;
>body(top=true);
>```


为模块定义两个附加的输入参数：`front_bumper`和`rear_bumper`。这些参数应接受布尔值，并使用两个`if`语句条件性地创建前后保险杠。以下是实现后的模块和使用示例：

{: .code-title }
>
>使用条件创建前后保险杠
>```openscad
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5, top, front_bumper, rear_bumper) {
>    // Car body base 
>    cube([base_length,width,base_height],center=true); 
>    // Car body top
>    if (top) {
>        translate([top_offset,0,base_height/2+top_height/2])
>        cube([top_length,width,top_height],center=true);
>    }
>    // Front bumper
>    if (front_bumper) {
>        color("blue") {
>            translate([-base_length/2,0,0])rotate([90,0,0]) {
>                cylinder(h=width - base_height,r=base_height/2,center=true);
>                translate([0,0,(width - base_height)/2])
>                    sphere(r=base_height/2);
>                translate([0,0,-(width - base_height)/2])
>                    sphere(r=base_height/2);
>            }
>        }
>    }
>    // Rear bumper
>    if (rear_bumper) {
>        color("blue") {
>            translate([base_length/2,0,0])rotate([90,0,0]) {
>                cylinder(h=width - base_height,r=base_height/2,center=true);
>                translate([0,0,(width - base_height)/2])
>                    sphere(r=base_height/2);
>                translate([0,0,-(width - base_height)/2])
>                    sphere(r=base_height/2);
>            }
>        }
>    }
>}
>$fa = 1;
>$fs = 0.4;
>body(top=false,front_bumper=true,rear_bumper=true);
>```

通过这种方式，您可以灵活地选择是否添加车身顶部、前保险杠和后保险杠。


## 挑战

在本章中，您学习了变量的条件赋值和简单的 `if` 语句。具体来说，您学会了如何有条件地修改设计各部分的尺寸和变换，以及如何有条件地包含或排除某些部分。现在是时候将这些知识结合在一个汽车模型中实践了。


如果您一直在跟随本教程，那么您的计算机中应该已经有一个 `vehicle_parts.scad` 脚本文件（从前几章中创建）。打开此脚本并根据最后一个示例更新 `body` 模块，以便它具有条件创建车顶、前保险杠和后保险杠的功能。为新增的输入参数设置默认值。具体来说，将 `top`、`front_bumper` 和 `rear_bumper` 参数的默认值分别设置为 `true`、`false` 和 `false`。保存更改并关闭脚本。

{: .code }
>```openscad
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5, top=true, front_bumper=false, rear_bumper=false) {
>    // 车身底部
>    cube([base_length, width, base_height], center=true); 
>    // 车顶
>    if (top) {
>        translate([top_offset, 0, base_height / 2 + top_height / 2])
>            cube([top_length, width, top_height], center=true);
>    }
>    // 前保险杠
>    if (front_bumper) {
>        color("blue") {
>            translate([-base_length / 2, 0, 0]) rotate([90, 0, 0]) {
>                cylinder(h=width - base_height, r=base_height / 2, center=true);
>                translate([0, 0, (width - base_height) / 2])
>                    sphere(r=base_height / 2);
>                translate([0, 0, -(width - base_height) / 2])
>                    sphere(r=base_height / 2);
>            }
>        }
>    }
>    // 后保险杠
>    if (rear_bumper) {
>        color("blue") {
>            translate([base_length / 2, 0, 0]) rotate([90, 0, 0]) {
>                cylinder(h=width - base_height, r=base_height / 2, center=true);
>                translate([0, 0, (width - base_height) / 2])
>                    sphere(r=base_height / 2);
>                translate([0, 0, -(width - base_height) / 2])
>                    sphere(r=base_height / 2);
>            }
>        }
>    }
>}
>```

保存更改后关闭脚本。


以下是一个基本的汽车脚本示例，您需要对其进行适当的添加和修改，以参数化汽车的设计。具体来说，您需要定义以下变量：`body_version`、`wheels_version`、`top`、`front_bumper` 和 `rear_bumper`，用于为汽车的设计做出选择。

```openscad
use <vehicle_parts.scad>
$fa=1;
$fs=0.4;

// 变量
body_version = "l"; // s-短，n-普通，l-长，r-矩形
wheels_version = "l"; // s-小，m-中，l-大
top = true;
front_bumper = true;
rear_bumper = true;
track = 30;
wheelbase = 40;

// 条件赋值
// 车身：底部长度
base_length =
(body_version == "l") ? 80 :
(body_version == "s") ? 60 :
(body_version == "r") ? 65 : 70;

// 车身：顶部长度
top_length =
(body_version == "l") ? 50 :
(body_version == "s") ? 30 :
(body_version == "r") ? 65 : 40;

// 车身：顶部偏移
top_offset =
(body_version == "l") ? 10 :
(body_version == "s") ? 5 :
(body_version == "r") ? 0 : 7.5;

// 车轮：半径
wheel_radius =
(wheels_version == "l") ? 10 :
(wheels_version == "m") ? 8 : 6;

// 车轮：宽度
wheel_width =
(wheels_version == "l") ? 8 :
(wheels_version == "m") ? 6 : 4;

// 创建车身
body(base_length=base_length, top_length=top_length, top_offset=top_offset, top=top, front_bumper=front_bumper, rear_bumper=rear_bumper);

// 前左车轮
translate([-wheelbase/2, -track/2, 0])
    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
// 前右车轮
translate([-wheelbase/2, track/2, 0])
    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
// 后左车轮
translate([wheelbase/2, -track/2, 0])
    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
// 后右车轮
translate([wheelbase/2, track/2, 0])
    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
// 前车轴
translate([-wheelbase/2, 0, 0])
    axle(track=track);
// 后车轴
translate([wheelbase/2, 0, 0])
    axle(track=track);
```
