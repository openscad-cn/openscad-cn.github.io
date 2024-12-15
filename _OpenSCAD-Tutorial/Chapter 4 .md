---
layout: "post"
title:  "第四章 引入模块以组织代码"
nav_order: 4
---

# 第四章 引入模块以组织代码
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 定义和使用模块

在上一章的最后一个示例中，脚本变得相当冗长。这是由于用更复杂的轮子设计替换了简单的圆柱形轮子（复杂轮子需要多个语句，而简单轮子只需一个语句）。要将简单轮子更换为复杂轮子，您需要找到脚本中所有定义简单轮子的 `cylinder` 命令，并用定义复杂轮子的命令替换它们。

这种过程与更改轮子直径的过程类似。当未使用变量时，您必须一个一个地找到脚本中的相关值并逐一替换。这种重复且耗时的过程，通过引入 `wheel_radius` 变量得到了改进，您可以快速轻松地更改轮子的直径。那么，是否有方法改进这种需要完全更改轮子设计的繁琐过程？答案是肯定的！您可以使用 **模块（module）**，它相当于对整个部分或模型应用的变量。

---

首先，回忆一下复杂轮子的设计：

---

{: .code-title }
>示例代码 `wheel_with_spherical_sides_and_holes.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius=10; 
>side_spheres_radius=50; 
>hub_thickness=4; 
>cylinder_radius=2; 
>cylinder_height=2*wheel_radius; 
>difference() {
>    sphere(r=wheel_radius);
>    translate([0,side_spheres_radius + hub_thickness/2,0])
>        sphere(r=side_spheres_radius);
>    translate([0,-(side_spheres_radius + hub_thickness/2),0])
>        sphere(r=side_spheres_radius);
>    translate([wheel_radius/2,0,0])
>        rotate([90,0,0])
>        cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>    translate([0,0,wheel_radius/2])
>        rotate([90,0,0])
>        cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>    translate([-wheel_radius/2,0,0])
>        rotate([90,0,0])
>        cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>    translate([0,0,-wheel_radius/2])
>        rotate([90,0,0])
>        cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>}
>```

---

您可以通过以下方式将上述轮子定义为模块：

---

{: .code-title }
>示例代码 `blank_model.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>module wheel() {
>    wheel_radius=10;
>    side_spheres_radius=50;
>    hub_thickness=4;
>    cylinder_radius=2;
>    cylinder_height=2*wheel_radius;
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0,side_spheres_radius + hub_thickness/2,0])
>            sphere(r=side_spheres_radius);
>        translate([0,-(side_spheres_radius + hub_thickness/2),0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2,0,0])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>        translate([0,0,wheel_radius/2])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>        translate([-wheel_radius/2,0,0])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>        translate([0,0,-wheel_radius/2])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>    }
>}
>```

---

{: .new-title }
> 模块定义规则
>
>1. **模块语法**
>   - 使用 `module` 关键字定义模块，后接模块名称（如 `wheel`）。
>   - 模块名称后是一对括号（`()`），目前括号内为空，因为尚未定义参数。
>   - 括号后是大括号，所有定义对象的命令都放置在大括号内。
>   - 末尾无需分号。
>
>2. **使用模块**
>   - 定义模块后，OpenSCAD 不会自动创建任何对象。
>   - 要创建轮子，必须添加使用模块的语句，如同创建原始体（例如 `cube` 或 `sphere`）一样。

---

{: .code-title }
>示例代码 `wheel_created_by_module.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>module wheel() {
>    wheel_radius=10;
>    side_spheres_radius=50;
>    hub_thickness=4;
>    cylinder_radius=2;
>    cylinder_height=2*wheel_radius;
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0,side_spheres_radius + hub_thickness/2,0])
>            sphere(r=side_spheres_radius);
>        translate([0,-(side_spheres_radius + hub_thickness/2),0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2,0,0])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>        translate([0,0,wheel_radius/2])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>        translate([-wheel_radius/2,0,0])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>        translate([0,0,-wheel_radius/2])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>    }
>}
>wheel();
>```

---


定义模块可以看作是扩展 OpenSCAD 脚本语言。定义了轮子模块后，就相当于增加了一个新的原始体。随后，您可以像使用其他原始体一样使用这个模块。

