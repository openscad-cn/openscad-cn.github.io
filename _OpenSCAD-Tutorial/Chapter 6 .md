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

在前几章中，您已经使用变量对设计进行了参数化，使其更易于定制。变量还可以存储布尔值（`true` 或 `false`）以及字符。

## 条件变量赋值

条件赋值是一种方法，您可以通过它指示 OpenSCAD 根据某些条件为变量分配不同的值。

## 更多条件变量赋值

当有多个选项时，可以使用字符变量来表示选择。

{% raw %}
```openscad
body_version = "l"; // l=长, s=短, r=矩形, n=普通
```
{% endraw %}

## 条件创建对象 - If 语句

![来自模块的车身](/assets/images/Car_body_from_module.jpg)

![带顶部的车身](/assets/images/Car_body_with_top.jpg)

![不带顶部的车身](/assets/images/Car_body_without_top.jpg)

![带前后保险杠的车身](/assets/images/Car_body_with_front_and_rear_bumper.jpg)

![带后保险杠的车身](/assets/images/Car_body_with_rear_bumper.jpg)

![带顶部和前后保险杠的车身](/assets/images/Body_with_top_with_front_and_rear_bumper.jpg)

![带顶部和前保险杠的车身](/assets/images/Body_with_top_with_front_bumper.jpg)

![不带顶部但带前后保险杠的车身](/assets/images/Body_without_top_with_front_and_rear_bumper.jpg)

![高度参数化的汽车脚本](/assets/images/Car_from_highly_parameterized_script.jpg)

![长车身大轮子的汽车](/assets/images/Car_with_long_body_and_large_wheels.jpg)

---

## 挑战

在本章中，您学习了变量的条件赋值和简单的 `if` 语句，学会了如何有条件地修改设计各部分的尺寸和变换，以及如何有条件地包含或排除某些部分。

---
