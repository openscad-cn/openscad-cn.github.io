---
layout: "post"
title:  "第三章 - 球体原始体与对象缩放"
order: 3.1
---

# 球体原始体与对象缩放
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 球体原始体

您将汽车展示给朋友后，他们对您的新技能感到非常惊讶。其中一位朋友甚至挑战您设计一些未来感十足的轮子。这是展示创意并学习更多 OpenSCAD 功能的好机会！

到目前为止，您已经使用了立方体和圆柱原始体。另一个 OpenSCAD 提供的 3D 原始体是球体。您可以使用以下命令创建一个球体：

---

{: .code-title }
>示例代码 `sphere.scad`
>
>```openscad
>sphere(r=10);
>```

---

球体创建后会以原点为中心。输入参数 `r` 对应球体的半径。一个想法是用球形替代圆柱形轮子：

---

{: .ex }
>尝试将汽车的轮子改为球形。为此，替换合适的 `cylinder` 命令为 `sphere` 命令。  
>- 您是否仍然需要将轮子围绕 X 轴旋转？  
>- 变量 `wheel_width` 是否仍然需要？  
>- 修改 `wheels_turn` 变量的值时，模型是否会发生明显变化？

---

将球形轮子压缩成更像轮子的形状。实现此目的的一种方法是使用 `scale` 命令。

{: .new }
用`scale` 命令调整球体形状


---

{: .ex }
>在一个空白模型中创建一个半径为 10 单位的球体。使用 `scale` 命令仅沿 Y 轴以 0.4 的比例缩放球体。  

---

{: .code-title }
>示例代码 `scaled_sphere.scad`
>
>```openscad
>scale([1,0.4,1])
>    sphere(r=10);
>```

---

{: .new }
用 resize 命令调整球体尺寸

另一种缩放对象的方法是使用 `resize` 变换。`resize` 与 `scale` 的区别在于：
- **`scale` 命令**：需要指定每个轴上的缩放比例。
- **`resize` 命令**：需要指定对象沿每个轴的目标尺寸。

例如，在前面的示例中，您从一个半径为 10 的球体开始（沿每个轴的总尺寸为 20 单位），沿 Y 轴缩放 0.4 倍后，Y 轴的结果尺寸为 8 单位。X 和 Z 轴的尺寸保持不变（20 单位）。您可以使用以下 `resize` 命令实现相同结果：

---

{: .code-title }
>示例代码 `narrowed_spherical_wheel_using_resize.scad`
>
>```openscad
>resize([20,8,20])
>    sphere(r=10);
>```

---

{: .new-title }
> 选择缩放方式的建议
>
>- 当您关注缩放比例时，使用 `scale` 命令更方便。
>- 当您更关注缩放结果的实际尺寸时，使用 `resize` 命令更方便。

---

{: .ex }
>尝试使用 `resize` 命令和 `wheel_width` 变量沿 Y 轴调整球形轮子的宽度。仅沿 Y 轴缩放轮子。  

---

{: .code-title }
>示例代码 `resized_wheel.scad`
>
>```openscad
>wheel_width = 8;
>resize([20,wheel_width,20])
>    sphere(r=10);
>```

---

新的轮子设计看起来很酷！接下来您可以创建更适合这种风格的车身。

---

{: .ex }
>**练习**  
>尝试使用 `sphere` 和 `resize`/`scale` 命令代替 `cube` 命令创建与轮子风格相匹配的车身。  

---

通过这节内容，您学习了如何使用球体原始体及其缩放命令调整形状，并为您的模型注入更多创意。

---

---
layout: "post"
title:  "第三章 - 组合对象的新方法"
order: 3.2
---

# 组合对象的新方法
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 隐式和显式的联合操作

到目前为止，当您在模型中创建附加对象时，只需在脚本中添加一条新语句即可。最终的汽车模型是所有定义对象的联合，您已经在隐式地使用 `union` 命令（布尔操作之一）。通过 `union` 布尔操作，OpenSCAD 会将所有对象的联合作为最终模型。在以下脚本中，`union` 被隐式使用：

---

{: .code-title }
>示例代码 `union_of_two_spheres_implicit.scad`
>
>```openscad
>sphere(r=10);
>translate([10,0,0])
>    sphere(r=10);
>```

---

您可以通过在脚本中显式包含 `union` 命令来使其更清晰：

---