---

{: .ex }
>**练习**  
>尝试在汽车脚本中定义上述轮子模块，并使用定义的轮子模块创建汽车的轮子。
>例如：
>```openscad
>wheel();
>translate([20,0,0])
>wheel();
>```

--- 

通过本节内容，您学习了如何通过定义模块来简化复杂设计的管理和复用，为模型的扩展和修改提供了高效的解决方案。

---

## 参数化模块

轮子模块中指定的设计包含许多变量，这些变量可用于自定义轮子设计。这些变量在模块定义的大括号内定义。结果是，虽然可以自定义轮子模块的输出，但该模块本身只能根据定义变量的值创建一个版本的轮子。这意味着轮子模块无法同时创建适用于前轴和后轴的不同轮子。

如果您已经熟悉了参数化设计的最佳实践，就会意识到这种情况并不可取。如果轮子模块可以创建不同版本的轮子，效果会更好。为实现这一点，需要将轮子模块中定义和使用的变量改为模块的参数。可以通过以下方式实现：

---

{: .code-title }
>示例代码 `wheel_created_by_parameterized_module.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>module wheel(wheel_radius, side_spheres_radius, hub_thickness, cylinder_radius) {
>    cylinder_height = 2 * wheel_radius;
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0, side_spheres_radius + hub_thickness/2, 0])
>            sphere(r=side_spheres_radius);
>        translate([0, -(side_spheres_radius + hub_thickness/2), 0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([-wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, -wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>    }
>}
>wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2);
>```

---

{: .new-title }
> 参数化模块的要点
>
>1. **模块参数定义**  
>   - 模块参数在模块名称后的括号内定义。例如 `wheel(wheel_radius, side_spheres_radius, hub_thickness, cylinder_radius)`。
>   - 变量的值不再在模块的大括号内分配，而是在每次调用模块时定义。
>
>2. **模块的可复用性**  
>   - 参数化后的模块可以根据需要创建不同版本的轮子，极大地提高了灵活性和可复用性。

---



{: .ex } 
>尝试在汽车脚本中定义上述轮子模块。使用轮子模块创建汽车的轮子。调用轮子模块时，将值 `10`, `50`, `4`, 和 `2` 传递给对应的 `wheel_radius`、`side_spheres_radius`、`hub_thickness` 和 `cylinder_radius` 参数。  
>

{: .code } 
>```openscad
>translate([-20, -track/2, 0])
>    wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2);
>translate([-20, track/2, 0])
>    wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2);
>```

---

{: .ex }
>在汽车脚本中定义 `wheel_radius`, `side_spheres_radius`, `hub_thickness` 和 `cylinder_radius` 变量，并分别赋值为 `10`, `50`, `4` 和 `2`。使用这些变量作为参数调用轮子模块。  

{: .code } 
>```openscad
>wheel_radius = 10;
>side_spheres_radius = 50;
>hub_thickness = 4;
>cylinder_radius = 2;
>translate([-20, -track/2, 0])
>    wheel(wheel_radius, side_spheres_radius, hub_thickness, cylinder_radius);
>translate([-20, track/2, 0])
>    wheel(wheel_radius, side_spheres_radius, hub_thickness, cylinder_radius);
>```

---

{: .ex }
>**练习**  
>为前轴和后轴定义不同的 `wheel_radius`, `side_spheres_radius`, `hub_thickness` 和 `cylinder_radius` 变量。为这些变量分配您喜欢的值组合，并在调用轮子模块时使用这些变量。  

{: .code } 
>```openscad
>// 前轮参数
>front_wheel_radius = 10;
>front_side_spheres_radius = 50;
>front_hub_thickness = 4;
>front_cylinder_radius = 2;
>
>// 后轮参数
>rear_wheel_radius = 12;
>rear_side_spheres_radius = 55;
>rear_hub_thickness = 5;
>rear_cylinder_radius = 3;
>
>// 调用模块
>translate([-20, -track/2, 0])
>    wheel(front_wheel_radius, front_side_spheres_radius, front_hub_thickness, front_cylinder_radius);
>translate([20, -track/2, 0])
>    wheel(rear_wheel_radius, rear_side_spheres_radius, rear_hub_thickness, rear_cylinder_radius);
>```

