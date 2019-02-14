

AFNetworking读码

![afnetwokring_stru](http://blog-1251606168.file.myqcloud.com/blog_2018/2019-01-28-085306.jpg)

- 网络通信核心AFURLSessionManager分析 
- HTTP网络通信核心AFHTTPSessionManager分析 
- 网络数据的装配解析员AFURLResponseSerialization分析 
- 网络状态监测员AFNetworkReachabilityManager分析 
- 网络数据的组装与解析AFURLRequestSerialization/AFURLResponseSerialization 分析 
- 网络安全策略 AFSecurityPolicy分析 
- AF提供的工具包AF UIKit的功能类分析 





![nsurlsession_stru](http://blog-1251606168.file.myqcloud.com/blog_2018/2019-01-28-092442.png)



各种请求

| HTTP Verb | CRUD           | Entire Collection (e.g. /customers)                          | Specific Item (e.g. /customers/{id})                         |
| --------- | -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| POST      | Create         | 201 (Created), 'Location' header with link to /customers/{id} containing new ID. | 404 (Not Found), 409 (Conflict) if resource already exists.. |
| GET       | Read           | 200 (OK), list of customers. Use pagination, sorting and filtering to navigate big lists. | 200 (OK), single customer. 404 (Not Found), if ID not found or invalid. |
| PUT       | Update/Replace | 405 (Method Not Allowed), unless you want to update/replace every resource in the entire collection. | 200 (OK) or 204 (No Content). 404 (Not Found), if ID not found or invalid. |
| PATCH     | Update/Modify  | 405 (Method Not Allowed), unless you want to modify the collection itself. | 200 (OK) or 204 (No Content). 404 (Not Found), if ID not found or invalid. |
| DELETE    | Delete         | 405 (Method Not Allowed), unless you want to delete the whole collection—not often desirable. | 200 (OK). 404 (Not Found), if ID not found or invalid.       |





# 参考

[Using HTTP Methods for RESTful Services](https://www.restapitutorial.com/lessons/httpmethods.html)