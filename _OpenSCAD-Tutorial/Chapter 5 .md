---
layout: "post"
title:  "第五章"
nav_order: 5
---

# 第五章
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 创建和使用独立模块脚本

在上一章中，您学习了 OpenSCAD 的一个强大功能——模块，以及如何将模块用于参数化设计。您还将汽车分解为不同的模块并重新组合，以创建不同类型的车辆。模块不仅是组织创作的一种方式，还可以帮助您构建自己的对象库。例如，车轮模块可以在大量设计中使用，将其保存为独立脚本可以让您在需要时轻松使用，而无需在当前设计脚本中重新定义。

---

{: .ex }
>**练习**定义简单车轮模块
>
>定义以下 `simple_wheel` 模块，并将其保存在一个单独的脚本文件中。在相同脚本中调用 `simple_wheel` 模块，以便直观地看到模块创建的对象。将脚本保存为 `simple_wheel.scad`。

---

{: .code-title }
>示例代码 `simple_wheel.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>module simple_wheel(wheel_radius=10, wheel_width=6) {
>    rotate([90,0,0])
>        cylinder(h=wheel_width, r=wheel_radius, center=true);
>}
>simple_wheel();
>```

---

您现在可以在另一个设计中使用已保存的模块。首先，需要创建一个新设计脚本。

{: .ex }
>**练习**在新设计中利用模块
>
>创建一个新的脚本并包含以下汽车设计。将脚本保存到与 `simple_wheel` 模块相同的工作目录中。

---

{: .code-title }
>示例代码 `car_with_simple_wheels.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 8;
>base_height = 10;
>top_height = 10;
>track = 30;
>// Car body base
>cube([60,20,base_height], center=true);
>// Car body top
>translate([5,0,base_height/2+top_height/2 - 0.001])
>    cube([30,20,top_height], center=true);
>// Front left wheel
>translate([-20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3, r=wheel_radius, center=true);
>// Front right wheel
>translate([-20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3, r=wheel_radius, center=true);
>// Rear left wheel
>translate([20,-track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3, r=wheel_radius, center=true);
>// Rear right wheel
>translate([20,track/2,0])
>    rotate([90,0,0])
>    cylinder(h=3, r=wheel_radius, center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track, r=2, center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track, r=2, center=true);
>```

---



您可以通过两种方式在汽车设计中使用 `simple_wheel.scad` 脚本：`include` 或 `use`。要包含脚本，请在汽车脚本顶部添加以下语句：

---

{: .code-title }
>**示例代码**使用 `include` 导入模块
>
>```openscad
>include <simple_wheel.scad>
>```

---

您会注意到，原点上生成了一个轮子。这是由于 `simple_wheel.scad` 脚本中的模块定义和模块调用都被包含进了当前脚本。接下来，您可以通过使用 `use` 命令来避免这个问题，但暂时不必担心。

---

{: .ex }
>**练习**替换汽车设计中的轮子
>汽车脚本中的轮子目前由 `cylinder` 命令创建。由于已包含 `simple_wheel.scad` 脚本，`simple_wheel` 模块现在可用。将所有 `cylinder` 命令替换为对 `simple_wheel` 模块的调用。调用时不定义任何参数。

---

{: .code-title }
>示例代码 `car_with_wheels_created_by_included_module.scad`
>
>```openscad
>include <simple_wheel.scad>
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 8;
>base_height = 10;
>top_height = 10;
>track = 30;
>// Car body base
>cube([60,20,base_height], center=true);
>// Car body top
>translate([5,0,base_height/2+top_height/2 - 0.001])
>    cube([30,20,top_height], center=true);
>// Front left wheel
>translate([-20,-track/2,0])
>    simple_wheel();
>// Front right wheel
>translate([-20,track/2,0])
>    simple_wheel();
>// Rear left wheel
>translate([20,-track/2,0])
>    simple_wheel();
>// Rear right wheel
>translate([20,track/2,0])
>    simple_wheel();
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track, r=2, center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track, r=2, center=true);
>```

---


{: .ex-title }
>**练习**自定义模块参数
>
>在调用 `simple_wheel` 模块时，定义 `wheel_radius` 和 `wheel_width` 参数。为此，使用现有的 `wheel_radius` 变量和一个新定义的 `wheel_width` 变量。

---

