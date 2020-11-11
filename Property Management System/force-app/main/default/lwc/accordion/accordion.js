import { api, track } from "lwc";
import Element from 'c/element';
export default class Accordion extends Element {
    @api title;
    @api activeSectionName;
    @track _openMultipleSections;
    @api repeaterIndex;
    set openMultipleSections(value) {
        this._openMultipleSections = value;
    }

    @api
    get openMultipleSections() {
        return this._openMultipleSections;
    }

    handleSectionToggle(event) {
        const lstOfOpenSections = event.detail.openSections;
        this.dispatchEvent(
        new CustomEvent("sectiontoggle", { detail: lstOfOpenSections })
        );
    }
    handleRecordUpdate(event) {
        this.dispatchEvent(
        new CustomEvent("recordupdate", { detail: event.detail, bubbles: true, composed: true })
        );
    }
}