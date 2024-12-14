---
layout: post
title:  "第九章"
nav_order: 9
---

# 第九章
{: .no_toc }

## 目录
{: .no_toc .text-delta }

## 在 OpenSCAD 中进行数学计算

到目前为止，您已经了解到 OpenSCAD 中的变量在脚本执行期间只能保存一个值，即最后分配给它们的值。您还学会了 OpenSCAD 变量的一个常见用途是为模型提供参数化功能。在这种情况下，每个参数化模型都会有几个独立变量，您可以通过更改这些变量的值来调整模型。这些变量通常直接赋值，如以下示例所示：

{: .code-title }
>**代码示例：**
>
>```openscad
>wheel_diameter = 12;
>body_length = 70;
>wheelbase = 40;
>// 等等。
>```

另一个已经多次出现但尚未明确提及的特性是能够在脚本中使用变量和硬编码值进行数学运算。例如，您可以通过将 `wheelbase` 变量除以二来计算汽车车轴和车轮沿 X 轴从原点的平移量。同样，使用 `track` 变量计算车轮沿 Y 轴的平移量。

{: .code-title }
>**文件名：** `axle_with_wheelset.scad`
>
>{: .code}
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>
>wheelbase = 40;
>track = 35;
>
>translate([-wheelbase/2, track/2])
>    simple_wheel();
>translate([-wheelbase/2, -track/2])
>    simple_wheel();
>translate([-wheelbase/2, 0, 0])
>    axle(track=track);
>```

在 OpenSCAD 中，加法、减法、乘法和除法分别使用符号 `+`、`-`、`*` 和 `/` 表示。除了这些基本操作之外，还有许多附加的数学操作在构建更复杂模型时非常有用。例如，您可以使用正弦和余弦函数将极坐标转换为直角坐标，从而在圆形模式中正确放置汽车。

{: .code-title }
>**文件名：** `circular_pattern_of_cars.scad`
>
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

在上述例子中，脚本不仅使用了可用的数学操作，还定义了两个额外的变量 `dx` 和 `dy` 来存储计算结果，以提高脚本的可读性。这种做法也可以应用于您的汽车模型中。

{: .code-title }
>**文件名：** `car.scad`
>
>{: .code}
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>
>wheelbase = 40;
>track = 35;
>
>// 车身
>body();
>// 前左轮
>translate([-wheelbase/2,-track/2,0])
>    simple_wheel();
>// 前右轮
>translate([-wheelbase/2,track/2,0])
>    simple_wheel();
>// 后左轮
>translate([wheelbase/2,-track/2,0])
>    simple_wheel();
>// 后右轮
>translate([wheelbase/2,track/2,0])
>    simple_wheel();
>// 前轴
>translate([-wheelbase/2,0,0])
>    axle(track=track);
>// 后轴
>translate([wheelbase/2,0,0])
>    axle(track=track);
>```

在上述模型中，数学运算被用来计算车轮和车轴在 X 和 Y 轴上的平移量。

{: .ex }
修改上述脚本以提高其可读性，并避免多次重复相同的数学运算。为此，您应该引入两个新变量 `half_wheelbase` 和 `half_track`，分别通过数学计算将这些变量设置为 `wheelbase` 和 `track` 的一半值。在平移命令中用这两个变量替代重复的数学运算。

{: .code-title }
>**文件名：** `car_with_additional_variables.scad`
>
>```openscad
>use <vehicle_parts.scad>
>$fa = 1;
>$fs = 0.4;
>
>wheelbase = 40;
>track = 35;
>
>half_wheelbase = wheelbase/2;
>half_track = track/2;
>
>// 车身
>body();
>// 前左轮
>translate([-half_wheelbase,-half_track,0])
>    simple_wheel();
>// 前右轮
>translate([-half_wheelbase,half_track,0])
>    simple_wheel();
>// 后左轮
>translate([half_wheelbase,-half_track,0])
>    simple_wheel();
>// 后右轮
>translate([half_wheelbase,half_track,0])
>    simple_wheel();
>// 前轴
>translate([-half_wheelbase,0,0])
>    axle(track=track);
>// 后轴
>translate([half_wheelbase,0,0])
>    axle(track=track);
>