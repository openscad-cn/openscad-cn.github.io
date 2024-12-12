---
layout: post
title:  "第一章"
order: 1
---


## 关于 OpenSCAD 的一些话

**OpenSCAD** 是一款利用构造实体几何（Constructive Solid Geometry, CSG）来构建 3D 模型的工具。在这里，基本操作就像是搭建积木一样，为创意打开了一扇大门。

让我们开始一次有趣的建模之旅吧！

---

## 开始学习本教程

本教程将成为您的可靠向导。我们将通过示例来揭示 OpenSCAD 的奥秘。通过完成本教程，您将掌握逐行构建独特 3D 模型的能力。

每一步都将帮助您增加信心和技能，让您逐渐成长为一名图像创作者。通过代码为您的设计注入生命，打造复杂的结构，将您的设计想法变为现实。

在整个教程中，我们将陪伴您，提供指导以释放 OpenSCAD 的全部潜能。

让我们一起探索、学习、创造吧！

---

## 用户界面

启动 **OpenSCAD** 后，窗口应类似于下图所示 。

<!-- 需添加图片 -->

窗口分为三个主要区域：

1. **左侧列**  
   左侧是内置的文本编辑器，这是魔法展开的地方。当您输入键盘指令时，代码会被转化为艺术作品。

2. **中间列**  
   中间显示的 3D 视图是您的设计呈现生命的地方。底部是操作序列控制台，始终准备为您提供帮助。它可以解开错误的谜团，引导您走向精通之路，是您值得信赖的向导。

3. **右侧列**  
   右侧是 GUI 自定义工具栏，它提供了一个直观的界面，让您可以轻松调整和修改模型的参数。

   
1. 创建您的第一个对象

您的第一个对象将是一个边长为 10 的完美立方体。为了创建它，您需要在文本编辑器中输入以下代码，然后点击参考轴下方操作栏中的预览（第一个）图标。

---

代码示例 `a_small_cube.scad`

```openscad
cube(10);
```

---

### 基本概念

对于没有编程背景的用户，了解 OpenSCAD 脚本语言的一些基本概念非常重要。

{: .new }
>
>1. **关键词 `cube`**  
>   关键词 `cube` 是 OpenSCAD 脚本语言的一部分，用于指示 OpenSCAD 创建一个立方体。
>
>2. **参数括号**  
>   在 `cube` 命令后面是一对圆括号，括号内定义了参数值。在此例中，立方体的边长被定义为 10。
>
>3. **语句结束符号**  
>   括号后面的分号表示语句结束。分号帮助 OpenSCAD 解析您在文本编辑器中输入的脚本。
>
>4. **代码格式灵活性**  
>   由于分号用于表示语句结束，因此您可以通过添加空格来自由调整代码格式。

---

{: .ex }
>尝试在 `cube` 和第一个括号之间添加一些空格，然后点击“预览”选项。  
>- 您的立方体是否成功创建了？  
>- 您是否收到任何错误信息？  

---

接着尝试在代码的不同位置添加额外的空格，再次点击“预览”，看看哪些情况下代码仍能正常运行，以及何时会在控制台中出现错误消息。  

---

{: .ex }
>- 如果您在单词 `cube` 的字母 `cu` 和 `be` 之间插入空格，点击“预览”会发生什么？  
>- 如果删除代码中的分号，会出现什么问题？

---

### 关于“预览”的重要提示

您在上面练习中多次读到了“点击预览”。每当您点击“预览”时，OpenSCAD 会解析您的脚本并创建相应的模型。  
**每次更改脚本**（例如添加空格或稍后增加新的语句）后，您都需要再次点击“预览”以查看更改的效果。

---

{: .ex }
>尝试将立方体的边长更改为 20，并观察会发生什么。  
>- 您是否记得点击“预览”以查看更改后的效果？

 ---

## 创建一个略有不同的立方体

立方体不一定是完美的（即各边长度相等）。立方体的边长可以不同。使用以下语句创建一个边长分别为 25、35 和 55 的立方体：

---