---

通过本节内容，您学习了如何参数化模块以提高模块的灵活性，并实现了更高效的模型设计和管理。

---


---

## 设置模块参数的默认值

您可以为轮子模块的参数设置默认值组合。这可以通过以下方式实现：

---

{: .code-title }
>示例代码 `wheel_with_default_parameters.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>module wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2) {
>    cylinder_height = 2 * wheel_radius;
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0, side_spheres_radius + hub_thickness/2, 0])
>            sphere(r=side_spheres_radius);
>        translate([0, -(side_spheres_radius + hub_thickness/2), 0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([-wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, -wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>    }
>}
>```

---

{: .new-title }
>模块默认值的优点
>
>1. **定义默认值**  
>   - 默认值在模块定义的括号中指定，例如：  
>     `module wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2)`。
>   - 如果调用模块时未指定某个参数的值，则会使用该参数的默认值。
>
>2. **灵活性**  
>   - 默认值可以设置为轮子最常用的版本。  
>   - 模块调用时，默认值可以被覆盖（重新定义）。覆盖时可以覆盖部分或全部默认值。

---

{: .new }
调用模块时，如果未指定参数，将使用默认值。例如：

---

{: .code-title }
>示例代码 `wheel_created_by_default_parameters.scad`
>
>```openscad
>wheel();
>```

---

{: .new }
您也可以通过指定参数来覆盖默认值。例如：

---

{: .code-title }
>示例代码 `wheel_with_thicker_hub.scad`
>
>```openscad
>wheel(hub_thickness=8);
>```

---

{: .code-title }
>示例代码 `wheel_with_thicker_hub_and_larger_radius.scad`
>
>```openscad
>wheel(hub_thickness=8, wheel_radius=12);
>```

---

{: .new-title }
>覆盖部分默认值的优势
>
>- **提高灵活性**：您可以通过覆盖一个或多个默认值来轻松定制模块的输出。
>- **提高可读性**：代码更加简洁，不需要重复定义未改变的参数。

---

{: .ex-title }
>**练习 1**  
>
>在轮子模块的定义中添加默认值。尝试创建多个轮子，覆盖部分或全部默认值。  

{: .ex-title }
>**练习 2**  
>
>尝试覆盖 `side_spheres_radius` 的默认值，使轮子看起来像下图所示的设计：  

---

{: .code-title }
>示例代码 `wheel_with_larger_side_radius.scad`
>
>```openscad
>wheel(side_spheres_radius=10);
>```

---

通过为模块参数设置默认值，您可以极大地提高代码的灵活性和模块的重用性，同时降低修改设计时的复杂性。

---


## 将整个模型分解为模块

使用模块是 OpenSCAD 的一个强大功能。您可以将模型看作是多个模块的组合。例如，汽车模型可以由车身模块、车轮模块和车轴模块组成。这种方法不仅提升了模型的可重用性，还可以通过重新组合模块创建不同的模型。

---


{: .ex-title  }
>**练习**  定义车身和车轴模块
>
>尝试定义车身模块和车轴模块。  
>- 车身模块和车轴模块需要哪些参数？  
>- 使用车身模块、车轮模块和车轴模块重新创建汽车模型。  
>- 为车轮模块的参数设置默认值，使其对应于前轮的设计。  
>- 定义适当的变量，传递不同的值给车轮模块以创建后轮。  
>- 也为车身模块和车轴模块的参数设置默认值。

---