{: .code-title }
>示例代码 `car_with_narrower_wheels_created_by_included_module.scad`
>
>```openscad
>include <simple_wheel.scad>
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 8;
>wheel_width = 4;
>base_height = 10;
>top_height = 10;
>track = 30;
>// Car body base
>cube([60,20,base_height], center=true);
>// Car body top
>translate([5,0,base_height/2+top_height/2 - 0.001])
>    cube([30,20,top_height], center=true);
>// Front left wheel
>translate([-20,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Front right wheel
>translate([-20,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Rear left wheel
>translate([20,-track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Rear right wheel
>translate([20,track/2,0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track, r=2, center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=track, r=2, center=true);
>```

---

通过上述示例可以看到，`include` 不仅使外部脚本的模块可用，还会创建外部脚本中生成的对象。为了避免这种情况，可以使用 `use` 命令。

{: .ex-title }
>**练习**使用 `use` 导入模块 
>
>将上一示例中的 `include` 命令替换为 `use` 命令。

---

{: .code-title }
>示例代码 `car_with_wheels_created_by_used_module.scad`
>
>```openscad
>use <simple_wheel.scad>
>$fa = 1;
>$fs = 0.4;
>// 其余代码与上一示例相同...
>```

---

通过这节内容，您学习了如何创建和使用独立模块脚本，并了解了 `include` 和 `use` 命令的区别。

---

## 使用包含多个模块的脚本

在前面的示例中，`simple_wheel.scad` 脚本中只有一个模块 `simple_wheel`。但实际情况并不一定总是如此，您可以在同一个脚本中定义多个模块。

---

{: .ex-title }
>**练习**在脚本中添加多个模块
>
>将以下模块添加到 `simple_wheel.scad` 脚本中，并将脚本重命名为 `wheels.scad`。

---

{: .code-title }
>示例代码 `wheels.scad`
>
>```openscad
>module complex_wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2) {
>    cylinder_height = 2 * wheel_radius;
>    difference() {
>        // Wheel sphere
>        sphere(r=wheel_radius);
>        // Side sphere 1
>        translate([0, side_spheres_radius + hub_thickness/2, 0])
>            sphere(r=side_spheres_radius);
>        // Side sphere 2
>        translate([0, - (side_spheres_radius + hub_thickness/2), 0])
>            sphere(r=side_spheres_radius);
>        // Cylinder 1
>        translate([wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        // Cylinder 2
>        translate([0, 0, wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        // Cylinder 3
>        translate([-wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        // Cylinder 4
>        translate([0, 0, -wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>    }
>}
>```

---

{: .ex-title }
>**练习**使用 `wheels.scad` 脚本中的模块
>
>在汽车脚本中使用 `wheels.scad` 脚本。用 `simple_wheel` 模块创建前轮，用 `complex_wheel` 模块创建后轮。

---

{: .code-title }
>示例代码 `car_with_different_wheels_from_used_modules.scad`
>
>```openscad
>use <wheels.scad>
>wheel_radius = 8;
>wheel_width = 4;
>base_height = 10;
>top_height = 10;
>track = 30;
>// Car body base
>cube([60, 20, base_height], center=true);
>// Car body top
>translate([5, 0, base_height/2 + top_height/2 - 0.001])
>    cube([30, 20, top_height], center=true);
>// Front left wheel
>translate([-20, -track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Front right wheel
>translate([-20, track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Rear left wheel
>translate([20, -track/2, 0])
>    complex_wheel();
>// Rear right wheel
>translate([20, track/2, 0])
>    complex_wheel();
>// Front axle
>translate([-20, 0, 0])
>    rotate([90, 0, 0])
>    cylinder(h=track, r=2, center=true);
>// Rear axle
>translate([20, 0, 0])
>    rotate([90, 0, 0])
>    cylinder(h=track, r=2, center=true);
>```

---

{: .ex-title }
>**练习**创建一个包含所有模块的脚本
>
>创建一个 `vehicle_parts.scad` 脚本。定义 `simple_wheel`、`complex_wheel`、`body` 和 `axle` 模块。在另一个脚本中使用这些模块，创建一个类似以下设计的车辆概念。

---

