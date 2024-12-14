---
layout: post
title:  "第七章"
nav_order: 7
---

# 第七章
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}


在上一章中，您学习了如何使用 if 语句控制设计中某些部分是否应该被创建。在本章中，您将学习如何在模型或对象形成特定模式时，创建多个部分或对象。

以下是一个汽车模型的示例，通过该示例您将学习如何创建这样的模式。

{: .code-title }
>**文件名：** `single_car.scad`
>
>{: .code}
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>// 变量
>track = 30;
>wheelbase=40;
>
>// 车身
>body();
>
>// 前左轮
>translate([-wheelbase/2,-track/2,0])
>    rotate([0,0,0])
>    simple_wheel();
>
>// 前右轮
>translate([-wheelbase/2,track/2,0])
>    rotate([0,0,0])
>    simple_wheel();
>
>// 后左轮
>translate([wheelbase/2,-track/2,0])
>    rotate([0,0,0])
>    simple_wheel();
>
>// 后右轮
>translate([wheelbase/2,track/2,0])
>    rotate([0,0,0])
>    simple_wheel();
>
>// 前轴
>translate([-wheelbase/2,0,0])
>    axle(track=track);
>
>// 后轴
>translate([wheelbase/2,0,0])
>    axle(track=track);
>```

{: .ex }
根据上述汽车示例，修改代码以创建另一辆汽车。为了避免重复编写创建汽车的代码，您应该创建一个 `car` 模块。该模块应具有两个输入参数：`track` 和 `wheelbase`，默认值分别为 30 和 40。第一辆车的位置应如上例所示，第二辆车应沿 Y 轴正方向平移 50 个单位。

>{: .code-title }
>**文件名：** `two_cars.scad`
>
>{: .code}
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>module car(track=30, wheelbase=40) {
>    // 车身
>    body();
>    
>    // 前左轮
>    translate([-wheelbase/2,-track/2,0])
>        rotate([0,0,0])
>        simple_wheel();
>    
>    // 前右轮
>    translate([-wheelbase/2,track/2,0])
>        rotate([0,0,0])
>        simple_wheel();
>    
>    // 后左轮
>    translate([wheelbase/2,-track/2,0])
>        rotate([0,0,0])
>        simple_wheel();
>    
>    // 后右轮
>    translate([wheelbase/2,track/2,0])
>        rotate([0,0,0])
>        simple_wheel();
>    
>    // 前轴
>    translate([-wheelbase/2,0,0])
>        axle(track=track);
>    
>    // 后轴
>    translate([wheelbase/2,0,0])
>        axle(track=track);
>}
>
>car();
>translate([0,50,0])
>    car();
>```

{: .ex }
使用 for 循环创建一个汽车阵列。第一个汽车应该位于原点，后续的每辆汽车应沿 Y 轴正方向相对于前一辆汽车平移 50 个单位，总共创建 10 辆汽车。

{: .code-title }
>**文件名：** `row_of_ten_cars_along_y_axis.scad`
>
>{: .code}
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>for (dy=[0:50:450]) {
>    translate([0,dy,0])
>        car();
>}
>```

{: .new-title }
>**for 循环语法**
>
>1. **关键字 `for`**
>   - 紧跟一对括号。
>   - 括号内定义循环变量及其取值范围。
>
>2. **循环变量**
>   - 在示例中，变量 `dy` 表示每辆车沿 Y 轴平移的单位数。
>   - 变量的值从 0 开始，每次增加 50，直到达到 450。
>
>3. **代码块**
>   - 大括号内包含循环中重复执行的语句。
>   - 在此示例中，大括号内的 `translate` 和 `car()` 语句重复执行。
>
>4. **执行次数**
>   - 循环变量 `dy` 共取 10 个值，因此循环语句执行 10 次。
>
>5. **灵活性**
>   - 使用循环变量参数化平移量，实现重复模式。

{: .ex }
使用 for 循环创建一个汽车阵列。第一个汽车位于原点，后续每辆汽车应沿 X 轴正方向相对于前一辆汽车平移 70 个单位，总共创建 8 辆汽车。for 循环变量应命名为 `dx`。

{: .code-title }
>**文件名：** `row_of_eight_cars_along_x_axis.scad`
>
>{: .code}
>```openscad
>use <vehicle_parts.scad>
>$fa=1;
>$fs=0.4;
>
>for (dx=[0:70:490]) {
>    translate([dx,0,0])
>        car();
>}
>```
