import { track , api } from 'lwc';
import Service from 'c/service';

export default class LayoutViewer extends Service {
    @track layout;
    @track isLayout = false;
    @track actions = [];
    @track _layoutName;
    @track _currentRecordId;
    @track isLoaded = false;
    @api unitCount;
    @api get records(){
        return this._records;
    }
    set records( val ){
        if(typeof val !== 'undefined'){
            if(Array.isArray(val) ){
                this._records = val;
            }
            else {
                this._records[0] = val;
            }
        }
    }
    @track _records = [];
    @track showLayout = false;
    @track workprocess =[];
    @api get currentRecordId(){
        return this._currentRecordId;
    }
    
    set currentRecordId( val ){
        if( val !== 'undefined') {
            this._currentRecordId = val;
            this.isData = true;
        }
        else {
            this.showLayout = this.isLayout  ? true : false;
        }
        
    }
    
    @api get layoutName (){
        return this._layoutName;
    }
    
    set layoutName( val ){
        this._layoutName = val ;
        this.fetchLayout( this._layoutName ).then( result =>{
            this.assignLayout( result );
        }).catch( error => {
            console.log( error);
        });
    }

    assignLayout( val ){
        if(val.hasOwnProperty('Layout__c')){
            this.layout = JSON.parse(val.Layout__c);
        }
        else{
            this.layout = val.layout;
        }
        if( val.hasOwnProperty('Actions__c') ){
            this.actions = JSON.parse(val.Actions__c);
        }
        else if( val.hasOwnProperty('actions')){
            this.actions = val.actions;
        }
        if( val.hasOwnProperty('Work_Processes__c') ){
            this.workprocess = JSON.parse(val.Work_Processes__c);
        }else if( val.hasOwnProperty('workProcesses')){
            this.workprocess = val.workProcesses;
        }
        this.isLayout = true;
        this.showLayout = this.isLayout && (this.isData || typeof this.currentRecordId === 'undefined') ? true : false;

    }
    connectedCallback(){
        this.isLoaded = true;
    }
    
}