/**
 * Copyright (c) 2018-present, HuaLaiKeJi, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 */

import WZSettingListView from './WZSettingListView'
import WZTimeSwitchList from './WZTimeSwitchList'
const nativeImageSource = require('nativeImageSource');

import React from 'react';
import { View,
    Text,
    StyleSheet,
    TouchableOpacity,
    AlertIOS,
} from 'react-native';


class WZAddTimeSwitch extends React.Component {
    constructor() {
        super();
        // this._tipAlert = this._tipAlert.bind(this);

        this._onTimeSwitchItemPress = this._onTimeSwitchItemPress.bind(this)
    }

    render() {
        return (
            <View style={styles111.scene}>

                <View>
                    <WZSettingListView
                        _onSettingListItemPress={this._settingListitenClick.bind(this)}
                    />
                </View>

                <TouchableOpacity
                    activeOpacity={0.5}
                    onPress={()=>
                        this._tipAlert()
                    }
                    style= {{justifyContent:'center', alignItems:'center', marginLeft: 20, marginRight:20, height:55,backgroundColor:'#ffffff', borderRadius:55/2, marginTop: 25}}
                >
                    <Text style={{color:'#F41A1A', fontSize: 18, }}>Remove Device</Text>
                </TouchableOpacity>

            </View>
        )
    }

    _settingListitenClick(rowID) {
        console.log('++++++++++++++++++  ' + rowID);

        this._onTimeSwitchItemPress();
        // Time Switch
        if (rowID==1) {
            console.log('aaaaaaaaaaaa' + this.props.navigator);

            this._onTimeSwitchItemPress();
            // this.props.navigator.push({
            //     // title: "From Right",
            //     component: WZTimeSwitchList,
            //
            //     title: 'Time Switch',
            //     barTintColor: '#FFFFFF',
            //     titleTextColor: '#000000',
            //     tintColor:  '#4B4B4B',
            //     translucent: false, // 不透明
            //
            //     leftButtonIcon: nativeImageSource({
            //         ios: 'wyzev2_light_return',
            //         width: 44,
            //         height: 44
            //     }),
            //     onLeftButtonPress:() => {this.props.navigator.pop()},
            // })
        }

        // 智能
        if (rowID==2) {

        }

        // 分享
        if (rowID==3) {

        }

        // 帮助反馈
        if (rowID==4) {

        }
    }

    _onTimeSwitchItemPress() {
        this.props.navigator.push({
            // title: "From Right",
            component: WZTimeSwitchList,

            title: 'Time Switch',
            barTintColor: '#FFFFFF',
            titleTextColor: '#000000',
            tintColor:  '#4B4B4B',
            translucent: false, // 不透明

            leftButtonIcon: nativeImageSource({
                ios: 'wyzev2_light_return',
                width: 44,
                height: 44
            }),
            onLeftButtonPress:() => {this.props.navigator.pop()},
        })
    }

    _tipAlert(){
        AlertIOS.alert('Tips', 'Do you want to remove the device?', [
            {
                text: 'Cancel',
                textColor:'#000000',
                onPress: function() {
                    console.log('取消按钮点击');
                }
            },
            {
                text: 'Remove',
                textColor:'#04CCAB',
                onPress: function() {
                    console.log('确认按钮点击');
                }

            },
        ])
    }
}
const styles111 = StyleSheet.create({
    scene: {
        flex: 1,
        backgroundColor: '#F7F7F7',
        flexDirection: 'column',
        justifyContent:'flex-start'
    },
})

module.exports = WZAddTimeSwitch;
// export default ToDoEdit;
