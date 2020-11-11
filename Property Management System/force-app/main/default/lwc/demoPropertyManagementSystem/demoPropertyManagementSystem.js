/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement, track, api, wire } from 'lwc';
import getSearchResult from '@salesforce/apex/LookupDataManager.getSearchResult';
import getObjectNameFromId from '@salesforce/apex/Engine.getObjectNameFromId';
import getBookingGridData from '@salesforce/apex/PropertyManagementSystemController.getBookingGridData';
import getAssignment from '@salesforce/apex/PropertyManagementSystemController.getAssignment';
import getServiceInterruptions from '@salesforce/apex/PropertyManagementSystemController.getServiceInterruptions';
import getCheckInCheckOutInformation from '@salesforce/apex/PropertyManagementSystemController.getCheckInCheckOutInformation';
import getOrganizationNamespace from '@salesforce/apex/PropertyManagementSystemController.getOrganizationNamespace';
import UNIT_TYPE_OBJECT from '@salesforce/schema/Unit_Type__c';
import PROPERTY_FIELD from '@salesforce/schema/Unit_Type__c.Property__c';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import PastDateSelected from '@salesforce/label/c.PastDateSelected';
import getUnitRecord from '@salesforce/apex/PropertyManagementSystemController.getUnitRecord';
import { updateRecord, getRecord, getFieldValue } from 'lightning/uiRecordApi';
import DIRTY_FIELD from '@salesforce/schema/Unit__c.Dirty__c';
import ID_FIELD from '@salesforce/schema/Unit__c.Id';
import Help_user_manual from '@salesforce/label/c.Help_user_manual';
import Checked_Out_Edit_Error from '@salesforce/label/c.Checked_Out_Edit_Error';
import PropertyNotExistError from '@salesforce/label/c.PropertyNotExistError';
import PropertySelectMessage from '@salesforce/label/c.PropertySelectMessage';
import Checked_Out_Cancel_Error from '@salesforce/label/c.Checked_Out_Cancel_Error';
import Checked_Out_CheckIn_Error from '@salesforce/label/c.Checked_Out_CheckIn_Error';
import Cancelled_Cancel_Error from '@salesforce/label/c.Cancelled_Cancel_Error';
import { CurrentPageReference } from 'lightning/navigation';
import getReservationOnfo from '@salesforce/apex/PropertyManagementSystemController.getReservationOnfo';


const menuForNewBooking = [{
    "menuItem": [{ "value": "Make Reservation", "iconName": "action:new_note", "iconSize": "xx-small", "disabled": false, "title": "Make Reservation", "type": "typeOne" },
    { "value": "Service Interruption", "iconName": "action:bug", "iconSize": "xx-small", "disabled": false, "title": "Service Interruption", "type": "typeOne" }
    ]
}];
const menuForNewUnitTypeBooking = [{ "menuItem": [{ "value": "Make Reservation", "iconName": "action:new_note", "iconSize": "xx-small", "disabled": false, "title": "Make Reservation", "type": "typeOne" }] }];


const menuForMarkDirty = [{ "menuItem": [{ "value": "Mark Dirty", "iconName": "action:new_note", "iconSize": "xx-small", "disabled": false, "title": "Mark Dirty", "type": "typeOne" }] }];

const menuForUnMarkDirty = [{ "menuItem": [{ "value": "Mark Clean", "iconName": "action:new_note", "iconSize": "xx-small", "disabled": false, "title": "Mark Clean", "type": "typeOne" }] }];


const menuForExistingBooking = [{
    "menuItem": [{ "value": "Check-Out", "iconName": "action:share", "iconSize": "xx-small", "disabled": false, "title": "Check-Out", "type": "typeOne" },
    { "value": "Change Reservation", "iconName": "action:add_relationship", "iconSize": "xx-small", "disabled": false, "title": "Change Reservation", "type": "typeOne" },
    { "value":"Change Unit","iconName":"action:edit","iconSize":"xx-small","disabled":false,"title":"Change Unit","type":"typeOne" }
    ]
}];

const menuForEarlyCheckIn = [{
    "menuItem": [{ "value": "Update Reservation", "iconName": "action:edit", "iconSize": "xx-small", "disabled": false, "title": "Update Reservation", "type": "typeOne" },
    { "value": "Cancel Reservation", "iconName": "action:remove", "iconSize": "xx-small", "disabled": false, "title": "Cancel Reservation" }
    ]
}];

