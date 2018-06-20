/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */
import styles from './light_js/styles';
import WZLightHomeClass from './light_js/WZLightHome';
import WZLightSettingClass from './light_js/WZLightSetting';
import React from 'react';
const nativeImageSource = require('nativeImageSource');

import {
    NavigatorIOS, StyleSheet,
} from 'react-native';

class App extends React.Component {
    constructor(props) {
        super(props);

        // Be sure to add this line in the constructor, or the "this" in method _onRightButtonPress will reference to the object itself.
        this._onRightButtonPress = this._onRightButtonPress.bind(this)
    }


    _onRightButtonPress() {
        this.refs.nav.push({
            title: "From Right",
            component: WZLightSettingClass
        })
    }


    render() {
        return (
            <NavigatorIOS ref="nav"
                          style = {styles.navigator}
                          initialRoute= {{
                              component: WZLightHomeClass,

                              title: 'Wyze Smart Light',
                              barTintColor: '#212542',
                              titleTextColor: '#ffffff80',
                              tintColor:  '#ffffff47',
                              translucent: false, // 不透明


                              leftButtonIcon: nativeImageSource({
                                  ios: 'wyzev2_light_return',
                                  width: 44,
                                  height: 44
                              }),
                              onLeftButtonPress:() => {alert('左边')},

                              // title: "Navigation demo",
                              rightButtonIcon: nativeImageSource({
                                  ios: 'wyzev2_light_more',
                                  width: 44,
                                  height: 44
                              }),
                              onRightButtonPress: this._onRightButtonPress
                          }}/>
        )
    }

}


export default App;