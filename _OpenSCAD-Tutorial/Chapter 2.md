---
layout: "post"
title:  "第二章 参数化"
nav_order: 2
---

# 第二章 参数化
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 缩放部分或整个模型

在上一章中创建的模型是使用 OpenSCAD 的一个良好起点，但在查看模型后，您可能会发现需要修改某些部分。在本节中，我们将讨论修改设计组件的策略。其中一种方法是使用 `scale` 命令，这是另一种变换命令。

通过以下方式修改创建汽车车身底部的语句，将车身长度增加 1.2 倍：

---

{: .code-title }
>示例代码 `car_with_lengthened_body_base.scad`
>
>```openscad
>// Car body base
>scale([1.2,1,1])
>    cube([60,20,10],center=true);
>```

---

您会注意到，`scale` 命令的使用方式与 `translate` 和 `rotate` 命令相似。它被添加在现有语句的左侧，中间没有分号。它的输入参数是一个包含三个值的向量。与 `translate` 和 `rotate` 命令类似，每个值分别对应于沿 X、Y 和 Z 轴的缩放比例。

---

{: .ex }
>尝试修改 `scale` 命令的输入，以沿 X 轴缩放车身底部 1.2 倍，沿 Y 轴缩放 0.1 或 2 倍。  
>- 您是否得到了一个可能是火星探测车或坦克的模型？  
>- 您是否对与原始汽车相比模型的不同感到惊讶？

---

{: .new }
>对多个对象应用缩放
>
>您也可以将相同的 `scale` 命令或其他任何变换命令应用于多个对象。以下代码将 `scale` 命令应用于汽车车身的底部和顶部：

---

{: .code-title }
>示例代码 `car_with_lengthened_body.scad`
>
>```openscad
>scale([1.2,1,1]) {
>    // Car body base
>    cube([60,20,10],center=true);
>    // Car body top
>    translate([5,0,10 - 0.001])
>        cube([30,20,10],center=true);
>}
>```

---

{: .new }
>
>1. **使用大括号**  
>   要将 `scale` 命令应用于多个对象，需要使用一组大括号。对应对象的定义语句及其分号放置在大括号内。大括号的末尾不需要分号。
>
>2. **增加可读性**  
>   注意如何通过空白和注释来提高脚本的可读性。以下脚本与上面的脚本完全等效，您可以自行决定更喜欢哪种风格：

---

{: .code-title }
>示例代码（无注释版本）
>
>```openscad
>scale([1.2,1,1]) {
>    cube([60,20,10],center=true);
>    translate([5,0,10 - 0.001])
>        cube([30,20,10],center=true);
>}
>```

---

{: .ex }
>尝试将 `scale` 命令应用于整个模型。  
>- 您是否记得将所有语句包括在大括号内？  
>- 为了使轮子不变形，沿 X 和 Z 轴的缩放因子应该是什么关系？  
>- 如果要使汽车保持相同比例但尺寸加倍，缩放因子应该是多少？

---

{: .new }
>为了防止轮子变形，沿 X 和 Z 轴的缩放因子应该相等。

## 快速测验

以下脚本是您在第一章中创建的模型：

---

{: .code }
>```openscad
>$fa = 1;
>$fs = 0.4;
>// Car body base
>cube([60,20,10],center=true);
>// Car body top
>translate([5,0,10 - 0.001])
>    cube([30,20,10],center=true);
>// Front left wheel
>translate([-20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Front right wheel
>translate([-20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Rear left wheel
>translate([20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Rear right wheel
>translate([20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>```

---

{: .ex }
>尝试让汽车的前轮围绕 Z 轴旋转 20 度，就像汽车正在向右转弯一样。为了让您的模型更加逼真，尝试让汽车的车身（底部和顶部）围绕 X 轴沿相反方向旋转 5 度。  
>- 要使轮子转动，请修改现有的 `rotate` 命令的输入参数。  
>- 要使车身旋转，请添加一个新的 `rotate` 命令。

---

