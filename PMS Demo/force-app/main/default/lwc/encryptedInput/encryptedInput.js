/* eslint-disable no-console */
import { api, track } from "lwc";
import Element from "c/element";
export default class EncryptedInput extends Element {
    @api label;
    @api name;
    @api maxLength;
    @api maskType;
    @api maskCharacter;
    @api required;
    @api readOnly;
    @api value;
    @api placeholder;
    @api messageWhenBadInput
    @api messageWhenPatternMismatch
    @api messageWhenRangeOverflow
    @api messageWhenRangeUnderflow
    @api messageWhenStepMismatch
    @api messageWhenTooShort
    @api messageWhenTooLong	
    @api messageWhenTypeMismatch
    @api messageWhenValueMissing
    @api messageToggleActive
    @api messageToggleInactive	
    @api ariaLabel
    @api ariaControls
    @api ariaLabelledBy
    @api ariaDescribedBy
    @api formatter
    @api pattern
    @api accept	
    @api minLength
    @api max
    @api min	
    @api variant	
    @api disabled
    @api validity
    @api fieldLevelHelp
    @api accessKey
    @api componentStyle;
    @api classes;
    @api id ;
    @api mode ; 
    
    @track _value;
   
    connectedCallback(){
        if( this.value !== undefined){
            this._value = this.setMaskingToValue( this.value );
        }
    }
    setMaskingToValue( val ){
        var encryptedString = '';
        switch ( this.maskType ){
            case "all" : 
                for (let k = 0; k < val.length; k++) {
                    encryptedString += this.maskCharacter;
                }
                break;
            case "lastFour" :
                if (val.length > 4) {
                    for (let k = 0; k < val.length - 4; k++) {
                        encryptedString += this.maskCharacter;
                    }
                    encryptedString += val.substr(val.length - 4);
                }
                else encryptedString += val;
                break;
            case "creditCard" : 
                if ( this.maskCharacter === "*" ){
                    encryptedString = "****-****-****-";
                }
                else if ( this.maskCharacter ==="X" ){
                    encryptedString = "XXXX-XXXX-XXXX-";
                }
                if (val.length >= 4) {
                    encryptedString += val.substr(val.length - 4);
                }
                else {
                    let maskval = 4 - val.length;
                    if (maskval > 0) {
                        for (let a = 0; a < maskval; a++) {
                            encryptedString += this.maskCharacter;
                        }
                        encryptedString += val;
                    }
                }
                break;
            case "nino" :
                if ( this.maskCharacter === "*" ) {
                    encryptedString = "** ** ** ** *";
                }
                else if ( this.maskCharacter === "X" ) {
                    encryptedString = "XX XX XX XX X";
                }
                break;
            case "ssn" : 
                if ( this.maskCharacter === "*" ) 
                    encryptedString = "***-**-";
                else if ( this.maskCharacter === "X" ) 
                    encryptedString = "XXX-XX-";
                if (val.length >= 4) {
                    encryptedString += val.substr(val.length - 4);
                } 
                else {
                    let maskval = 4 - val.length;
                    if (maskval > 0) {
                        for (let a = 0; a < maskval; a++) {
                            encryptedString +=this.maskCharacter ;
                        }
                        encryptedString += val;
                    }
                }
                break;
            case "sin" :
                if ( this.maskCharacter === "*" ){
                    encryptedString = "***-***-";
                }
                else if ( this.maskCharacter === "X" ){
                    encryptedString = "XXX-XXX-";
                }
                if (val.length >= 3) {
                    encryptedString += val.substr(val.length - 3);
                }
                else {
                    let maskval = 3 - val.length;
                    if (maskval > 0) {
                        for (let a = 0; a < maskval; a++) {
                            encryptedString += this.maskCharacter ;
                        }
                            encryptedString += val;
                    }
                }
                break;
            default :
                break;
        }
        return encryptedString;
    }
    handleChange( event ){
        this.dispatchEvent(new CustomEvent('inputchange',{detail : event.target.value}));
        this._value = event.target.value;
    }
    setMaskValue(){
        if( this._value ){
            this._value = this.setMaskingToValue( this._value );
        }
    }
}