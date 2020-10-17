import { LightningElement, track } from 'lwc';

export default class ParentVideo extends LightningElement {
    @track parentValue="Last name";
    handleChange(){
        this.parentValue="Full name";
    }
    handleCall(){
        var childCompVar=this.template.querySelector('c-child-video');
        var sendParam={'firstname':'Rasika'};
        childCompVar.testChildMethod(sendParam);
    }
    handleEvent(event){
        alert("custom event");
        this.parentValue="Custom Event";
        alert('first value: '+event.detail.firstparam);
        alert('second value: '+event.detail.secondparam);
    }
}