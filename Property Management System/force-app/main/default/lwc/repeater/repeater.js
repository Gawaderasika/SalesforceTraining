/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';

export default class Repeater extends LightningElement {
    @api lstLayouts = [];
    @api maxLength;
    @api addRecordTitle = 'Add Record';
    @api removeRecordTitle = 'Remove Record';
    @api get records(){
        return this.lstData;
    }
    set records( value ){
        this.lstData = value === undefined ? [] : [...[],...value];
    }

    @track lstData = [];

    connectedCallback(){
    }
    
    addrecord(){
        if( this.maxLength === undefined || this.maxLength >= this.lstData.length){
            let ob ={};
            if( this.lstData.length > 0){
                ob = {...this.lstData[0]};
                //ob = {};
            }
            else{
                ob.Name = '';
                ob.last = '';
                ob.key =  this.lstData.length;
            }
            this.lstData = [...this.lstData,...[ob]];
            const addrecord = new CustomEvent("addrecord", {
                detail: {'model': this.lstLayouts[0].childs[0].model, 'record' : ob}
            });
            this.dispatchEvent(addrecord);
        }
        else {
            //validation
        }
        
    }

    get showAddIcon (){
        return this.maxLength === undefined ? true : this.lstData.length < this.maxLength ? true : false;
    }

    get showRemoveIcon (){
        return this.lstData.length > 1 ? true : false;
    }

    removerecord( ){
        this.lstData.pop();
        const removeRecord = new CustomEvent("removerecord", {
            detail: {'model' : this.lstLayouts[0].childs[0].model}
        });
        this.dispatchEvent(removeRecord);
    }

}