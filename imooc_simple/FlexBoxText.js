/**
 * 第一个测试文件
 * */

import React,  { Component } from 'react';
import {
    StyleSheet,
    Text,
    View
} from 'react-native';


export default class FlexBoxText extends Component {
    render() {
        return (<View style={{alignItems:'stretch', /*justifyContent: 'space-between',*/ flexWrap:'wrap', flexDirection:'row', backgroundColor: 'darkgray', marginTop: 20, height: 500, borderTopWidth: 2, borderBottomWidth: 2, borderBottomColor: 'red', }}>
            {/*<View style={{width:40, height:40, backgroundColor: 'darkcyan', margin: 5}}>*/}
                {/*<Text style={{fontSize: 22}}>1</Text>*/}
            {/*</View>*/}

            {/*<View style={{width:40, height:40, backgroundColor: 'darkcyan', margin: 5, alignSelf:'flex-end'}}>*/}
                {/*<Text style={{fontSize: 22}}>2</Text>*/}
            {/*</View>*/}

            {/*<View style={{width:40, backgroundColor: 'darkcyan', margin: 5 }}>*/}
                {/*<Text style={{fontSize: 22}}>3</Text>*/}
            {/*</View>*/}

            {/*<View style={{width:40, height:40, backgroundColor: 'darkcyan', margin: 5, alignSelf: 'center'}}>*/}
                {/*<Text style={{fontSize: 22}}>4</Text>*/}
            {/*</View>*/}


            // flex 权重比
            <View style={{width:100, height:40, backgroundColor: 'darkcyan', margin: 5, flex: 2, paddingLeft:20, paddingRight:20}}>
                <View style={{flex:1, backgroundColor:'red', left:20}}></View>
            </View>

            <View style={{width:100, height:40, backgroundColor: 'darkcyan', margin: 5, flex: 1}}>
                <Text style={{fontSize: 22}}>2</Text>
            </View>

            <View style={{width:40, height:40, backgroundColor: 'darkcyan', margin: 50 }}>
                <Text style={{fontSize: 22}}>3</Text>
            </View>

            <View style={{width:40, height:40, backgroundColor: 'darkcyan', margin: 5}}>
                <Text style={{fontSize: 22}}>4</Text>
            </View>

        </View>)
    }
}
