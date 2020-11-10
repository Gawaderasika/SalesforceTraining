/* eslint-disable no-console */
import {  api, track } from 'lwc';
import Element from "c/element";



export default class Modal extends Element {
    @api isOpenModal = false;
    @api headerText ='';
    @api footerText ='';
    @api modalContent ='';
    @api conentClass = 'slds-text-heading_small slds-text-align_cente';
    @api headerClass = 'slds-text-heading_medium slds-hyphenate';
    @api footerClass = 'slds-text-heading_medium slds-hyphenate';
    @api contentStyle;
    @api headerStyle;
    @api footerStyle;
    @api showCancelButton = false;
    @track _cancelButtonStyle;

    handleOpenModal() {
        this.isOpenModal = true;
        
    }
    
    handleCloseModal() {
        let pwrLayouViewer = this.querySelectorAll('c-layout-viewer');
        if(pwrLayouViewer !== undefined && pwrLayouViewer.length > 0){
            let pwrLayout = pwrLayouViewer[0].getElementsByTagName('c-layout')
            if(pwrLayout !== undefined && pwrLayout.length > 0 ){
                let pwrLayoutItem = pwrLayout[0].getElementsByTagName('c-layout-item');
                pwrLayoutItem[0].popModal();
            }
        }
      //  pwrLayouViewer[0].getElementsByTagName('c-pwr-layout')[0].getElementsByTagName('c-pwr-layout-item')[0].popModal();
        this.isOpenModal = false;
        const modalClose = new CustomEvent("modalclose", {
            detail: false,
        });
        this.dispatchEvent(modalClose);
    }

    handleButtonStyle() {
        if( this._cancelButtonStyle !== 'undefined' ) {
            this._cancelButtonStyle = 'outline: 0';
        }       
    }

    @api
    set isShowCancelButtonStyle(value) {
        let cancelBtnHighlightingCSS = value;
        if(cancelBtnHighlightingCSS !== 'undefined' )
          this._cancelButtonStyle = cancelBtnHighlightingCSS;
        else 
          this._cancelButtonStyle = 'outline: 0';
    }

    get isShowCancelButtonStyle() {
        return this._cancelButtonStyle;
    }
}