/* eslint-disable getter-return */
/* eslint-disable consistent-return */
/* eslint-disable no-empty */
/* eslint-disable no-useless-concat */
import { LightningElement, api, track, wire } from 'lwc';
import getObjectPrefixId from '@salesforce/apex/Engine.getObjectPrefixId';
import getObjInfo from '@salesforce/apex/Engine.getObjInfo';
import { isErrorOccur } from "c/errorHelper";
export default class Lookup extends LightningElement {
    
    @track _recordLimit;
    @track _showLabel;
    @track _minimumCharacterToSearch;
    @track _debounceDelay;
    @track isInputFieldRequired = false;
    @track isShowSearchIcon = true;
    @track isShowClearIcon = false;
    @track inputReadOnly = false;    
    @track isLookupDisabled = false;
    @track isLoading = false;
    @api selectedRecordName = '';
    @api lookupData = []; 
    @api label;   
    @api isRequired = false;
    @api dropdownHeight;
    @api placeholder;
    @api objectApiName ;
    @api fieldApiName;
    @api isDisabled;
    @api filterCondition;
    @api searchTerm = '';
    @api finalSearchTerm;
    @api searchDelayTimeout;
    @api selectedRecordId;
    @api createRecord;
    @api objName;
    @api dropdownClass = '';  
    @api isReadOnly;   
    @api isInsideClicked = false;
    @track isInvalid;

    @api get isInvalidEntry() {
      return this.isInvalid;
    }
 
    set isInvalidEntry(value) {
      if(value === 'yes') {
        this.isInvalid =  true;
        isErrorOccur[0] = true;
        }
      else {
        this.isInvalid = false;
        isErrorOccur[0] = false;
      }
    }
  
    get createNewRecord(){
      return this.createRecord;
    }
    
    @api get debounceDelay(){
      return this._debounceDelay
    } 
    set debounceDelay( value ){
      if(typeof value === 'undefined'){
        this._debounceDelay = 300;
      }
      else{
        this._debounceDelay = value;
      }
    }
    @api get minimumCharacterToSearch(){
      return this._minimumCharacterToSearch;
    }

    set minimumCharacterToSearch( value ){
      if(typeof value === 'undefined'){
        this._minimumCharacterToSearch = 2;
      }
      else{
        this._minimumCharacterToSearch = value;
      }
    }
    set showLabel (value) {
      if(value === false){
        this._showLabel = false;
      }
      else{
        this._showLabel = true;
      }
    }
    @api get showLabel(){
      return this._showLabel;
    }
    set recordLimit (value) {
      if(typeof value === 'undefined'){
        this._recordLimit = 10;
      }
      else{
        this._recordLimit = value;
      }
    }
    @api get recordLimit(){
      return this._recordLimit;
    }  
  
  renderedCallback(){
    if(this.selectedRecordName !== ''){
      this.isInvalidEntry = 'no';
      isErrorOccur[0] = false;
    }
  }
  connectedCallback() {
    this.isInsideClicked = false;
    if(this.selectedRecordName !== '') {
      this.isShowSearchIcon = false;
      this.isShowClearIcon = true;
      this.inputReadOnly = true;
    }
    if(this.isReadOnly === true) {
      this.isShowSearchIcon = false;
      this.isShowClearIcon = false;
      this.inputReadOnly = true;
    }
    if(this.isDisabled === true) {
      this.isLookupDisabled = true;
      this.isShowSearchIcon = false;
      this.isShowClearIcon = false;
    }
  }
  
  @api setDisable(){
    this.isLookupDisabled = true;
    this.isShowSearchIcon = false;
    this.isShowClearIcon = false;
  }

  @api removeDisable(){
    this.isLookupDisabled = false;
    if(this.isShowSearchIcon || !this.isShowClearIcon) 
      this.isShowSearchIcon = true;
    if(!this.isShowClearIcon)
      this.isShowClearIcon = false;
  }
  
  @api removeInvalidEntry(){
    this.isInvalidEntry = 'no';
    isErrorOccur[0] = false;
  }
  
