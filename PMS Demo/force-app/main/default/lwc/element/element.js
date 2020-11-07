import { LightningElement,api } from 'lwc';
export default class Element extends LightningElement {
    @api componentStyle;
    @api classes;
    @api id;
    @api mode;
    @api isModelSupported;
    @api actionOnload;
    constructor(){
        super();
        this.componentStyle = '';
        this.classes = '';
        this.id = '';
        this.mode = 'view'; 
        this.isModelSupported = false;
        this.actionOnload ='';
    }
}