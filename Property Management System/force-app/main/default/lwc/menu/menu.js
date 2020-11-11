import { LightningElement, api, track } from 'lwc';

export default class Menu extends LightningElement {
    @api menuItem;
    @api type;
    @track menuItems;
    @api clientX;
    @api clientY;
    @track subMenu;
    @track offsetWidth;
    @track offsetHeight;
    @track classes;
    count;
  
    connectedCallback() {
        if (this.menuItem !== undefined) {
            this.menuItems = this.menuItem[0].menuItem;
            for(let item in this.menuItems){
                if(this.menuItems[item].hasOwnProperty('subType')){
                    this.subMenu = true;
                }
            }
        }
        if(this.subMenu === undefined){
            this.classes = 'slds_dropdown slds-dropdown_length-5 ';
        }
        else{
            this.classes = 'slds_dropdown ';
        }
        this.count = 0;
    }

    renderedCallback() {
        if (this.template.querySelectorAll('.slds_dropdown')[0] !== undefined && this.count === 0) {
            this.offsetWidth = this.template.querySelectorAll('.slds_dropdown')[0].getBoundingClientRect().width;
            this.offsetHeight = this.template.querySelectorAll('.slds_dropdown')[0].getBoundingClientRect().height;
            this.count++;
            if (this.clientX !== undefined) {
                this.handleMenuAlignment();
            }
            //Booking menu right click disable 
            let b =this.template.querySelector('.slds-dropdown-trigger_click.slds-is-open')
            if(b){
                b.addEventListener('contextmenu', function (e) {  
                  e.preventDefault(); 
                }, false);
       
       }
   
        }
    }

    handleMenuAlignment() {
        let screenWidth = window.innerWidth;
        let screenHeight = window.innerHeight;
        if (this.type === undefined) {
            if (this.clientX + this.offsetWidth > screenWidth) {
                this.classes = this.classes + 'slds-dropdown_right ';
            } else if (this.clientX + this.offsetWidth < screenWidth) {
                this.classes = this.classes + 'slds-dropdown_left ';
            }

            if (this.clientY + this.offsetHeight > screenHeight) {
                this.classes = this.classes + 'slds-dropdown_bottom';
            }
        } else {
            if (this.clientX + this.offsetWidth > screenWidth) {
                this.classes = this.classes + ' slds-dropdown_submenu_left ';
            } else if (this.clientX + this.offsetWidth < screenWidth) {
                this.classes = this.classes + 'slds-dropdown_submenu_right ';
            }

            if (this.clientY + this.offsetHeight > screenHeight) {
                this.classes = this.classes + 'slds-dropdown_submenu-bottom';
            }
        }
    }
}