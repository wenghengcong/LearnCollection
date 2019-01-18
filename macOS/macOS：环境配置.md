---
title: macOS环境配置
date: 2017-03-12 10:18:09
description:
categories:
- macOS
tags:
---



# 环境变量

macOS 默认的是 `Bourne Shell`，其环境变量配置文件及加载顺序如下：

```
/etc/profile
/etc/bashrc
/etc/paths 
~/.bash_profile # macOS
~/.bash_login 
~/.profile 
~/.bashrc # linux
```

其中 `/etc/profile` `/etc/bashrc` 和 `/etc/paths` 是系统级环境变量，对所有用户都有效。但它们的加载时机有所区别：

- `/etc/profile` 任何用户登陆时都会读取该文件
- `/etc/bashrc` bash shell执行时，不管是何种方式，读取此文件
- `/etc/paths` 任何用户登陆时都会读取该文件

后面几个是当前用户级的环境变量。macOS 默认用户环境变量配置文件为 `~/.bash_profile`，Linux 为 `~/.bashrc`。

如果不存在 `~/.bash_profile`，则可以自己创建一个 `~/.bash_profile`。

- 如果 `~/.bash_profile` 文件存在，则后面的几个文件就会被忽略
- 如果 `~/.bash_profile` 文件不存在，才会以此类推读取后面的文件

> 如果使用的是 SHELL 类型是 `zsh`，则还可能存在对应的 `/etc/zshrc` 和 `~/.zshrc`。任何用户登录 `zsh` 的时候，都会读取该文件。某个用户登录的时候，会读取其对应的 `~/.zshrc`。





# 配置类型

下面是各种配置的路径地址：

 ## 全局环境配置

> /etc/profile



## 用户全局配置

> ~/.bash_profile



每次打开终端都要source对应的配置文件，分别在下面文件添加对应还配置即可： 

## bash配置

> ~/.bashrc

 

## zsh配置

>  ~/.zshrc

假如使用iTerm，iTerm使用的是ZSH，所以，假如要是的配置在`~/.bash_profile`在一启动就生效，需要在 `~/.zshrc`头部加入：

```sh
#使得bash_profile生效
source ~/.bash_profile
```



# 配置范例

```sh
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH

#Java env
JAVA_HOME="/usr/libexec/java_home"
CLASS_PATH="$JAVA_HOME/lib"
PATH=".:$PATH:$JAVA_HOME/bin"

#Tomcat env
export TOMCAT_HOME=/Users/wenghengcong/Open/apache-tomcat-8.5.31
export PATH=$PATH:$TOMCAT_HOME/bin

#Tools env
export TOOLS_HOME=/Users/wenghengcong/Tools/crazyscript
export PATH=$PATH:$TOOLS_HOME

#Maven env
export MAVEN_HOME=/Users/wenghengcong/Open/apache-maven-3.5.3
export PATH=$PATH:$MAVEN_HOME/bin

#Ant env
export ANT_HOME=/Users/wenghengcong/Open/apache-ant-1.9.7
export PATH=$PATH:$ANT_HOME/bin

#mysql
export PATH=${PATH}:/usr/local/mysql/bin
```



# 推荐：Path路径直接配置

```
$ vim /etc/paths
```

上面配置等效于：

```json
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/usr/local/mysql/bin
/Users/wenghengcong/Open/apache-tomcat-8.5.31/bin
/Users/wenghengcong/Open/apache-maven-3.5.3/bin
/Users/wenghengcong/Open/apache-ant-1.9.7/bin
/Users/wenghengcong/Github/ALotScripts/bin
```



# 生效

```Sh
// source #配置文件路径
source ~/.bashrc	
```

