---
layout: post
title:  "第八章"
nav_order: 8
---

# 第八章
{: .no_toc }

## 目录
{: .no_toc .text-delta }

## 通过旋转拉伸从2D对象创建3D对象

到目前为止，您已经创建了许多模型并定制了汽车设计，同时培养了扎实的参数化建模技能并探索了 OpenSCAD 的不同功能。令人印象深刻的是，您所创建的每个模型都只使用了三个基本原始体：球体、立方体和圆柱体。通过将这些原始体与变换命令相结合，您可以创建大量模型，但仍有一些模型无法仅通过这些原始体创建。例如，下图所示的轮子设计。

该轮子设计需要创建一个看起来像甜甜圈的对象。

这种甜甜圈形状的对象无法通过球体、立方体和圆柱体创建。相反，它需要使用2D原始体和一种可以从2D轮廓生成3D形状的新命令。具体来说，可以通过首先使用 `circle` 原始体定义一个圆形的2D轮廓，然后使用 `rotate_extrude` 命令旋转拉伸该轮廓来创建甜甜圈。

{: .code-title }
>**文件名：** `circular_profile.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 12;
>tire_diameter = 6;
>translate([wheel_radius - tire_diameter/2, 0])
>    circle(d=tire_diameter);
>```

{: .code-title }
>**文件名：** `extruded_donut.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 12;
>tire_diameter = 6;
>rotate_extrude(angle=360) {
>    translate([wheel_radius - tire_diameter/2, 0])
>        circle(d=tire_diameter);
>}
>```

{: .new }
>- 2D轮廓通常位于 X-Y 平面，并定义在 X ≥ 0 且 Z = 0 的区域。
>- 2D轮廓始终具有零厚度，仅用于与 `rotate_extrude` 或 `linear_extrude` 命令结合使用以定义3D对象。
>- `rotate_extrude` 命令接受一个2D轮廓作为输入，并通过围绕 Y 轴旋转该轮廓生成3D对象。
>- 生成的3D对象的旋转轴位于 Z 轴上。
>
>`rotate_extrude` 命令有一个名为 `angle` 的输入参数，用于定义2D轮廓围绕 Y 轴旋转的角度。例如：
>- 当 `angle` 设置为 360 度时，将生成一个完整的甜甜圈。
>- 当 `angle` 设置为 60 度时，将生成部分甜甜圈。

{: .ex }
完成新的轮子设计，定义缺失的圆柱体对象。圆柱体的高度应等于 `wheel_width` 变量的值，半径应等于 `wheel_radius - tire_diameter/2`。圆柱体应居中于原点。

{: .code-title }
>**文件名：** `rounded_wheel_horizontal.scad`
>
>```openscad
>$fa = 1;
>$fs = 0.4;
>wheel_radius = 12;
>wheel_width = 4;
>tire_diameter = 6;
>rotate_extrude(angle=360) {
>    translate([wheel_radius - tire_diameter/2, 0])
>        circle(d=tire_diameter);
>}
>cylinder(h=wheel_width, r=wheel_radius - tire_diameter/2, center=true);
>```

{: .ex }
为了使该轮子与之前章节中的模型兼容，将其绕 X 轴旋转 90 度。将此轮子设计转换为一个名为 `rounded_simple_wheel` 的模块，并将其添加到 `vehicle_parts.scad` 文件中以便日后使用。

{: .code-title }
>**文件名：** `rounded_simple_wheel.scad`
>
>```openscad
>module rounded_simple_wheel(wheel_radius=12, wheel_width=4, tire_diameter=6) {
>    rotate([90,0,0]) {
>        rotate_extrude(angle=360) {
>            translate([wheel_radius - tire_diameter/2, 0])
>                circle(d=tire_diameter);
>        }
>        cylinder(h=wheel_width, r=wheel_radius - tire_diameter/2, center=true);
>    }
>}
>```

{: .ex }
上述轮子是轴对称对象，这意味着它围绕一个轴具有对称性。具体来说，对称轴是用于旋转2D轮廓以形成3D对象的轴。删除上述模块中的圆柱体命令，并在提供的2D轮廓中进行适当修改，使整个轮子由 `rotate_extrude` 命令创建。

{: .code-title }
>**代码片段：**
>
>```openscad
>translate([wheel_radius - tire_diameter/2, 0])
>    circle(d=tire_diameter);
>translate([0, -wheel_width/2])
>    square([wheel_radius - tire_diameter/2, wheel_width]);
>```

{: .code-title }
>**文件名：** `rounded_simple_wheel.scad`
>
>```openscad
>module rounded_simple_wheel(wheel_radius=12, wheel_width=4, tire_diameter=6) {
>    rotate([90,0,0]) {
>        rotate_extrude(angle=360) {
>            translate([wheel_radius - tire_diameter/2, 0])
>                circle(d=tire_diameter);
>            translate([0, -wheel_width/2])
>                square([wheel_radius - tire_diameter/2, wheel_width]);
>        }
>    }
>}
>```

