---
layout: "post"
title:  "第五章 模块与库"
nav_order: 5
---

# 第五章 模块与库
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

您现在可以在另一个设计中使用已保存的模块。

## 使用包含多个模块的脚本

![从使用模块创建的不同轮子](/assets/images/Car_with_different_wheels_from_used_modules.jpg)

---

## 使用 MCAD 库

MCAD 库是 OpenSCAD 附带的一个常用机械设计组件库。

---

## 创建更多可参数化的模块

通过 `children` 命令可以传递多个对象。

![模块创建的带复杂轮组的车轴](/assets/images/Axle_with_complex_wheelset_from_module.jpg)

![参数化模块创建的带复杂轮组的车轴](/assets/images/Axle_with_complex_wheelset_from_parameterized_module.jpg)

![参数化模块创建的不同轮子车轴](/assets/images/Axle_with_different_wheels_from_parameterized_module.jpg)

![参数化模块创建的翻转不同轮子车轴](/assets/images/Axle_with_flipped_different_wheels_from_parameterized_module.jpg)

![参数化模块创建的带大复杂轮组的车轴](/assets/images/Axle_with_large_complex_wheelset_from_parameterized_module.jpg)

![参数化模块创建的缺少轮子车轴](/assets/images/Axle_with_missing_wheel_from_parameterized_module.jpg)

![模块创建的相同轮子车轴](/assets/images/Axle_with_same_wheels_from_module.jpg)

![模块创建的带简单轮组的车轴](/assets/images/Axle_with_simple_wheelset_from_module.jpg)

![参数化模块创建的带简单轮组的车轴](/assets/images/Axle_with_simple_wheelset_from_parameterized_module.jpg)

---

通过这次挑战，您将能够将模块化设计的概念应用于实际问题，同时提高设计的灵活性和可重用性。

---
