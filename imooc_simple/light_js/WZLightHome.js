/**
 * Copyright (c) 2018-present, HuaLaiKeJi, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 */

import styles from './styles';
import LinearGradient from 'react-native-linear-gradient';
import React from 'react';
import ToDoEdit from './WZLightSetting';
import LightStateListView from './LightStateListView';
import WZLightGlobal from './WZLightGlobal';
import WZLightTiming from './WZLightTiming'


const nativeImageSource = require('nativeImageSource');
import {
    Text,
    View,
    Button,
    Image,
    TouchableOpacity,
    NavigatorIOS, StyleSheet,
    PanResponder,
    Modal,
} from 'react-native';


// 获取屏幕宽高
import {Dimensions} from 'react-native';
// var Dimensions = require('Dimensions');
var screenWidth = Dimensions.get('window').width;
var screenHeight = Dimensions.get('window').height;
var screenScale = Dimensions.get('window').scale;


class WZLightHomeClass extends React.Component {


    constructor() {
        super();

        this.openItem = this.openItem.bind(this);

        this.state = {
            cctValue: 0.0,
            briValue: 0.0,

            cctTemp: 0.0,
            briTemp: 0.0,
            shadowColor: 'gray',

            modalShow: false,
        }
    }



    componentWillMount() {
        this._panResponder = PanResponder.create({
            onStartShouldSetPanResponder: (evt, gestureState) => {

                this.setState({
                    cctTemp: this.state.cctValue,
                    briTemp: this.state.briValue,
                });
                console.log('------------ 将要触摸');
                return true;
            },
            onMoveShouldSetPanResponder:  (evt, gestureState) => {
                console.log('------------ 将要触摸2');
                return false;
            },
            onPanResponderGrant: (evt, gestureState) => {
                console.log('------------ 开始触摸');
                // this._highlight();
            },
            onPanResponderMove: (evt, gestureState) => {

                var dy = gestureState.dy/2;
                var dx = gestureState.dx/2;

                dy = Math.round(dy);
                dx = Math.round(dx);


                console.log(`dy : ${dy}   dx : ${dx}`);

                // 这里根据绝对值判断是归于上下滑动还是左右滑动
                if (Math.abs(dy) >= Math.abs(dx))  {

                    console.log(`上下滑动`);

                    // 增加bri
                    console.log(`before : ${this.state.briValue}   before : ${this.state.cctValue}  before : ${this.state.briTemp}`);
                    if (dy>0){
                        this.setState({
                            briValue: this.state.briValue<=0?0:this.state.briTemp-dy
                        });
                    } else {
                        this.setState({
                            briValue: this.state.briValue>=100?100:this.state.briTemp-dy
                        });
                    }

                    console.log(`after : ${this.state.briValue}   after : ${this.state.cctValue}   after : ${this.state.briTemp}`);
                } else {
                    console.log(`左右滑动`);

                    if (dx>0){
                        this.setState({
                            cctValue: this.state.cctValue>=100?100:this.state.cctTemp+dx
                        });
                    } else {
                        this.setState({
                            cctValue: this.state.cctValue<=0?0:this.state.cctTemp+dx
                        });
                    }
                }



                this.updateCurrentLightState();
                console.log(`currentBri : ${this.state.briValue}   currentCCT : ${this.state.cctValue}  before : ${this.state.briTemp}`);


            },
            onPanResponderRelease: (evt, gestureState) => {
                console.log('------------ 触摸结束');
                // this._unhighlight();
            },
            onPanResponderTerminate: (evt, gestureState) => {
                console.log('------------ 触摸完成');
            },
        })
    }

    componentWillUnmount() {
    }

    _onForward = () => {
        this.props.navigator.push({
            component:ToDoEdit,
            title: '第二个场景',
        });
    }

    openItem(lightState) {
        console.log('++++++++++++++++++  ' + lightState);
    }

    lightStateBtnClick(rowID) {
        console.log('++++++++++++++++++  ' + rowID);

        // 点击了定时
        if (rowID==3) {
            console.log('点击了定时');

            // this.props.navigator.replace({
            //     component:WZLightTiming,
            //     title: '定时',
            // });


            this.refs.timingView._showTimingView(true);
            return;
        }

        var briValue = 0;
        var cctValue = 0;

        if (rowID==0){
            briValue=100;
            cctValue=100;
        } else if (rowID==1) {
            briValue=50;
            cctValue=1;
        } else {
            briValue=10;
            cctValue=1;
        }

        // 更新数据
        console.log(briValue + 'EEE'+ cctValue);
        this.state.briValue = briValue;
        this.state.cctValue = cctValue;

        console.log(briValue + 'qqc'+ cctValue);
        console.log(this.state.briValue + 'SSS'+ this.state.cctValue);

        this.updateCurrentLightState(briValue, cctValue);

    }


    // 更新颜色方法
    updateCurrentLightState(bri, cct){
        var  shadowColor = getColorWithRriCct(this.state.briValue, this.state.cctValue);
        console.log(shadowColor);
        this.setState({
            shadowColor: shadowColor,
        });

        // 通过 ref 传值更新子控件状态
        this.refs.lightView._upDateLightColor(shadowColor);
    }