{: .code-title }
>示例代码 `turning_car.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>rotate([5,0,0]) {
>    // Car body base
>    cube([60,20,10],center=true);
>    // Car body top
>    translate([5,0,10 - 0.001])
>        cube([30,20,10],center=true);
>}
>// Front left wheel
>translate([-20,-15,0])
>    rotate([90,0,-20])
>    cylinder(h=3,r=8,center=true);
>// Front right wheel
>translate([-20,15,0])
>    rotate([90,0,-20])
>    cylinder(h=3,r=8,center=true);
>// Rear left wheel
>translate([20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Rear right wheel
>translate([20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>```

---

通过这次练习，您应该能更好地理解如何结合 `rotate` 命令创建更复杂、更逼真的模型。

---

## 使用变量控制轮子大小

以下代码展示了如何通过变量 `wheel_radius` 控制轮子的大小：

---

{: .code-title }
>示例代码 `car_with_same_sized_wheels.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 6;
>// Car body base
>cube([60,20,10],center=true);
>// Car body top
>translate([5,0,10 - 0.001])
>    cube([30,20,10],center=true);
>// Front left wheel
>translate([-20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front right wheel
>translate([-20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>wheel_radius = 12;
>// Rear left wheel
>translate([20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear right wheel
>translate([20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>```

---

{: .new }
>1. **变量值的覆盖**  
>   您会注意到所有轮子的大小都相同。这是因为 OpenSCAD 使用了变量的最后一次赋值。即使变量在更早的语句中已被引用，最终仍会采用最后赋值的值。
>
>2. **警告信息**  
>   当出现变量被覆盖的情况时，OpenSCAD 会给出警告。例如：  
>   ```openscad
>   WARNING: wheel_radius was assigned on line 3 but was overwritten on line 17
>   ```
>

---

{: .note }
> **提示**  
> 在 `{}` 大括号内定义的变量仅在大括号内有效。即使同名变量在不同的大括号层级中重复赋值，也不会被视为冲突。

---


## 参数化模型的更多部分

通过参数化，您现在可以轻松调整轮子的大小。然而，如果能以同样的方式自定义模型的更多方面会更方便。请注意，修改轮子的大小并不会影响模型的其他部分，也不会破坏模型。这种情况并非总是如此。

---

{: .ex }
>**练习**  
>尝试通过定义 `base_height` 和 `top_height` 变量来修改汽车车身底部和顶部的高度，并在对应语句中做出适当更改。  
>将 `base_height` 变量的值赋为 `5`，`top_height` 变量的值赋为 `8`。您注意到了什么？

---

{: .code-title }
>示例代码 `car_with_floating_body_top.scad`
>
>```openscad
>base_height = 5;
>top_height = 8;
>// Car body base
>cube([60,20,base_height],center=true);
>// Car body top
>translate([5,0,10 - 0.001])
>    cube([30,20,top_height],center=true);
>```

---

{: .note }
>可以明显看出，汽车的车身不再是一个整体，底部和顶部分离了。这是因为车身顶部的正确位置依赖于车身底部和顶部的高度。  
>为了让顶部位于底部之上，您需要将顶部沿 Z 轴平移的距离定义为底部高度的一半加顶部高度的一半。  
>如果您要参数化底部和顶部的高度，也应该同时参数化顶部沿 Z 轴的平移量。

---

{: .ex }
>尝试使用 `base_height` 和 `top_height` 变量参数化车身顶部沿 Z 轴的平移量，使其位于车身底部之上。  
>尝试为 `base_height` 和 `top_height` 分配不同的值。车身顶部的位置是否保持正确？

---

{: .code-title }
>示例代码 `car_with_properly_attached_body_top.scad`
>
>```openscad
>base_height = 5;
>top_height = 8;
>wheel_radius = 8;
>// Car body base
>cube([60,20,base_height],center=true);
>// Car body top
>translate([5,0,base_height/2+top_height/2 - 0.001])
>    cube([30,20,top_height],center=true);
>```

---

{: .code-title }
>示例代码 `car_with_higher_body.scad`
>
>```openscad
>base_height = 8;
>top_height = 14;
>```

