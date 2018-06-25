/**
 * Copyright (c) 2018-present, HuaLaiKeJi, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 */

import WZTimeSwitchNoneView from './WZTimeSwitchNoneView'
import React from 'react';
import { View,
    Text,
    StyleSheet,
    TouchableOpacity,
    AlertIOS,
} from 'react-native';


class WZTimeSwitchList extends React.Component {
    constructor() {
        super();
        // this._tipAlert = this._tipAlert.bind(this);
    }

    render() {
        return (
            <View style={styles.scene}>
                <WZTimeSwitchNoneView
                />
            </View>
        )
    }

    _settingListitenClick(rowID) {
        console.log('++++++++++++++++++  ' + rowID);

        // Time Switch
        if (rowID==1) {
            // this._onTimeSwitchItemPress;
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

    // _onTimeSwitchItemPress() {
    //     this.refs.navigator.push({
    //         // title: "From Right",
    //         component: WZLightSettingClass,
    //
    //         title: 'Device Setting',
    //         barTintColor: '#FFFFFF',
    //         titleTextColor: '#000000',
    //         tintColor:  '#4B4B4B',
    //         translucent: false, // 不透明
    //
    //         leftButtonIcon: nativeImageSource({
    //             ios: 'wyzev2_light_return',
    //             width: 44,
    //             height: 44
    //         }),
    //         onLeftButtonPress:() => {this.refs.nav.pop()},
    //
    //
    //         interactivePopGestureEnabled: false,
    //     })
    // }

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
const styles= StyleSheet.create({
    scene: {
        flex: 1,
    },
})

module.exports = WZTimeSwitchList;
// export default ToDoEdit;
