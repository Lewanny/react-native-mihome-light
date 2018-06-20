import styles from './styles';
// import t  from 'tcomb-form-native';
import React from 'react';
import { View,
    TouchableHighlight,
    Text,
    ScrollView,
    StyleSheet,
} from 'react-native';



class WZLightSettingClass extends React.Component {
    // constructor() {
    //     super();
    //     this.openSetting = this.openSetting.bind(this);
    // }

    // render() {
    //     return (
    //         <ScrollView>
    //             <View>
    //                 <Text>Test screen</Text>
    //             </View>
    //         </ScrollView>
    //     );
    // }

    render() {
        return (
            <View style={[styles111.scene, {backgroundColor: '#FFF1E8'}]}>
                <Text seyle={styles111.settingLightStateStyle}>You came here from the NavigatorIOS right button.</Text>
            </View>
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

module.exports = WZLightSettingClass;
// export default ToDoEdit;