{: .code-title }
>示例代码 `union_of_two_spheres_explicit.scad`
>
>```openscad
>union() {
>    sphere(r=10);
>    translate([12,0,0])
>        sphere(r=10);
>}
>```

---

{: .new-title }
>1. `union` 命令没有输入参数（所有布尔操作均如此）。
>2. `union` 应用于大括号内的所有对象。大括号内的语句以分号结束，而关闭大括号后没有分号。
>3. 这种语法与应用于多个对象的变换语法类似。

---

## 布尔操作：差集与交集

除了 `union`，OpenSCAD 提供了另外两种布尔操作：`difference` 和 `intersection`。

{: .new-title }
>差集操作
>
>`difference` 命令会从第一个对象中减去大括号内定义的第二个及后续对象。以下是使用差集的示例：

---

{: .code-title }
>示例代码 `difference_of_two_spheres.scad`
>
>```openscad
>difference() {
>    sphere(r=10);
>    translate([12,0,0])
>        sphere(r=10);
>}
>```

---

如果有第三个或更多对象，它们也会被减去：

---

{: .code-title }
>示例代码 `difference_of_three_spheres.scad`
>
>```openscad
>difference() {
>    sphere(r=10);
>    translate([12,0,0])
>        sphere(r=10);
>    translate([0,-12,0])
>        sphere(r=10);
>}
>```

---

{: .new-title }
>交集操作
>
>`intersection` 命令保留所有对象的重叠部分。以下是交集的示例：

---

{: .code-title }
>示例代码 `intersection_of_three_spheres.scad`
>
>```openscad
>intersection() {
>    sphere(r=10);
>    translate([12,0,0])
>        sphere(r=10);
>    translate([0,-12,0])
>        sphere(r=10);
>}
>```

---

如果只定义两个球体，交集结果如下：

---

{: .code-title }
>示例代码 `intersection_of_two_spheres.scad`
>
>```openscad
>intersection() {
>    sphere(r=10);
>    translate([12,0,0])
>        sphere(r=10);
>}
>```

---

{: .ex-title }
>练习：使用差集设计新轮子
>
>尝试使用差集命令创建新轮子设计。首先创建一个球体，然后从两侧减去一部分球体。

---

{: .code-title }
>示例代码 `wheel_with_spherical_sides.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 10;
>side_spheres_radius = 50;
>hub_thickness = 4;
>difference() {
>    sphere(r=wheel_radius);
>    translate([0,side_spheres_radius + hub_thickness/2,0])
>        sphere(r=side_spheres_radius);
>    translate([0,-(side_spheres_radius + hub_thickness/2),0])
>        sphere(r=side_spheres_radius);
>}
>```

---

{: .ex-title }
>练习：为轮子添加孔洞
>
>通过减去四个与轮子垂直的圆柱体，从轮子上去除一些材料。这些圆柱应放置在半个轮子半径的位置，并均匀分布。

---

{: .code-title }
>示例代码 `wheel_with_spherical_sides_and_holes.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 10;
>side_spheres_radius = 50;
>hub_thickness = 4;
>cylinder_radius = 2;
>cylinder_height = 2 * wheel_radius;
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


{: .ex-title }
>练习：在汽车模型中使用新轮子
>
>尝试将上述新轮子应用于汽车模型中：

---

{: .code-title }
>示例代码 `car_with_wheels_with_spherical_sides_and_holes.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 10;
>base_height = 10;
>top_height = 14;
>track = 35;
>side_spheres_radius = 50;
>hub_thickness = 4;
>cylinder_radius = 2;
>cylinder_height = 2 * wheel_radius;
>rotate([0,0,0]) {
>    cube([60,20,base_height],center=true);
>    translate([5,0,base_height/2+top_height/2 - 0.001])
>        cube([30,20,top_height],center=true);
>}
>translate([-20,-track/2,0])
>    rotate([0,0,0])
>    difference() {
>        sphere(r=wheel_radius);
>        translate([0,side_spheres_radius + hub_thickness/2,0])
>            sphere(r=side_spheres_radius);
>        translate([0,-(side_spheres_radius + hub_thickness/2),0])
>            sphere(r=side_spheres_radius);
>        translate([wheel_radius/2,0,0])
>            rotate([90,0,0])
>            cylinder(h=cylinder_height,r=cylinder_radius,center=true);
>    }
>// Repeat similar structures for other wheels...
>```

---

通过这节内容，您学习了如何使用布尔操作创建复杂模型，并尝试设计了独特的汽车轮子。

---