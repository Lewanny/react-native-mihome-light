/**
 * 第一个测试文件
 * */

import React,  { Component } from 'react';
import {
    StyleSheet,
    Text
} from 'react-native';


/**
 *  方式一 : ES6
 *  推荐方法
 * */
export default class HelloCompent extends Component {
    render() {
        return <Text style={{fontSize: 20, backgroundColor: 'red', color: 'blue'}}>Hello,World.{this.props.name}</Text>
    }
}

/**
 *  方式二 : ES5
 * */
// var HelloCompent=React.createClass {
//     render() {
//         return <Text style={{fontSize: 20, backgroundColor: 'red', color: 'blue'}}>Hello,World.</Text>
//     }
// }
// module.exports=HelloCompent;

/**
 *  方式三 : 函数式
 *  无状态的, 不能使用 this
 *  没有完整生命周期, 但是可以访问属性
 * */
// function HelloCompent(aa) {
//     return <Text style={{fontSize: 20, backgroundColor: 'red', color: 'blue'}}>Hello,World.{aa.name}</Text>
// }
// module.exports=HelloCompent;