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

---


## 创建更复杂的模式

在之前的例子中，for 循环变量 `dy` 直接用于修改模式中每个单独模型的某些属性。唯一修改的属性是每个模型沿 Y 或 X 轴的平移量。在每次循环中，变量 `dy` 的值等于每个模型需要的平移量。

当模型需要修改多个属性时，for 循环变量最好取整数值，例如 0、1、2、3 等。然后通过这些整数值生成修改模型不同属性（例如沿某些轴的平移或某些部分的缩放）的所需值。在以下示例中，这个概念被用来同时将每辆车沿 Y 轴和 X 轴分别平移 50 和 70 个单位。

{: .code-title }
>**文件名：** `diagonal_row_of_five_cars.scad`
>
>{: .code}
>```openscad
>for (i=[0:1:4]) {
>    translate([i*70,i*50,0])
>        car();
>}
>```

{: .new }>
>- 在此例中，for 循环变量被命名为 `i`。当 for 循环变量以这种方式使用时，通常被称为索引变量（index variable），并通常命名为 `i`。
>- 由于 for 循环变量取整数值，因此需要将其乘以一个合适的数字来生成所需的平移量。
>  - 沿 Y 轴的平移量通过将变量 `i` 乘以 50 生成。
>  - 沿 X 轴的平移量通过将变量 `i` 乘以 70 生成。

{: .ex }
为上例添加旋转变换，使每辆车绕 Z 轴旋转。第一辆车不应旋转。每辆后续的车相对于前一辆车绕 Z 轴正方向多旋转 90 度。Z 轴正方向的旋转会将 X 轴旋转到 Y 轴方向。思考：要保持汽车位置正确，旋转变换应在平移变换之前还是之后应用？

{: .code-title }
>**文件名：** `diagonal_row_of_five_twisted_cars.scad`
>
>{: .code}
>```openscad
>for (i=[0:1:4]) {
>    translate([i*70,i*50,0])
>        rotate([0,0,i*90])
>        car();
>}
>```

以下是一个更有趣的模式。

{: .code-title }
>**文件名：** `circular_pattern_of_ten_cars.scad`
>
>{: .code}
>```openscad
>r = 200;
>for (i=[0:36:359]) {
>    translate([r*cos(i),r*sin(i),0])
>        car();
>}
>```

{: .new }>
>1. **极坐标**
>   - 创建圆形模式需要使用极坐标。
>   - 极坐标是一种通过已知圆的半径和角度计算圆上点的 X 和 Y 坐标的方法。
>   - 角度 0 对应于圆上属于 X 轴正方向的点。
>     - Y 轴正方向对应 90 度。
>     - X 轴负方向对应 180 度。
>     - Y 轴负方向对应 270 度。
>     - X 轴正方向再次对应 360 度。
>   - 根据极坐标，X 坐标通过将半径乘以角度的余弦计算，Y 坐标通过将半径乘以角度的正弦计算。
>
>2. **循环变量的取值**
>   - 为了在圆周上均匀放置 10 辆车，循环变量 `i` 每次增加 36（360/10=36）。
>   - 首辆车位于角度 0，360 度对应的车会与其重叠。因此循环变量需要在达到 360 之前停止递增，例如可以设定为 359。
>
>3. **脚本可读性**
>   - 使用额外变量并正确命名可以让脚本更具描述性。


{: .code-title }
>**文件名：** `parametric_circular_pattern.scad`
>
>{: .code}
>```openscad
>r = 200; // 圆的半径
>n = 10; // 汽车数量
>step = 360/n;
>for (i=[0:step:359]) {
>    angle = i;
>    dx = r*cos(angle);
>    dy = r*sin(angle);
>    translate([dx,dy,0])
>        car();
>}
>```

{: .ex }
>修改上例的参数以创建一个圆周为 160 单位、由 14 辆车组成的模式。

{: .code-title }
>**文件名：** `parametric_circular_pattern_of_fourteen_cars.scad`
>
>{: .code}
>```openscad
>r = 160; // 圆的半径
>n = 14; // 汽车数量
>step = 360/n;
>for (i=[0:step:359]) {
>    angle = i;
>    dx = r*cos(angle);
>    dy = r*sin(angle);
>    translate([dx,dy,0])
>        car();
>}
>```

{: .ex }
如果您不熟悉极坐标，可以使用以下脚本进行试验。尝试为半径和角度赋予不同的值，观察汽车的位置。

{: .code-title }
>**文件名：** `car_positioned_with_polar_coordinates.scad`

{: .code}
>```openscad
>radius = 100;
>angle = 30; // 角度，单位为度
>
>dx = radius*cos(angle);
>dy = radius*sin(angle);
>
>translate([dx,dy,0])
>    car();
>```

---


## 挑战

{: .ex }
**练习**
上述脚本用于创建一个由 14 辆车组成的圆形模式。通过添加旋转变换修改脚本，使所有汽车面向圆心。使用修改后的脚本创建一个由 12 辆车组成、半径为 140 单位的模式。

