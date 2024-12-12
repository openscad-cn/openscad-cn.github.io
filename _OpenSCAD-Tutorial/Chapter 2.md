---
layout: "post"
title:  "第二章"
order: 2
---

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

### 对多个对象应用缩放

您也可以将相同的 `scale` 命令或其他任何变换命令应用于多个对象。以下代码将 `scale` 命令应用于汽车车身的底部和顶部：

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
