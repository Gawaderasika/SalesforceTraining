/* eslint-disable no-console */
/* eslint-disable no-alert */
import { api, track } from 'lwc';
import Element from 'c/element';
const bootstrapToSldsVariant = {
    "primary" : "brand",
    "default" : "neutral",
    "success" : "success",
    "danger"  : "destructive"
}
export default class Button extends Element {
    @api name;
    @api label;
    @api value;
    @api type;
    @api get variant( ) {
        return this._variant;
    }

    set variant ( val ) {
        if( val !== undefined){
            if(bootstrapToSldsVariant.hasOwnProperty( val ) ) {
                this._variant = bootstrapToSldsVariant[ val ];
            }
            else{
                this._variant = val ;
            }
        }
        else {
            this._variant =  'neutral';
        }
    }
    @api title;
    @api iconName;
    @api iconPosition;
    @api repeaterIndex;

    
    @track _variant;
    handleClick(event){
        const buttonEvent = new CustomEvent('buttonclick', { detail: event.target, bubbles: true, composed: true })
        this.dispatchEvent(buttonEvent);
    }
}