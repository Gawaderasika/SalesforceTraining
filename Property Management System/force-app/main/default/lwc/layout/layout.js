/* eslint-disable no-console */
import { api, track } from 'lwc';
import Element from 'c/element';

export default class Layout extends Element {
    @api layout;
    @api workprocess;
    @api unitCount;
    @api get lstLayouts(){
        return this.layoutItems;
    }
    set lstLayouts( val ){
        this.layoutItems = val;
    }
    @api currentRecordId;
    @api repeaterIndex;
    @api actions=[];
    @api records;
    @api isLoaded;
    @track layoutItems = [];
    @track showModelView = false;
    contentLayout;
    footerLayout;

    connectedCallback(){
        if(this.lstLayouts.length === 0 && this.layout){
            if(this.layout.view !== undefined){
                this.layoutItems = this.layout.view.childs;
            }
            else {
                this.contentLayout = this.layout.contentView.childs;
                this.footerLayout = this.layout.footerView.childs;
                this.showModelView = true;
            }
        }   
    }
    handleRecordUpdate( event ){
        this.dispatchEvent(new CustomEvent('recordupdate', {detail : event.detail, composed: true, bubbles: true}));
    }
   
}