{: .code-title }
>**文件名：** `cars_facing_at_the_origin.scad`
>
>{: .code}
>```openscad
>r = 140; // 模式半径
>n = 12; // 汽车数量
>step = 360/n;
>for (i=[0:step:359]) {
>    angle = i;
>    dx = r*cos(angle);
>    dy = r*sin(angle);
>    translate([dx,dy,0])
>        rotate([0,0,angle])
>        car();
>}
>```

{: .ex }
>通过适当修改上述脚本，创建以下三种模式：
>1. 所有汽车背对圆心。
>2. 所有汽车沿圆周切线方向逆时针排列。
>3. 所有汽车沿圆周切线方向顺时针排列。

{: .code-title }
>**背对圆心的汽车模式** `cars_facing_away_from_the_origin.scad`
>
>{: .code}
>```openscad
>translate([dx,dy,0])
>    rotate([0,0,angle - 180])
>    car();
>```

{: .code-title }
>**逆时针驾驶的汽车模式** `cars_driving_counter_clockwise.scad`
>
>```openscad
>translate([dx,dy,0])
>    rotate([0,0,angle - 90])
>    car();
>```

{: .code-title }
>**顺时针驾驶的汽车模式** `cars_driving_clockwise.scad`
>
>```openscad
>translate([dx,dy,0])
>    rotate([0,0,angle - 270])
>    car();
>```

现在您已经掌握了使用 for 循环创建复杂模式的技能，是时候将这些技能应用于更复杂的轮子设计了！

{: .ex }
如果您对 OpenSCAD 技能感到自信，或者想要进一步尝试，请创建一个名为 `spoked_wheel` 的新模块，设计如下图所示的轮子。如果需要额外指导，可以完成以下练习。

{: .ex }
如果需要额外指导，请创建一个名为 `spoked_wheel` 的新模块，该模块应包含 5 个输入参数：`radius`、`width`、`thickness`、`number_of_spokes` 和 `spoke_radius`，默认值分别为 12、5、5、7 和 1.5。使用 `cylinder` 和 `difference` 命令创建轮圈，通过从一个较大的圆柱体中减去一个较小的圆柱体完成。仅使用 `radius`、`width` 和 `thickness` 变量来完成此步骤。

{: .code-title }
>**文件名：** `ring_of_spoked_wheel.scad`
>
>```openscad
>module spoked_wheel(radius=12, width=5, thickness=5, number_of_spokes=7, spoke_radius=1.5) {
>    
>    // 轮圈
>    inner_radius = radius - thickness/2;
>    difference() {
>        cylinder(h=width,r=radius,center=true);
>        cylinder(h=width + 1,r=inner_radius,center=true);
>    }
>}
>spoked_wheel();
>```

{: .ex }
扩展上述模块，额外创建轮子的辐条。轮子的辐条需要是圆柱形，长度应从轮圈中心延伸到半厚度位置。您需要使用 for 循环创建辐条模式。

{: .code-title }
>**文件名：** `spoked_wheel_horizontal.scad`
>
>```openscad
>module spoked_wheel(radius=12, width=5, thickness=5, number_of_spokes=7, spoke_radius=1.5) {
>    
>    // 轮圈  
>    inner_radius = radius - thickness/2;
>    difference() {
>        cylinder(h=width,r=radius,center=true);
>        cylinder(h=width + 1,r=inner_radius,center=true);
>    }
>    
>    // 辐条
>    spoke_length = radius - thickness/4;
>    step = 360/number_of_spokes;
>    for (i=[0:step:359]) {
>        angle = i;
>        rotate([0,90,angle])
>            cylinder(h=spoke_length,r=spoke_radius);
>    }
>}
>spoked_wheel();
>```

{: .ex }
为了使新设计的轮子与您在教程中创建的现有设计兼容，需要将其旋转以保持垂直。

{: .code-title }
>**文件名：** `spoked_wheel.scad`
>
>```openscad
>module spoked_wheel(radius=12, width=5, thickness=5, number_of_spokes=7, spoke_radius=1.5) {
>    
>    rotate([90,0,0]) {
>        // 轮圈
>        inner_radius = radius - thickness/2;
>        difference() {
>            cylinder(h=width,r=radius,center=true);
>            cylinder(h=width + 1,r=inner_radius,center=true);
>        }
>        
>        // 辐条
>        spoke_length = radius - thickness/4;
>        step = 360/number_of_spokes;
>        for (i=[0:step:359]) {
>            angle = i;
>            rotate([0,90,angle])
>                cylinder(h=spoke_length,r=spoke_radius);
>        }
>    }
>}
>
>
>spoked_wheel();
>```

{: .ex }
将 `spoked_wheel` 模块添加到 `vehicle_parts.scad` 文件中，并在汽车模型中使用新设计的轮子。您可以尝试复制以下模型。

