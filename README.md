WMRoute
=========

一个高效、灵活、简单的iOS跳转路由

为什么要在造一个轮子？
===========

已经有很多款不错的 Route 了，但都不是很满足需求。
有的不够高效，有的需要进行注册。很繁琐，于是就有了 WMRoute。

安装
=========

下载 Demo，把 WMRoute 文件拷贝到工程即可

使用教程
========

声明 Controller 比注册简单， 就一句话，而且在主工程看不见代码
-----------

```Object-C
//代码创建 viewController
#define URL_TestAViewController @"code://TestAViewController"

//storyboard 创建 viewController
#define URL_TestBViewController          @"sb://Main/TestBViewController"
```

在需要跳转处实现
----------
```Object-C
[[WMRoute route]pushWithURLString:URL_TestAViewController param:nil animated:YES];

[[WMRoute route]presentWithURLString:URL_TestBViewController param:@{@"textId":@"33333"} animated:YES completion:nil];
```
传参直接在 param 中携带 即可。