---


{: .new }
每次参数化模型的某些方面时，都应该同时参数化相关的依赖部分，以防模型分离或破碎。

---

{: .ex }
>尝试使用一个名为 `track` 的新变量参数化左右轮之间的间距。  
>为 `track` 变量赋予不同的值。您注意到了什么？模型中是否有其他部分依赖于 `track` 变量的值？如果是，请使用 `track` 变量参数化它们，以确保模型不分离。

---

{: .code-title }
>示例代码 `car_with_unattached_wheels.scad`
>
>```openscad
>track = 40;
>// Front left wheel
>translate([-20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front right wheel
>translate([-20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear left wheel
>translate([20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear right wheel
>translate([20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>```

---

{: .code-title }
>示例代码 `car_with_properly_attached_wheels.scad`
>
>```openscad
>track = 40;
>// Front left wheel
>translate([-20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front right wheel
>translate([-20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear left wheel
>translate([20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear right wheel
>translate([20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track,r=2,center=true);
>```

---

通过这次练习，您可以掌握如何参数化模型的多个部分，同时确保相关依赖部分保持正确。

---


## 挑战

以下脚本对应于具有参数化轮子半径、车身底部高度、顶部高度以及车轮间距的汽车模型：

---

{: .code-title }
>示例代码 `car_from_parameterized_script.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 8;
>base_height = 10;
>top_height = 10;
>track = 30;
>// Car body base
>cube([60,20,base_height],center=true);
>// Car body top
>translate([5,0,base_height/2+top_height/2 - 0.001])
>    cube([30,20,top_height],center=true);
>// Front left wheel
>translate([-20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front right wheel
>translate([-20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear left wheel
>translate([20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Rear right wheel
>translate([20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=wheel_radius,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track,r=2,center=true);
>```

---

{: .ex }
>尝试使用 `wheel_width` 变量参数化轮子的宽度，使用 `wheels_turn` 变量参数化前轮围绕 Z 轴的旋转角度，使用 `body_roll` 变量参数化车身围绕 X 轴的旋转角度。  
>尝试为 `wheel_radius`、`base_height`、`top_height`、`track`、`wheel_width`、`wheels_turn` 和 `body_roll` 赋予不同的值，创建您喜欢的汽车版本。

---

{: .code-title }
>示例代码 `turning_car_from_parameterized_script.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 10;
>base_height = 10;
>top_height = 14;
>track = 40;
>wheel_width = 10;
>body_roll = -5;
>wheels_turn = 20;
>rotate([body_roll,0,0]) {
>    // Car body base
>    cube([60,20,base_height],center=true);
>    // Car body top
>    translate([5,0,base_height/2+top_height/2 - 0.001])
>        cube([30,20,top_height],center=true);
>}
>// Front left wheel
>translate([-20,-track/2,0])
>    rotate([90,0,wheels_turn])
>    cylinder(h=wheel_width,r=wheel_radius,center=true);
>// Front right wheel
>translate([-20,track/2,0])
>    rotate([90,0,wheels_turn])
>    cylinder(h=wheel_width,r=wheel_radius,center=true);
>// Rear left wheel
>translate([20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=wheel_width,r=wheel_radius,center=true);
>// Rear right wheel
>translate([20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=wheel_width,r=wheel_radius,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track,r=2,center=true);
>```

---

通过这次练习，您应该已经清楚地了解，参数化您的模型可以让您轻松地复用、自定义和迭代设计，同时可以毫不费力地探索不同的可能性。

---

## 参数化您自己的模型

您是否已经将新学到的技能付诸实践？是否尝试创建了其他模型？

---

{: .ex }
>尝试参数化您已创建模型的几个或更多方面。  
>- 尝试为您定义的变量分配各种不同的值组合。  
>- 观察设计的不同版本之间有多大的差异。  
>- 看看您能走多远！

---

通过参数化，您可以轻松探索设计的多种可能性，同时提高模型的可定制性和重用性。
