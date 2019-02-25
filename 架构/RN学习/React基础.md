---
typora-copy-images-to: ./media
---

# React

## React 介绍

![react-logo](./media/react-logo.png)

- React 是一个用于构建用户界面的渐进式 JavaScript 库
  - 本身只处理 UI
  - 不关心路由
  - 不处理 ajax
- React主要用于构建UI，很多人认为 React 是 MVC 中的 V（视图）。
  - 数据驱动视图
- React 由 Facebook 开发
- 第一个真生意义上把组件化思想待到前端开发领域
  - angular 早期没有组件化思想
  - 后来也被 Vue 学习借鉴了

React 起源于 Facebook 的内部项目，因为该公司对市场上所有 [JavaScript MVC 框架](http://www.ruanyifeng.com/blog/2015/02/mvcmvp_mvvm.html)，都不满意，就决定自己写一套，用来架设 [Instagram](https://instagram.com/) 的网站。做出来以后，发现这套东西很好用，就在2013年5月[开源](http://facebook.github.io/react/blog/2013/06/05/why-react.html)了。

由于 React 的设计思想极其独特，属于革命性创新，性能出众，代码逻辑却非常简单。所以，越来越多的人开始关注和使用，认为它可能是将来 Web 开发的主流工具。

这个项目本身也越滚越大，从最早的UI引擎变成了一整套前后端通吃的 Web App 解决方案。衍生的 React Native 项目，目标更是宏伟，希望用写 Web App 的方式去写 Native App。如果能够实现，整个互联网行业都会被颠覆，因为同一组人只需要写一次 UI ，就能同时运行在服务器、浏览器和手机（参见[《也许，DOM 不是答案》](http://www.ruanyifeng.com/blog/2015/02/future-of-dom.html)）。

- 数据驱动视图
- 组件化
- 路由


- React 8w
  - 对技术要求比较高
  - 今年春天的，只要会用就行
  - 编程性更好一些，更底层，更灵活
  - 可玩儿性更高
- Vue 7.5 w
- angular
  - 1 5.7 w
  - 2 3w

### React 特点

- 组件化
- 高效
  - 虚拟 DOM
  - Vue 2 也是虚拟 DOM
  - 虚拟 DOM 更高效
- 灵活
  - 渐进式，本身只处理 UI ，可以和你的其它技术栈组合到一起来使用
- 声明（配置）式设计
  - `data` 响应式数据
  - `mathods` 处理函数
  - 这样做的好处就是按照我们约定好的方式来开发，所有人写出来的代码就像一个人写的
  - `state`
  - 方法就是类成员
  - 也有特定的组件生命钩子
- JSX
  - 一种预编译 JavaScript 语言，允许让你的 JavaScript 和 HTML 混搭
  - 模板中就是 JavaScript 逻辑
- 单向数据流
  - 组件传值
  - 所有数据都是单向的，组件传递的数据都是单向
  - Vue 也是单向数据流
  - 没有双向数据绑定

### React 的发展历史

- Facebook 内部用来开发 Instagram
- 2013 年开源了 React
- 随后发布了 React Native
- React 开源协议
  - [知乎专栏 -React 的许可协议到底发生了什么问题？](https://zhuanlan.zhihu.com/p/28618630)
  - [知乎 - 如何看待 Facebook 计划将 React 改为 MIT 许可证？](https://www.zhihu.com/question/65728078)
  - [阮一峰 - 开源许可证教程](http://www.ruanyifeng.com/blog/2017/10/open-source-license-tutorial.html)
  - [阮一峰 - 如何选择开源许可证](http://www.ruanyifeng.com/blog/2011/05/how_to_choose_free_software_licenses.html)
  - React  最后架不住社区的压力，最后还是修改了许可协议条款。我分享，我骄傲。
- [React - Releases](https://github.com/facebook/react/releases)
- 2013 年 7 月 3 日 `v0.3.0`
- 2016 年 3 月 30 日 `v0.14.8`
- 2016 年 4 月 9 日 `v15.0.0`
- 2017 年 9 月 27 日 `v16.0.0`
- 截止到目前：2017 年 11 月 29 日 `v16.2.0`

### React 与 Vue 的对比

#### 技术层面

- Vue 生产力更高（更少的代码实现更强劲的功能）
- React 更 hack 技术占比比较重
- 两个框架的效率都采用了虚拟 DOM
  - 性能都差不多
- 组件化
  - Vue 支持
  - React 支持
- 数据绑定
  - 都支持数据驱动视图
  - Vue 支持表单控件双向数据绑定
  - React 不支持双向数据绑定
- 它们的核心库都很小，都是渐进式 JavaScript 库
- React 采用 JSX 语法来编写组件
- Vue 采用单文件组件
  - `template`
  - `script`
  - `style`

#### 开发团队

- React 由 Facebook 前端维护开发
- Vue
  - 早期只有尤雨溪一个人
  - 由于后来使用者越来越多，后来离职专职开发维护
  - 目前也有一个小团队在开发维护

#### 社区

- React 社区比 Vue 更强大
- Vue 社区也很强大

#### Native APP 开发

- React Native
  - 可以原生应用
  - React 结束之后会学习
- Weex
  - 阿里巴巴内部搞出来的一个东西，基于 Vue

### 相关资源链接

- [React 官网](https://reactjs.org/)
- [官方教程](https://reactjs.org/tutorial/tutorial.html)
  - 连字游戏
- [官方文档](https://reactjs.org/docs/)
  - 基础教程
  - 高级教程
  - API 参考文档
- [React - GitHub](https://github.com/facebook/react)
- [阮一峰 - React 技术栈系列教程](http://www.ruanyifeng.com/blog/2016/09/react-technology-stack.html)
- [阮一峰 - React 入门实例教程]（http://www.ruanyifeng.com/blog/2015/03/react.html
- [awesome react](https://github.com/enaqx/awesome-react)
- [awesome-react-components](https://github.com/brillout/awesome-react-components)

## EcmaScript 6 补充

- `class` 构造函数的语法糖

## React 核心概念

### 组件化

![react-component](https://cn.vuejs.org/images/components.png)

### 虚拟 DOM

> 虚拟 DOM 对于使用者来讲完全不用关心

- [知乎 - 如何理解虚拟DOM？](https://www.zhihu.com/question/29504639)
- [深度剖析：如何实现一个 Virtual DOM 算法](https://github.com/livoras/blog/issues/13)
- [理解 Virtual DOM](https://github.com/y8n/blog/issues/5)
- [深入浅出React（四）：虚拟DOM Diff算法解析](http://www.infoq.com/cn/articles/react-dom-diff)
- [全面理解虚拟DOM，实现虚拟DOM](https://foio.github.io/virtual-dom/)
- [50行代码实现Virtual DOM](http://www.jianshu.com/p/cbb7d7094fb9)
- [网上都说操作真实 DOM 慢，但测试结果却比 React 更快，为什么？](https://www.zhihu.com/question/31809713)

### JSX

虚拟 DOM 写起来麻烦，所以提供了 JSX 的方式。

## 起步

### 安装

- 云端编程环境
  - 只用于 demo 测试
- 脚手架工具：`create-react-app`
  - 目前不推荐使用
  - 类似于 `vue-cli`
  - 集成了 webpack 构建工具等环境
  - 自动刷新浏览器
  - 。。。
- 本地简单开发测试环境（没有模块化支持）
- 自己手动搭建模块化 webpack 开发环境

> https://reactjs.org/docs/hello-world.html



### babel-standalone

> 参考文档：https://github.com/babel/babel/tree/master/packages/babel-standalone

自己手动调用 babel API 编译执行：

```html
<script>
  var input = 'const getMessage = () => "Hello World"; console.log(getMessage())';

  // 调用 Babel 提供的转换 API 完成编译转换，得到结果字符串
  // 编译过程比较耗时，所以只推荐开发测试使用
  // 咱们这里使用它的目的是为了简化 react 的学习过程
  var output = Babel.transform(input, { presets: ['es2015'] }).code;
  
  // eval 函数支持动态解析执行 JavaScript 字符串
  window.eval(output)
</script>
```

babel 自动编译执行：

```html
<!--
当 babel-standalone 发现 type="text/babel" 类型标签的时候：
	1. 将 script 标签中的内容转换为浏览器可以识别的 JavaScript
	2. 使用 eval 执行编译结果代码
-->
<script type="text/babel">
  const getMessage = () => "Hello World";
  console.log(getMessage())
</script>
```



### 初始化及安装依赖

```Shell
$ mkdir react-demos
$ cd react-demos
$ npm init --yes
$ npm install --save react react-dom @babel/standalone
```

### Hello World

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>demo - Hello World</title>
  <script src="node_modules/@babel/standalone/babel.js"></script>
  <script src="node_modules/react/umd/react.development.js"></script>
  <script src="node_modules/react-dom/umd/react-dom.development.js"></script>
</head>

<body>
  <div id="root"></div>
  <script type="text/babel">
    ReactDOM.render(
      <h1>Hello, react!</h1>,
      document.getElementById('root')
    )
  </script>
</body>

</html>
```

## JSX

JSX 全称 `JavaScript XML` ，是一种扩展的 JavaScript 语言，它允许 HTML 语言直接写在 JavaScript 语言中，不加任何引号，这就是 JSX 语法。它允许 HTML 与 JavaScript 的混写。

- [Introducing JSX](https://reactjs.org/docs/introducing-jsx.html)
- [JSX In Depth](https://reactjs.org/docs/jsx-in-depth.html)
- [React Without JSX](https://reactjs.org/docs/react-without-jsx.html)

### 环境配置

- 非模块化环境
  - `babel-standalone`
  - 执行时编译，速度比较慢
  - 只适用于开发测试环境
- 模块化环境
  - 结合 webpack 配置 babel 响应的工具完成预编译
  - 浏览器执行的是预编译结果
- Babel REPL 赋值查看编译结果
  - 使用在线测试

### 基本语法规则

- 必须只能有一个根节点
- 多标签写到包到一个小括号中，防止 JavaScript 自动分号不往后执行的问题。


- 遇到 HTML 标签 （以 `<` 开头） 就用 HTML 规则解析
  - 单标签不能省略结束标签。
- 遇到代码块（以 `{` 开头），就用 JavaScript 规则解析
- JSX 允许直接在模板中插入一个 JavaScript 变量
  - 如果这个变量是一个数组，则会展开这个数组的所有成员添加到模板中
- 单标签必须结束 `/>`

基本语法：

```jsx
const element = <h1>Hello, world!</h1>;
```

### 在 JSX 中嵌入 JavaScript 表达式

- 语法
- 如果 JSX 写到了多行中，则建议包装括号避免自动分号的陷阱

```jsx
function formatName(user) {
  return user.firstName + ' ' + user.lastName;
}

const user = {
  firstName: 'Harper',
  lastName: 'Perez'
};

const element = (
  <h1>
    Hello, {formatName(user)}!
  </h1>
);

ReactDOM.render(
  element,
  document.getElementById('root')
);
```

```jsx
const user = {
  name: '张三',
  age: 18,
  gender: 0
}

const element = (
  <div>
    <p>姓名：{user.name}</p>
    <p>年龄：{user.age}</p>
    <p>性别：{user.gender === 0 ? '男' : '女'}</p>
  </div>
)
```



### 在 JavaScript 表达式中嵌入 JSX

```jsx
function getGreeting (user) {
  if (user) {
    return <h1>Hello, {user.name}</h1>
  }
  return <h1>Hello, Stranger.</h1>
}

const user = {
  name: 'Jack'
}

const element = getGreeting(user)

ReactDOM.render(
  element,
  document.getElementById('root')
)
```

### JSX 中的节点属性

- 动态绑定属性值
- `class` 使用 `className`
- `tabindex` 使用 `tabIndex`
- `for` 使用 `htmlFor`

普通的属性：

```jsx
const element = <div tabIndex="0"></div>;
```

在属性中使用表达式：

```jsx
const element = <img src={user.avatarUrl}></img>;
```

### 声明子节点

- 必须有且只有一个根节点

如果标签是空的，可以使用 `/>` 立即关闭它。

```jsx
const element = <img src={user.avatarUrl} />;
```

JSX 子节点可以包含子节点（最好加上小括号，防止自动分号的问题）：

```jsx
const element = (
  <div>
    <h1>Hello!</h1>
    <h2>Good to see you here.</h2>
  </div>
);
```

### JSX 自动阻止注入攻击

原样输出：

```jsx
const element = <div>{'<h1>this is safe</h1>'}</div>
```

输出 html：

```jsx
function createMarkup() {
  return {__html: 'First &middot; Second'};
}

function MyComponent() {
  return <div dangerouslySetInnerHTML={createMarkup()} />;
}
```

### 在 JSX 中使用注释

在 JavaScript 中的注释还是以前的方式：

```javascript
// 单行注释

/*
 * 多行注释
 */
```

在 jsx 的标签中写注释需要注意：

写法一（不推荐）：

```jsx
{
  // 注释
  // ...
}
```

写法二（推荐，把多行写到单行中）：

```
{/* 单行注释 */}
```

写法三（多行）：

```jsx
{
  /*
   * 多行注释
   */
}
```

### JSX 原理

Babel 会把 JSX 编译为 `React.createElement()` 函数。



下面两种方式是等价的：

```jsx
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
);
```

```jsx
const element = React.createElement(
  'h1',
  {className: 'greeting'},
  'Hello, world!'
);
```

```javascript
// Note: this structure is simplified
const element = {
  type: 'h1',
  props: {
    className: 'greeting',
    children: 'Hello, world'
  }
};
```

### DOM Elements

> 参考文档：https://reactjs.org/docs/dom-elements.html

### JSX 语法高亮

>  http://babeljs.io/docs/editors

## 列表渲染

> 参考文档：https://reactjs.org/docs/lists-and-keys.html

JSX 允许直接在模板插入 JavaScript 变量。如果这个变量是一个数组，则会展开这个数组的所有成员。

```jsx
var arr = [
  <h1>Hello world!</h1>,
  <h2>React is awesome</h2>,
];

ReactDOM.render(
  <div>{arr}</div>,
  document.getElementById('example')
);
```

综上所述，我们可以这样：

```jsx
var names = ['Alice', 'Emily', 'Kate'];

ReactDOM.render(
  <div>
  {
    names.map(function (name) {
      return <div>Hello, {name}!</div>
    })
  }
  </div>,
  document.getElementById('example')
);
```

## 条件渲染

> 参考文档：https://reactjs.org/docs/conditional-rendering.html

### 示例1：

```jsx
function UserGreeting(props) {
  return <h1>Welcome back!</h1>;
}

function GuestGreeting(props) {
  return <h1>Please sign up.</h1>;
}

function Greeting(props) {
  const isLoggedIn = props.isLoggedIn;
  if (isLoggedIn) {
    return <UserGreeting />;
  }
  return <GuestGreeting />;
}

ReactDOM.render(
  // Try changing to isLoggedIn={true}:
  <Greeting isLoggedIn={false} />,
  document.getElementById('root')
);
```

### 示例2：

```jsx
function LoginButton(props) {
  return (
    <button onClick={props.onClick}>
      Login
    </button>
  );
}

function LogoutButton(props) {
  return (
    <button onClick={props.onClick}>
      Logout
    </button>
  );
}

class LoginControl extends React.Component {
  constructor(props) {
    super(props);
    this.handleLoginClick = this.handleLoginClick.bind(this);
    this.handleLogoutClick = this.handleLogoutClick.bind(this);
    this.state = {isLoggedIn: false};
  }

  handleLoginClick() {
    this.setState({isLoggedIn: true});
  }

  handleLogoutClick() {
    this.setState({isLoggedIn: false});
  }

  render() {
    const isLoggedIn = this.state.isLoggedIn;

    let button = null;
    if (isLoggedIn) {
      button = <LogoutButton onClick={this.handleLogoutClick} />;
    } else {
      button = <LoginButton onClick={this.handleLoginClick} />;
    }

    return (
      <div>
        <Greeting isLoggedIn={isLoggedIn} />
        {button}
      </div>
    );
  }
}

ReactDOM.render(
  <LoginControl />,
  document.getElementById('root')
);
```

### 示例3（行内判断）：

```jsx
function Mailbox(props) {
  const unreadMessages = props.unreadMessages;
  return (
    <div>
      <h1>Hello!</h1>
      {unreadMessages.length > 0 &&
        <h2>
          You have {unreadMessages.length} unread messages.
        </h2>
      }
    </div>
  );
}

const messages = ['React', 'Re: React', 'Re:Re: React'];
ReactDOM.render(
  <Mailbox unreadMessages={messages} />,
  document.getElementById('root')
);
```

### 示例4（if-else）：

```jsx
render() {
  const isLoggedIn = this.state.isLoggedIn;
  return (
    <div>
      The user is <b>{isLoggedIn ? 'currently' : 'not'}</b> logged in.
    </div>
  );
}
```

```jsx
render() {
  const isLoggedIn = this.state.isLoggedIn;
  return (
    <div>
      {isLoggedIn ? (
        <LogoutButton onClick={this.handleLogoutClick} />
      ) : (
        <LoginButton onClick={this.handleLoginClick} />
      )}
    </div>
  );
}
```

### 示例5（阻止组件渲染）：

```jsx
function WarningBanner(props) {
  if (!props.warn) {
    return null;
  }

  return (
    <div className="warning">
      Warning!
    </div>
  );
}

class Page extends React.Component {
  constructor(props) {
    super(props);
    this.state = {showWarning: true}
    this.handleToggleClick = this.handleToggleClick.bind(this);
  }

  handleToggleClick() {
    this.setState(prevState => ({
      showWarning: !prevState.showWarning
    }));
  }

  render() {
    return (
      <div>
        <WarningBanner warn={this.state.showWarning} />
        <button onClick={this.handleToggleClick}>
          {this.state.showWarning ? 'Hide' : 'Show'}
        </button>
      </div>
    );
  }
}

ReactDOM.render(
  <Page />,
  document.getElementById('root')
);
```

## 事件处理

> 参考文档：https://reactjs.org/docs/handling-events.html

### 示例1

```jsx
<button onclick="activateLasers()">
  Activate Lasers
</button>
```

```jsx
<button onClick={activateLasers}>
  Activate Lasers
</button>
```

### 示例2

```html
<a href="#" onclick="console.log('The link was clicked.'); return false">
  Click me
</a>
```

```jsx
function ActionLink() {
  function handleClick(e) {
    e.preventDefault();
    console.log('The link was clicked.');
  }

  return (
    <a href="#" onClick={handleClick}>
      Click me
    </a>
  );
}
```

### 示例3（this 绑定问题）

```jsx
class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};

    // This binding is necessary to make `this` work in the callback
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        {this.state.isToggleOn ? 'ON' : 'OFF'}
      </button>
    );
  }
}

ReactDOM.render(
  <Toggle />,
  document.getElementById('root')
);
```

箭头函数：

```jsx
class LoggingButton extends React.Component {
  // This syntax ensures `this` is bound within handleClick.
  // Warning: this is *experimental* syntax.
  handleClick = () => {
    console.log('this is:', this);
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        Click me
      </button>
    );
  }
}
```

更简单的方式：

```jsx
class LoggingButton extends React.Component {
  handleClick() {
    console.log('this is:', this);
  }

  render() {
    // This syntax ensures `this` is bound within handleClick
    return (
      <button onClick={(e) => this.handleClick(e)}>
        Click me
      </button>
    );
  }
}
```

### 示例4（传递参数）

```jsx
<button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
<button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
```

### 事件绑定中的 this 指向问题（坑）

> 多分享，多交流

第一种绑定方式（不做任何处理）：

- `this` 指向 Window
- 默认接收一个参数 `event` 事件源对象
- 不支持额外的参数传递

```jsx
<button onClick={this.handleClick}>点击改变 message</button>
```

第二种方式（bind）：

- `this` 指向组件实例
- 默认接收一个参数 `event`

```jsx
<button onClick={this.handleClick.bind(this)}>点击改变 message</button>
```

第二种方式还可以为方法传递额外参数：

- 手动传递的参数会放到函数最前面，`event` 会作为函数的最后一个参数

```jsx
<button onClick={this.handleClick.bind(this, 123, 456)}>点击改变 message</button>
```

第三种方式（箭头函数）：

- 自动 bind  this
- 手动传递参数
- 参数顺序自己指定，`event` 也需要自己手动传递

```jsx
<button onClick={(e) => {this.handleClick(e, 123, 456)}}>点击改变 message</button>
```



## Class 和 Style

class:

```jsx
<div className="before" title="stuff" />
```

style:

```jsx
<div style={{color: 'red', fontWeight: 'bold'}} />
```

### classNames

> classNames 是一个第三方工具库，可以很方便的帮我们根据条件拼接样式类名
>
> https://github.com/JedWatson/classnames

## 表单处理

> 参考文档：https://reactjs.org/docs/forms.html

## 组件

React 允许将代码封装成组件（component），然后像插入普通 HTML 标签一样，在网页中插入这个组件。

### 组件规则注意事项

- 组件类的第一个首字母必须大写
- 组件类必须有 `render` 方法
- 组件类必须有且只有一个根节点
- 组件属性可以在组件的 `props` 获取
  - 函数需要声明参数：`props`
  - 类直接通过 `this.props`

### 函数式组件（无状态）

- 名字不能用小写
  - React 在解析的时候，是以标签的首字母来区分的
  - 如果首字母是小写则当作 HTML 来解析
  - 如果首字母是大小则当作组件来解析
  - 结论：组件首字母必须大写

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

const element = <Welcome name="Sara" />;
ReactDOM.render(
  element,
  document.getElementById('root')
);
```

组件构成：

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

function App() {
  return (
    <div>
      <Welcome name="Sara" />
      <Welcome name="Cahal" />
      <Welcome name="Edite" />
    </div>
  );
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

### 抽取组件

```jsx
function Comment(props) {
  return (
    <div className="Comment">
      <div className="UserInfo">
        <img className="Avatar"
          src={props.author.avatarUrl}
          alt={props.author.name}
        />
        <div className="UserInfo-name">
          {props.author.name}
        </div>
      </div>
      <div className="Comment-text">
        {props.text}
      </div>
      <div className="Comment-date">
        {formatDate(props.date)}
      </div>
    </div>
  );
}
```



### 类方式组件（有状态）

### class 补充

> 本质就是对 EcmaScript 5 中构造函数的一个语法糖
>
> 就是让你写构造函数（类）更方便了

- 基本语法
- `constructor` 构造函数
- 实例成员
  - 实例属性
  - 实例方法
- 类成员
  - 静态方法
  - 静态属性

### class 组件语法

> 在 React 中推荐使用 EcmaScript 6 Class 的方式类定义组件

```jsx
class ShoppingList extends React.Component {
  render() {
    return (
      <div className="shopping-list">
        <h1>Shopping List for {this.props.name}</h1>
        <ul>
          <li>Instagram</li>
          <li>WhatsApp</li>
          <li>Oculus</li>
        </ul>
      </div>
    );
  }
}

// Example usage: <ShoppingList name="Mark" />
```

本质：

```javascript
return React.createElement('div', {className: 'shopping-list'},
  React.createElement('h1', /* ... h1 children ... */),
  React.createElement('ul', /* ... ul children ... */)
);
```



### 组件传值 Props

- Props 是只读的，不能修改

EcmaScript 5 构造函数：

```javascript
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

EcmaScript 6 Class：

```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

### `this.props.children`

> 参考文档：https://reactjs.org/docs/react-api.html#reactchildren

`this.props` 对象的属性与组件的属性一一对应，但是有一个例外，就是 `this.props.children` 属性。

它表示组件的所有子节点。

`this.props.children` 的值有三种可能：如果当前组件没有子节点，它就是 `undefined`;如果有一个子节点，数据类型是 `object` ；如果有多个子节点，数据类型就是 `array` 。所以，处理 `this.props.children` 的时候要小心。

React 提供一个工具方法 [`React.Children`](https://facebook.github.io/react/docs/top-level-api.html#react.children) 来处理 `this.props.children` 。我们可以用 `React.Children.map` 来遍历子节点，而不用担心 `this.props.children` 的数据类型是 `undefined` 还是 `object`。

### 组件状态 State

> 参考文档：https://reactjs.org/docs/state-and-lifecycle.html

### 组件生命周期

> 参考文档：https://reactjs.org/docs/state-and-lifecycle.html
>
> 完整生命周期 API：https://reactjs.org/docs/react-component.html#the-component-lifecycle

### PropTypes 类型校验

> 参考文档：https://reactjs.org/docs/typechecking-with-proptypes.html

组件的属性可以接受任意值，字符串、对象、函数等等都可以。有时，我们需要一种机制，验证别人使用组件时，提供的参数是否符合要求。

示例：

```jsx
import PropTypes from 'prop-types';

class Greeting extends React.Component {
  render() {
    return (
      <h1>Hello, {this.props.name}</h1>
    );
  }
}

Greeting.propTypes = {
  name: PropTypes.string
};
```

### Default Prop Values 

> 参考文档：https://reactjs.org/docs/typechecking-with-proptypes.html#default-prop-values

示例：

```jsx
class Greeting extends React.Component {
  render() {
    return (
      <h1>Hello, {this.props.name}</h1>
    );
  }
}

// Specifies the default values for props:
Greeting.defaultProps = {
  name: 'Stranger'
};

// Renders "Hello, Stranger":
ReactDOM.render(
  <Greeting />,
  document.getElementById('example')
);
```

或者：

```jsx
class Greeting extends React.Component {
  static defaultProps = {
    name: 'stranger'
  }

  render() {
    return (
      <div>Hello, {this.props.name}</div>
    )
  }
}
```

### React Without ES6

> 参考文档：https://reactjs.org/docs/react-without-es6.html

## 和服务端交互

组件的数据来源，通常是通过 Ajax 请求从服务器获取，可以使用 `componentDidMount` 方法设置 Ajax 请求，等到请求成功，再用 `this.setState` 方法重新渲染 UI 。



## 获取真实 DOM 节点

> 参考文档：https://reactjs.org/docs/refs-and-the-dom.html

组件并不是真实的 DOM 节点，而是存在于内存之中的一种数据结构，叫做虚拟 DOM （virtual DOM）。只有当它插入文档以后，才会变成真实的 DOM 。根据 React 的设计，所有的 DOM 变动，都先在虚拟 DOM 上发生，然后再将实际发生变动的部分，反映在真实 DOM上，这种算法叫做 [DOM diff](http://calendar.perfplanet.com/2013/diff/) ，它可以极大提高网页的性能表现。

但是，有时需要从组件获取真实 DOM 的节点，这时就要用到 `ref` 属性。

示例：

```jsx
class CustomTextInput extends React.Component {
  constructor(props) {
    super(props);
    this.focusTextInput = this.focusTextInput.bind(this);
  }

  focusTextInput() {
    // Explicitly focus the text input using the raw DOM API
    this.textInput.focus();
  }

  render() {
    // Use the `ref` callback to store a reference to the text input DOM
    // element in an instance field (for example, this.textInput).
    return (
      <div>
        <input
          type="text"
          ref={(input) => { this.textInput = input; }} />
        <input
          type="button"
          value="Focus the text input"
          onClick={this.focusTextInput}
        />
      </div>
    );
  }
}
```



## TodoMVC

### 开始

下载模板：

```shell
git clong https://github.com/tastejs/todomvc-app-template.git --depth=1 todomvc-react
```

安装依赖：

```shell
cd todomvc-react
npm install
```

安装 `react` 开发环境依赖：

```shell
npm install --save babel-standalone react react-dom
```



## React 其它

### React DevTools

> https://github.com/facebook/react-devtools

### create-react-app



