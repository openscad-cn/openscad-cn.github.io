---
layout: post
title:  "第七章 循环"
nav_order: 7
---

# 第七章 循环
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 创建重复模式的零件或模型 - for 循环

在上一章中，您学习了如何使用 if 语句控制设计中某些部分是否应该被创建。在本章中，您将学习如何在模型或对象形成特定模式时，创建多个部分或对象。

---

## 创建更复杂的模式

在之前的例子中，for 循环变量直接用于修改模式中每个单独模型的某些属性。当模型需要修改多个属性时，for 循环变量最好取整数值。

![对角排列的五辆汽车](/assets/images/Diagonal_row_of_five_cars.jpg)

![对角排列的五辆旋转汽车](/assets/images/Diagonal_row_of_five_twisted_cars.jpg)

![圆形排列的十辆汽车](/assets/images/Circular_pattern_of_ten_cars.jpg)

![用极坐标定位的汽车](/assets/images/Car_positioned_with_polar_coordinates.jpg)

---

## 挑战

![面向圆心的汽车](/assets/images/Cars_facing_at_the_origin.jpg)

![背向圆心的汽车](/assets/images/Cars_facing_away_from_the_origin.jpg)

![顺时针驾驶的汽车](/assets/images/Cars_driving_clockwise.jpg)

![逆时针驾驶的汽车](/assets/images/Cars_driving_counter_clockwise.jpg)

---

## 创建模式的模式 — 嵌套 for 循环

![五行六列的汽车阵列](/assets/images/Five_rows_of_six_cars.jpg)

---

如果您的 OpenSCAD 技能足够自信，请创建一个名为 `spoked_wheel` 的新模块：

![辐条轮子](/assets/images/Spoked_wheel.jpg)

![水平辐条轮子](/assets/images/Spoked_wheel_horizontal.jpg)

![使用辐条轮子的汽车](/assets/images/Car_with_spoked_wheels.jpg)

---