代码示例 `a_different_cube.scad`

```openscad
cube([25,35,55]);
```

---

### 缩放视图

您首先会注意到这个立方体相比之前的立方体要大得多。事实上，它大到无法完全显示在视口中。为了修复这个问题，可以将鼠标移到视口上并向后滚动鼠标滚轮，直到可以看到整个立方体。  
您也可以通过移动鼠标到视口并滚动滚轮来随意放大或缩小模型。或者，您可以使用视口下方工具栏中的缩放图标：  
- **放大（第四个图标）**  
- **缩小（第五个图标）**  
您还可以通过使用 **“查看全部”（第三个图标）**，让 OpenSCAD 自动选择一个合适的缩放级别。

---

{: .ex }
>1. 将鼠标移到视口上，并使用滚轮放大和缩小模型。  
>2. 尝试使用工具栏中的放大和缩小图标。  
>3. 使用“查看全部”功能让 OpenSCAD 为您选择一个合适的缩放级别。

---

### 移动和旋转视图

除了缩放以外，您还可以移动和旋转模型的视图。操作方法如下：  
- **移动视图**：将鼠标移到视口上，按住鼠标右键并拖动。  
- **旋转视图**：将鼠标移到视口上，按住鼠标左键并拖动。  
- **重置视图**：使用视口下方工具栏中的 **“重置视图”（第六个图标）**。

---

{: .ex }
>1. 按住鼠标左键或右键拖动鼠标，在视口中移动或旋转模型的视图。  
>2. 尝试在操作中调整视图并观察效果。看看需要多久才能让视图变得混乱到必须重置。

---

### 定义不同边长的立方体

为了创建一个具有不同边长的立方体，需要在括号中定义一对方括号，并在其中添加三个值。这对方括号表示一个向量（vector）。向量的值需要用逗号分隔，对应于立方体沿 X、Y 和 Z 轴的边长。  
当 `cube` 命令的输入是一个包含三个值的向量时，OpenSCAD 会创建一个边长分别对应于向量值的立方体。之前您通过定义参数 `size` 的值来创建完美立方体。大多数 OpenSCAD 命令都可以使用不同的参数，甚至更多、更少或不带参数，以实现不同的效果。

---

{: .ex }
>1. 尝试使用 `cube` 命令而不带任何参数。会发生什么？  
>2. 使用 `cube` 命令创建一个边长分别为 50、5 和 10 的立方体。  
>3. 使用 `cube` 命令创建一个边长为 17.25 的完美立方体。

---

### 居中立方体

您会注意到，所有的立方体都是在第一象限创建的。可以定义一个额外的参数 `center`，并将其值设置为 `true`，以让立方体的中心位于原点。完整语句如下：

---

代码示例 `a_centered_cube_with_different_side_lengths.scad`

```openscad
cube([20,30,50],center=true);
```

---

{: .note }
当括号内定义多个参数时，参数之间需要用逗号分隔。

---

{: .ex }
>1. 尝试创建一个完美立方体或具有不同边长的立方体。  
>2. 使用适当的额外输入参数使立方体的中心位于原点。  
>3. 如果愿意，可以在逗号前后添加一些空格，观察是否会影响代码的运行。

---

## 添加更多对象并平移对象

构造实体建模方法使用许多基本对象，以及一些方法来变换和组合这些对象，从而创建更复杂的模型。在之前的示例中使用的立方体就是一个基本对象。基本对象也被称为**原始体（primitives）**，可以直接在 OpenSCAD 脚本语言中使用。

例如，汽车并不是 OpenSCAD 的原始体，因为脚本语言中没有对应的关键词。这非常合理，因为 OpenSCAD 是一组建模工具，而不是预定义模型的库。通过使用这些工具，您可以组合现有的原始体来创建自己的汽车。为此，您需要了解如何在模型中添加多个对象。

---

### 添加第一个立方体

首先创建一个边长分别为 60、20 和 10 的立方体，并将其中心设置在原点。

```openscad
cube([60,20,10],center=true);
```

---

### 添加第二个立方体

