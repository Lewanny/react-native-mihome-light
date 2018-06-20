/**
 * 第一个测试文件
 * */

import React,  { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image
} from 'react-native';


/**
 *  方式一 : ES6
 *  推荐方法
 * */
export default class RefText extends Component {

    constructor(props) {
        super(props);
        // 初始状态
        this.state={
            size: 80
        }
    }

    getCurrentSize(){
        return this.state.size;
    }

    render() {
       return  <View>
            <Text
                style={{fontSize: 20}}
                onPress={()=>{
                    this.setState({
                        size: this.state.size+10,
                    })
                }}
            >我打气球！！！</Text>
           <Text
               style={{fontSize: 20}}
               onPress={()=>{
                   this.setState({
                       size: this.state.size-10,
                   })
               }}
           >我放气球！！！</Text>
            // 加载网络图片或已经存在于原生目录的文件
                {/*<Image*/}
                    {/*source={{uri: 'aab'}}*/}
                {/*/>*/}
                <Image source={require('./aab.png')}
                       style={{width: this.state.size, height: this.state.size}} />
        </View>
    }
}
