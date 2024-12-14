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
 
## 使用 polygon 原始体和数学创建更复杂的对象
{: .no_toc }

从上面的示例可以看出，`polygon` 原始体使创建无法仅使用基本 2D 或 3D 原始体实现的对象成为可能。为了最大限度地发挥 `polygon` 命令的潜力并创建更复杂的设计，需要通过数学编程生成轮廓点。这是因为手动定义数百个点来设计平滑的非方形轮廓是不可行的。例如，以下心形模型的轮廓点不可能手动定义。

{: .code-title }
>**代码示例：**
>
>```openscad
>x = 16*sin(t)^3;
>y = 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t);
>```

当变量 `t` 的范围覆盖从 0 到 360 度的值时，上述方程生成心形轮廓的 X 和 Y 坐标，从顶部中间点顺时针移动。可以使用以下方式生成包含点坐标的列表：

{: .code-title }
>**文件名：** `heart_points_list.scad`
>
>```openscad
>n = 500;
>h = 10;
>step = 360/n;
>points = [ for (t=[0:step:359.999]) [16*pow(sin(t),3), 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)]];
>linear_extrude(height=h)
>    polygon(points);
>```

{: .new }
>- 列表生成使用 `for` 关键字，类似于 for 循环的语法。
>- `t` 变量从 0 到 359.999，避免重复点。
>- 可以通过调整 `step` 控制生成的点数量。
>- 点的数量 `n` 与 `step` 的关系为 `step = 360/n`。

{: .ex }
修改上述脚本，使心形轮廓由 20 个点组成。

{: .code-title }
>**文件名：** `heart_low_poly.scad`
>
>```openscad
>n = 20;
>h = 10;
>step = 360/n;
>points = [ for (t=[0:step:359.999]) [16*pow(sin(t),3), 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)]];
>linear_extrude(height=h)
>    polygon(points);
>```

{: .ex }
>使用新介绍的列表生成语法生成以下列表：
>1. `[1, 2, 3, 4, 5, 6]`
>2. `[10, 8, 6, 4, 2, 0, -2]`
>3. `[[3, 30], [4, 40], [5, 50], [6, 60]]`

{: .code-title }
>**代码示例：**
>
>```openscad
>// 第一题
>x = [ for (i=[1:6]) i ];
>
>// 第二题
>x = [ for (i=[10:-2:-2]) i ];
>
>// 第三题
>x = [ for (i=[3:6]) [i, i*10] ];
>```

您可以定义自己的数学函数来组织复杂计算。例如，可以定义一个函数来生成心形轮廓点的 X 和 Y 坐标：

{: .code-title }
>**文件名：** `heart_function.scad`
>
>```openscad
>function heart_coordinates(t) = [16*pow(sin(t),3), 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)];
>
>n = 500;
>h = 10;
>step = 360/n;
>points = [ for (t=[0:step:359.999]) heart_coordinates(t) ];
>linear_extrude(height=h)
>    polygon(points);
>```

您还可以定义生成点列表的函数：

{: .code-title }
>**文件名：** `heart_points_function.scad`
>
>```openscad
>function heart_points(n=50) = [ for (t=[0:360/n:359.999]) heart_coordinates(t) ];
>
>n = 20;
>h = 10;
>points = heart_points(n=n);
>linear_extrude(height=h)
>    polygon(points);
>```

{: .ex }
创建一个名为 `heart` 的模块。模块应具有两个输入参数 `h` 和 `n`，分别对应心形的高度和点的数量。模块应调用 `heart_points` 函数生成所需的点列表，并将该列表传递给 `polygon` 命令以创建 2D 轮廓，并将其拉伸为指定的高度。

{: .code-title }
>**文件名：** `heart.scad`
>
>{: .code}
>```openscad
>module heart(h=10, n=50) {
>    points = heart_points(n=n);
>    linear_extrude(height=h)
>        polygon(points);
>}
>```

{: .ex }
将 `heart_coordinates` 和 `heart_points` 函数与 `heart` 模块保存在名为 `heart.scad` 的脚本中，并将其添加到您的库中。每次需要在设计中包含心形时，可以使用 `use` 命令引入该脚本的函数和模块。

---

## 新的挑战

现在是时候运用您的新技能为赛车创建一个空气动力学扰流板了！

{: .ex }

使用一个对称的 NACA 00xx 四位数翼型创建扰流板。其半厚度公式如下：

\[ y_t = 5t(0.2969\sqrt{x} - 0.1260x - 0.3516x^2 + 0.2843x^3 - 0.1015x^4) \]

