# Java_SpringBoot

## Spring Boot属性配置文件详解

相信使用过一段时间Spring Boot的用户，一定知道这条命令：

`java -jar xxx.jar --server.port=8888`，通过使用–server.port属性来设置xxx.jar应用的端口为8888。

在命令行运行时，连续的两个减号`--`就是对`application.properties`中的属性值进行赋值的标识。所以，`java -jar xxx.jar --server.port=8888`命令，等价于我们在`application.properties`中添加属性`server.port=8888`，该设置在样例工程中可见，读者可通过删除该值或使用命令行来设置该值来验证。

通过命令行来修改属性值固然提供了不错的便利性，但是通过命令行就能更改应用运行的参数，那岂不是很不安全？是的，所以Spring Boot也贴心的提供了屏蔽命令行访问属性的设置，只需要这句设置就能屏蔽：`SpringApplication.setAddCommandLineProperties(false)`。


