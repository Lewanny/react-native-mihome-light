/**
 * 第一个测试文件
 * */

import React,  { Component } from 'react';
import propTypes from 'prop-types'
import {
    StyleSheet,
    Text,
    View
} from 'react-native';


export default class PropsText extends Component {
    static  defaultProps={
        name: '小白',
        age : 21,
        sex:null
    }

    static propTypes={
        name:propTypes.string,
        age:propTypes.number,
        sex:propTypes.string.isRequest,

    }


    render() {
        return <View>
            <Text style={{fontSize: 20, backgroundColor: 'red', color: 'blue'}}>姓名：{this.props.name}</Text>
            <Text style={{fontSize: 20, backgroundColor: 'red', color: 'blue'}}>年龄：{this.props.age}</Text>
            <Text style={{fontSize: 20, backgroundColor: 'red', color: 'blue'}}>性别：{this.props.sex}</Text>
        </View>
    }
}