为了在模型中添加第二个立方体，请在文本编辑器的下一行输入相同的语句，但将边长更改为 30、20 和 10。

文件名：`a_smaller_cube_covered_by_a_bigger_cube.scad`

```openscad
cube([60,20,10],center=true);
cube([30,20,10],center=true);
```

在模型中，您应该看不到任何变化，因为第二个立方体在任何方向上都不比第一个立方体大，并且完全被第一个立方体覆盖。

---

### 平移第二个立方体

通过以下方式修改第二条语句，您可以将第二个立方体平移到第一个立方体的顶部部分。

文件名：`two_cubes.scad`

```openscad
cube([60,20,10],center=true);
translate([0,0,5])
    cube([30,20,10],center=true);
```

通过使用 `translate` 命令，您完成了这一操作。`translate` 是可用的变换命令之一。这些变换命令本身不会创建任何对象，而是应用于现有对象以以某种方式修改它们。  
`translate` 命令的输入参数是一个包含三个值的向量。每个值分别表示对象沿 X、Y 和 Z 轴移动的单位数值。注意，`translate` 命令后没有分号。紧接着 `translate` 命令的是要进行平移的对象定义，而分号则用于语句结束时。

---

{: .ex }
>1. 更改 `translate` 命令的输入参数，使立方体沿 X 轴平移 5 单位，沿 Z 轴平移 10 单位。  
>2. 如果愿意，可以添加一些空格来调整语句的格式。  
>3. 尝试在 `translate` 命令后添加分号，观察会发生什么。

---

### 避免完全重叠

在下面的示例中，第二个立方体恰好位于第一个立方体的顶部。这是应该避免的情况，因为 OpenSCAD 无法明确判断两个立方体是否形成了一个整体对象。为避免这种情况，可以始终保持大约 0.001 - 0.002 的小重叠。

一种方法是将 Z 轴的平移值从 10 减少到 9.999：

文件名：`two_cubes_with_small_overlap.scad`

```openscad
cube([60,20,10],center=true);
translate([0,0,9.999])
    cube([30,20,10],center=true);
```

另一种方法是更明确地从脚本中相应的值减去 0.001：

文件名：`two_cubes_with_explicit_small_overlap.scad`

```openscad
cube([60,20,10],center=true);
translate([0,0,10 - 0.001])
    cube([30,20,10],center=true);
```

第三种方法是添加一个高度为 0.002 的立方体来填补间隙：

文件名：`third_cube_close_small_gap.scad`

```openscad
cube([60,20,10],center=true);
translate([0,0,10])
    cube([30,20,10],center=true);
translate([0,0,5 - 0.001])
    cube([30,20,0.002],center=true);
```

在整个教程中，您会经常遇到这种情况。当两个对象完全接触时，您应始终通过增加或减少 0.001 单位的公差来保证小的重叠。

## 圆柱原始体与旋转对象

您刚刚创建的模型看起来像一辆空气动力学很差的汽车车身。没关系，您将在接下来的章节中让这辆车看起来更有趣且更具空气动力学特性。现在，您将使用圆柱原始体和旋转变换为汽车添加轮子和车轴。

您可以通过添加一个包含 `cylinder` 命令的语句来创建一个轮子。您需要定义两个输入参数：`h` 和 `r`。第一个参数表示圆柱的高度，第二个参数表示圆柱的半径。

---

代码示例 `a_cylinder_covered_by_cubes.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
cylinder(h=3,r=8);
```

您会注意到圆柱被其他对象遮挡。您可以使用 `translate` 命令将圆柱沿 Y 轴负方向平移 20 个单位以使其可见。

---

代码示例 `two_cubes_and_a_cylinder.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([0,-20,0])
    cylinder(h=3,r=8);
```

轮子现在可见，但如果它没有正确放置，您的汽车无法移动。您可以使用 `rotate` 命令使轮子直立。为此，您需要围绕 X 轴旋转 90 度。

---

代码示例 `two_cubes_and_a_rotated_cylinder.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
rotate([90,0,0])
    translate([0,-20,0])
    cylinder(h=3,r=8);
```

