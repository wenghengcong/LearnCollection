# Apple CloudKit Client App using React

## Background

I am an iOS developer with a growing interest in CloudKit. However, to be able to seriously consider
CloudKit for many apps there needs to be at the very least a web site representation of the data.
This allows for sharing content to users without the app installed or to users that (gasp) don't
use iOS. CloudKit has a JS library that can be used to build a web ui. After looking
around I couldn't find any good tutorials for this so I tried to figure something out on my own.
Additionally, I figured I would take the opportunity to learn about React. So this is my
first attempt at a React app using ES6 with CloudKit as the backend.

## References

### Tutorials
- [React, Flux, and ES6](https://medium.com/front-end-developers/react-and-flux-migrating-to-es6-with-babel-and-eslint-6390cf4fd878#.a0va9xxw9) good reference for es6 compatibility.
- [Flux Stores and ES6](https://medium.com/@softwarecf/flux-stores-and-es6-9b453dbf9db#.ipafweix6) ES6 compatible stores.
- [React on ES6+](https://babeljs.io/blog/2015/06/07/react-on-es6-plus) good JS / ES6 reference.
- [Basic React app on ES6](http://jmfurlott.com/tutorial-setting-up-a-simple-isomorphic-react-app/) good setup that I probably should have used.
- [React ES6 Components](http://www.tamas.io/react-with-es6/)
- [Convert ES5 to ES6](http://cheng.logdown.com/posts/2015/09/29/converting-es5-react-to-es6)
- [CloudKitJS Reference] (https://developer.apple.com/library/ios/documentation/CloudKitJS/Reference/CloudKitJavaScriptReference/index.html#//apple_ref/doc/uid/TP40015359)
- [Apple Example](https://developer.apple.com/library/ios/samplecode/CloudAtlas/Introduction/Intro.html#//apple_ref/doc/uid/TP40014599)

### Boilerplate

Boilerplate provided by https://github.com/nicksp/redux-webpack-es6-boilerplate.git and tweaked
to remove redux.  

- [webpack](http://webpack.github.io/) and [webpack-dev-server](https://webpack.github.io/docs/webpack-dev-server.html) as a client-side module builder and module loader.
- [npm](https://www.npmjs.com/) as a package manager and task runner (say [**NO**](http://blog.keithcirkel.co.uk/why-we-should-stop-using-grunt/) to gulp/grunt).
- [Babel](http://babeljs.io/) 6 as a transpiler from ES6 to ES5.
- [React](https://facebook.github.io/react/) and [JSX](https://facebook.github.io/jsx/) as a virtual Dom JavaScript library for rendering user interfaces (views).
- [ESLint](http://eslint.org/) as a reporter for syntax and style issues. [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react) for additional React specific linting rules.
- [Sass](http://sass-lang.com/) as a compiler of CSS styles with variables, mixins, and more.
- [Mocha](https://mochajs.org/) as a test framework.
- [Chai](http://chaijs.com/) as a BDD assertion library that works along with `Mocha`.

## Getting Started

### Installation

* Run Apple's CloudKit catalog [example] (https://developer.apple.com/library/ios/samplecode/CloudAtlas/Introduction/Intro.html#//apple_ref/doc/uid/TP40014599), so that this site
will have something to connect to.

```
$ git clone <repository> app-name
$ cd app-name
$ npm install
```

* Edit src/js/constants/AppConstants.js to define CloudKitJS configuration

## Development

There are two ways in which you can build and run the web app:

* Build once for (ready for ***Production***):
  * `$ npm run build`
  * Open `build/index.html` through the local webserver


* Hot reloading via webpack dev server:
  * `$ npm start`
  * Point your browser to http://localhost:3000/, page hot reloads automatically when there are changes

## Testing

To execute all unit tests, use:

```sh
npm run test
```

To run unit tests continuously during development (watch tests), use:

```sh
npm run test:watch
```

## FAQ

## TODO

- [ ] Remove 'CloudKit' not defined eslint error
- [ ] Better handle use of CloudKit js library
- [ ] Pagination of events
- [ ] Authentication

## License

[MIT](http://opensource.org/licenses/MIT)
