import { LightningElement, api, track } from 'lwc';

export default class MenuItem extends LightningElement {
    @api item;
    @track showChild;
    @api type;
    @track clientX;
    @track clientY;
    connectedCallback() {
        this.showChild = false;
    }

    onClickDisplaySubMenu(event) {
            this.clientX = event.clientX;
            this.clientY = event.clientY;
            this.showChild = true;
    }

    onclickHideMenu() {
        this.showChild = false;
        this.dispatchEvent(
            new CustomEvent('itemselected', {
                detail: this.item.value, bubbles: true, composed: true
            })
        );
    }

    lostFocusHideSubMenu() {
        this.showChild = false;
    }

    get className(){
        if(this.item.disabled === true){
            return 'slds-dropdown__item disabled';
        }
        else{
            return 'slds-dropdown__item';
        }
    }
}