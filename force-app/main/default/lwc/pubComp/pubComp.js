import { LightningElement, wire } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {fireEvent} from 'c/pubsub';

export default class pubComp extends LightningElement {
    @wire (CurrentPageReference) pageRef;
    callEvent(event){
        var eventParam={'firstname':'Rasika'};
        fireEvent(this.pageRef, 'pubsubevent', eventParam);

    }
}