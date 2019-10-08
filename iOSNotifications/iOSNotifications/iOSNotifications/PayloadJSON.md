
> 下面说明远程服务器通知的payload json格式

# 通用

{
    "aps" : {
        "alert" : "Hello World!",
        "sound" : "default",
        "category" : "example-category",
        "thread" : "example-thread",
        "thread-identifier" : "example-thread-identifier"
    }
    "custom-field" : "some value",
}

# 内容修改

mutable-content：表明需要修改通知内容，只针对远程通知有效！
可修改的内容包括整个通知中所有的部分。

{
    "aps":{
        "alert":{
            "title":"Hurry Up!",
            "body":"Go to School~"
        },
    "sound":"default",
    "mutable-content":1,
    },
}

# 自定义界面

category，根据该字段加载不同category action，以及加载不同的Notification Content

{
    "aps":{
        "alert":{
            "title":"Hurry Up!",
            "body":"Go to School~"
        },
    "sound":"default",
    "category":"customUI",
    },
}

注意：category必须和Info.plist中的UNNotificationExtensionCategory一致。

# 图片加载

//此处自定义一个字段image，用于下载地址：
{
    "aps":{
        "alert":{
            "title":"Hurry Up!",
            "body":"Go to School~"
        },
        "sound":"default",
        "mutable-content":1,
        "category":"customUI",
    },
    "image":"http://p2.so.qhmsg.com/t01570d67d63111d3e7.jpg"
}

//同时，需要注意的是，在下载图片是采用http时，需要在extension info.plist加上 app transport
//注意：image读取的层次结构

# 静默推送

{
    "aps":{
        "content-available":1,
    }
}

# 支持subtitle

{
    "aps":{
    "alert":{
        "title":"I am title",
        "subtitle":"I am subtitle",
        "body":"I am body"
    },
    "sound":"default",
    "badge":1
    }
}
