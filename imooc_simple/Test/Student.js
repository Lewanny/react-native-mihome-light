/**Create by Lewanny, on 2018/05/02*/
export default class Syudent {
    constructor(name, sex, age){
        this.name=name;
        this.age=age;
        this.sex=sex;
    }

    getDescription(){
        return '姓名:'+this.name+' 性别:'+this.sex+' 年龄:'+this.age;
    }
}

