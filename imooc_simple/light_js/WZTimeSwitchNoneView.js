/**
 * Copyright (c) 2018-present, HuaLaiKeJi, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 */

import React from 'react';
import WZAddTimeSwitch from './WZAddTimeSwitch'
import { View,
    Text,
    StyleSheet,
    TouchableOpacity,
    AlertIOS,
    Image,
} from 'react-native';


class WZTimeSwitchNoneView extends React.Component {
    constructor() {
        super();
        // this._tipAlert = this._tipAlert.bind(this);
    }

    render() {
        return (
            <View style={styles.scene}>

                <Image
                    style={{marginTop: 115}}
                    source={require('./Thumbnails/wyzev2_light_time_switch_none.png')}>
                </Image>
                <Text style={{color:'#999999', fontSize: 16, marginTop: 52}}>You haven’t set the timing yet</Text>

                <TouchableOpacity
                    activeOpacity={0.5}
                    onPress={()=>
                        this._goToaddClick()
                    }
                    style= {{justifyContent:'center', alignItems:'center', width: 263, height:55,backgroundColor:'#04CCAB', borderRadius:55/2, marginTop: 115}}
                >
                    <Text style={{color:'#ffffff', fontSize: 18, }}>Go to add ></Text>
                </TouchableOpacity>
            </View>
        )
    }

    _goToaddClick(rowID) {


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
}
const styles = StyleSheet.create({
    scene: {
        flex: 1,
        backgroundColor: '#F7F7F7',
        flexDirection: 'column',
        justifyContent: 'flex-start',
        alignItems: 'center'
    },
})

module.exports = WZTimeSwitchNoneView;
// export default ToDoEdit;