在上述公式中，`x` 是弦线上的位置，`t` 是以弦线长度的百分比表示的翼型最大厚度。

创建一个名为 `naca_half_thickness` 的函数。该函数应具有两个输入参数：`x` 和 `t`。根据给定的 `x` 和 `t`，函数应返回对应的 NACA 翼型的半厚度。

{: .code-title }
>**文件名：** `naca_airfoil_module.scad`
>
>```openscad
>function naca_half_thickness(x,t) = 5*t*(0.2969*sqrt(x) - 0.1260*x - 0.3516*pow(x,2) + 0.2843*pow(x,3) - 0.1015*pow(x,4));
>```

{: .ex }
创建一个名为 `naca_top_coordinates` 的函数，用于生成翼型上半部分的 X 和 Y 坐标列表。函数应具有两个输入参数：`t` 和 `n`，分别对应翼型的最大厚度和点的数量。

{: .code-title }
>**文件名：** `naca_airfoil_module.scad`
>
>```openscad
>function naca_top_coordinates(t,n) = [ for (x=[0:1/(n-1):1]) [x, naca_half_thickness(x,t)]];
>```

{: .ex }
创建一个类似的函数 `naca_bottom_coordinates`，生成翼型下半部分的点列表。这些点应按逆序排列。

{: .code-title }
>**文件名：** `naca_airfoil_module.scad`
>
>```openscad
>function naca_bottom_coordinates(t,n) = [ for (x=[1:-1/(n-1):0]) [x, -naca_half_thickness(x,t)]];
>```

{: .ex }
创建一个名为 `naca_coordinates` 的函数，将上述两个列表连接起来，生成完整的翼型轮廓点列表。

{: .code-title }
>**文件名：** `naca_airfoil_module.scad`
>
>```openscad
>function naca_coordinates(t,n) = concat(naca_top_coordinates(t,n), naca_bottom_coordinates(t,n));
>```

{: .ex }
使用 `naca_coordinates` 函数生成具有最大厚度为 0.12 且每半部分包含 300 个点的翼型轮廓。

{: .code-title }
>**文件名：** `small_airfoil_polygon.scad`
>
>```openscad
>points = naca_coordinates(t=0.12,n=300);
>polygon(points);
>```

{: .ex }
将上述脚本转换为一个名为 `naca_airfoil` 的模块。模块应具有三个输入参数：`chord`、`t` 和 `n`。

{: .code-title }
>**文件名：** `naca_airfoil_module.scad`
>
>```openscad
>module naca_airfoil(chord,t,n) {
>    points = naca_coordinates(t,n);
>    scale([chord,chord,1])
>        polygon(points);
>}
>```

{: .ex }
创建一个名为 `naca_wing` 的模块，通过对翼型 2D 轮廓应用 `linear_extrude` 命令生成机翼。模块应具有两个额外的输入参数：`span` 和 `center`。

{: .code-title }
>**文件名：** `spoiler_wing.scad`
>
>```openscad
>module naca_wing(span,chord,t,n,center=false) {
>    linear_extrude(height=span,center=center) {
>        naca_airfoil(chord,t,n);
>    }
>}
>
>rotate([90,0,0])
>    naca_wing(span=50,chord=20,t=0.12,n=500,center=true);
>```

{: .ex }
使用 `naca_wing` 模块在上一个示例的基础上添加两个较小的垂直翼片，以完成汽车扰流板设计。

{: .code-title }
>**文件名：** `spoiler.scad`
>
>```openscad
>rotate([90,0,0])
>    naca_wing(span=50,chord=20,t=0.12,n=500,center=true);
>translate([0,10,-15])
>    naca_wing(span=15,chord=15,t=0.12,n=500);
>translate([0,-10,-15])
>    naca_wing(span=15,chord=15,t=0.12,n=500);
>```

{: .ex }
将上述扰流板添加到赛车设计中完成最终设计。

{: .code-title }
>**文件名：** `racing_car_with_spoiler.scad`
>
>```openscad
>use <vehicle_parts.scad>
>use <naca.scad>
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
>
>// 扰流板
>module car_spoiler() {
>    rotate([90,0,0])
>        naca_wing(span=50,chord=20,t=0.12,n=500,center=true);
>    translate([0,10,-15])
>        naca_wing(span=15,chord=15,t=0.12,n=500);
>    translate([0,-10,-15])
>        naca_wing(span=15,chord=15,t=0.12,n=500);
>}
>
>translate([l4+d5/2,0,25])
>    car_spoiler();
>```