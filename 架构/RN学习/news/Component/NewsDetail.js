
import React, {Component} from 'react';
import {
    ListView,
    Platform,
    StyleSheet,
    Text,
    View,
    WebView
} from 'react-native';

export default class NewsDetail extends Component {
    // 初始化方法
    constructor(props) {
        super(props);
        this.state = {
            // 具体的数据
            detailData: ''
        };
    }

    render() {
        return (
            <View>
                <Text>消息详情页</Text>
            </View>
        );
    }
}