

# Java

## macOS 安装多个Java版本

应用场景：某些项目只能运行在Java的旧版本上。



1. 安装多个Java版本，下载dmg直接安装。

https://docs.oracle.com/javase/7/docs/webnotes/install/mac/mac-jdk.html  



1. 安装jenv

   ```shell
   brew install jenv
   ```



Use [jEnv](http://www.jenv.be/).

If your system runs [homebrew](http://brew.sh/), you can install it using

```java
brew install jenv
```

(You may need to run `brew update` to get the latest recipes first)

Add it to your bash profile using

```java
echo 'eval "$(jenv init -)"' >> ~/.bash_profile
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc 
echo 'eval "$(jenv init -)"' >> ~/.zshrc 
```

Start a new shell to make this change to the profile effective.

You can then add jdk’s like this:

```java
jenv add /Library/Java/JavaVirtualMachines/jdk1.8.0_05.jdk/Contents/Home
```

list the available versions using

```java
jenv versions
```

And switch between environments using

```java
jenv global oracle64-1.8.0.25
```







# 数据库

## Redis

官网 https://redis.io/  [中文镜像](http://www.redis.net.cn/)

教程：

英文文档：https://redis.io/documentation

命令行学习：http://try.redis.io/



### 教程

**推荐**：[中文](http://www.redis.net.cn/tutorial/3501.html)

[Redis入门教程-超详细](https://blog.csdn.net/yuzsmc/article/details/81979262)

[Redis【入门】就这一篇！](https://zhuanlan.zhihu.com/p/37982685)





## SQL

教程

w3school  http://www.w3school.com.cn/sql/index.asp

廖雪峰 [SQL教程](https://www.liaoxuefeng.com/wiki/001508284671805d39d23243d884b8b99f440bfae87b0f4000)

极客学院 http://wiki.jikexueyuan.com/project/sql/group-by.html





# BD项目

## BD后端

webservice

pop.xml中配置：bd.jdbc.url



Spring配置

resources/applicationContent.xml

resouces/application.property



Mybatis

resouce/mybatis



Service/Dao

基础的数据结构在modules



## BDR

1. bdr-dao 数据访问接口，均为Interface接口

2. bdr-domain 	数据库访问接口

   1. 下面是mybatis 生成的

      ```
      \bdr-domain\src\generator\model  mybatis 生成的Model
      \bdr\bdr-domain\src\generator\xml mybatis 生成的Mapper.xml
      \bdr\bdr-domain\src\generator\dao mybatis 生成的dao
      ```

   2. main目录是自己copy生成后，加上之后变动之后改的。

3. bdr-interface 对外部提供可调用的接口Interface

4. bdr-service 外部接口的对应是实现

5. bdr-web 



**运行bdr，先clean，再compile。**

b'd



## 京东内部工具链条

jsf



## 数据库



| 表                           | 字段 | 说明                                                       |
| ---------------------------- | ---- | ---------------------------------------------------------- |
| bd_store                     |      | 门店                                                       |
| bd_sys_jss                   |      | 资源表，包括券码表等                                       |
| bd_user                      |      | 用户表                                                     |
| bd_user_role                 |      | 用户-用户角色关联表                                        |
| bd_role                      |      | 用户角色                                                   |
| bd_role_permission           |      | 用户权限                                                   |
| bd_industry                  |      | 行业分类                                                   |
| bd_partner                   |      | 商家                                                       |
| bd_dept                      |      | 部门                                                       |
| bd_activities                |      | 活动                                                       |
| bd_actiity_invite            |      | 活动邀请                                                   |
| bd_activity_regist           |      | 报名的合作方                                               |
| bd_activity_res              |      | 活动资源                                                   |
| bd_address                   |      | 地址                                                       |
| bd_benefits                  |      | 权益                                                       |
| bd_benefits                  |      | 权益对应的地址                                             |
| bd_benefits_batch            |      | 券码批次列表                                               |
| bd_benefits_rule             |      | 权益规则表，由业务方指定规则，例如京东多少可以兑换多少券。 |
| bd_business_verify           |      | BD审批                                                     |
| bd_channel                   |      | 业务频道信息表                                             |
| bd_channel_apply_info        |      | 业务申请信息吧                                             |
| bd_coupon_code_info          |      | 券码信息表，业务方申请的券码                               |
| bd_coupon_code_info_received |      | 已领券码信息表                                             |
|                              |      |                                                            |
|                              |      |                                                            |
|                              |      |                                                            |





## 工作

资源详情接口：

bd_benefits

1)      入参：资源ID

2)      出参：资源信息，包括资源名称，适用城市，使用说明，使用流程，资源展示图（入口图，详情图）

3)      校验逻辑：校验该业务是否已申请该资源并通过审核；

4)      异常情况说明：因为网络原因领取失败，返回“网络较差，请稍后再试”

5)      异常情况说明：因为其他原因领取失败，返回“该权益已被抢光，请看看别的吧”



资源列表接口

当用户进入某个业务频道时，调用资源列表接口，展示分配给该业务的所有资源

1)      入参：业务ID/业务名称

2)      出参：该业务下的所有资源信息（包含入口图，资源名称，资源投放时间）



查询bd_benefits_verify 表获取所有channel_id下的权益，然后根据权益id去获取对应的权益信息。