{: .code-title }
>示例代码 `car_with_ten_wheels.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 8;
>wheel_width = 4;
>base_length = 60;
>top_length = 80;
>track = 30;
>wheelbase_1 = 38;
>wheelbase_2 = 72;
>z_offset = 10;
>body(base_length=base_length, top_length=top_length, top_offset=0);
>// Front left wheel
>translate([-wheelbase_2/2, -track/2, z_offset])
>    complex_wheel();
>// Front right wheel
>translate([-wheelbase_2/2, track/2, z_offset])
>    complex_wheel();
>// Rear left wheel
>translate([wheelbase_2/2, -track/2, z_offset])
>    complex_wheel();
>// Rear right wheel
>translate([wheelbase_2/2, track/2, z_offset])
>    complex_wheel();
>// Front axle
>translate([-wheelbase_2/2, 0, z_offset])
>    axle(track=track);
>// Rear axle
>translate([wheelbase_2/2, 0, z_offset])
>    axle(track=track);
>// Middle front left wheel
>translate([-wheelbase_1/2, -track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Middle front right wheel
>translate([-wheelbase_1/2, track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Middle left wheel
>translate([0, -track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Middle right wheel
>translate([0, track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Middle rear left wheel
>translate([wheelbase_1/2, -track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Middle rear right wheel
>translate([wheelbase_1/2, track/2, 0])
>    simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>// Middle front axle
>translate([-wheelbase_1/2, 0, 0])
>    axle(track=track);
>// Middle axle
>translate([0, 0, 0])
>    axle(track=track);
>// Middle rear axle
>translate([wheelbase_1/2, 0, 0])
>    axle(track=track);
>```

---

通过这节内容，您学习了如何在一个脚本中包含多个模块，并利用这些模块创建复杂的设计。

--

## 使用 MCAD 库

