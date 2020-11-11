import { LightningElement,api } from 'lwc';

export default class Header extends LightningElement {
    @api title ;
    @api subTitle;
    @api iconUrl;
    
}