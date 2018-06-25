/**
 * Copyright (c) 2018-present, HuaLaiKeJi, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 */

import styles from './styles';
// import t  from 'tcomb-form-native';
import React from 'react';
import LinearGradient from 'react-native-linear-gradient';

import { View,
    TouchableHighlight,
    Text,
    ScrollView,
    StyleSheet,
    Modal,
    TouchableOpacity,
    Image,
} from 'react-native';


// 获取屏幕宽高
import {Dimensions} from 'react-native';
// var Dimensions = require('Dimensions');
var screenWidth = Dimensions.get('window').width;
var screenHeight = Dimensions.get('window').height;
var screenScale = Dimensions.get('window').scale;


class WZLightTiming extends React.Component {
    constructor() {
        super();
        this.state = {
            modalShow: false,
        }
        this._showTimingView = this._showTimingView.bind(this);
    }


    _showTimingView(isShow) {
        this.setState({
            modalShow: isShow,
        });
    }


    render() {
        return (

        <Modal
            animationType={'slide'}
            transparent={true}
            onRequestClose={() => console.log('onRequestClose...')}
            visible={this.state.modalShow}
        >
            <TouchableOpacity
                // onPress={() => this.setState({
                //     modalShow: false
                // })}
                activeOpacity={1.0}
                style={{
                    flex: 1,
                }}>

                <LinearGradient
                    colors={['#191D35ea', '#141021ef']}

                    style={{
                    // position: 'absolute',
                    // bottom: 0,
                    //     flex: 1,
                    width: screenWidth,
                    height: screenHeight,
                    // backgroundColor: 'grey',
                    // alignItems:'center',
                    //     flex: 1,
                    //     justifyContent:'space-between',
                    //
                        flexDirection: 'column-reverse',
                }} >





                    // 自定义关闭按钮
                    <TouchableOpacity
                        activeOpacity={0.5}
                        onPress={()=>
                            this.setState({
                                modalShow: false
                            })
                        }
                    >
                        <View style= {{justifyContent:'center',alignItems:'center', alignSelf:'center',width:50,height:50, marginBottom: 50}}>
                            <Image source={require('./Thumbnails/wyzev2_light_close_nor.png')}>
                            </Image>
                        </View>
                    </TouchableOpacity>


                    // 定时按钮列表
                    <View style= {{flexDirection:'row', justifyContent:'center', alignItems:'center',width:screenWidth, height:64, marginBottom: 50}}>

                        // 15min
                        <TouchableOpacity
                            activeOpacity={0.5}
                            onPress={()=>this.setState({
                                modalShow: false
                            })}
                            style= {{justifyContent:'center',alignItems:'center',width:64,height:64, margin:16}}
                        >
                            <Image source={require('./Thumbnails/wyzev2_light_15min_nor.png')}>
                            </Image>
                        </TouchableOpacity>


                        // 30min
                        <TouchableOpacity
                            activeOpacity={0.5}
                            onPress={()=>this.setState({
                                modalShow: false
                            })}
                            style= {{justifyContent:'center',alignItems:'center',width:64,height:64,margin:16}}
                        >
                            <Image source={require('./Thumbnails/wyzev2_light_30min_nor.png')}>
                            </Image>
                        </TouchableOpacity>

                        // 60min
                        <TouchableOpacity
                            activeOpacity={0.5}
                            onPress={()=>this.setState({
                                modalShow: false
                            })}
                            style= {{justifyContent:'center',alignItems:'center',width:64,height:64, margin:16}}
                        >
                            <Image source={require('./Thumbnails/wyzev2_light_60min_nor.png')}>
                            </Image>
                        </TouchableOpacity>
                    </View>

                    // 提示
                    <Text style={{alignSelf: 'center',
                        marginBottom: 55,
                        width: 220,
                        height: 50,
                        fontSize: 16,
                        lineHeight: 25,
                        textAlign:'center',
                        color: '#ffffffb7',
                    }}>Please select delay time to turn off the light</Text>

                {/*// </View>*/}
              </LinearGradient>
            </TouchableOpacity>

        </Modal>
        )
    }
}

const styles111 = StyleSheet.create({
    scene: {
        padding: 10,
        paddingTop: 74,
        flex: 1,
    },

    settingLightStateStyle: {
        padding: 10,
        paddingTop: 74,
        flex: 1,
        color: '#ffffff64',
    }
})

module.exports = WZLightTiming;
// export default ToDoEdit;