    render() {
        return (

            <LinearGradient colors={['#212542', '#171227']} style={{flex: 1, justifyContent:'space-between'}}>
                <Text style={WZHomeStyles.WZHomeLightStateStyle}>BRI {this.state.briValue}%    CCT {this.state.cctValue}%</Text>

                // 用来做手势的 View
                <View style={{/*backgroundColor: this.state.shadowColor,*/width: screenWidth, flex: 2,  alignItems:'center', justifyContent:'center'}}   {...this._panResponder.panHandlers}>
                    <ImageButton
                        _lightStateChange={this.openItem.bind(this)}
                        ref = "lightView"
                    />
                </View>

                {/*flex: 2*/}

                <View style={{/*backgroundColor: 'gray',*/ marginBottom: 64, height: 120, marginLeft: 10, marginRight: 10, width: screenWidth-20}}>
                    <LightStateListView
                        _onLighStateButtonPress={this.lightStateBtnClick.bind(this)}
                    />
                </View>

                // 弹出的定时选择器 modal
                <WZLightTiming
                    ref = "timingView"
                />
            </LinearGradient>
        );
    }
}



function getColorWithRriCct(bri, cct) {

    // 分别计算 RGBA 的值
    var alphaValue = (75 + (bri * 1.5))/255;
    var redValue =  255 - cct/100*(255-239);
    var greenValue =  255 - cct/100*(255-216);
    var blueValue  =  255 - cct/100*(255-98);

    // 239,216,98
    // 255,255,255

    console.log(`red : ${redValue}   green : ${greenValue}  blue : ${blueValue}  alpha : ${alphaValue}`);

    WZLightGlobal.redValue =  redValue;
    WZLightGlobal.greenValue =  greenValue;
    WZLightGlobal.blueValue =  blueValue;
    WZLightGlobal.alaphValue = alphaValue;
    // return rgba(255, 255, 255, 0.5);

    return "rgba(" + redValue + ", " + greenValue + ", " + blueValue + ", " + alphaValue + ")";
}


function getColorRGBA(red, green, blue, alaph) {
    return "rgba(" + red + ", " + green + ", " + blue + ", " + alaph + ")";
}

function getColorRGBWitthDefaultA(red, green, blue) {
    var alaph = 0.2;
    return "rgba(" + red + ", " + green + ", " + blue + ", " + alaph + ")";
}



class ImageButton extends React.Component {


    constructor(props) {
        super(props);

        this.state = {
            shadowColor: 'white',
            shadowBorderColor: '#ffffff40',
            buttonImg: require('./Thumbnails/wyzev2_light_switch_nor.png'),
            isLighted: true,
        }

        this._onButtonPress = this._onButtonPress.bind(this);
        this._upDateLightColor = this._upDateLightColor.bind(this);
        this.props._lightStateChange = this.props._lightStateChange.bind(this);
    }

    _upDateLightColor(color) {
        var borderColor = getColorRGBWitthDefaultA(WZLightGlobal.redValue, WZLightGlobal.greenValue, WZLightGlobal.blueValue);
        this.setState ({
            shadowColor: color,
            shadowBorderColor: borderColor,
        });

    }




    _onButtonPress(parms){
        console.log(parms+'dianji anniu');

        this.setState ({
            // buttonImg: this.state.buttonImg===require('./Thumbnails/wyzev2_light_switch_nor.png')?require('./Thumbnails/wyzev2_light_switch_sel.png'):require('./Thumbnails/wyzev2_light_switch_nor.png'),
            isLighted: !this.state.isLighted,
        });

        var lightState = this.state.isLighted;
        if (lightState) {
            this.setState ({
                shadowColor: '#ffffff00',
                shadowBorderColor: '#ffffff00',
            });
        } else {
            var curLightColor = getColorRGBA(WZLightGlobal.redValue,  WZLightGlobal.greenValue,  WZLightGlobal.blueValue, WZLightGlobal.alaphValue);
            var curBorderColor = getColorRGBWitthDefaultA(WZLightGlobal.redValue, WZLightGlobal.greenValue, WZLightGlobal.blueValue);
            this.setState ({
                shadowColor: curLightColor,
                shadowBorderColor: curBorderColor,
            });
        }

        this.props._lightStateChange(lightState);
    }

    render(){
        return(

            <View style=  {{justifyContent:'center',alignItems:'center',width:150,height:150,backgroundColor:this.state.shadowBorderColor,  borderRadius:160/2,  shadowOffset: {width: 0, height: 0},
                shadowColor: this.state.shadowColor,
                shadowOpacity: 1.0,
                shadowRadius: 70,
            }}>

                <TouchableOpacity
                    activeOpacity={0.9}
                    onPress={()=>this._onButtonPress('')}
                >

                    <View style= {{justifyContent:'center',alignItems:'center',width:145,height:145,backgroundColor:this.state.shadowColor, borderRadius:145/2,
                    }}>
                        <Image source={this.state.buttonImg}>
                        </Image>
                        {/*<Text style={{color:'#ffffff'}}>{this.state.textaaaaa}</Text>*/}
                    </View>

                </TouchableOpacity>


            </View>


        );
    }

}

export default ImageButton;


const WZHomeStyles = StyleSheet.create({
    scene: {
        backgroundColor: '#ffffff',
        color: '#ffffff',
    },

    //
    // container222: {
    //     flex: 1,
    //     flexDirection: 'column',
    //     justifyContent: 'center',
    //     alignItems: 'flex-start',
    //     padding: 10,
    //     backgroundColor: '#ffffff',
    // },

    WZHomeListViewStyles: {
        padding: 10,
        paddingTop: 74,
        flex: 1,
    },

    WZHomeLightStateStyle: {
        // padding: 10,
        alignSelf: 'center',
        marginTop: 13,
        width: 180,
        height: 20,
        fontSize: 12,
        // flex: 1,
        textAlign:'center',
        color: '#ffffffa3',
        // backgroundColor: 'red'

    },

    WZHomeBtnsGbViewStyle: {
        // padding: 10,
        // alignSelf: 'center',
        marginBottom: 0,
        borderRadius: 0,
        height: 120,
        width: screenWidth,
    },
})


module.exports = WZLightHomeClass;
