import { LightningElement,api } from 'lwc';

export default class ChildVideo extends LightningElement {
    @api myName = "First name";
    @api testChildMethod(parentParam){
        alert("This is child test"+parentParam.firstname);
    }
    handleMe(){
        const childEvent=new CustomEvent('buttonclick',
            {
                detail: {
                    firstparam:'first value',
                    secondparam:'second value'
                }
            });
        this.dispatchEvent(childEvent);
    }
}