  onSearch(event) {
    this.searchTerm = event.target.value;
    const searchTermWithoutSpace = this.searchTerm.trim().replace(/\*/g, '').toLowerCase();
    
    if (this.finalSearchTerm === searchTermWithoutSpace) {
      return;
    }

    this.finalSearchTerm = searchTermWithoutSpace;
    
    if(this.finalSearchTerm.length === 0 || this.searchTerm.length === 0) {
      this.isInvalid = false;
      
    }
    
    if(this.finalSearchTerm){
      this.createRecord = true;
    }
    
    if (this.finalSearchTerm.length >= 0) {
      const searchEvent = new CustomEvent('search', {
        detail: {
          searchText: this.finalSearchTerm,
          recordLimit: this.recordLimit,
          objectApiName: this.objectApiName,
          fieldApiName: this.fieldApiName,
          filterCondition: this.filterCondition
        }
      });

      this.isLoading = true;
      this.isShowSearchIcon = false;
      this.dispatchEvent(searchEvent);
    }
  }  
  handleClickEvent(event){
    const clickEvent = new CustomEvent('blurevent', {
      detail: {
        searchTerm : this.searchTerm
      }
    });
    this.dispatchEvent(clickEvent);
  }

  // eslint-disable-next-line no-unused-vars
  clearSelectedRecord(event) {
    this.isShowSearchIcon = true;
    this.isShowClearIcon = false;
    this.inputReadOnly = false;
    this.isInsideClicked = true;
    this.selectedRecordId = '';
    this.selectedRecordName = '';
    this.searchTerm = '';
    const onSelectionEvent= new CustomEvent('selectionchange', {
      detail: { 
        selectedRecordId : this.selectedRecordId, 
        selectedRecordName: this.selectedRecordName,
        fieldApiName : this.fieldApiName,
        operation : 'clearLookup'
      } 
    });
    this.isInvalid = false;
    this.dispatchEvent(onSelectionEvent);
  }

  onRecordSelection(event) {
    this.selectedRecordId = event.currentTarget.dataset.id;
    this.selectedRecordName = event.currentTarget.dataset.name;
    this.lookupData = []; 
    this.createRecord = false;
    this.isShowSearchIcon = false;
    this.isLoading = false;
    this.isShowClearIcon = true;
    this.inputReadOnly = true;
    const onSelectionEvent= new CustomEvent('selectionchange', {
          detail: { 
            selectedRecordId : this.selectedRecordId, 
            selectedRecordName: this.selectedRecordName,
            fieldApiName : this.fieldApiName,
            operation : 'selectLookup'            
      } 
   });
   this.dispatchEvent(onSelectionEvent);
  }
  
  get showLoader(){
    if(!this.isShowSearchIcon === false){

    return this.isLoading && this.lookupData.length === 0;
    }

  }
  get getDropdownClass() {
    let css = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ' ;
    if ((this.lookupData !== undefined && this.lookupData.length > 0) || this.createRecord) { 
      css = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
    }
    return css;
  }
  
 

  get getInputClass() {
    let css = 'slds-input slds-combobox__input slds-combobox__input-value slds-combobox__input-value '
    + (this.hasSelection() ? 'has-custom-border' : '');   
    return css;
  }

  get getInputValue(){ 
    
    return this.hasSelection() ? this.selectedRecordName : this.searchTerm;
  } 

  hasSelection() {
    return this.selectedRecordName !== '';
  }

  @api
  get getDropdownHeight() {
    let dropdown_customCSS = 0;
    if(this.dropdownHeight) {
      dropdown_customCSS = "height:" +this.dropdownHeight+ "%;";  
    }    
    return dropdown_customCSS;       
  }

  get getLookupData() {
    return this.lookupData;
  }

  @api clearDependentChildLookups(){
    this.isShowSearchIcon = true;
    this.isShowClearIcon = false;
    this.inputReadOnly = false;
    this.selectedRecordId = '';
    this.selectedRecordName = '';
    this.searchTerm = '';
  }
  
  @api setSelectedRecordName(result){
    for(let key in result) {
      if(key === 'Name') {
        this.selectedRecordName = result[key];
      }
      else{
        this.selectedRecordId = result[key];
      }
    }
    if(this.selectedRecordName !== '' || this.selectedRecordId !== undefined){
      this.isShowSearchIcon = false;
      this.isLoading = false;
      this.isShowClearIcon = true;
      this.inputReadOnly = true; 
      if(this.isReadOnly === true || this.isDisabled === true) {
        this.isShowClearIcon = false;
      }
    }
  }


  createRecordFunc() {
    getObjInfo({
      objName : this.objectApiName,
      lstFieldApiName : [this.fieldApiName]
    }).then(results => {
      let response = JSON.parse(JSON.stringify(results));
      this.objName = response[this.fieldApiName].relatedToObjectApiName;
      getObjectPrefixId({
        objName: this.objName
      }).then(results => {
        let url = window.location.origin + '/' + results + '/' + 'e?retURL=%2F00Q%2Fo';
      window.open(url, '_Blank');
      });
    });
    
  }
}