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
} = ReactNative;

var THUMB_URLS = [
    require('./Thumbnails/wyzev2_light_btight_nor.png'),
    require('./Thumbnails/wyzev2_light_warm_nor.png'),
    require('./Thumbnails/wyzev2_light_midnight_nor.png'),
    require('./Thumbnails/wyzev2_light_delay_nor.png'),
];


var THUMB_SEL_URLS = [
    require('./Thumbnails/wyzev2_light_btight_sel.png'),
    require('./Thumbnails/wyzev2_light_warm_sel.png'),
    require('./Thumbnails/wyzev2_light_midnight_sel.png'),
    require('./Thumbnails/wyzev2_light_delay_sel.png'),
];


var TITLES_URLS = [
    'Bright',
    'Warm',
    'Midnight',
    'Delay',
];

var LightStateListView = createReactClass({
    displayName: 'LightStateListView',

    statics: {
        title: '<ListView> - Grid Layout',
        description: 'Flexbox grid layout.'
    },

    getInitialState: function() {
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        return {
            dataSource: ds.cloneWithRows(this._genRows({})),
        };
        this.props._onLighStateButtonPress = this.props._onLighStateButtonPress.bind(this);
    },

    // constructor() {
    //     var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
    //     return {
    //         dataSource: ds.cloneWithRows(this._genRows({})),
    //     };
    //
    //     this._onButtonPress = this._onButtonPress.bind(this);
    // },

    // _onLighStateButtonPress(rowID){
    //     console.log(rowID+'dianji anniu');
    // },

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
        if (this.selIndex==rowID)  {
            imgSource = THUMB_SEL_URLS[rowID];
        }
        //
        // console.log(rowData);
        // console.log(rowData.imageNor);
        // console.log(rowID);
        //

        return (
            <TouchableHighlight onPress={() => this._pressRow(rowID)} underlayColor="transparent">
                <View>
                    <View style={styles.row}>
                        <Image style={styles.thumb} source={imgSource} />
                        <Text style={styles.text}>
                            {rowData.title}
                        </Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    },


    _genRows: function(pressData: {[key: number]: boolean}): Array<string> {
        var dataBlob = [
            {
                title: 'Bright',
                imageNor: require('./Thumbnails/wyzev2_light_btight_nor.png'),
            },

            {
                title: 'Warm',
                imageNor: require('./Thumbnails/wyzev2_light_warm_nor.png')
            },

            {
                title: 'Midnight',
                imageNor: require('./Thumbnails/wyzev2_light_midnight_nor.png')
            },

            {
                title: 'Delay',
                imageNor: require('./Thumbnails/wyzev2_light_delay_nor.png')
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

        this.props._onLighStateButtonPress(rowID);
    },
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
        flexDirection: 'row',
        flexWrap: 'wrap',
        alignItems: 'flex-start',
        // backgroundColor: 'red',
    },
    row: {
        justifyContent: 'center',
        padding: 5,
        margin: 3,
        width: 70,
        height: 110,
        backgroundColor: 'rgba(255, 255, 255, 0.0)',
        alignItems: 'center',
    },
    thumb: {
        width: 64,
        height: 64
    },
    text: {
        flex: 1,
        marginTop: 13,
        // fontWeight: 'bold',
        color: '#ffffff5b',
    },
});

module.exports = LightStateListView;
