import { api } from 'lwc';
import Element from 'c/element';

export default class Multipicklist extends Element {

    @api label;
    @api options;
    @api required;
    @api sourceLabel;
    @api selectedLabel;
    @api disabled;
    @api min;
    @api max;
    @api name;
    @api value;
    @api requiredOptions;
    @api variant;
    @api size;
    @api disableReordering;
    @api fieldLevelHelp;
    @api showActivityIndicator;
    // @api validity;
    @api addButtonLabel;
    @api removeButtonLabel;
    @api upButtonLabel;
    @api downButtonLabel;
  
    handlechange(event) {
        var selectedOption = event.target.value;
        this.dispatchEvent(new CustomEvent('inputchange', { detail: selectedOption }));
    }
}