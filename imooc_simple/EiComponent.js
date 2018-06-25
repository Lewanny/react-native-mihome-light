import React, { Component } from 'react'
import {
    Text,
    View
} from 'react-native'

/**
 * 导出变量/常量
 * */
var name = '小明';
var age  = '22';
export {name, age};

/**
 * 导出导入组件见 HelloCompnent.js
 * */
export default class EiCompenent extends Component {
    render(){
        return<text>a</text>
    }
}

export  function getSum(a, b, c) {
    return a+b+c
}

/**
 * 导出方法
 * */

