
import React, {Component} from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View} from 'react-native';

export default class Mine extends Component {
    //React组件生命周期

    //构造函数，在创建组件的时候调用一次
    constructor(props, context) {
        super(props, context);

    }

    // 在组件挂载之前调用一次。如果在这个函数里面调用setState，
    // 本次的render函数可以看到更新后的state，并且只渲染一次。
    componentWillMount() {

    }
    //在组件挂载之后调用一次。这个时候，子主键也都挂载好了，可以在这里使用refs。
    componentDidMount() {

    }
    //props是父组件传递给子组件的。父组件发生render的时候子组件就会调用componentWillReceiveProps
    // 不管props有没有更新，也不管父子组件之间有没有数据交换
    componentWillReceiveProps(nextProps) {

    }
    // 组件挂载之后，每次调用setState后都会调用shouldComponentUpdate判断是否需要重新渲染组件。
    // 默认返回true，需要重新render。
    // 在比较复杂的应用里，有一些数据的改变并不影响界面展示，可以在这里做判断，优化渲染效率。
    shouldComponentUpdate(nextProps, nextState) {

    }
    // shouldComponentUpdate返回true或者调用forceUpdate之后，componentWillUpdate会被调用。
    componentWillUpdate(nextProps, nextState) {

    }

    // 除了首次render之后调用componentDidMount，其它render结束之后都是调用componentDidUpdate。
    componentDidUpdate() {

    }


    // render是一个React组件所必不可少的核心函数（上面的其它函数都不是必须的）。记住，不要在render里面修改state。
    render() {
        return (
            <View>
                <Text>我的</Text>
            </View>
        );
    }
}