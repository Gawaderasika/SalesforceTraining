import { LightningElement, wire } from 'lwc';
import {registerListener, unregisterAllListener} from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';

export default class SubComp extends LightningElement {
    @wire (CurrentPageReference) pageRef;
    connectedCallback(){
        registerListener('pubsubevent', this.handleCallback, this);
    }

    disconnectedCallback(){
        unregisterAllListener(this);
    }

    handleCallback(details){
        alert('parameter from publisher '+ detail.firstname);
    }
}