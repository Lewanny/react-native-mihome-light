/**
 * Copyright (c) 2018-present, HuaLaiKeJi, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 */

'use strict';
import WZLightGlobal from "./WZLightGlobal";

var React = require('react');
var createReactClass = require('create-react-class');
var ReactNative = require('react-native');
var {
    Image,
    ListView,
    TouchableHighlight,
    StyleSheet,
    Text,
    View,
    AlertIOS,
} = ReactNative;

// 获取屏幕宽高
import {Dimensions} from 'react-native';
// var Dimensions = require('Dimensions');
var screenWidth = Dimensions.get('window').width;
var screenHeight = Dimensions.get('window').height;
var screenScale = Dimensions.get('window').scale;




var WZSettingListView = createReactClass({
    displayName: 'WZSettingListView',

    statics: {
        title: '<ListView> - Grid Layout',
        description: 'Flexbox grid layout.'
    },

    getInitialState: function() {
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        return {
            dataSource: ds.cloneWithRows(this._genRows({})),
            deviceName: 'WYZE smart light',
        };
        this.props._onSettingListItemPress = this.props._onSettingListItemPress.bind(this);
    },



    _pressData: ({}: {[key: number]: boolean}),

    UNSAFE_componentWillMount: function() {
        this._pressData = {};
        this.selIndex = 999;
    },

    render: function() {
        return (
            // ListView wraps ScrollView and so takes on its properties.
            // With that in mind you can use the ScrollView's contentContainerStyle prop to style the items.
            <ListView
                contentContainerStyle={styles.list}
                dataSource={this.state.dataSource}
                initialListSize={21}
                pageSize={3} // should be a multiple of the no. of visible cells per row
                scrollRenderAheadDistance={500}
                renderRow={this._renderRow}
                scrollEnabled={false}
            />
        );
    },


    _renderRow: function(rowData, sectionID: number, rowID: number) {
        var imgSource = rowData.imageNor;

        if (rowID == 0) {
            return (
                <TouchableHighlight onPress={() => this._pressRow(rowID)} underlayColor="transparent">
                    <View>
                        <View style={styles.row}>
                            <Text style={styles.text}>
                                {rowData.title}
                            </Text>
                            <Text style={styles.textName}>
                                {this.state.deviceName}
                            </Text>
                            <Image style={styles.thumb} source={imgSource} />
                        </View>
                    </View>
                </TouchableHighlight>
            );

        }
        return (
            <TouchableHighlight onPress={() => this._pressRow(rowID)} underlayColor="transparent">
                <View>
                    <View style={styles.row}>
                        <Text style={styles.text}>
                            {rowData.title}
                        </Text>
                        <Image style={styles.thumb} source={imgSource} />
                    </View>
                </View>
            </TouchableHighlight>
        );
    },


    _genRows: function(pressData: {[key: number]: boolean}): Array<string> {
        var dataBlob = [
            {
                title: 'Device Name',
                imageNor: require('./Thumbnails/wyzev2_arrow_icon.png'),
            },

            {
                title: 'Time Switch',
                imageNor: require('./Thumbnails/wyzev2_arrow_icon.png')
            },

            {
                title: 'Automation',
                imageNor: require('./Thumbnails/wyzev2_arrow_icon.png')
            },

            {
                title: 'Share Device',
                imageNor: require('./Thumbnails/wyzev2_arrow_icon.png')
            },

            {
                title: 'Help and Feedback',
                imageNor: require('./Thumbnails/wyzev2_arrow_icon.png')
            },
        ];
        return dataBlob;
    },

    _pressRow: function(rowID: number) {
        this.selIndex = rowID;
        this._pressData[rowID] = !this._pressData[rowID];
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows(
                this._genRows(this._pressData)
            )});

        this.props._onSettingListItemPress(rowID);
        // 重命名
        if (rowID==0){
            this._renameAlert();
            return;
        }
    },


    // _onSettingListItemPress(rowID){
    //     console.log(rowID+'dianji anniu');
    // },


    _renameAlert (){
        AlertIOS.prompt('Change Device Name', 'Please enter new device name', [
            {
                text: 'Cancel',
                onPress: function() {
                    console.log('取消按钮点击');
                }
            },
            {
                text: 'OK',

                onPress: () => {
                    this.setState({
                        deviceName: 'aaaaaa',
                    });
                    console.log('取消按钮点击');
                    // this._onChangeText('bbbbbbbbbb');
                },
            },
        ])
    },

    _onChangeText(promptValue){
        console.log("输入的内容",promptValue);
    }
});




/* eslint no-bitwise: 0 */
var hashCode = function(str) {
    var hash = 15;
    for (var ii = str.length - 1; ii >= 0; ii--) {
        hash = ((hash << 5) - hash) + str.charCodeAt(ii);
    }
    return hash;
};

var styles = StyleSheet.create({
    list: {
        justifyContent: 'space-around',
        flexDirection: 'column',
        flexWrap: 'wrap',
        alignItems: 'flex-start',
        backgroundColor: '#FFFFFF',
        marginTop: 15,
    },
    row: {
        flexDirection: 'row',
        justifyContent: 'center',
        // padding: 5,
        // margin: 3,
        width: screenWidth,
        height: 62,
        backgroundColor: 'rgba(255, 255, 255, 0.0)',
        alignItems: 'center',
        borderBottomWidth:1,
        borderBottomColor: '#E1E1E1',
        borderBottomLeftRadius: 20,
    },
    thumb: {
        width: 38,
        height: 38,
        marginRight: 11,
    },
    text: {
        flex: 1,
        // marginTop: 13,
        // fontWeight: 'bold',
        color: '#000000',
        fontSize: 14,
        marginLeft: 20,
    },

    textName: {
        textAlign: 'right',
        color: '#999999',
        fontSize: 14,
        marginRight: 0,
    },
});

module.exports = WZSettingListView;
