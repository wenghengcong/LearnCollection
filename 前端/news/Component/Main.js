
import React, {Component} from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    TabBarIOS,
    NavigatorIOS,
    Image,
    View} from 'react-native';

import Home from './Home';
import Find from './Find';
import Message from './Message';
import Mine from './Mine';

export default class Main extends Component {

    //ES6的写法
    constructor(props) {
        super(props);
        this.state = {
            selectedItem: 'home'
        };
    }

    render() {
        return (
            <TabBarIOS
                tintColor = "orange"
            >
                {/*首页*/}
                <TabBarIOS.Item
                    // 图片加载方法
                    // <Image source={require('./my-icon.png')} />
                    // <Image source={{uri: 'https://facebook.github.io/react/logo-og.png'}}
                    //     style={{width: 400, height: 400}} />

                    icon= {require('./img/tabbar_home.png')}
                    title="首页"
                    selected={this.state.selectedItem == 'home'}
                    onPress={()=>{this.setState({selectedItem: 'home'})}}
                >
                    <NavigatorIOS
                        ref='nav'
                        initialRoute={{
                            component: Home,
                            title: '首页',
                            leftButtonIcon:require('./img/navigationbar_friendattention.png'),
                            rightButtonIcon:require('./img/navigationbar_pop.png')
                        }}
                        style={{flex: 1}}
                    />
                </TabBarIOS.Item>

                {/*发现*/}
                <TabBarIOS.Item
                    icon= {require('./img/tabbar_discover.png')}
                    title="首页"
                    selected={this.state.selectedItem == 'find'}
                    onPress={()=>{this.setState({selectedItem: 'find'})}}
                >
                    <NavigatorIOS
                        ref='find'
                        initialRoute={{
                            component: Find,
                            title: '发现',
                        }}
                        style={{flex: 1}}
                    />
                </TabBarIOS.Item>

                {/*消息*/}
                <TabBarIOS.Item
                    icon= {require('./img/tabbar_message_center.png')}
                    title="消息"
                    selected={this.state.selectedItem == 'message'}
                    onPress={()=>{this.setState({selectedItem: 'message'})}}
                >
                    <NavigatorIOS
                        ref='message'
                        initialRoute={{
                            component: Home,
                            title: '消息',
                        }}
                        style={{flex: 1}}
                    />
                </TabBarIOS.Item>

                {/*我的*/}
                <TabBarIOS.Item
                    icon= {require('./img/tabbar_profile.png')}
                    title="我的"
                    selected={this.state.selectedItem == 'mine'}
                    onPress={()=>{this.setState({selectedItem: 'mine'})}}
                >
                    <NavigatorIOS
                        ref='mine'
                        initialRoute={{
                            component: Home,
                            title: '我的',
                            leftButtonTitle:'设置'
                        }}
                        style={{flex: 1}}
                    />
                </TabBarIOS.Item>
            </TabBarIOS>
        );
    }
}