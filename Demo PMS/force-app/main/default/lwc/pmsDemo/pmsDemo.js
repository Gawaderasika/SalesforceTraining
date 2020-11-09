/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement, track, api, wire } from 'lwc';
import getSearchResult from '@salesforce/apex/LookupDataManager.getSearchResult';
import getObjectNameFromId from '@salesforce/apex/Engine.getObjectNameFromId';
import getBookingGridData from '@salesforce/apex/PropertyManagementSystemController.getBookingGridData';
import getAssignment from '@salesforce/apex/PropertyManagementSystemController.getAssignment';
import getOrganizationNamespace from '@salesforce/apex/PropertyManagementSystemController.getOrganizationNamespace';
import UNIT_TYPE_OBJECT from '@salesforce/schema/Unit_Type__c';
import PROPERTY_FIELD from '@salesforce/schema/Unit_Type__c.Property__c';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUnitRecord from '@salesforce/apex/PropertyManagementSystemController.getUnitRecord';
import { updateRecord, getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Unit__c.Id';
import Help_user_manual from '@salesforce/label/c.Help_user_manual';
import PropertyNotExistError from '@salesforce/label/c.PropertyNotExistError';
import PropertySelectMessage from '@salesforce/label/c.PropertySelectMessage';
import Cancelled_Cancel_Error from '@salesforce/label/c.Cancelled_Cancel_Error';
import { CurrentPageReference } from 'lightning/navigation';



export default class pmsDemo extends NavigationMixin(LightningElement) {

    unitTypeReservationId;
    selUnitId;
    serviceInterruptionId;
    newBooking;
    hideCheckboxColumn = true;
    unitCount = 0;
    @wire(CurrentPageReference) pageRef;
    @api propertyId;
    @track propertyNotExistError = PropertyNotExistError;
    @track propertySelectMessage = PropertySelectMessage;
    @track isCancelReservarion = false;
    @track lookupPropertyData = [];
    @track selectedRecord;
    @track showLabel;
    @track showDefault = true;
    @track selectedRecordName = '';
    @track label;
    @track isRequired;
    @track debounceDelay = 300;
    @track minimumCharacterToSearch = 0;
    @track dropdownHeight;
    @track placeholder = 'Enter property name';
    @track objectApiName;
    @track fieldApiName;
    @track recordLimit = 10;
    @track bookingEntities;
    @track bookingData;
    @track serviceInterruptionData;
    @track showGrid = true;
    @track logoIcon;
    @track isSpinner;
    @track isOpenModal;
    @track isOpenModalForBokingTable;
    @track _assignmentId;
    @track isNewBooking = false;
    @track isExistingBooking = false;
    @track isServiceInterruption = false;
    @track showPwrMenu = false;
    @track menuPosition;
    @track clientX;
    @track clientY;
    @track menuItem;
    @track showValidPropertyError = false;
    @track propertySelectionRequest = false;
    @track namespacePrefix;
    @track isCheckIn = false;
    @track isCheckOut = false;
    @track showlayout = false;
    @track objName;
    @track layoutName = '';
    @track disabledCondition = false;
    @track checkLookupListFlag = true;
    @track createRecord;
    @track searchTextTemp ='';
   @track  insideLookup = false;
   
    @track columns = [
    {
        'path': 'name',
        'label': 'Name',
        'type': 'text'
    },
    {
        'path': 'memberName',
        'label': 'Member Name',
        'type': 'text'
    },
    {
        'path': 'startdate',
        'label': 'Start Date',
        'type': 'Date'
    },
    {
        'path': 'enddate',
        'label': 'End Date',
        'type': 'Date'
    },
    {
        'path': 'status',
        'label': 'Status',
        'type': 'text'
    }

    ];

    @track tableAction;
    @track records;
    @track showBokingTable = false;
    @track showLookup = false;

    connectedCallback() {
        this.getNamespace();
        this.objectApiName = UNIT_TYPE_OBJECT.objectApiName;
        this.fieldApiName = PROPERTY_FIELD.fieldApiName;
        if (this.showDefault) {
            this.loadDefaultProperty();
        }
    }
    
    getNamespace() {
        getOrganizationNamespace().then(result => { this.namespacePrefix = (result !== undefined ? result === true ? 'epms__' : null : null);}).catch(error => { this.error = error; });       
    }

    handleSelect(event) {
        let record = { apiName: this.apiName, value: event.target.value };
        this.dispatchEvent(
            new CustomEvent("updatefieldvalue", {
                detail: typeof event.detail !== "object" ? event.detail : record
            })
        );
    }
    fetchBookingData(propertyId) {  
        
        if (propertyId !== undefined) {
            getBookingGridData({
                propertyId: propertyId
            }).then(result => {
                if (result !== undefined) { 
                    debugger;
                    this.bookingEntities = JSON.parse(result.jsonBookingEntities);
                    this.bookingData = JSON.parse(result.jsonBookingData);
                    this.serviceInterruptionData = JSON.parse(result.jsonServiceInterruptionBookingData);                    
                    this.template.querySelector('c-booking-grid').refreshGrid();
                }
                this.isSpinner = false;
            }).catch(error => {
                this.isSpinner = false;
                this.error = error;
            });
        }
        
    }
    loadDefaultProperty() {
        getSearchResult({
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            searchText: this.finalSearchTerm,
            numberOfRecords: this.recordLimit,
            filterCondition: this.filterCondition,
            showDefault: this.showDefault
        }).then(results => {
            this.showGrid = true;
            this.showLookup = true;
            if (results[0] !== undefined) {
                this.propertyId = results[0].recordId;
                this.selectedRecordName = results[0].recordName;
                this.fetchBookingData(this.propertyId);
            }
            return results;
        }).catch(error => {
            console.log('error on load::'+JSON.stringify(error));
        });
    }
    handleSearch(event) {
        let searchText = event.currentTarget.finalSearchTerm;
        let recordLimit = event.currentTarget.recordLimit;
        let objectApiName = event.currentTarget.objectApiName;
        let fieldApiName = event.currentTarget.fieldApiName;
        let filterCondition = event.currentTarget.filterCondition;
        let isLookupClicked = false;
        let showDefault = false;
        this.showPwrMenu = false;
        //this.insideLookup = true;
        this.searchTextTemp = searchText;
        if(searchText && searchText.length < 2) {//While searching only searchText is not geting undefined
            showDefault = true;
            this.selectedLookupOption = 'invalid';
        }else if(searchText === '' || this.selectedLookupOption === false) {//clear lookup is pressed then this.selectedLookupOption = false
            isLookupClicked = true;                                         //searchText === '' is true when typed string is cleared by backspace
               // this.checkLookupListFlag = false;   
                this.showValidPropertyError = false;
                this.propertySelectionRequest = true;    
                                     
        }
           
        if(searchText && searchText.length !== 0) {
            isLookupClicked = false; 
        } 
         if(this.showGrid ===  true && this.operationNew === 'selectLookup'){
            this.createRecord = false;
            searchText = '';
            this.selectedLookupOption = true;
        }
        this.searchTextTemp = searchText;
        this.operationNew ='inavlid';
        if(this.selectedLookupOption !== true) { // after selecting the lookup result option don't call getSearchResult as no need to show lookup results
        getSearchResult({
                objectApiName: objectApiName,
                fieldApiName: fieldApiName,
                searchText:  searchText,
                numberOfRecords: recordLimit,
                filterCondition: filterCondition,
                showDefault: showDefault,
                isLookupClicked: isLookupClicked
            }).then(results => {
                if(results !== null) {
                    this.lookupPropertyData = results.map(result => {
                        return result;
                    });
                    if(results.length > 0) {
                     } 
                    else {
                         this.showGrid = false;
                        this.lookupPropertyData = [];
                    }
                }else {
                     this.propertySelectionRequest = false;
                     this.showGrid = false;
                     this.lookupPropertyData = [];
                }
                this.createRecord = true;
            }).catch(error => {
                console.log('error::'+JSON.stringify(error));
            });
        }
      

    }
    handleSearchOnClick(event) {
        if(this.insideLookup ===false)
         this.lookupPropertyData = [];
        let searchText ;
        if(this.operationNew === 'inavlid' ){//if we double click on input field  and it contans some text
            searchText = event.currentTarget.finalSearchTerm;
        }else
        {   
         searchText = '';
      }
        let recordLimit = event.currentTarget.recordLimit;
        let objectApiName = event.currentTarget.objectApiName;
        let fieldApiName = event.currentTarget.fieldApiName;
        let filterCondition = event.currentTarget.filterCondition;
        let isLookupClicked = true;
        let showDefault = false;
        this.showPwrMenu = false; 
        this.searchTextTemp = searchText;  
        this.insideLookup = true;
        if(searchText && searchText.length< 2) {//While searching only searchText is not geting undefined
            showDefault = true;
            this.selectedLookupOption = 'invalid';
        }else if(searchText === '' || this.selectedLookupOption === false) {//clear lookup is pressed then this.selectedLookupOption = false
            isLookupClicked = true;                                         //searchText === '' is true when typed string is cleared by backspace
            //this.checkLookupListFlag = false; 
         }
        
        if(searchText && searchText.length !== 0) {//
            isLookupClicked = false; 
            this.showValidPropertyError = false;
            this.createRecord = true;
        } 
        if(this.showGrid === false && this.operationNew === 'clearLookup' &&  this.propertySelectionRequest === true)
        {
            isLookupClicked = true;
            searchText = '';
            
        }
        if(this.showGrid ===  true && this.operationNew === 'selectLookup'){//if record get selected getsearchresult method mot called
            this.createRecord = false;
            searchText = '';
            this.selectedLookupOption = true;
        }
      
        this.searchTextTemp = searchText;  
        if(this.selectedLookupOption !== true && this.propertyId==='' ) { // after selecting the lookup result option don't call getSearchResult as no need to show lookup results
        getSearchResult({
                objectApiName: objectApiName,
                fieldApiName: fieldApiName,
                searchText:  searchText,
                numberOfRecords: recordLimit,
                filterCondition: filterCondition,
                showDefault: showDefault,
                isLookupClicked: isLookupClicked
            }).then(results => {
                if(results !== null) {
                    this.lookupPropertyData = results.map(result => {
                        return result;
                    });
                    if(results.length > 0) {
                       this.createRecord = true;
                        
                    } 
                    else {
                       this.showGrid = false;
                        this.lookupPropertyData = [];
                    }
                }else {
                    //this.showValidPropertyError = true;
                    this.propertySelectionRequest = false;
                    this.showGrid = false;
                    this.lookupPropertyData = [];
                }
               
            }).catch(error => {
                console.log('error::'+JSON.stringify(error));
            });
        }
        
     
    }
    
    closeOpenedMenu(event) {
        if(this.checkLookupListFlag && this.checkLookupListFlag === true && this.lookupPropertyData !== undefined   ){
             if(this.insideLookup === false){
                this.lookupPropertyData = [];
                this.createRecord = false;
             }
           
         }else{
             this.checkLookupListFlag = true;
        }
         this.handleSearchvalue(event);
     }
    handlerefresh(){
        this.refreshGrid();
    }

    handleHelp()
    {
        window.open(Help_user_manual);
    }
    refreshGrid() {
        this.showlayout = false;
        this.showBokingTable = false;
        this.isSpinner = true;
        this.fetchBookingData(this.propertyId);
    }
    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }


    handleSearchvalue(event){
        this.insideLookup = false;
        if(this.searchTextTemp !== '' && this.propertyId === ''){
            if(this.searchTextTemp !== undefined && this.searchTextTemp.length > 0 && this.lookupPropertyData.length === 0){
                this.showValidPropertyError = true;
                this.propertySelectionRequest = false;
            }else{
                this.showValidPropertyError = false;
                this.propertySelectionRequest = true;
            }
        }
    }
    handleSelectionChange(event) {
        this.showGrid = true;
        this.propertyId = event.detail.selectedRecordId;
        let recordOperation = event.detail.operation;
        if (recordOperation === 'selectLookup') {
            this.selectedLookupOption = true;
            this.lookupPropertyData = [];
            this.propertySelectionRequest = false;
            this.showValidPropertyError = false;
            this.createRecord = false;
         } else if (recordOperation === 'clearLookup') {
            this.selectedLookupOption = false;
            this.checkLookupListFlag = false;
            this.propertySelectionRequest = true;
            this.insideLookup = false;
       }else
        {
            this.propertySelectionRequest = false;
            this.showValidPropertyError = false;
        }
        
        this.operationNew = recordOperation;
        if(this.propertyId !== '') {
            this.isSpinner = true;
            this.fetchBookingData(this.propertyId);
            this.disabledCondition = false;
            this.propertySelectionRequest = false;
            this.showValidPropertyError = false;
        }else {
            this.showGrid = false;
            this.propertySelectionRequest = true;
            this.disabledCondition = true;
        }
    }

    handleModalClose(event) {
        this.isOpenModal = false;
        this.isOpenModalForBokingTable = false;
        this.isExistingBooking = false;
        this.isNewBooking = false;
        if(event.detail !== undefined && (event.detail === false || event.detail.toLowerCase() === 'cancel' || event.detail.toLowerCase() === 'close')){ //Skip spinner for 'cancel' or 'close' action
            this.showlayout = false;
            this.showBokingTable = false;
        }else{
            this.refreshGrid();
        }
    }
    

    getSalesforceFormatDate(startDate, enddate) {
        var dateString;
        if (enddate === null) {
            let date = new Date(startDate);
            dateString = this.getDate(date);
        } else {
            if (enddate === startDate) {
                let date = new Date(enddate);
                date.setDate(date.getDate() + 1);
                let day = date.getDate();
                let month = date.getMonth() + 1;
                let year = date.getFullYear();
                dateString = year + '-' + month + '-' + day;
            } else {
                let date = new Date(enddate);
                dateString = this.getDate(date);
            }
        }
        return dateString;
    }

    getDate(date) {
        let day = date.getDate();
        if(day < 10) {
            day = '0'+ day;
        }
        let month = date.getMonth() + 1
        if(month < 10) {
            month = '0'+ month;
        }
        let year = date.getFullYear();
        return (year + '-' + month + '-' + day);
    }
    showNotification(_title,_message,_variant) {
        const evt = new ShowToastEvent({
            title: _title,
            message: _message,
            variant: _variant,
        });
        this.dispatchEvent(evt);
    }

    
}