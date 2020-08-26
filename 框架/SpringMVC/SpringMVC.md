## SpringMVC原理

Spring的Web框架就是为了帮你解决这些关注点而设计的。Spring MVC基于模型-视图-控制器（Model-View-Controller，MVC）模式实现，它能够帮你构建像Spring框架那样灵活和松耦合的Web应用程序。 

![img](SpringMVC.assets\wps3.jpg)

第一步：发起请求到**前端控制器(DispatcherServlet)**

第二步：前端控制器请求HandlerMapping查找 Handler；可以根据xml配置、注解进行查找

第三步：处理器映射器HandlerMapping向前端控制器返回Handler

第四步：前端控制器调用处理器适配器去执行Handler

第五步：处理器适配器去执行Handler

第六步：Handler执行完成给适配器返回ModelAndView

第七步：处理器适配器向前端控制器返回ModelAndView

ModelAndView是springmvc框架的一个底层对象，包括 Model和view

第八步：前端控制器请求视图解析器去进行视图解析，根据逻辑视图名解析成真正的视图(jsp)

第九步：视图解析器向前端控制器返回View

第十步：前端控制器进行视图渲染，视图渲染将**模型数据(在ModelAndView对象中)填充到request域**

第十一步：前端控制器向用户响应结果

**控制器**：只是方法上添加了@RequestMapping注解的类，这个注解声明了它们所要处理的请求。 

## 搭建Spring MVC

DispatcherServlet是Spring MVC的核心。

**Springmvc的优点:**

- 可以支持各种视图技术,而不仅仅局限于JSP；
- 与Spring框架集成（如IoC容器、AOP等）；

- 清晰的角色分配：前端控制器(dispatcherServlet) , 请求到处理器映射（handlerMapping), 处理器适配器（HandlerAdapter), 视图解析器（ViewResolver）。

- 支持各种请求资源的映射策略。

当DispatcherServlet启动的时候，它会创建Spring应用上下文，并加载配置文件或配置类中所声明的bean。

但是在Spring Web应用中，通常还会有另外一个应用上下文。另外的这个应用上下文是由ContextLoaderListener创建的。我们希望DispatcherServlet加载包含Web组件的bean，如控制器、视图解析器以及处理器映射，而ContextLoaderListener要加载 应用中的其他bean。这些bean通常是驱动应用后端的中间层和数据层组件。

Spring是使用XML进行配置的， 你可以使用< mvc:annotation-driven >启用注解驱动的Spring MVC。



## SpringMVC参数绑定

springmvc是用来**处理页面的一些请求**，然后将数据再通过视图返回给用户的。

在springmvc中，接收页面提交的key/value数据是**通过方法形参来接收的**。从客户端请求的key/value数据，经过参数绑定，将key/value数据绑定到**controller方法的形参上**，然后就可以在controller中使用该参数了。

**基本数据类型**

SpringMVC Controller各方法参数绑定首先支持Java所有基本类型（包括： byte、short、int、long、float、double、char、string、boolean），以及基本类型对应封装高级类（包括：StringBuilder、StringBuffer）。

**对象**

public String requestPeople(@ModelAttribute People people)



#### @PathVariable

@PathVariable 是用来获得请求url中的动态参数的，可以将URL中的变量映射到功能处理方法的参数上，其中URL 中的 {xxx} 占位符可以通过@PathVariable(“xxx“) 绑定到操作方法的入参中。

```java
@GetMapping(value = "/{id}/hello")
@ResponseBody
public int say(@PathVariable("id") Integer id){
  return id;
}
```

#### @RequestHeader

@RequestHeader 注解，可以把Request请求header部分的值绑定到方法的参数上。

#### @CookieValue

@CookieValue 可以把Request header中关于cookie的值绑定到方法的参数上。

#### @RequestParam（集合也行）

@RequestParam注解用来处理Content-Type: 为 application/x-www-form-urlencoded编码的内容。提交方式为get或post。（Http协议中，form的enctype属性为编码方式，常用有两种：application/x-www-form-urlencoded和multipart/form-data，默认为application/x-www-form-urlencoded）；

@RequestParam注解实质是将Request.getParameter() 中的Key-Value参数Map利用Spring的转化机制ConversionService配置，转化成参数接收对象或字段，
get方式中queryString的值，和post方式中body data的值都会被Servlet接受到并转化到Request.getParameter()参数集中，所以@RequestParam可以获取的到；

该注解有三个属性： value、required、defaultValue； value用来指定要传入值的id名称，required用来指示参数是否必录，defaultValue表示参数不传时候的默认值。

使用注解 @RequestParam ，我们可以**使用任意形参**，但是注解里面的 value 属性值要和表单的name属性值一样。

