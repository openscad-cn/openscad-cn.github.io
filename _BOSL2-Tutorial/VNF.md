---
layout: post
title:  "VNF（如何分段构建多面体）"
nav_order: 2.2
---
# VNF（如何分段构建多面体）

{: .no_toc }

## 目录
{: .no_toc .text-delta }

1. TOC
{:toc}

## 什么是 VNF？/What's a VNF?

VNF 是 Vertices 'N' Faces（顶点与面）的缩写。  
当您使用 OpenSCAD 内置模块 `polyhedron()` 时，您可能已经遇到过顶点和面的概念。  
`polyhedron()` 最简单的形式接受两个参数，第一个是顶点的列表，第二个是面的列表，每个面是顶点列表中的索引列表。  
例如，要制作一个立方体，您可以这样做：


```openscad
include <BOSL2/std.scad>
verts = [
    [-1,-1,-1], [1,-1,-1], [1,1,-1], [-1,1,-1],
    [-1,-1, 1], [1,-1, 1], [1,1, 1], [-1,1, 1]
];
faces = [
    [0,1,2], [0,2,3],  //BOTTOM
    [0,4,5], [0,5,1],  //FRONT
    [1,5,6], [1,6,2],  //RIGHT
    [2,6,7], [2,7,3],  //BACK
    [3,7,4], [3,4,0],  //LEFT
    [6,4,7], [6,5,4]   //TOP
];
polyhedron(verts, faces);
```

VNF 结构（通常称为 VNF）只是一个包含两个项目的列表，第一个项目是顶点列表，第二个项目是面列表。将 VNF 传递给函数比分别传递顶点和面要简单得多。

与 `polyhedron()` 模块等效的，接受 VNF 的模块是 `vnf_polyhedron()`。要将同样的立方体作为 VNF 创建，您可以这样做：

```openscad
include <BOSL2/std.scad>
vnf = [
    [
        [-1,-1,-1], [1,-1,-1], [1,1,-1], [-1,1,-1],
        [-1,-1, 1], [1,-1, 1], [1,1, 1], [-1,1, 1],
    ],
    [
        [0,1,2], [0,2,3],  //BOTTOM
        [0,4,5], [0,5,1],  //FRONT
        [1,5,6], [1,6,2],  //RIGHT
        [2,6,7], [2,7,3],  //BACK
        [3,7,4], [3,4,0],  //LEFT
        [6,4,7], [6,5,4]   //TOP
    ]
];
vnf_polyhedron(vnf);
```

## 将多面体分块组装/Assembling a Polyhedron in Parts

一个 VNF 不必包含完整的多面体，其中的顶点也不必是唯一的。这就展现了 VNF 的真正强大之处：您可以使用 `vnf_join()` 函数将多个部分多面体的 VNF 合并成一个更完整的 VNF。  
这样，您就可以分部分地构建一个复杂的多面体，而不必跟踪在其他部分中创建的所有顶点。

作为示例，考虑一个大致呈球形的多面体，顶点位于顶部和底部的极点。您可以将其分解为三个主要部分：顶部帽、底部帽和侧壁。顶部和底部帽都有一圈顶点，这些顶点通过三角形与顶部或底部顶点连接，而侧面则是多圈顶点，通过四边形连接。

让我们先创建顶部帽：

```openscad
include <BOSL2/std.scad>
cap_vnf = [
    [[0,0,1], for (a=[0:30:359.9]) spherical_to_xyz(1,a,30)], // Vertices
    [for (i=[1:12]) [0, i%12+1, i]] // Faces
];
vnf_polyhedron(cap_vnf);
```

底部帽与顶部帽完全相同，只是镜像对称：

```openscad
include <BOSL2/std.scad>
cap_vnf = [
    [[0,0,1], for (a=[0:30:359.9]) spherical_to_xyz(1,a,30)], // Vertices
    [for (i=[1:12]) [0, i%12+1, i]] // Faces
];
cap_vnf2 = zflip(cap_vnf);
vnf_polyhedron(cap_vnf2);
```

为了创建侧面，我们可以使用 `vnf_vertex_array()` 函数，将一个行列网格的顶点转换为 VNF。`col_wrap=true` 参数告诉它将最后一列的顶点与第一列的顶点连接起来。`caps=false` 参数告诉它，我们不希望它为第一行和最后一行的末端创建帽子：

```openscad
include <BOSL2/std.scad>
wall_vnf = vnf_vertex_array(
    points=[
        for (phi = [30:30:179.9]) [
            for (theta = [0:30:359.9])
            spherical_to_xyz(1,theta,phi)
        ]
    ],
    col_wrap=true, caps=false
);
vnf_polyhedron(wall_vnf);
```