您应该注意以下几点：

{: .new }
>1. `rotate` 和 `translate` 命令之间没有分号。分号仅用于语句的结束。
>2. `rotate` 命令的输入参数是一个包含三个值的向量，每个值分别表示对象围绕 X、Y 和 Z 轴旋转的角度。
>3. 由于对象在旋转前已从原点移动，因此轮子旋转后移到了汽车下方。良好的建模实践是先旋转对象，然后再将其平移到所需位置。


---

### 旋转车轮

尝试先旋转轮子，然后再平移它，改变 `rotate` 和 `translate` 命令的顺序。

---

代码示例 文件名：`two_cubes_and_a_rotated_and_translated_cylinder.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([0,-20,0])
    rotate([90,0,0])
    cylinder(h=3,r=8);
```

---

### 添加左前轮


修改 `translate` 命令的输入参数，将轮子设置为汽车的左前轮。

---

代码示例 `car_body_and_front_left_wheel.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8);
```

### 添加右前轮

通过复制上一条语句并仅更改一个值的符号，为汽车添加右前轮。

---

代码示例 `car_body_and_misaligned_front_wheels.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8);
translate([-20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8);
```

您会注意到轮子的位置并不对称。这是因为圆柱在创建时未居中于原点。

---

### 让轮子对称

为 `cylinder` 命令添加一个额外的输入参数，指示 OpenSCAD 使两个轮子在创建时居中于原点。您的轮子现在对称了吗？

---

代码示例 `car_body_and_aligned_front_wheels.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
```


## 完成您的第一个模型

{: .ex}
>使用您学到的知识为汽车添加后轮。尝试为前轮和后轮添加连接轴。


---

代码示例 文件名：`completed_car.scad`

```openscad
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
translate([20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
```

在上述模型中，轴和轮子之间的重叠等于轮子厚度的一半。如果模型是以轮子和轴刚好接触的方式创建的，则需要像汽车车身的两个立方体一样，确保它们之间有小的重叠。

---

### 增加模型分辨率

您可能已经注意到轮子的分辨率较低。目前，您使用的是 OpenSCAD 的默认分辨率设置。可以通过以下命令完全控制模型的分辨率：

```openscad
$fa = 1;
$fs = 0.4;
```

将上述两条语句添加到汽车脚本的开头。您是否注意到轮子的分辨率有所变化？

---

代码示例 `completed_car_higher_resolution.scad`

```openscad
$fa = 1;
$fs = 0.4;
cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
translate([20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
```

{: .new }
 特殊变量
>`$fa` 和 `$fs` 是特殊变量，用于根据分配给它们的值确定模型的分辨率。具体功能将在稍后章节详细解释。您只需记住，将这两条语句添加到任何脚本中，即可实现适合 3D 打印的通用高分辨率。

---

### 添加注释

在与朋友共享脚本之前，可以添加一些注释帮助他们理解。使用双斜杠 `//` 开始一行，可以书写任何内容而不影响模型。

---

{: .code }
>代码示例 `completed_car_commented.scad`
>```openscad
>$fa = 1;
>$fs = 0.4;
>// Car body base
>cube([60,20,10],center=true);
>// Car body top
>translate([5,0,10 - 0.001])
>    cube([30,20,10],center=true);
>// Front left wheel
>translate([-20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Front right wheel
>translate([-20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Rear left wheel
>translate([20,-15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Rear right wheel
>translate([20,15,0])
>    rotate([90,0,0])
>    cylinder(h=3,r=8,center=true);
>// Front axle
>translate([-20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>// Rear axle
>translate([20,0,0])
>    rotate([90,0,0])
>    cylinder(h=30,r=2,center=true);
>```

保存脚本并导出 STL 文件后，您可以将汽车模型用于 3D 打印。

---

## 创建一个新模型

{: .ex }
>### 练习
>尝试使用您学到的所有知识创建一个新的简单模型。可以是房子、飞机或任何您喜欢的东西。不必追求完美，只需用您的新技能尽情实验！

