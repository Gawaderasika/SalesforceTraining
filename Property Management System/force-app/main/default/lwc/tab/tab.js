import {api} from 'lwc';
import Element from 'c/element';
export default class Tab extends Element {
    @api label;
    @api value;
    @api title;
    @api iconName;
    @api iconAssistiveText;
    @api showErrorIndicator= false;
    @api variant;
    @api activeTabValue;
    @api tabs;
    @api repeaterIndex;
    @api currentRecordId;
    @api records;
    handleActive(event) {
        const activeEvent = new CustomEvent('active', { detail: event.target, bubbles: true, composed: true });
        this.dispatchEvent(activeEvent);
    }
}