{: .code-title }
>示例代码 `car_with_different_wheels_and_default_body_and_axle.scad`
>
>```openscad
>module wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2) {
>    cylinder_height = 2 * wheel_radius;
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0, side_spheres_radius + hub_thickness/2, 0])
>            sphere(r=side_spheres_radius);
>        translate([0, -(side_spheres_radius + hub_thickness/2), 0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([-wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, -wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>    }
>}
>
>module body(base_height=10, top_height=14, base_length=60, top_length=30, width=20, top_offset=5) {
>    cube([base_length, width, base_height], center=true);
>    translate([top_offset, 0, base_height/2 + top_height/2 - 0.001])
>        cube([top_length, width, top_height], center=true);
>}
>
>module axle(track=35, radius=2) {
>    rotate([90, 0, 0])
>        cylinder(h=track, r=radius, center=true);
>}
>
>$fa = 1;
>$fs = 0.4;
>wheelbase = 40;
>track = 35;
>body_roll = 0;
>wheels_turn = 0;
>wheel_radius_rear = 12;
>
>rotate([body_roll, 0, 0]) {
>    body();
>}
>translate([-wheelbase/2, -track/2, 0])
>    rotate([0, 0, wheels_turn])
>    wheel();
>translate([-wheelbase/2, track/2, 0])
>    rotate([0, 0, wheels_turn])
>    wheel();
>translate([wheelbase/2, -track/2, 0])
>    rotate([0, 0, 0])
>    wheel(wheel_radius=wheel_radius_rear);
>translate([wheelbase/2, track/2, 0])
>    rotate([0, 0, 0])
>    wheel(wheel_radius=wheel_radius_rear);
>translate([-wheelbase/2, 0, 0])
>    axle();
>translate([wheelbase/2, 0, 0])
>    axle();
>```

---


{: .ex-title }
>**练习**创建六轮汽车模型
>
>尝试复用车身、车轮和车轴模块创建一个类似于六轮汽车的模型。

---

{: .code-title }
>示例代码 `car_with_six_wheels.scad`
>
>```openscad
>module wheel(wheel_radius=10, side_spheres_radius=50, hub_thickness=4, cylinder_radius=2) {
>    cylinder_height = 2 * wheel_radius;
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0, side_spheres_radius + hub_thickness/2, 0])
>            sphere(r=side_spheres_radius);
>        translate([0, -(side_spheres_radius + hub_thickness/2), 0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([-wheel_radius/2, 0, 0])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>        translate([0, 0, -wheel_radius/2])
>            rotate([90, 0, 0])
>            cylinder(h=cylinder_height, r=cylinder_radius, center=true);
>    }
>}
>
>module body(base_height=10, top_height=14, base_length=100, top_length=75, width=20, top_offset=5) {
>    cube([base_length, width, base_height], center=true);
>    translate([top_offset, 0, base_height/2 + top_height/2 - 0.001])
>        cube([top_length, width, top_height], center=true);
>}
>
>module axle(track=35, radius=2) {
>    rotate([90, 0, 0])
>        cylinder(h=track, r=radius, center=true);
>}
>
>$fa = 1;
>$fs = 0.4;
>track = 35;
>body_roll = 0;
>wheels_turn = 0;
>wheel_radius = 12;
>front_axle_offset = 30;
>rear_axle_1_offset = 10;
>rear_axle_2_offset = 35;
>
>rotate([body_roll, 0, 0]) {
>    body(base_length=100, top_length=75, top_offset=5);
>}
>translate([-front_axle_offset, -track/2, 0])
>    rotate([0, 0, wheels_turn])
>    wheel(wheel_radius=wheel_radius);
>translate([-front_axle_offset, track/2, 0])
>    rotate([0, 0, wheels_turn])
>    wheel(wheel_radius=wheel_radius);
>translate([rear_axle_1_offset, -track/2, 0])
>    rotate([0, 0, 0])
>    wheel(wheel_radius=wheel_radius);
>translate([rear_axle_1_offset, track/2, 0])
>    rotate([0, 0, 0])
>    wheel(wheel_radius=wheel_radius);
>translate([rear_axle_2_offset, -track/2, 0])
>    rotate([0, 0, 0])
>    wheel(wheel_radius=wheel_radius);
>translate([rear_axle_2_offset, track/2, 0])
>    rotate([0, 0, 0])
>    wheel(wheel_radius=wheel_radius);
>translate([-front_axle_offset, 0, 0])
>    axle();
>translate([rear_axle_1_offset, 0, 0])
>    axle();
>translate([rear_axle_2_offset, 0, 0])
>    axle();
>```

---

通过本节内容，您学习了如何使用模块化设计组织复杂模型，同时为模块设置参数和默认值，使模型更灵活、易于扩展。

---