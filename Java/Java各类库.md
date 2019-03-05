## log4j2

　　java项目寻找log4j2配置文件会依次读取classpath是否有下面这些文件：

- log4j.configurationFile
- log4j2-test.properties
- `log4j2-test.yaml `或者 `log4j2-test.yml`
- `log4j2-test.json` 或者 `log4j2-test.jsn`
- log4j2-test.xml
- log4j2.properties
- `log4j2.json` 或者 `log4j2.jsn`
- log4j2.xml
- `DefaultConfiguration` 



### 配置说明

https://blog.csdn.net/batter_hwb/article/details/83416522