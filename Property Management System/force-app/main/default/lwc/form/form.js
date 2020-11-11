/* eslint-disable no-console */
import { api, track } from "lwc";
import Service from 'c/service';

export default class Form extends Service{
    
    @track lstFields = [];
    @track showFields = false;
    @track isListHaveFields = false;
    @track _record = {};
    @track tempObject = {};
    @track _currentRecordId;
    @track isRecordFetched = false;
    @track fieldInfo ;
    @track lstFieldsTODisplay = [];
    @track lstFieldApiName = [];
    @track _repeaterIndex;

    @api actionOnload ;
    @track _isLoading = false;
    @api get repeaterIndex(){
        return this._repeaterIndex;
    }
    set repeaterIndex( val ){
        this._repeaterIndex = val !== undefined ? val + 1 : val;
    }

    @api get model(){
        return this._model;
    }
    set model( val ){
        if( val !== undefined){
            this._model = val;
        }
    }
    
    @api get columnsView(){
        return this.noOfColumns;
    }
    set columnsView( val ){
        this.noOfColumns = val === undefined ? 1 : val;
    }

    @api get currentRecordId(){
        return this._currentRecordId;
    }
    
    set currentRecordId( val ){
        if( typeof val !== undefined ) {
            this._currentRecordId = val;
        }
        else {
            this.record = {};
            this.showLayout = this.isLayout  ? true : false;
        }
    }

    @api get fields(){
        return this.lstFields;
    }

    set fields( value ){
        if(  typeof value !== undefined){
            this.lstFields = value;
            this.isListHaveFields =  true ;
            for( let lstFieldIterator = 0 ; lstFieldIterator < this.lstFields.length ;  lstFieldIterator++){
                this.lstFieldApiName.push( this.lstFields[lstFieldIterator].name );
            }
            if(typeof this._currentRecordId === undefined){
                this.showFields = true;
            }
        }
        else{
            this.isListHaveFields = false;
        }
       
    }

    @api get records(){
        return this._record;
    }

    set records( value ){
        var tempValue;
        if(value !== undefined){
            if( Array.isArray(value)){
                if( value[0] !== undefined){
                    tempValue = value[0][this._model];
                }
            }
            else{
                tempValue = value;
            }
            if( Array.isArray(tempValue)){
                this._record = tempValue[0];
            }
            else{
                this._record = tempValue;
            }
        }
        else{
            this._record = {};
        }
        this.tempObject = {...this._record};
    }

    get columnView(){
        this.noOfColumns = this.noOfColumns === undefined ? 1 : this.noOfColumns;
        return 'slds-col slds-size_1-of-'+this.noOfColumns;
    }
    get formClass(){
        return "slds-grid slds-wrap slds-gutters";
    }

    get renderCondition(){
        return this.showFields && this._currentRecordId !== undefined ? this._record !== undefined ? true : false : true;
    }
    
    connectedCallback(){
        if( this._currentRecordId !== undefined && this._model !== undefined){
            this._isLoading = true;
            this.fetchRecord( this._model , this._currentRecordId);
        }
        if( this._model !== undefined && this.lstFieldApiName.length > 0){
            this._isLoading = true;
            this.fetchFieldInformation( this._model , this.lstFieldApiName);
        }
        if( this.actionOnload !== '' && this.actionOnload !== undefined){
            this.dispatchEvent( new CustomEvent('load', {
                detail:this.actionOnload      
            }));
        }
    }
    /*updtDependntFldValue(event){
        const updtdependntfldvalue = new CustomEvent('updtdependntfldvalue',{
            detail: event.detail,
            bubbles: true, composed: true
          }); 
          this.dispatchEvent(updtdependntfldvalue);
    }*/
    updateFieldValue( event ){
        let dispatchObject = {};
        let isLookupClearClick = false;
        dispatchObject.record ={};
        this.tempObject[event.target.apiName] = typeof event.detail !== "object" ? event.detail : event.detail.value;
        dispatchObject.record[event.target.apiName] = this.tempObject[event.target.apiName];
        dispatchObject.record.operation = event.detail.operation;
        //call only when clear button is pressed for lookup 
        if(typeof event.detail === 'object' && event.detail.operation !== undefined && event.detail.operation === 'clearLookup'){
            isLookupClearClick = true;
            this.clearDependentChildLookups(event, dispatchObject);
        }
        dispatchObject.model = this._repeaterIndex !== undefined ? this._model+'--Repeater--Number'+this._repeaterIndex : this._model; 
        if(isLookupClearClick && dispatchObject.record.dependentChildLookupsToClear !== undefined && dispatchObject.record.dependentChildLookupsToClear.length > 0 ){
            for(let index = 0 ; index < dispatchObject.record.dependentChildLookupsToClear.length ; index ++){
                dispatchObject.record[Object.values(dispatchObject.record.dependentChildLookupsToClear)[index]] = '';
                //dispatchObject.record[Object.values(recordInformation.parentValue.dependentChildLookupsToClear)[i]] = '';
             //   recordInformation.parentValue[Object.values(recordInformation.parentValue.dependentChildLookupsToClear)[i]] = ''; 
            }
        }
        this.dispatchEvent( new CustomEvent('updaterecord', {
            detail:dispatchObject      
        }));
    }
    clearDependentChildLookups(event, dispatchObject){
        if(dispatchObject.record[event.target.apiName] === '' && this.lstFields !== undefined && this.lstFields.length > 0){
            let childLookupFieldsToClear = [];
            for(let key = 0; key < this.lstFields.length; key++){
                if(this.lstFields[key].reference !== undefined && this.lstFields[key].reference === this._model && this.lstFields[key].referenceField === event.target.apiName){
                    childLookupFieldsToClear.push(this.lstFields[key].name);
                    childLookupFieldsToClear.push(this.lstFields[key].referenceField);
                }
            }
            if(childLookupFieldsToClear.length > 0){
                dispatchObject.record.dependentChildLookupsToClear = childLookupFieldsToClear;
            }
        }
    }
    fetchRecord( modelName , recordId  ){
        if( recordId !== undefined ){            
            let condition =  [{ fieldName:'Id',operator:'equals',valueType:'String',value:recordId}];
            this.query(modelName,condition).then( result =>{                                                                                                                                                     
                this._record = result.data[0];
                this.isRecordFetched = true;
                this.showFields = true;
                // eslint-disable-next-line @lwc/lwc/no-async-operation
                setTimeout(() => {
                    this._isLoading = false;
                }, 1000);  
            }).catch( error => console.log(error))
        }
    }

    fetchFieldInformation ( modelName , lstFieldApiName ){
        this.showFields = false;
        this.getDescribeField( modelName , lstFieldApiName).then( result =>{
            this.assignFieldSchemaToField( result );
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            setTimeout(() => {
                this._isLoading = false;
            }, 1000);  
        }).catch( error => {
            console.log( error);
        })
    }
    
    getLookupData( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition ){
        this.getLookupData( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition );
    }

    assignFieldSchemaToField( mapOfApiToSchema ){
        let fieldIterator = 0;
        let lengthOfLstField = this.lstFields.length;
        let lstFld = [];
        for( fieldIterator ; fieldIterator < lengthOfLstField ; fieldIterator ++){
            let schema = {};
            let tempObject = JSON.parse(JSON.stringify(this.lstFields[fieldIterator]));
            schema = mapOfApiToSchema[this.lstFields[fieldIterator].name];
            schema = {...this.lstFields[fieldIterator],  ...schema  };
            tempObject.fieldSchema = schema;
            lstFld.push(tempObject);
        }
        this.lstFieldsTODisplay= [...lstFld];
        this.showFields = true;
    }
}