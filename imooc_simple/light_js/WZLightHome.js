import styles from './styles';
import LinearGradient from 'react-native-linear-gradient';
import React from 'react';
import ToDoEdit from './WZLightSetting';
import ListViewGridLayoutExample from './WZLightSecondView';
const nativeImageSource = require('nativeImageSource');
import {
    Text,
    View,
    Button,
    Image,
    TouchableOpacity,
    NavigatorIOS, StyleSheet,
    PanResponder,
} from 'react-native';


// 获取屏幕宽高
import {Dimensions} from 'react-native';
// var Dimensions = require('Dimensions');
var screenWidth = Dimensions.get('window').width;
var screenHeight = Dimensions.get('window').height;
var screenScale = Dimensions.get('window').scale;


class WZLightHomeClass extends React.Component {

    componentWillMount() {
        this._panResponder = PanResponder.create({
            onStartShouldSetPanResponder: (evt, gestureState) => {
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
                console.log(`pageX : ${evt.nativeEvent.pageX}   pageY : ${evt.nativeEvent.pageY}`);
                console.log(`locationX : ${evt.nativeEvent.locationX}   locationY : ${evt.nativeEvent.locationY}`);
                console.log(`moveX : ${gestureState.moveX}   moveX : ${gestureState.moveY}`);
                // this.setState({
                //     marginLeft: evt.nativeEvent.pageX,
                //     marginTop: pageY,
                // });
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
            title: '第二个场景'
        });
    }

    openItem(state) {
        console.log('++++++++++++++++++');
    }

    render() {
        return (

            <LinearGradient colors={['#212542', '#171227']} style={{flex: 1, justifyContent:'space-between'}}>
                <Text style={WZHomeStyles.WZHomeLightStateStyle}>Bright</Text>

                // 用来做手势的 View
                <View style={{/*backgroundColor: 'cyan',*/ width: screenWidth, flex: 2,  alignItems:'center', justifyContent:'center',
                    onStartShouldSetResponderCapture: true,
                    onMoveShouldSetResponderCapture: true,
                    onMoveShouldSetPanResponderCapture: true,
                }}   {...this._panResponder.panHandlers}>
                    <ImageButton
                        onLightStateChange={() => this.openItem(state)}
                    ></ImageButton>
                </View>

                {/*flex: 2*/}

                <View style={{/*backgroundColor: 'gray',*/ marginBottom: 64, height: 120, marginLeft: 10, marginRight: 10, width: screenWidth-20}}>
                    <ListViewGridLayoutExample></ListViewGridLayoutExample>
                </View>


            </LinearGradient>
        );
    }
}


class ImageButton extends React.Component {


    constructor(props) {
        super(props);
        this._onButtonPress = this._onButtonPress.bind(this);

        this.state = {
            textaaaaa: '默认',
            buttonImg: require('./Thumbnails/wyzev2_light_switch_nor.png')
        }
    }



    _onButtonPress(aa){
        console.log(aa+'dianji anniu');

        this.setState ({
            textaaaaa: this.state.textaaaaa==='点击后'? '默认':'点击后',
            buttonImg: this.state.buttonImg===require('./Thumbnails/wyzev2_light_switch_nor.png')?require('./Thumbnails/wyzev2_light_switch_sel.png'):require('./Thumbnails/wyzev2_light_switch_nor.png')
        });

        console.log(this.state.textaaaaa);

        ()=>this.props.onLightStateChange(state);
    }

    render(){
        return(

            <View style=  {{justifyContent:'center',alignItems:'center',width:150,height:150,backgroundColor:'#ffffff40',  borderRadius:160/2,  shadowOffset: {width: 0, height: 0},
                shadowColor: 'white',
                shadowOpacity: 0.8,
                shadowRadius: 70,
                onStartShouldSetResponder: false,
                onMoveShouldSetResponder: false,
            }}>

                <TouchableOpacity
                    onPress={()=>this._onButtonPress('aaacdaf')}
                    activeOpacity={0.9}
                >

                    <View style=  {{justifyContent:'center',alignItems:'center',width:145,height:145,backgroundColor:'#ffffff', borderRadius:145/2,
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
        color: '#ffffff64',
        // backgroundColor: 'red'

    },

    WZHomeBtnsGbViewStyle: {
        // padding: 10,
        // alignSelf: 'center',
        marginBottom: 0,
        borderRadius: 0,
        height: 120,
        width: screenWidth,
        // flex: 1,
        // color: '#0000000',
        // alignSelf: 'stretch',
        // justifyContent: 'center'
        // backgroundColor: '#ffffff'
    },
})


module.exports = WZLightHomeClass;