//    { "value": "Change Reservation", "iconName": "action:add_relationship", "iconSize": "xx-small", "disabled": false, "title": "Change Reservation", "type": "typeOne" },

const menuForExistingBookingWithoutCheckOut = [{
    "menuItem": [{"value":"Check-In","iconName":"action:check","iconSize":"xx-small","disabled":false,"title":"Check-In","type":"typeOne"},
    { "value": "Update Reservation", "iconName": "action:edit", "iconSize": "xx-small", "disabled": false, "title": "Update Reservation", "type": "typeOne" },
    { "value": "Cancel Reservation", "iconName": "action:remove", "iconSize": "xx-small", "disabled": false, "title": "Cancel Reservation" }
    ]
}];

const menuForServiceInterruption = [
    {
        "menuItem": [
            {
                "value": "Update Service Interruption",
                "iconName": "action:edit",
                "iconSize": "xx-small",
                "disabled": false,
                "title": "Update Service Interruption",
                "type": "typeOne",
                "align": "left"
            },
            {
                "value": "Cancel Service Interruption",
                "iconName": "action:remove",
                "iconSize": "xx-small",
                "disabled": false,
                "title": "Cancel Service Interruption",
                "type": "typeOne"
            }
        ]
    }
];

export default class DemoPropertyManagementSystem extends NavigationMixin(LightningElement) {

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
    //change - 1
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
    //clicked Unit type link
    handleEntitybookingclicked(event) {
        this.isOpenModalForBokingTable = true;
        this.isOpenModal = false;
        getAssignment({
            unitTypeId: event.detail.id,
            event: 'select',
            selectDate: event.detail.selectDate.getFullYear() + '-' + (event.detail.selectDate.getMonth() + 1) + '-' + event.detail.selectDate.getDate()
        }).then(results => {
            this.showBokingTable = true;
            this.records = results;
            /*this.records.forEach(function(record){
                record.openRecordlink = window.location.origin+'/'+record.id;
            });*/
            let date = new Date(new Date().setHours(0, 0, 0, 0));
            if(event.detail.selectDate < date){
                this.tableAction = [
                    { label: 'View', name: 'View' }
                ];
            }else if(event.detail.selectDate > date){
                this.tableAction = [
                    { label: 'View', name: 'View' },
                    { label: 'Edit', name: 'Edit' },
                    { label: 'Cancel', name: 'Cancel' }
                ];
            }else{
                this.tableAction = [
                    { label: 'View', name: 'View' },
                    { label: 'Check In', name: 'Check-In' },
                    { label: 'Edit', name: 'Edit' },
                    { label: 'Cancel', name: 'Cancel' }
                ];
            }

            this.isExistingBooking = false;
        });
    }
    //clicked Unit for update
    handleExistingBookingClicked(event) {
        let ifTrueShowMenu = true;
        this.isOpenModal = false;
        this.menuPosition = 'position: fixed;left: ' + event.detail.eventDetails.clientX + 'px;top: ' + event.detail.eventDetails.clientY + 'px;';
        this.menuItem = menuForExistingBookingWithoutCheckOut
        this.isCancelReservarion = false;
        this.unitTypeReservationId = event.detail.id;
        let date = new Date();

        /*eslint-disable*/
        for (let data in this.bookingData) {
            if (this.bookingData[data].id === event.detail.id) {
                let startDate = this.getUTCDate(new Date(this.bookingData[data].startdate));
                let endDate = this.getUTCDate(new Date(this.bookingData[data].enddate));
                if (this.bookingData[data].status === "Checked Out" || endDate < date) {
                    ifTrueShowMenu = false;
                    break;
                } else {
                    if (startDate > date || endDate <= date) {
                        this.menuItem = menuForEarlyCheckIn;
                        break;
                    }
                    if (this.bookingData[data].status === "Checked In") {
                        this.menuItem = menuForExistingBooking;
                        break;
                    }
                }
            }
        }
        this.clientX = event.detail.eventDetails.clientX;
        this.clientY = event.detail.eventDetails.clientY;
        this.showPwrMenu = false;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        if(ifTrueShowMenu){
            setTimeout(() => {
                this.showPwrMenu = true;
            }, 100);
        }
    }

