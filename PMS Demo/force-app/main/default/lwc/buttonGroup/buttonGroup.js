import { track,api } from 'lwc';
import Element from 'c/element';
export default class ButtonGroup extends Element {

    @track listButton = [];
    @track listButtonMenu = [];
    constructor(){
        super();
    for(let i=0 ;i<=6;i++){
            this.listButton.push({
           //     name:'New Button'+i,
                label:'New Button'+i,
           //     value:'New Button',
           //     type:'Button',
           //     variant:'',
            //    title:'Button Title',
            //    iconName:'utility:download',
            //    iconPosition:'left'
            });
    }
    if(this.listButton.length > 5){
        this.listButtonMenu.push({
            //     name:'New Button'+i,
                 label:'New Button',
            //     value:'New Button',
            //     type:'Button',
            //     variant:'',
             //    title:'Button Title',
             //    iconName:'utility:download',
             //    iconPosition:'left'
 
             });
    }
}
}