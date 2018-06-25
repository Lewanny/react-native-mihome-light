/**Create by Lewanny, on 2018/05/02*/
import Student from './Student'

export default class HongStudent extends Student{

    constructor() {
        super('小红', '女', 18);
    }

    getDescription() {
        return '哈哈哈😁'+super.getDescription();
    }

}