{: .new }
轴对称对象可以完全通过 `rotate_extrude` 命令创建。上述轮子设计是一个具体的例子。是否通过提供整个对象的2D轮廓并使用单个 `rotate_extrude` 创建轴对称对象，或仅对无法通过其他方式创建的部分使用 `rotate_extrude`，取决于具体情况并由您决定。

---


## 挑战
现在是时候将您的新知识应用到实践中，为迷你机器人汽车项目创建一个轮辋。

{: .ex }
扩展 `rounded_simple_wheel` 模块，使轮子的设计在轮毂上有一个用于安装轴的孔。为此，您需要使用 `difference` 命令从现有模型中减去一个圆柱体。孔的直径应等于一个新的模块输入参数 `axle_diameter`，该参数的默认值应为 3 单位。在定义圆柱体高度时，需确保其总是略长于轮子的宽度，以避免使用 `difference` 命令时出现错误。保存修改后的模块后，使用以下参数创建轮子的版本：`wheel_radius=20`、`wheel_width=6`、`tire_diameter=4` 和 `axle_diameter=5`。

{: .code-title }
>**文件名：** `robot_wheel.scad`
>
>```openscad
>module rounded_simple_wheel(wheel_radius=12, wheel_width=4, tyre_diameter=6, axle_diameter=3) {
>    difference() {
>        
>        // 轮子
>        rotate([90,0,0]) {
>            rotate_extrude(angle=360) {
>                translate([wheel_radius-tyre_diameter/2,0])
>                    circle(d=tyre_diameter);
>                translate([0,-wheel_width/2])
>                    square([wheel_radius-tyre_diameter/2,wheel_width]);
>            }
>        }
>        
>        // 轴孔
>        rotate([90,0,0])
>            cylinder(h=wheel_width+1,r=axle_diameter/2,center=true);
>    }
>}
>
>rounded_simple_wheel(wheel_radius=20, wheel_width=6, tyre_diameter=4, axle_diameter=5);
>```

该轮子设计非常适合用于迷你机器人汽车，但您可以通过改进来为机器人提供更好的牵引力。例如，您可以只打印轮辋，并使用 O 型圈或橡皮圈作为轮胎，以提高牵引力。

最终的轮子可能如下图所示，其中蓝色部分表示 O 型圈或橡皮圈。

对应需要 3D 打印的轮辋如下所示：

{: .ex }
>以 `rounded_simple_wheel` 模块为参考，创建一个新的模块 `robot_rim`。`robot_rim` 模块应具有与 `rounded_simple_wheel` 模块相同的输入参数。添加所有必要的命令使其创建上述轮辋设计。有两种方法可以实现：
>
>1. 在 `rotate_extrude` 命令中，通过从表示轮胎的圆形减去表示轮辋的方形定义2D轮廓，并从生成的3D对象中减去轴的圆柱体以获得最终设计。
>2. 从表示轮辋的较大圆柱体中减去表示轮胎的甜甜圈形对象和表示轴孔的圆柱体。
>
>虽然有一些关于良好设计实践的传统智慧，但实际上没有绝对的对错。选择最符合直觉或最合理的方法即可。为练习起见，可以尝试两种方法，看看哪种方法更适合您。


{: .code-title }
>**第一种方法** `robot_rim_from_profile_difference.scad`
>
>{: .code}
>```openscad
>module robot_rim(wheel_radius=12, wheel_width=4, tyre_diameter=6, axle_diameter=3) {
>    rotate([90,0,0])difference() {
>        
>        // 轮辋
>        rotate_extrude(angle=360) {
>            difference() {
>                
>                // 圆柱轮廓
>                translate([0,-wheel_width/2])
>                    square([wheel_radius-tyre_diameter/2,wheel_width]);
>                
>                // 轮胎轮廓
>                translate([wheel_radius-tyre_diameter/2,0])
>                    circle(d=tyre_diameter);
>            }
>        }
>        
>        // 轴孔
>        cylinder(h=wheel_width+1,r=axle_diameter/2,center=true);
>    }
>}
>```


{: .code-title }
>**第二种方法** `robot_rim_from_3d_object_difference.scad`
>
>```openscad
>module robot_rim(wheel_radius=12, wheel_width=4, tyre_diameter=6, axle_diameter=3) {
>    rotate([90,0,0])
>        difference() {
>            
>            // 轮辋
>            cylinder(h=wheel_width,r=wheel_radius-tyre_diameter/2,center=true);
>            
>            // 轮胎
>            rotate_extrude(angle=360) {
>                translate([wheel_radius-tyre_diameter/2,0])
>                    circle(d=tyre_diameter);
>            }
>
>            // 轴孔
>            cylinder(h=wheel_width+1,r=axle_diameter/2,center=true);
>        }
>}
>```

设计新零件时，考虑零件的制造过程通常是有帮助的。这种考虑不仅有助于适应当前的制造方法，还可以指导您的建模过程。

例如，假设您不是使用增材制造（如3D打印）来制造此机器人轮子，而是使用减材制造（如车床或铣床）。在这种情况下，您可能会选择第二种方法，因为它更接近实际制造过程，并可能更好地估计最终制造过程需要的步骤数。
