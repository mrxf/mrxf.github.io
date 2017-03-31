---
title: 'C#重载、C#重写和C#隐藏的区别'
date: 2014-05-26 11:22:07
tags: C#
---
C#重载、C#重写和C#隐藏的定义

C#重载：同一个作用域内发生（比如一个类里面），定义一系列同名方法，但是方法的参数列表不同。这样才能通过传递不同的参数来决定到底调用哪一个。而返回值类型不同是不能构成重载的。

C#重写：继承时发生，在子类中重新定义父类中的方法，子类中的方法和父类的方法是一样的

<!--more-->

例如:基类方法声明为virtual(虚方法)，派生类中使用override申明此方法的重写.

C#隐藏：基类方法不做申明（默认为非虚方法），在派生类中使用new声明此方法的隐藏。

C#重载时，根据参数选择调用的方法；

C#重写时，访问父类子类皆调用子类的重写方法；

C#隐藏时，访问父类则调用父类的方法，子类子类的方法。

C#隐藏(new)示例：

```C#
using System;    
   class A    
   {    
         public void F()      
         {    
            Console.WriteLine("A.F");      
         }    
   }    
   class B: A    
   {    
         new public void F()      
         {      
            Console.WriteLine("B.F");      
         }    
   }    
   class Test    
   {    
         static void Main(string[] args)  
         {    
               B b = new B();    
               b.F();    
               A a = b;      
               a.F();    
         }    
   }   
```
 输出为 
 ```cmd
B.F 
A.F 
```

C#重写virtual(虚方法)示例  

```C#
using System;    
 class A    
 {    
       public virtual void F()      
       {    
          Console.WriteLine("A.F");      
       }    
 }    
 class B: A    
 {    
       public override void F()      
       {      
          Console.WriteLine("B.F");      
       }    
 }    
 class Test    
 {    
       static void Main()      
       {    
             B b = new B();    
             b.F();    
             A a = b;      
             a.F();    
       }    
 }  
```
输出为 
```cmd
B.F 
B.F
```
补充：重写override一般用于接口实现和继承类的方法改写，要注意

1. 覆盖的方法的标志必须要和被覆盖的方法的标志完全匹配，才能达到覆盖的效果；
2. 覆盖的方法的返回值必须和被覆盖的方法的返回一致；
3. 覆盖的方法所抛出的异常必须和被覆盖方法的所抛出的异常一致，或者是其子类；
4. 被覆盖的方法不能为private，否则在其子类中只是新定义了一个方法，并没有对其进行覆盖。

[原文地址](http://joeblackzqq.blog.163.com/blog/static/16259543220108394657747/)