{: .code-title }
>**文件名：** `car_with_spoked_wheels.scad`
>
>```openscad
>use <vehicle_parts.scad>
>
>$fa = 1;
>$fs = 0.4;
>
>front_track = 24;
>rear_track = 34;
>wheelbase = 60;
>
>front_wheels_radius = 10;
>front_wheels_width = 4;
>front_wheels_thickness = 3;
>front_spoke_radius = 1;
>
>front_axle_radius = 1.5;
>
>// 圆形车身
>resize([90,20,12])
>    sphere(r=10);
>translate([10,0,5])
>    resize([50,15,15])sphere(r=10);
>
>// 车轮
>translate([-wheelbase/2,-front_track/2,0])
>    spoked_wheel(radius=front_wheels_radius, width=front_wheels_width, thickness=front_wheels_thickness, spoke_radius=front_spoke_radius);
>translate([-wheelbase/2,front_track/2,0])
>    spoked_wheel(radius=front_wheels_radius, width=front_wheels_width, thickness=front_wheels_thickness, spoke_radius=front_spoke_radius);
>translate([wheelbase/2,-rear_track/2,0])
>    spoked_wheel();
>translate([wheelbase/2,rear_track/2,0])
>    spoked_wheel();
>
>// 车轴
>translate([-wheelbase/2,0,0])
>    axle(track=front_track, radius=front_axle_radius);
>translate([wheelbase/2,0,0])
>    axle(track=rear_track);
>```


---


## 创建模式的模式 - 嵌套 for 循环"

以下脚本在 Y 轴上创建了一排汽车。

{: .code-title }
>**文件名：** `row_of_six_cars_along_y_axis.scad`
>
>```openscad
>n = 6; // 汽车数量
>y_spacing = 50;
>for (dy=[0:y_spacing:n*y_spacing-1]) {
>    translate([0,dy,0])
>        car();
>}
>```

{: .ex }
修改上述脚本以创建另外 4 排汽车。每排汽车沿 X 轴正方向相对于上一排平移 70 个单位。

{: .code-title }
>**文件名：** `five_rows_of_six_cars.scad`
>
>```openscad
>n = 6; // 汽车数量
>y_spacing = 50;
>for (dy=[0:y_spacing:n*y_spacing-1]) {
>    translate([0,dy,0])
>        car();
>}
>for (dy=[0:y_spacing:n*y_spacing-1]) {
>    translate([70,dy,0])
>        car();
>}
>for (dy=[0:y_spacing:n*y_spacing-1]) {
>    translate([140,dy,0])
>        car();
>}
>for (dy=[0:y_spacing:n*y_spacing-1]) {
>    translate([210,dy,0])
>        car();
>}
>for (dy=[0:y_spacing:n*y_spacing-1]) {
>    translate([280,dy,0])
>        car();
>}
>```

如果您一直密切关注本教程，您可能已经注意到上述脚本效率不高。它包含大量重复代码，并且排数不能轻松修改。类似于本章开头创建汽车队列的问题，我们可以通过嵌套 for 循环来解决这一问题。

{: .code-title }
>**文件名：** `five_rows_of_six_cars_with_nested_for_loops.scad`
>
>```openscad
>n_cars = 6;
>y_spacing = 50;
>n_rows = 5;
>x_spacing = 70;
>for (dx=[0:x_spacing:n_rows*x_spacing-1]) {
>    for (dy=[0:y_spacing:n_cars*y_spacing-1]) {
>        translate([dx,dy,0])
>            car();
>    }
>}
>```

{: .new }
>- 外层循环的每次重复会执行内层循环的所有迭代，从而创建一排汽车。
>- 每排汽车的位置由变量 `dx` 控制，其值在外层循环的每次迭代中更新。
>- 在每次外层循环迭代期间，`dx` 的值保持不变，而内层循环修改 `dy` 的值，从而生成汽车队列。

{: .ex }
使用嵌套 for 循环创建三个圆形汽车模式，类似于下图。外层循环变量用于参数化每个模式的半径，圆形模式的半径应分别为 140、210 和 280 单位。每个模式应包含 12 辆车。

{: .code-title }
>**文件名：** `three_circular_patterns.scad`
>
>```openscad
>n = 12; // 汽车数量
>step = 360/n;
>for (r=[140:70:280]) {
>    for (angle=[0:step:359]) {
>        dx = r*cos(angle);
>        dy = r*sin(angle);
>        translate([dx,dy,0])
>            rotate(angle)
>            car();
>    }
>}
>```

{: .ex }
修改上一个练习的脚本，使得不仅半径不同，每个模式的汽车数量也不同。为此，将外层循环变量从 `r` 更改为索引变量 `i`。在每次外层循环重复时，根据公式 `r = 70 + i*70` 计算半径，并根据公式 `n = 12 + i*2` 更新汽车数量变量 `n`。此外，每次外层循环重复时还需更新变量 `step`。

{: .code-title }
>**文件名：** `three_circular_patterns_with_increasing_number_of_cars.scad`
>
>```openscad
>for (i=[1:1:3]) {
>    r = 70 + i*70;
>    n = 12 + i*2;
>    step = 360/n;
>    for (angle=[0:step:359]) {
>        dx = r*cos(angle);
>        dy = r*sin(angle);
>        translate([dx,dy,0])
>            rotate(angle)
>            car();
>    }
>}
>```