将所有部分通过 `vnf_join()` 合并，我们得到：

```openscad
include <BOSL2/std.scad>
cap_vnf = [
    [[0,0,1], for (a=[0:30:359.9]) spherical_to_xyz(1,a,30)], // Vertices
    [for (i=[1:12]) [0, i%12+1, i]] // Faces
];
cap_vnf2 = zflip(cap_vnf);
wall_vnf = vnf_vertex_array(
    points=[
        for (phi = [30:30:179.9]) [
            for (theta = [0:30:359.9])
            spherical_to_xyz(1,theta,phi)
        ]
    ],
    col_wrap=true, caps=false
);
vnf = vnf_join([cap_vnf,cap_vnf2,wall_vnf]);
vnf_polyhedron(vnf);
```

这现在是一个完整的流形多面体。

## 调试 VNF/Debugging a VNF

创建多面体的一个关键任务是确保所有面都朝向正确的方向。对于 VNF 也是如此。  
找出反向面的最佳方法是，在查看您的多面体或 VNF 时，简单地选择 OpenSCAD 中的 View→Thrown Together 菜单项。  
任何紫色的面都是反向的，您需要修复它们。例如，这个立方体的两个顶部面三角形之一是反向的：

```openscad
include <BOSL2/std.scad>
vnf = [
    [
        [-1,-1,-1], [1,-1,-1], [1,1,-1], [-1,1,-1],
        [-1,-1, 1], [1,-1, 1], [1,1, 1], [-1,1, 1],
    ],
    [
        [0,1,2], [0,2,3],  //BOTTOM
        [0,4,5], [0,5,1],  //FRONT
        [1,5,6], [1,6,2],  //RIGHT
        [2,6,7], [2,7,3],  //BACK
        [3,7,4], [3,4,0],  //LEFT
        [6,4,7], [6,4,5]   //TOP
    ]
];
vnf_polyhedron(vnf);
```

另一种查找 VNF 问题的方法是使用 `vnf_validate()` 模块，它会将问题输出到控制台，并尝试显示问题所在的位置。  
这可以找到更多类型的非流形错误，但可能会比较慢：


```openscad
include <BOSL2/std.scad>
vnf = [
    [
        [-1,-1,-1], [1,-1,-1], [1,1,-1], [-1,1,-1],
        [-1,-1, 1], [1,-1, 1], [1,1, 1], [-1,1, 1],
    ],
    [
        [0,1,2], [0,2,3],  //BOTTOM
        [0,4,5], //FRONT
        [1,5,6], [1,6,2],  //RIGHT
        [2,6,7], [2,7,3],  //BACK
        [3,7,4], [3,4,0],  //LEFT
        [6,4,7], [6,4,5]   //TOP
    ]
];
vnf_validate(vnf, size=0.1);
```

```log
ECHO: "ERROR REVERSAL (violet): Faces Reverse Across Edge at [[-1, -1, 1], [1, -1, 1]]"
ECHO: "ERROR REVERSAL (violet): Faces Reverse Across Edge at [[1, -1, 1], [1, 1, 1]]"
ECHO: "ERROR REVERSAL (violet): Faces Reverse Across Edge at [[1, 1, 1], [-1, -1, 1]]"
```

`vnf_validate()` 模块在显示第一个找到的问题类型后会停止，因此一旦解决了这些问题，您需要再次运行它以显示任何其他剩余的问题。例如，上述示例中的反向面隐藏了前面上的一个非流形孔：

```openscad
include <BOSL2/std.scad>
vnf = [
    [
        [-1,-1,-1], [1,-1,-1], [1,1,-1], [-1,1,-1],
        [-1,-1, 1], [1,-1, 1], [1,1, 1], [-1,1, 1],
    ],
    [
        [0,1,2], [0,2,3],  //BOTTOM
        [0,4,5], //FRONT
        [1,5,6], [1,6,2],  //RIGHT
        [2,6,7], [2,7,3],  //BACK
        [3,7,4], [3,4,0],  //LEFT
        [6,4,7], [6,5,4]   //TOP
    ]
];
vnf_validate(vnf, size=0.1);
```

```log
ECHO: "ERROR HOLE_EDGE (red): Edge bounds Hole at [[-1, -1, -1], [1, -1, -1]]"
ECHO: "ERROR HOLE_EDGE (red): Edge bounds Hole at [[-1, -1, -1], [1, -1, 1]]"
ECHO: "ERROR HOLE_EDGE (red): Edge bounds Hole at [[1, -1, -1], [1, -1, 1]]"
```