MCAD 库（[GitHub 链接](https://github.com/openscad/MCAD)）是 OpenSCAD 附带的一个常用机械设计组件库。通过调用相应的 OpenSCAD 脚本和模块，您可以在设计中利用 MCAD 库中的对象。例如，`boxes.scad` 脚本包含了一个圆角盒子的模型模块。您可以打开此脚本以查看模块的参数，并将其用于设计中的圆角盒子。

以下脚本展示了如何创建一个完全圆角的盒子，其边长为 10、20 和 30 单位，圆角半径为 3 单位：

---

{: .code-title }
>示例代码 `completely_rounded_box.scad`
>
>```openscad
>use <MCAD/boxes.scad>
>$fa = 1;
>$fs = 0.4;
>roundedBox(size=[10,20,30], radius=3, sidesonly=false);
>```

---

通过将参数 `sidesonly` 设置为 `true`，您可以创建一个具有相同尺寸但只有四个圆角边的盒子：

---

{: .code-title }
>示例代码 `sides_only_rounded_box.scad`
>
>```openscad
>use <MCAD/boxes.scad>
>$fa = 1;
>$fs = 0.4;
>roundedBox(size=[10,20,30], radius=3, sidesonly=true);
>```

---

`boxes.scad` 脚本位于 MCAD 目录中，而 MCAD 目录位于 OpenSCAD 的库目录下。库目录可以在 OpenSCAD 的安装文件夹中找到。如果您希望从任何目录中访问自己的库，可以将它们添加到库目录中。此外，您可以在 [OpenSCAD 的库页面](https://www.openscad.org/libraries.html) 浏览其他可用的 OpenSCAD 库。不过，GitHub 和 Thingiverse 上可用的库数量远远超过 OpenSCAD 网站上列出的库。

---

{: .ex }
>使用 MCAD 库的 `boxes.scad` 脚本创建一个完全圆角的盒子，其边长为 50、20 和 15 单位，圆角半径为 5 单位。

---

{: .code-title }
>示例代码 `horizontal_completely_rounded_box.scad`
>
>```openscad
>use <MCAD/boxes.scad>
>$fa = 1;
>$fs = 0.4;
>roundedBox(size=[50,20,15], radius=5, sidesonly=false);
>```

---

{: .ex }
>使用 MCAD 库的 `boxes.scad` 脚本创建一个只有四个圆角边的盒子，其边长为 50、50 和 15 单位，圆角半径为 20 单位。

---

{: .code-title }
>示例代码 `short_sides_only_rounded_box.scad`
>
>```openscad
>use <MCAD/boxes.scad>
>$fa = 1;
>$fs = 0.4;
>roundedBox(size=[50,50,15], radius=20, sidesonly=true);
>```

---

通过本节内容，您学习了如何使用 MCAD 库中的模块为设计添加更多功能和复杂性。

---


## 创建更多可参数化的模块

到目前为止，模块的输入参数是通过定义特定的模块输入参数实现的。例如，`complex_wheel` 模块能够根据输入参数（如 `wheel_radius`、`hub_thickness` 等）创建各种参数化的轮子。

在设计中，您一直在使用 `body`、`wheel` 和 `axle` 模块的组合来生成各种车辆设计。在所有的车辆设计中，两轮和一个轴组合成了一个轮轴组。您可能已经考虑过创建一个 `axle_wheelset` 模块来同时定义这三种对象，而您这样想是正确的！但为什么之前没有实现这个模块呢？接下来我们将揭晓答案。

---

以下代码展示了如何使用现有知识将 `simple_wheel` 和 `axle` 模块组合到一起：

---

{: .code-title }
>示例代码 `axle_with_simple_wheelset_from_module.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>module axle_wheelset(wheel_radius=10, wheel_width=6, track=35, radius=2) {
>    translate([0,track/2,0])
>        simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>    axle(track=track, radius=radius);
>    translate([0,-track/2,0])
>        simple_wheel(wheel_radius=wheel_radius, wheel_width=wheel_width);
>}
>axle_wheelset();
>```

---

此模块可以很好地满足创建一组 `simple_wheel` 的需求。然而，如果要切换到复杂的轮子设计，则需要完全重新定义一个新的模块：

---

{: .code-title }
>示例代码 `axle_with_complex_wheelset_from_module.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>module axle_wheelset_complex(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2, track=35, radius=2) {
>    translate([0,track/2,0])
>        complex_wheel(wheel_radius=wheel_radius, side_spheres_radius=side_spheres_radius, hub_thickness=hub_thickness, cylinder_radius=cylinder_radius);
>    axle(track=track, radius=radius);
>    translate([0,-track/2,0])
>        complex_wheel(wheel_radius=wheel_radius, side_spheres_radius=side_spheres_radius, hub_thickness=hub_thickness, cylinder_radius=cylinder_radius);
>}
>axle_wheelset_complex();
>```

---


为了避免为不同的轮子和轴设计定义大量的模块，可以将轮子设计参数化。以下是改进的模块定义：

---

{: .code-title }
>示例代码 `axle_with_simple_wheelset_from_parameterized_module.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>module axle_wheelset(track=35, radius=2) {
>    translate([0,track/2,0])
>        children(0);
>    axle(track=track, radius=radius);
>    translate([0,-track/2,0])
>        children(0);
>}
>axle_wheelset() {
>    simple_wheel();
>}
>```

---

通过在调用模块时使用大括号传递轮子设计，可以轻松切换轮子类型：

---

{: .code-title }
>示例代码 `axle_with_complex_wheelset_from_parameterized_module.scad`
>
>```openscad
>axle_wheelset() {
>    complex_wheel();
>}
>```

---

{: .code-title }
>示例代码 `axle_with_large_complex_wheelset_from_parameterized_module.scad`
>
>```openscad
>axle_wheelset(radius=5) {
>    complex_wheel(wheel_radius=20);
>}
>```

---


通过 `children` 命令可以传递多个对象。例如，可以通过以下修改使模块在一侧使用复杂轮子，另一侧使用简单轮子：

---

{: .code-title }
>示例代码 `axle_with_different_wheels_from_parameterized_module.scad`
>
>```openscad
>module axle_wheelset(track=35, radius=2) {
>    translate([0,track/2,0])
>        children(0);
>    axle(track=track, radius=radius);
>    translate([0,-track/2,0])
>        children(1);
>}
>axle_wheelset() {
>    complex_wheel();
>    simple_wheel();
>}
>```

---

{: .ex }
>1. 尝试交换调用模块时大括号内定义的轮子顺序。观察结果。
>2. 尝试仅定义一个轮子。是否会出现错误提示？
>3. 在 `vehicle_parts.scad` 中添加一个 `axle_wheelset` 模块，并使用 `children` 命令参数化轮子设计。用该脚本创建一个新的车辆设计。

---

## 挑战

在过去两章中学习的内容为您提供了一套强大的工具，帮助您开始创建自己的对象库，这些对象可以灵活组合和自定义，以实现新的设计。

---

{: .ex }
> **练习**  
> 想象一个您希望创建的模型。将其分解为不同的部分。为每个部分设计多种替代方案，并定义生成它们的模块。  
> - 每个模块的输入参数应该是什么？  
> - 使用 `children` 功能定义一个或多个模块，以便灵活地组合您创建的各个部分。  

---

通过这次挑战，您将能够将模块化设计的概念应用于实际问题，同时提高设计的灵活性和可重用性。

---