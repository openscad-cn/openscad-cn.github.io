---
layout: post
title:  "第九章"
nav_order: 9
---

# 第九章
{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

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

---

## 使用 polygon 原始体创建任意 2D 对象

除了 `circle` 和 `square` 2D 原始体外，OpenSCAD 还提供了一个 `polygon` 原始体，可以用来设计几乎任何 2D 对象。通过提供一个包含点坐标的列表，您可以定义任意 2D 对象。以下是一个示例。

{: .code-title }
>**文件名：** `profile_1_polygon.scad`
>
>```openscad
>p0 = [0, 0];
>p1 = [0, 30];
>p2 = [15, 30];
>p3 = [35, 20];
>p4 = [35, 0];
>points = [p0, p1, p2, p3, p4];
>polygon(points);
>```

{: .new }
>- `polygon` 原始体使用点列表作为输入。
>- 点通过 X 和 Y 坐标对表示，并按顺序提供。
>- 点的顺序可以是顺时针或逆时针。
>- 推荐使用变量名（如 `p0`, `p1`）存储点坐标，以便更好地跟踪设计。

可以直接在控制台中使用 `echo` 命令打印变量或列表的内容。

{: .code-title }
>**代码示例：**
>
>```openscad
>echo(points);
>// 输出：[[0, 0], [0, 30], [15, 30], [35, 20], [35, 0]]
>```

您可以直接在 `polygon` 命令中定义点列表，但这不推荐，因为会降低脚本的可读性和可扩展性。

{: .code-title }
>**代码示例：**
>
>```openscad
>polygon([[0, 0], [0, 30], [15, 30], [35, 20], [35, 0]]);
>```

通过参数化点的坐标定义，可以快速修改对象的尺寸。这可以通过为每个尺寸引入变量并使用数学表达式定义点的坐标来实现。

{: .code-title }
>**文件名：** `profile_1_polygon_parametric.scad`
>
>```openscad
>// 给定尺寸
>d1 = 15;
>d2 = 20;
>h1 = 20;
>h2 = 10;
>// 点
>p0 = [0, 0];
>p1 = [0, h1 + h2];
>p2 = [d1, h1 + h2];
>p3 = [d1 + d2, h1];
>p4 = [d1 + d2, 0];
>points = [p0, p1, p2, p3, p4];
>// Polygon
>polygon(points);
>```

{: .ex }
使用 `polygon` 原始体创建以下 2D 对象。定义包含点坐标对的列表，并将其传递给 `polygon` 命令。点的坐标定义应与给定尺寸相关。

{: .code-title }
>**文件名：** `profile_2_polygon.scad`
>
>```openscad
>// 给定尺寸
>h1 = 23;
>h2 = 10;
>h3 = 8;
>d1 = 25;
>d2 = 12;
>d3 = 15;
>// 点
>p0 = [0, 0];
>p1 = [0, h1 + h2];
>p2 = [d3, h1];
>p3 = [d1 + d2, h1 + h2];
>p4 = [d1 + d2, h3];
>p5 = [d1, 0];
>points = [p0, p1, p2, p3, p4, p5];
>// Polygon
>polygon(points);
>```

{: .ex }
使用 `linear_extrude` 和 `rotate_extrude` 命令分别创建一个管和一个环，2D 轮廓应为上例的多边形。管的高度应为 100 单位，环的内径应为 100 单位。

{: .code-title }
>**文件名：** `linearly_extruded_polygon.scad`
>
>```openscad
>linear_extrude(height=100)
>    polygon(points);
>```

{: .code-title }
>**文件名：** `rotationaly_extruded_polygon.scad`
>
>```openscad
>rotate_extrude(angle=360)
>    translate([50,0,0])
>    polygon(points);
>```

接下来，使用您的新技能创建一个 UwU 赛车！

{: .ex }
使用 `polygon` 命令创建上述赛车车身。定义设计的每个点，将它们添加到列表中并传递给 `polygon` 命令。点的坐标定义应与给定尺寸相关。

{: .code-title }
>**文件名：** `racing_car_body.scad`
>
>```openscad
>// 模型参数
>d1=30;
>d2=20;
>d3=20;
>d4=10;
>d5=20;
>
>w1=15;
>w2=45;
>w3=25;
>
>h=14;
>
>// 右侧点
>p0 = [0, w1/2];
>p1 = [d1, w1/2];
>p2 = [d1 + d2, w2/2];
>p3 = [d1 + d2 + d3, w2/2];
>p4 = [d1 + d2 + d3 + d4, w3/2];
>p5 = [d1 + d2 + d3 + d4 + d5, w3/2];
>
>// 左侧点
>p6 = [d1 + d2 + d3 + d4 + d5, -w3/2];
>p7 = [d1 + d2 + d3 + d4, -w3/2];
>p8 = [d1 + d2 + d3, -w2/2];
>p9 = [d1 + d2, -w2/2];
>p10 = [d1, -w1/2];
>p11 = [0, -w1/2];
>
>// 所有点
>points = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11];
>
>// 拉伸车身轮廓
>linear_extrude(height=h)
>    polygon(points);
>```

{: .ex }
扩展上述脚本，使用额外变量提高脚本的可读性并避免重复数学运算。

{: .code-title }
>**文件名：** `racing_car_body_with_extra_variables.scad`
>
>```openscad
>// 模型参数
>d1=30;
>d2=20;
>d3=20;
>d4=10;
>d5=20;
>
>w1=15;
>w2=45;
>w3=25;
>
>h=14;
>
>// 长度
>l1 = d1;
>l2 = d1 + d2;
>l3 = d1 + d2 + d3;
>l4 = d1 + d2 + d3 + d4;
>l5 = d1 + d2 + d3 + d4 + d5;
>
>// 右侧点
>p0 = [0, w1/2];
>p1 = [l1, w1/2];
>p2 = [l2, w2/2];
>p3 = [l3, w2/2];
>p4 = [l4, w3/2];
>p5 = [l5, w3/2];
>
>// 左侧点
>p6 = [l5, -w3/2];
>p7 = [l4, -w3/2];
>p8 = [l3, -w2/2];
>p9 = [l2, -w2/2];
>p10 = [l1, -w1/2];
>p11 = [0, -w1/2];
>
>// 所有点
>points = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11];
>
>// 拉伸车身轮廓
>linear_extrude(height=h)
>    polygon(points);
>```

{: .ex }
完成 UwU 赛车的设计，在车身上添加剩余的部分。

{: .code-title }
>**文件名：** `racing_car.scad`
>
>```openscad
>use <vehicle_parts.scad>
>
>$fa = 1;
>$fs = 0.4;
>
>// 模型参数
>d1=30;
>d2=20;
>d3=20;
>d4=10;
>d5=20;
>
>w1=15;
>w2=45;
>w3=25;
>
>h=14;
>track=40;
>
>// 长度
>l1 = d1;
>l2 = d1 + d2;
>l3 = d1 + d2 + d3;
>l4 = d1 + d2 + d3 + d4;
>l5 = d1 + d2 + d3 + d4 + d5;
>
>// 右侧点
>p0 = [0, w1/2];
>p1 = [l1, w1/2];
>p2 = [l2, w2/2];
>p3 = [l3, w2/2];
>p4 = [l4, w3/2];
>p5 = [l5, w3/2];
>
>// 左侧点
>p6 = [l5, -w3/2];
>p7 = [l4, -w3/2];
>p8 = [l3, -w2/2];
>p9 = [l2, -w2/2];
>p10 = [l1, -w1/2];
>p11 = [0, -w1/2];
>
>// 所有点
>points = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11];
>
>// 拉伸车身轮廓
>linear_extrude(height=h)
>    polygon(points);
>
>// 座舱
>translate([d1+d2+d3/2,0,h])
>    resize([d2+d3+d4,w2/2,w2/2])
>    sphere(d=w2/2);
>
>// 车轴
>l_front_axle = d1/2;
>l_rear_axle = d1 + d2 + d3 + d4 + d5/2;
>half_track = track/2;
>
>translate([l_front_axle,0,h/2])
>    axle(track=track);
>translate([l_rear_axle,0,h/2])
>    axle(track=track);
>
>// 车轮
>translate([l_front_axle,half_track,h/2])
>    simple_wheel(wheel_width=10);
>translate([l_front_axle,-half_track,h/2])
>    simple_wheel(wheel_width=10);
>
>translate([l_rear_axle,half_track,h/2])
>    simple_wheel(wheel_width=10);
>translate([l_rear_axle,-half_track,h/2])
>    simple_wheel(wheel_width=10);
>```

---