![img](file:///C:\Users\ADMINI~1\AppData\Local\Temp\ksohtml12216\wps1.jpg) 

我们可以使用注解@RequestParam对简单的类型进行参数绑定。

![img](file:///C:\Users\ADMINI~1\AppData\Local\Temp\ksohtml12216\wps2.jpg) 

所以说，如果不使用@RequestParam，要求request传入参数名称和controller方法的形参名称一致，方可绑定成功。

#### @RequestBody

对于前台传参为json数据，可以使用RequestBody,去接收参数（特别适用于ajax 通过json传值  ajax contentType设置为：contentType: "application/json



在springmvc的controller控制层接收日期参数时，如果不加以设置，服务器开启后，进入不了页面中，会报错。这个错误就是日期在页面传入到springmvc的controller中的时候没有转化。就会引起错误。

ModelAndView中，这个是以request方式保存的



## SpringMVC常用注解

@RequestMapping：用于处理请求 url 映射的注解，可用于类或方法上。用于类上，则表示类中的所有响应请求的方法都是以该地址作为父路径。

@RequestBody：注解实现接收http请求的json数据，将json转换为java对象。

@ResponseBody：注解实现将conreoller方法返回对象转化为json对象响应给客户。

## View与ViewResolver

### View

视图的作用是渲染模型数据，将模型里的数据以某种形式呈现给客户端。视图对象可以是常见的JSP，还可以是Excel或PDF等形式不一的媒体。为了实现视图模型和具体实现技术的解耦，Spring在org.springframework.web.servlet包中定义了一个抽象的**View接口**，该接口定义了两个方法：

- String getContentType():视图对应的MIME类型，如text/html,image/jpeg等等；

- void render(Map model,HttpServletRequest  request,HttpServletResponse response):将模型数据以某种MIME类型渲染出来。

  **视图对象是一个Bean**,通常情况下，视图对象由视图解析器负责实例化。由于视图Bean是无状态的，所以它们不会有线程安全的问题。

**View接口的任务**：就是接受模型以及Servlet的request和response对象，并将输出结果渲染到response中。

### ViewResolver

SpringMVC中的视图解析器的主要作用就是：将逻辑视图转换成用户可以看到的物理视图。

SpringMVC中处理视图最终要的两个接口就是ViewResolver和View，ViewResolver的作用是将逻辑视图解析成物理视图，View的主要作用是调用其render()方法将物理视图进行渲染。

一般来说，对于SpringMVC控制器中的方法，无论是返回String、View或者是ModelAndView，SpringMVC在内部都会将返回结果封装成ModelAndView对象，然后返回给用户。

SpringMVC为逻辑视图名的解析提供了不同的策略，可以在Spring Web上下文中配置一种或多种视图解析器，并指定它们之间的先后顺序。视图解析器的工作比较单一：将逻辑视图名解析为一个具体的视图对象。所有视图解析器都实现了ViewResolver接口，该接口仅有一个方法：`View  resolverViewName(String viewName,Locale locale) resolverViewName()`的签名清楚地向我们传达了视图解析器的工作含义：根据逻辑视图名和本地化对象得到一个视图对象。

**视图解析器实现类**
解析为Bean名字：
BeanNameViewResolver :将逻辑视图名解析为一个Bean,Bean的id等于逻辑视图名。XmlViewResolver:和BeanNameViewResolver类似，只不过目标视图Bean对象定义在一个独立的XML文件中，而非定义在DispatcherServlet上下文的主配置文件中

国际化解析：
ResourceBundleViewResolver:在国际化资源文件中定义视图实现类以及相关的信息。使用该视图解析器可以为不同本地化类型提供不同的解析结果。

**解析为URL文件：**
**InternalResourceViewResovlver:将视图名解析为一个URL文件，一般使用该解析器将视图名映射为保存在WEB-INF目录中的程序文件（如JSP）；会将视图名解析为JSP文件。**

XsltViewResolver:将视图名解析为一个指定XSLT样式表的URL文件

JasperReportsViewResolver:JasperReports是一个基于java的开源报表工具，该解析器将视图名解析为报表文件对应的URL

模板文件视图：
FreeMarkerViewResolver:解析为基于FreeMarker模板技术的模板文件

VelocityViewResolver和VelocityLayoutViewResolver:解析为基于Velocity模板技术的模板文件

内容协商：
ContentNegotiatingViewResolver:该解析器不负责具体的视图解析，而是作为一个中间人的角色根据请求所要求的MIME类型，从上下文中选择一个适合的视图解析器，再将视图解析工作委托其负责

### 配置视图解析器

通用的实践是将JSP文件放到Web应用的WEB-INF目录下，防止对它的直接访问。如果我们将所有的JSP文件都放在“/WEB-INF/views/”目录下，并且xxx页的JSP名为xxx.jsp。

```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"> 
    //使用JSTL标签来处理格式化和信息
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
    <property name="contentType" value="text/html"/>        
    <property name="prefix" value="/WEB-INF/views/"/>
    <property name="suffix" value=".jsp"/>
</bean> 
```

第七章第十五章