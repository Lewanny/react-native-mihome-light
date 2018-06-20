/**
 * 第一个测试文件
 * */

import React,  { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableWithoutFeedback,
    Alert,
    TouchableHighlight
} from 'react-native';


export default class TouchableText extends Component {
    constructor(props){
        super(props);
        this.state=({
            count: 0
        })
    }


    render() {
        return <View>
            <TouchableWithoutFeedback
                onPress={()=>{
                    this.setState({
                        count: this.state.count+1
                    })
                }}

                onLongPress={()=>{
                    Alert.alert('提示', '确认删除吗', [
                        {text:'取消', onPress:()=>{}, styles: 'cancel'},
                        {text:'确定', onPress:()=>{}}
                    ])
                }}
            >

                <View style={styles.button}>
                    <Text style={styles.buttonText}>点我！我是按钮！！</Text>
                </View>
            </TouchableWithoutFeedback>
            <Text style={styles.text}>单机了:{this.state.count}次</Text>


            <TouchableHighlight
                style={styles.button}
                activeOpacity={0.5}
                underlayColor='green'
                onHideUnderlay={()=>{
                    this.setState({text:'衬底被隐藏'})
                }}
                onShowUnderlay={()=>{
                    this.setState({text:'衬底显示啊啊啊'})
                }}
                onPress={()=>{

                }}
            >
                 <View style={styles.button}>
                    <Text style={styles.buttonText}>
                        TouchableHighlight
                    </Text>
                </View>
            </TouchableHighlight>
            <Text style={styles.text}>{this.state.text}</Text>

        </View>
    }
}


const styles=StyleSheet.create({
    button:{
        borderWidth: 1,
        borderRadius: 5,
        // marginTop: 5,
        // padding: 5
    },

    buttonText: {
        fontSize: 18
    },

    text: {
        fontSize: 20
    }
})