import React, { Component } from 'react';
import {
    Text,
    View
} from 'react-native';

export default class LifecycleCompent extends Component {

    constructor(props) {
        super(props);
        console.log('-----constructor----');
        this.state={
            count: 0,
        }
    }

    componentWillMount() {
        console.log('-----componentWillMount----');
    }

    componentDidMount() {
        console.log('-----componentDidMount----');
    }

    componentWillReceiveProps(nextProps) {
        console.log('-----componentWillReceiveProps----');
    }

    shouldComponentUpdate(nextProps, nextState) {
        console.log('-----shouldComponentUpdate----');
        return false;
    }

    componentWillUpdate(nextProps, nextState) {
        console.log('-----componentWillUpdate----');
    }

    componentDidUpdate() {
        console.log('-----componentDidUpdate----');
    }

    componentWillUnmount() {
        console.log('-----componentWillUnmount----');
    }

    render() {
        console.log('-----render----');
        return <View>
            <Text
                style={{fontSize: 22, backgroundColor: 'gray'}}
                onPress={()=>{
                    this.setState({
                        count: this.state.count+1,
                    })
                    console.log('被打了！！！');
                }}
            >有本事来打我呀.</Text>
            <Text style={{fontSize: 25, color: 'green'}}>被打了{this.state.count}次.</Text>
        </View>
    }
}