import { api } from 'lwc';
import Element from 'c/element';
export default class Picklist extends Element {
    @api label;
    @api dropdownAlignment;
    @api placeholder;
    @api name;
    @api value;
    @api options;
    @api messageWhenValueMissing;
    @api fieldLevelHelp;
    @api variant;
    @api readonly;
    @api required;
    @api disabled;
    @api spinnerActive;
    @api validity;
    @api readOnly;
    connectedCallback() {
        if (this.placeholder === undefined)
            this.placeholder = '-Select-';
        if(this.options !== undefined)
            this.options = [{ label: '--None--', value: '', selected: true }, ...this.options ];
    }
    handleChange(event) {
        var selectedOption;
        this.value = event.detail.value;
        selectedOption = this.options.filter(val => val.value === event.target.value);
        let valueToDispatch = selectedOption[0].value === '-Select-' ? '' : selectedOption[0].value;
        this.dispatchEvent(new CustomEvent('inputchange', { detail: valueToDispatch }));
    }
    
}