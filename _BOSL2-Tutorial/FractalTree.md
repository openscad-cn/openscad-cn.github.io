---
layout: post
title:  "分形树"
nav_order: 3.1
---
# 分形树


{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

### 从树干开始/Start with a Tree Trunk

首先，包含 BOSL2 库，然后创建一个起始模块，其中仅包含一个 tapered（渐变）圆柱体作为树干。

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7)
    cylinder(h=l, d1=l/5, d2=l/5*sc);
tree();
```

### 附加树枝/Attaching a Branch

您可以通过将 `attach()` 作为树干圆柱体的子对象，将树枝附加到树干的顶部。

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7)
    cylinder(h=l, d1=l/5, d2=l/5*sc)
        attach(TOP)
            yrot(30) cylinder(h=l*sc, d1=l/5*sc, d2=l/5*sc*sc);
tree();
```

### 复制树枝/Replicating the Branch

您可以通过复制一个树枝并使它们相互旋转，而不是单独附加每个树枝。

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7)
    cylinder(h=l, d1=l/5, d2=l/5*sc)
        attach(TOP)
            zrot_copies(n=2)  // Replicate that branch
                yrot(30) cylinder(h=l*sc, d1=l/5*sc, d2=l/5*sc*sc);
tree();
```

### 使用递归/Use Recursion

由于树枝与主干非常相似，我们可以使树的生成具有递归性。  
不要忘记终止条件，否则它将尝试无限递归下去！

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7, depth=10)
    cylinder(h=l, d1=l/5, d2=l/5*sc)
        attach(TOP)
            if (depth>0)  { // Important!
                zrot_copies(n=2)
                yrot(30) tree(depth=depth-1, l=l*sc, sc=sc);
            }
tree();
```

### 使其不平坦/Make it Not Flat

平面的树形状并不是我们想要的，因此我们可以通过将每一层旋转 90 度来让它看起来更加蓬松。

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7, depth=10)
    cylinder(h=l, d1=l/5, d2=l/5*sc)
        attach(TOP)
            if (depth>0) {
                zrot(90)  // Bush it out
                zrot_copies(n=2)
                yrot(30) tree(depth=depth-1, l=l*sc, sc=sc);
            }
tree();
```

### 添加树叶/Adding Leaves

让我们添加一些树叶。它们看起来像是标准 `teardrop()` 模块的压扁版本，所以我们可以使用该模块来实现。

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7, depth=10)
    cylinder(h=l, d1=l/5, d2=l/5*sc)
        attach(TOP)
            if (depth>0) {
                zrot(90)
                zrot_copies(n=2)
                yrot(30) tree(depth=depth-1, l=l*sc, sc=sc);
            } else {
                yscale(0.67)
                teardrop(d=l*3, l=1, anchor=BOT, spin=90);
            }
tree();
```

### 添加颜色/Adding Color

我们可以为这个模型添加颜色。`color()` 模块将强制所有子对象及其后代使用新颜色，即使它们之前已经有了颜色。  
然而，`recolor()` 模块只会为那些没有被更深层次的 `recolor()` 设置颜色的子对象和后代着色。

```openscad
include <BOSL2/std.scad>
module tree(l=1500, sc=0.7, depth=10)
    recolor("lightgray")
    cylinder(h=l, d1=l/5, d2=l/5*sc)
        attach(TOP)
            if (depth>0) {
                zrot(90)
                zrot_copies(n=2)
                yrot(30) tree(depth=depth-1, l=l*sc, sc=sc);
            } else {
                recolor("springgreen")
                yscale(0.67)
                teardrop(d=l*3, l=1, anchor=BOT, spin=90);
            }
tree();
```


