import { LightningElement,api } from 'lwc';

export default class PageHeader extends LightningElement {
    @api title ;
    @api subTitle;
    @api iconUrl;
    
}