    getUTCDate(date){
        var newDate = new Date();
        newDate.setTime(date.getTime() + (date.getTimezoneOffset() * 60 * 1000));
        return newDate;
    }
    
    handleExistingInterruptionClicked(event) {
        this.isOpenModal = false;
        this.clientX = event.detail.eventDetails.clientX;
        this.clientY = event.detail.eventDetails.clientY;
        this.showPwrMenu = false;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setTimeout(() => {
            this.showPwrMenu = true;
        }, 100);
        let date = new Date();
        let startDate = this.getUTCDate(new Date(event.detail.startdate));
        let endDate = this.getUTCDate(new Date(event.detail.enddate));
        if (endDate > date) {
            this.menuItem = menuForServiceInterruption;
        }else{
            this.menuItem = null;
        }
        this.menuPosition = 'position: fixed;left: ' + event.detail.eventDetails.clientX + 'px;top: ' + event.detail.eventDetails.clientY + 'px;';

        this.isCancelReservarion = false;
        this.serviceInterruptionId = event.detail.id;
    }

    handleUpdateReservation(recordId, reservationAction) {
        getAssignment({
            unitTypeId: recordId,
            event: 'update',
            selectDate: null
        }).then(results => {
             if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked out' ){
                this.showNotification('', Checked_Out_Edit_Error, 'error');
                this.showlayout = false;
              }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked in' && reservationAction !== 'Change Unit' ){
                  this.showNotification('', Checked_Out_Edit_Error, 'error');
                  this.showlayout = false;
                }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='cancelled'  ){
                    this.showNotification('', Checked_Out_Edit_Error, 'error');
                    this.showlayout = false;
                  }
              else{
            this.showlayout = true;
            let record = [];
            let recordObj = {};
            if (this.namespacePrefix !== null) {
                 recordObj = {
                    "Unit_Type_Reservations": [
                        {
                            'id': results[0].unitTypeReservationId,
                            "epms__Start_Date__c": results[0].startdate,
                            "epms__End_Date__c": results[0].enddate,
                            "epms__Unit_Type__c": results[0].entitytype_id,
                            "epms__Unit__c": results[0].entitychild1_id,
                            "epms__Reservation_Member_Name__c": results[0].reservationMemberId,
                            "epms__Status__c": results[0].status,
                            "epms__Action__c": reservationAction,
                            "epms__Property__c": this.propertyId
                        }],
                    "Reservations": [{
                        'id': results[0].reservationId,
                        "epms__Reservation_Member_Name__c": results[0].reservationMemberId,
                        "epms__Reservation_Property__c": this.propertyId
                    }]
                }
                record.push(recordObj);
            }
            else {
                 recordObj = {
                    "Unit_Type_Reservations": [
                        {
                            'id': results[0].unitTypeReservationId,
                            "Start_Date__c": results[0].startdate,
                            "End_Date__c": results[0].enddate,
                            "Unit_Type__c": results[0].entitytype_id,
                            "Unit__c": results[0].entitychild1_id,
                            "Reservation_Member_Name__c": results[0].reservationMemberId,
                            "Status__c": results[0].status,
                            "Action__c": reservationAction,
                            "Property__c": this.propertyId
                        }
                    ],
                    "Reservations": [
                        {
                            'id': results[0].reservationId,
                            "Reservation_Member_Name__c": results[0].reservationMemberId,
                            "Reservation_Property__c": this.propertyId
                        }
                    ]
                }
                record.push(recordObj);
            }
            this.selectedRecord = record;
            this.isOpenModal = true;
        }

        });
    }

    handleExtendReservations(recordId) {
        getAssignment({
            unitTypeId: recordId,
            event: 'update',
            selectDate: null
        }).then(results => {
            this.showlayout = true;
            let record = [];
            let recordObj = {};
            if (this.namespacePrefix !== null) {
                recordObj = {
                    "Unit_Type_Reservations": [
                        {
                            'id': results[0].unitTypeReservationId,
                            "epms__Start_Date__c": results[0].startdate,
                            "epms__End_Date__c": results[0].enddate,
                            "epms__Unit_Type__c": results[0].entitytype_id,
                            "epms__Unit__c": results[0].entitychild1_id,
                            "epms__Reservation_Member_Name__c": results[0].reservationMemberId,
                            "epms__Action__c": 'Change Reservation'
                        }
                    ]
                }
            }
            else{
                recordObj = {
                    "Unit_Type_Reservations": [
                        {
                            'id': results[0].unitTypeReservationId,
                            "Start_Date__c": results[0].startdate,
                            "End_Date__c": results[0].enddate,
                            "Unit_Type__c": results[0].entitytype_id,
                            "Unit__c": results[0].entitychild1_id,
                            "Reservation_Member_Name__c": results[0].reservationMemberId,
                            "Action__c": 'Change Reservation'
                        }
                    ]
                }
            }

            record.push(recordObj);
            this.selectedRecord = record;
            this.isOpenModal = true;
        });
    }

    handleUpdateServiceInterruption(recordId) {
        //this.isCancelReservarion = false;
        //this.isNewBooking = false;
        getServiceInterruptions({
            propertyId: recordId,
        }).then(results => {
            let recordDetails = JSON.parse(results)[0];
            //this.isExistingBooking = true;
            this.showlayout = true;
            let record = [];
            let recordObj = {};
                if (this.namespacePrefix !== null) {
                     recordObj = {
                        "Service_Interruptions": [
                            {
                                'id': recordDetails.id,
                                "epms__Start_Date__c": recordDetails.startdate,
                                "epms__End_Date__c": recordDetails.enddate,
                                "epms__Unit__c": recordDetails.entitychild1_id,
                                "epms__Interruption_Reason__c": recordDetails.serviceInerruptionReason,
                                "epms__Property__c": recordDetails.property_id,
                                "epms__Other_Reason__c": recordDetails.otherReason,
                                "epms__Action__c": 'Update Interruption'
                            }
                        ]
                    }

                }
                else{
                     recordObj = {
                        "Service_Interruptions": [
                            {
                                'id': recordDetails.id,
                                "Start_Date__c": recordDetails.startdate,
                                "End_Date__c": recordDetails.enddate,
                                "Unit__c": recordDetails.entitychild1_id,
                                "Interruption_Reason__c": recordDetails.serviceInerruptionReason,
                                "Property__c": recordDetails.property_id,
                                "Other_Reason__c": recordDetails.otherReason,
                                "Action__c": 'Update Interruption'
                            }
                        ]
                    }
                }




                record.push(recordObj);

            this.selectedRecord = record;
            this.isOpenModal = true;

        });
    }

    //clicked New Unit for update
    handleSelectionComplete(event) {
        this.isOpenModal = false;
        if (event.detail !== '') {
            this.clientX = event.detail.eventDetails.clientX;
            this.clientY = event.detail.eventDetails.clientY;
            this.showPwrMenu = false;
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            setTimeout(() => {
                this.showPwrMenu = true;
            }, 100);
            this.menuPosition = 'position: fixed;left: ' +  event.detail.eventDetails.clientX + 'px;top: ' + event.detail.eventDetails.clientY + 'px;';
            if (event.detail.newBooking.length > 0 && event.detail.newBooking[0].entitychild1_id === '')
                this.menuItem = menuForNewUnitTypeBooking;
            else
                this.menuItem = menuForNewBooking;
            this.isCancelReservarion = false;
            this.newBooking = event.detail.newBooking;
        } else {
            this.showPwrMenu = false;
            
            this.isOpenModal = false;
            let modalClass = this.template.querySelector("[class='slds-dropdown-trigger_click slds-is-open']")

        }
    }

    handleServiceInterruption() {
        this.isOpenModal = true;
        this.showlayout = true;
        let record = [];
        let lstServiceInterruptions = [];
        for (let index = 0; index < this.newBooking.length; index++) {
            let serviceInterruptionObj = {};
            if (this.namespacePrefix !== null) {
                serviceInterruptionObj = {
                    "epms__Start_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, null),
                    "epms__End_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, this.newBooking[index].enddate),
                    "epms__Unit__c": this.newBooking[index].entitychild1_id,
                    "epms__Property__c": this.newBooking[index].propertyId,
                    "epms__Action__c": 'Make Service Interruption'
                }
            }
            else{
                serviceInterruptionObj = {
                    "Start_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, null),
                    "End_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, this.newBooking[index].enddate),
                    "Unit__c": this.newBooking[index].entitychild1_id,
                    "Property__c": this.newBooking[index].propertyId,
                    "Action__c": 'Make Service Interruption'
                }
            }
            this.unitCount = this.newBooking[index].unitCount;
            lstServiceInterruptions.push(serviceInterruptionObj);
        }
        let recordObj = {
            "Service_Interruptions": lstServiceInterruptions
        }
        record.push(recordObj);
        this.selectedRecord = record;
    }

    handleMarkDirty(event) {
       
        let ifTrueShowMenu = true;
        this.selectedCellId = event.detail.selectedCellId;
        let arr = this.selectedCellId.split('_');
        this.selUnitId = arr[1];
        this.selectedUnitId = this.selUnitId;
        this.isOpenModal = false;
        let DirtyFieldValue;
        let menu ;
       
        getUnitRecord({
            unitId: this.selUnitId
        }).then(result => {
            DirtyFieldValue = JSON.parse(JSON.stringify(result[0].dirty));
            if (DirtyFieldValue === false) {
                menu = menuForMarkDirty;
            }
            else {
                menu = menuForUnMarkDirty;
            }
           if(menu === undefined)
           {
            ifTrueShowMenu =false;
           }
            this.menuItem = menu;
            this.menuPosition = 'position: fixed;left: ' + event.detail.eventDetails.clientX + 'px;top: ' + event.detail.eventDetails.clientY + 'px;';
            this.showPwrMenu = false;
          if(ifTrueShowMenu){
            setTimeout(() => {
                this.showPwrMenu = true;
            }, 100);
            }
       }).catch(error => {

        });
    }






    handleMarkDirtyRecord(event)
    {
         let arr = this.selectedCellId.split('_');
        this.selUnitId = arr[1];
        const fields = {};
        if (this.namespacePrefix !== null) {
           fields[ID_FIELD.fieldApiName] = this.selUnitId;
           fields["epms__Dirty__c"] = true;
        }else{
           fields[ID_FIELD.fieldApiName] = this.selUnitId;
           fields[DIRTY_FIELD.fieldApiName] = true;
        }
        const recordInput = { fields };
        this.isSpinner =true;
        updateRecord(recordInput)
                .then(() => {
                    setTimeout(() => {
                        this.template.querySelector('c-booking-grid').addstyle();
                         this.isSpinner = false;
                        this.showNotification('Success', 'Successfully updated', 'success');
                    }, 500);
                   
                    
          })
                .catch(error => {
                });
             

              
            
    }

    handleCleanDirtRecord(event)
    { 
         let arr = this.selectedCellId.split('_');
        this.selUnitId = arr[1];

          const fields = {};
        if (this.namespacePrefix !== null) {
             fields[ID_FIELD.fieldApiName] = this.selUnitId;
             fields["epms__Dirty__c"] = false;
        }else{
            fields[ID_FIELD.fieldApiName] = this.selUnitId;
           fields[DIRTY_FIELD.fieldApiName] = false;
        }
        const recordInput = { fields };
        this.isSpinner =true;
        updateRecord(recordInput)
                .then(() => {
                    setTimeout(() => {
                        this.template.querySelector('c-booking-grid').removestyle();
                         this.isSpinner = false;
                         this.showNotification('Success', 'Successfully updated', 'success');
                    }, 500);
                   
                   
                })
                .catch(error => {
                    this.showNotification('Error', 'Error while saving record', 'error');
                });
               
               

    }






    handleMakeReservation() {
        this.isCancelReservarion = false;
        this.isOpenModal = true;
        this.showlayout = true;
        let record = [];
        let recordObj = {};
        let unitTypeReservations = [];
        if (this.namespacePrefix !== null) {
            for (let index = 0; index < this.newBooking.length; index++) {
                 let unitTypeReservationObj = {
                    "epms__Start_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, null),
                    "epms__End_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, this.newBooking[index].enddate),
                    "epms__Unit_Type__c": this.newBooking[index].entitytype_id,
                    "epms__Unit__c": this.newBooking[index].entitychild1_id,
                    "epms__Reservation_Member_Name__c": '',
                    "epms__Property__c": this.propertyId,
                    "epms__Action__c": 'Make Reservation'
                }
                this.unitCount = this.newBooking[index].unitCount;
                unitTypeReservations.push(unitTypeReservationObj);
            }
            recordObj = {
                "Unit_Type_Reservations": unitTypeReservations,
                "Reservations": [{
                    "epms__Reservation_Member_Name__c": '',
                    "epms__Reservation_Property__c": this.propertyId
                }]
            }
            record.push(recordObj);
        }
        else {
            for (let index = 0; index < this.newBooking.length; index++) {
                let unitTypeReservationObj = {
                   "Start_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, null),
                   "End_Date__c": this.getSalesforceFormatDate(this.newBooking[index].startdate, this.newBooking[index].enddate),
                   "Unit_Type__c": this.newBooking[index].entitytype_id,
                   "Unit__c": this.newBooking[index].entitychild1_id,
                   "Reservation_Member_Name__c": '',
                   "Property__c": this.propertyId,
                   "Action__c": 'Make Reservation'
               }
               this.unitCount = this.newBooking[index].unitCount;
               unitTypeReservations.push(unitTypeReservationObj);
           }
           recordObj = {
               "Unit_Type_Reservations": unitTypeReservations,
               "Reservations": [{
                   "Reservation_Member_Name__c": '',
                   "Reservation_Property__c": this.propertyId
               }]
           }
           record.push(recordObj);

        }
        this.selectedRecord = record;
    }

    handleCheckIn(recordId) {
        let todaysDate = this.getDate(new Date());
        getCheckInCheckOutInformation({
            unitTypeReservationsId: recordId,
        }).then(results => {
          
            if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked out' ){
                this.showNotification('', Checked_Out_CheckIn_Error, 'error');
                this.showlayout = false;
              }else if(JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked in'){
                this.showNotification('', 'Already Checked-In', 'success');
                this.showlayout = false;        
              }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='cancelled' ){
                this.showNotification('', 'You cannot check in for cancelled reservations', 'error');
                this.showlayout = false;
              }
              else{
            this.showlayout = true;
            let record = [];
            let recordObj = {};
            if (this.namespacePrefix !== null){
                 recordObj = {
                    "Assignments": [
                        {
                            'id': results[0].reservationId,
                            "epms__Check_In_Date__c": todaysDate,
                            "epms__Check_Out_Date__c": results[0].enddate,
                            "epms__Unit_Type__c": results[0].entitytype_id,
                            "epms__Unit__c": results[0].entitychild1_id,
                            "epms__Unit_Type_Reservation__c": results[0].unitTypeReservationId,
                            "epms__Action__c": 'Check In'
                        }
                    ]
                }
            }
            else{
                 recordObj = {
                    "Assignments": [
                        {
                            'id': results[0].reservationId,
                            "Check_In_Date__c": todaysDate,
                            "Check_Out_Date__c": results[0].enddate,
                            "Unit_Type__c": results[0].entitytype_id,
                            "Unit__c": results[0].entitychild1_id,
                            "Unit_Type_Reservation__c": results[0].unitTypeReservationId,
                            "Action__c": 'Check In'
                        }
                    ]
                }
            }

            record.push(recordObj);
            this.selectedRecord = record;
            this.isOpenModal = true;
        }
        });
    
    }

    handleCheckOut(recordId) {
        getCheckInCheckOutInformation({
            unitTypeReservationsId: recordId,
        }).then(results => {
            this.showlayout = true;
            let record = [];
            let recordObj = {};
            let date = new Date();
            if(this.getSalesforceFormatDate(date , null) === results[0].startdate){
                date.setDate(date.getDate() + 1);
            }
            date = this.getSalesforceFormatDate(date , null);
            if (this.namespacePrefix !== null){
                 recordObj = {
                    "Assignments": [
                        {
                            'id': results[0].reservationId,
                            "epms__Check_In_Date__c": results[0].startdate,
                            "epms__Check_Out_Date__c": date,
                            "epms__Unit_Type__c": results[0].entitytype_id,
                            "epms__Unit__c": results[0].entitychild1_id,
                            "epms__Unit_Type_Reservation__c": results[0].unitTypeReservationId,
                            "epms__Action__c": 'Check Out'
                        }
                    ]
                }
            }
            else{
                 recordObj = {
                    "Assignments": [
                        {
                            'id': results[0].reservationId,
                            "Check_In_Date__c": results[0].startdate,
                            "Check_Out_Date__c": date,
                            "Unit_Type__c": results[0].entitytype_id,
                            "Unit__c": results[0].entitychild1_id,
                            "Unit_Type_Reservation__c": results[0].unitTypeReservationId,
                            "Action__c": 'Check Out'
                        }
                    ]
                }
            }

            record.push(recordObj);
            this.selectedRecord = record;
            this.isOpenModal = true;
        });
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
    handleRowAction(event) {
        let date = new Date();
        let endDate = this.getUTCDate(new Date(event.detail.data.enddate));

        getObjectNameFromId({
            recordId: event.detail.data.id
        }).then(results => {
            this.objName = results;
            switch (event.detail.actionName) {
                case 'Check-In':
                    this.isOpenModalForBokingTable = false;
                    this.showBokingTable = false;
                    this.layoutName = 'Check_In';
                    if(this.objName === 'Reservation__c' || this.objName === 'epms__Reservation__c'){
                        getReservationOnfo({
                            resTypeId: event.detail.data.id,
                          }).then(results => {
                            if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='cancelled' ){
                                this.showNotification('', 'You cannot check in for cancelled reservations', 'error');
                                this.showlayout = false;
                              }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked in' ){
                                this.showNotification('', 'Already Checked-In', 'success');
                                this.showlayout = false;
                              }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked out' ){
                                this.showNotification('', 'You cannot check in after checked out ', 'error');
                                this.showlayout = false;
                              }else{
                                this.showNotification('', 'Please check in from respective UTRs', 'error');
                              }
                            });
                        
                    }
                  
                    
                    this.handleCheckIn(event.detail.data.id);
                    break;
                case 'Edit':
                    event.detail.id = event.detail.data.id;
                    this.isOpenModalForBokingTable = false;
                    this.showBokingTable = false;

                    if (this.objName === 'Reservation__c' || this.objName === 'epms__Reservation__c') {
                        this.showNotification('', 'You cannot edit reservation', 'error');
                    }
                    else if(endDate < date){
                       this.showNotification('', PastDateSelected, 'error');
                    }
                    else {
                        this.layoutName = 'Update_Reservations';
                        this.handleUpdateReservation(event.detail.data.id, 'Update Reservation');
                    }
                    break;
                case 'Cancel':
                    event.detail.id = event.detail.data.id;
                    this.isOpenModalForBokingTable = false;
                    this.showBokingTable = false;
                    this.resData =[];
                    if (this.objName === 'Reservation__c' || this.objName === 'epms__Reservation__c') {
                        
                        this.layoutName = 'Cancel_Reservation';
                       
                        this.handelCancelReservation(event);
                              


                    }
                    else if(endDate < date){
                        this.showNotification('', PastDateSelected, 'error');
                    }
                    else {
                        this.layoutName = 'Cancel_Unit_Type_Reservation';
                        this.handelCancelUnitTypeReservation(event);
                    }

                    break;
                case 'View':
                    let url = window.location.origin+'/'+event.detail.data.id;
                    window.open(url, '_Blank');
                    break;
                // eslint-disable-next-line no-alert
                default:
                    alert('Select Proper');
            }
        }).catch(error => {
            this.error = error;
        });
    }

    showNotification(_title,_message,_variant) {
        const evt = new ShowToastEvent({
            title: _title,
            message: _message,
            variant: _variant,
        });
        this.dispatchEvent(evt);
    }

    handelCancelUnitTypeReservation(event) {
        getAssignment({
            unitTypeId: event.detail.id,
            event: 'cancel',
            selectDate: null
        }).then(results => {
        
        if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked out' ){
            this.showNotification('', Checked_Out_Cancel_Error, 'error');
            this.showlayout = false;
          }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='checked in' ){
            this.showNotification('', Checked_Out_Cancel_Error, 'error');
            this.showlayout = false;
          }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='cancelled' ){
            this.showNotification('', Cancelled_Cancel_Error, 'error');
            this.showlayout = false;
          }
          else{
        let record = [];
        let recordObj = {};
        if (this.namespacePrefix !== null){
             recordObj = {
                "Unit_Type_Reservations": [
                    {
                        'id': event.detail.id,
                        "epms__Action__c": 'Cancel Reservation'
                    }
                ]
            }
        }
        else{
             recordObj = {
                "Unit_Type_Reservations": [
                    {
                        'id': event.detail.id,
                        "Action__c": 'Cancel Reservation'
                    }
                ]
            }
        }

        record.push(recordObj);
        this.isOpenModal = true;
        this.showlayout = true;
        this.selectedRecord = record;
     }
    });
    }

    handelCancelReservation(event){
        let record = [];
        let recordObj = {};
        getReservationOnfo({
            resTypeId: event.detail.id,
          }).then(results => {
            if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() ==='cancelled' ){
                this.showNotification('', 'Already cancelled', 'success');
                this.showlayout = false;
              }else if( JSON.parse(JSON.stringify(results[0].status)).toLowerCase() !=='active' ){
                this.showNotification('', Checked_Out_Cancel_Error, 'error');
                this.showlayout = false;
              }
               else{
        if (this.namespacePrefix !== null){
             recordObj = {
                "Reservations": [
                    {
                        'id': event.detail.id,
                        'epms__Action__c': 'Cancel Reservation'
                    }
                ]
            }
        }
        else{
             recordObj = {
                "Reservations": [
                    {
                        'id': event.detail.id,
                        'Action__c': 'Cancel Reservation'
                    }
                ]
            }
        }
       
        record.push(recordObj);
        this.isOpenModal = true;
        this.showlayout = true;
        this.selectedRecord = record;
    }
    });
    }

    handleCancelServiceInterruption(event) {
        let record = [];
        let recordObj = {};
        if (this.namespacePrefix !== null){
            recordObj = {
               "Service_Interruptions": [
                   {
                       'id': event.detail.id,
                       "epms__Action__c": 'Cancel Interruption'
                   }
               ]
           }
       }
       else{
            recordObj = {
               "Service_Interruptions": [
                   {
                       'id': event.detail.id,
                       "Action__c": 'Cancel Interruption'
                   }
               ]
           }
       }
        record.push(recordObj);
        this.isOpenModal = true;
        this.showlayout = true;
        this.selectedRecord = record;
    }



    handleMenuAction(event) {
        this.showPwrMenu = false;
        switch (event.detail) {
            case 'Update Reservation':
                this.layoutName = 'Update_Reservations';
                this.handleUpdateReservation(this.unitTypeReservationId, 'Update Reservation');
                break;
            case 'Make Reservation':
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Repeater_Make_Reservation';
                this.handleMakeReservation(event);
                break;
            case 'Service Interruption':
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Make_Service_Interruptions';
                this.handleServiceInterruption(event);
                break;
            case 'Cancel Reservation':
                event = { detail: { id: this.unitTypeReservationId } }
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Cancel_Unit_Type_Reservation';
                this.handelCancelUnitTypeReservation(event);
                break;
            case 'Check-In':
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Check_In';
                this.handleCheckIn(this.unitTypeReservationId);
                break;
            case 'Check-Out':
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Check_Out';
                this.handleCheckOut(this.unitTypeReservationId);
                break;
            case 'Change Reservation':
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Extend_Reservations';
                this.handleExtendReservations(this.unitTypeReservationId);
                break;
            case 'Update Service Interruption':
                this.layoutName = 'Update_Interruption';
                this.handleUpdateServiceInterruption(this.serviceInterruptionId);
                break;
            case 'Cancel Service Interruption':
                event = {
                     detail: {
                    id: this.serviceInterruptionId
                }
                }
                this.isOpenModalForBokingTable = false;
                this.showBokingTable = false;
                this.layoutName = 'Cancel_Interruption';
                this.handleCancelServiceInterruption(event);
                break;

            case 'Change Unit':
                this.layoutName = 'Change_Unit';
                this.handleUpdateReservation(this.unitTypeReservationId, 'Change Unit');
                break;
            // eslint-disable-next-line no-alert
            case 'Mark Dirty':
                this.handleMarkDirtyRecord(event);
                break;
            case 'Mark Clean':
                 this.handleCleanDirtRecord(event);
                 break;
            default:
                alert('Wrong Selection');
        }
    }

}