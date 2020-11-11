/* eslint-disable no-return-assign */
/* eslint-disable no-unused-expressions */
/* eslint-disable default-case */
/* eslint-disable consistent-return */
/* eslint-disable no-unused-vars */
/* eslint-disable no-shadow */
/* eslint-disable no-case-declarations */
/* eslint-disable no-console */
/* eslint-disable no-alert */
import { api, track, wire } from "lwc";
import Service from 'c/service';
import { NavigationMixin } from 'lightning/navigation';
import { updatedRecord, lstActions, lstWorkProcesses, lstModalActions, lstModalContext} from "./layoutItemHelper";
//,fieldNameToClear 
import { fireEvent, registerListener, unregisterAllListeners } from 'c/pubSubHandler';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { isErrorOccur  } from "c/errorHelper";
import Page_error from '@salesforce/label/c.Page_error';

export default class LayoutItem extends NavigationMixin(Service) {
    @api layoutItem;
    @api actions;
    @api repeaterIndex;
    @api isLoaded;
    @api unitCount;

    @api get records() {
        return this.originalRecord;
    }
    set records(val) {
        this.originalRecord = val;
    }
    @api currentRecordId;
    @api workprocess;

    @track originalRecord;
    @track modelName;
    @track isSection = false;
    @track isButton = false;
    @track isButtonGroup = false;
    @track isTab = false;
    @track isField = false;
    @track isTooltip = false;
    @track isModal = false;
    @track isPageHeader = false;
    @track isAccordion = false;
    @track isDatatable = false;
    @track hasChild = false;
    @track isTable = false;
    @track isForm = false;
    @track isCard = false;
    @track isGrid = false;
    @track isGridCell = false;
    @track isRepeater = false;
    @track objectApiName;
    @track isModalOpen = false;
    @track layoutName;
    @track repeaterRecord = [];
    @track clickResponse = true;
    @wire(CurrentPageReference) pageRef;

    deepCloneObject(objectpassed) {
        if (objectpassed === null || typeof objectpassed !== 'object') {
            return objectpassed;
        }
        let temporary = objectpassed.constructor();
        for (let key in objectpassed) {
            if (temporary[key] === undefined) {
                temporary[key] = this.deepCloneObject(objectpassed[key]);
            }
        }
        return temporary;

    }

    connectedCallback() {
        registerListener('getDependentPicklistValues', this.getDependentPicklist, this);
        if (this.actions && this.actions.length > 0) {
            lstActions[0] = this.actions;
        }
        if (this.workprocess && this.workprocess.length > 0) {
            lstWorkProcesses[0] = this.workprocess;
        }
        if (this.isLoaded !== undefined && this.isLoaded) {
            if (updatedRecord[0] !== undefined) {
                updatedRecord.length = 0;
            }
        }
        if (this.originalRecord !== undefined && this.originalRecord.length > 0 && updatedRecord.length === 0) {
            updatedRecord[0] = this.deepCloneObject(this.originalRecord[0]);
        }
        if (this.layoutItem && this.layoutItem.hasOwnProperty("childs") && this.layoutItem.childs.length > 0) {
            this.hasChild = true;
        }
        if (this.layoutItem && this.layoutItem.type) {
            switch (this.layoutItem.type.toLowerCase()) {
                case "section":
                    this.isSection = true;
                    break;
                case "accordion":
                    this.isAccordion = true;
                    break;
                case "field":
                    this.isField = true;
                    break;
                case "tab":
                    this.isTab = true;
                    break;
                case "tabs":
                    this.isTabs = true;
                    break;
                case "modal":
                    this.isModal = true;
                    break;
                case "tooltip":
                    this.isTooltip = true;
                    break;
                case "pageheader":
                    this.isPageHeader = true;
                    break;
                case "button":
                    this.isButton = true;
                    break;
                case "accordion-section":
                    this.isAccordionSection = true;
                    break;
                case "table":
                    this.isTable = true;
                    this.calledAction(this.layoutItem.onload, this);
                    break;
                case "form":
                    this.isForm = true;
                    break;
                case "card":
                    this.isCard = true;
                    break;
                case "grid":
                    this.isGrid = true;
                    break;
                case "grid-cell":
                    this.isGridCell = true;
                    break;
                case "repeater":
                    this.isRepeater = true;
                    this.records = updatedRecord[0][this.layoutItem.model];
                    break;
                default:
                    break;
            }
        }
        if (this.layoutItem.model !== undefined) {
            this.getModelDefObjectName(this.layoutItem.model).then(result => {
                if (result)
                    this.objectApiName = result.data;
            });
        }
    }

    getDependentPicklist(detail) {
        let parentValue = updatedRecord[0][detail.model][0][detail.controllingFieldApiName];
        fireEvent(this.pageRef, 'setDependentPicklistValues', parentValue);
    }

    get columnView() {
        return (this.layoutItem.largeSize !== undefined && this.layoutItem.largeSize.$numberInt !== undefined) ? 12 / this.layoutItem.largeSize.$numberInt : 1;
    }

    handleTabChange(event) {
        console.log(event.detail);
    }

    navigateToNewRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectApiName,
                actionName: 'new'
            }
        });
    }

    navigateToRecordEditPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'edit'
            }
        });
    }

    handleTableAction(event) {
        const actionName = event.detail.actionName;
        switch (actionName) {
            case 'New':
                this.navigateToNewRecordPage();
                break;
            default:
        }
    }

    buttonClick() {
        setTimeout(() => {
            if (isErrorOccur[0] === true && this.layoutItem.onclick.action.toLowerCase() !== 'cancel') {
                this.showNotification('', Page_error, 'error');
            }
            else{
                if ( this.clickResponse && Object.entries(this.layoutItem.onclick).length !== 0) {
                    for (let act = 0; act < lstActions[0].length; act++) {
                        if ((lstActions[0][act].type).toLowerCase() === (this.layoutItem.onclick.type).toLowerCase() && (lstActions[0][act].name).toLowerCase() === (this.layoutItem.onclick.action).toLowerCase()) {
                            this.clickResponse = (lstActions[0][act].type).toLowerCase() === 'workprocess' && (lstActions[0][act].workProcess).toLowerCase() === 'save' ? false : true;//Provision to restrict multiple save/update clicks and requests
                            this.calledAction(lstActions[0][act], this);
                            break;
                        }
                    }
                }
            }
        }, 500);
    }
    showNotification(_title, _message, _variant) {
        const evt = new ShowToastEvent({
            title: _title,
            message: _message,
            variant: _variant,
        });
        this.dispatchEvent(evt);
    }


    handleRowAction(event) {
        const actionName = event.detail.actionName;
        const row = event.detail.data;
        switch (actionName) {
            case 'Edit':
                this.navigateToRecordEditPage(row.Id);
                break;
            case 'Delete':
                this.recordToDelete = row;
                this.removeRecord([row], this.layoutItem.model).then(result => {
                    console.log(result);
                    this.deleteRow(row);
                });
                break;
            default:
        }
    }

    deleteRow(row) {
        const { Id } = row;
        const index = this.findRowIndexById(Id);
        if (index !== -1) {
            this.records = this.records
                .slice(0, index)
                .concat(this.records.slice(index + 1));
        }
    }

    findRowIndexById(Id) {
        let ret = -1;
        this.records.some((row, index) => {
            if (row.Id === Id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    handleRecordUpdate(event) {
        let model;
        let modelInDetail = event.detail.model;
        let instance;
        if (modelInDetail.includes('--Repeater--Number')) {
            let arr = modelInDetail.split('--Repeater--Number');
            model = arr[0];
            instance = arr[1] - 1;
        }
        else {
            model = modelInDetail;
            instance = 0;
        }
        if (updatedRecord.length === 0) {
            updatedRecord[0] = {};
        }
        if (updatedRecord[0][model] === undefined) {
            updatedRecord[0][model] = [];
        }
        if (updatedRecord[0][model][instance] === undefined) {
            updatedRecord[0][model][instance] = {};
        }
        let tempObject = {};
        if (this.currentRecordId !== undefined && updatedRecord[0][model][instance].id === undefined) {
            tempObject.Id = this.currentRecordId;
        }
        updatedRecord[0][model][instance] = { ...updatedRecord[0][model][instance], ...event.detail.record, ...tempObject };
        let recordInformation = {};
        recordInformation.parentValue = updatedRecord[0][model][instance];
        recordInformation.eventInfo = event;
        fireEvent(this.pageRef, 'updatedFieldValues', recordInformation);

    }

    executeWorkProcesses(workprocess, objModelToRecord, actionIndexToExecute = 0) {
        return new Promise((resolve, reject) => {
            this.calledAction(workprocess.actions[actionIndexToExecute], this).then(result => {
                actionIndexToExecute++;
                if (actionIndexToExecute < workprocess.actions.length) {
                    this.executeWorkProcesses(workprocess, objModelToRecord, actionIndexToExecute).then(result => {
                        resolve(result);
                    }).catch(error => {
                        if (workprocess.onError !== undefined && workprocess.onError.type !== undefined) {
                            this.calledAction(workprocess.onError, this);
                        }
                    });
                }
                else if (actionIndexToExecute === workprocess.actions.length) {
                    let action = {};
                    if (workprocess.onSuccess !== undefined && workprocess.onSuccess.type !== undefined) {
                        action = workprocess.onSuccess;
                        this.calledAction(action, this);
                    }
                }
            }).catch(error => {
                if (error.success !== undefined && !error.success && error.type !== undefined && error.message !== undefined) {
                    this.calledAction(error, this);
                }
                else if (workprocess.onError !== undefined && workprocess.onError.type !== undefined) {
                    this.calledAction(workprocess.onError, this);
                }
            });

        })
    }

    upsertRecord(recordToUpdate, model, context) {
        return new Promise(function (resolve, reject) {
            context.saveRecord(recordToUpdate, model).then(result => {
                for (let resultIterator = 0; resultIterator < result.length; resultIterator++) {
                    if (updatedRecord.length === 0) {
                        updatedRecord[0] = {};
                    }
                    if (updatedRecord[0][model] === undefined) {
                        updatedRecord[0][model] = [];
                    }
                    if (updatedRecord[0][model][resultIterator] === undefined) {
                        updatedRecord[0][model][resultIterator] = {};
                    }
                    if (updatedRecord[0][model][0] === undefined) {
                        updatedRecord[0][model][resultIterator + 1].id = result[resultIterator];
                    }
                    else {
                        let tempObj = {};
                        tempObj.id = result[resultIterator];
                        updatedRecord[0][model][resultIterator] = { ...updatedRecord[0][model][resultIterator], ...tempObj };
                    }
                    updatedRecord[0][model][resultIterator] = { ...updatedRecord[0][model][resultIterator], ...updatedRecord[0][model][resultIterator] };
                }
                //updatedRecord[0][model] = [];

                resolve(true);
            }).catch(error => {
                reject(error);
            });
        });

    }

   /* updtDependntFldValue(event){
        fieldNameToClear[0] = event.detail;
        
    }*/
    setAndAppend(action) {
        return new Promise((resolve, reject) => {
            let sourceValue;
            switch (action.sourceMappings.source.toLowerCase()) {
                case 'model':
                    let field = action.sourceMappings.field === '_id' ? 'id' : action.sourceMappings.field;
                    sourceValue = updatedRecord[0][action.sourceMappings.model][0][field];
                    break;

                default:
                    break;
            }
            switch (action.destinationMappings.source.toLowerCase()) {
                case 'model':
                    let model = action.destinationMappings.model;
                    let field = action.destinationMappings.field === '_id' ? 'id' : action.destinationMappings.field;

                    if (updatedRecord[0][model][0] === undefined) {
                        updatedRecord[0][model].shift();
                    }
                    for (let recordIterator = 0; recordIterator < updatedRecord[0][model].length; recordIterator++) {
                        updatedRecord[0][model][recordIterator][field] = sourceValue;
                    }
                    resolve(true);
                    break;


                default:

                    break;
            }
        })
    }





    calledAction(action, context) {

        return new Promise((resolve, reject) => {
            let recordToUpdate = [];
            var event;
            switch (action.type.toLowerCase()) {
                case 'redirect':
                    window.location = action.url;
                    break;

                case 'set':
                    context.setAndAppend(action).then(result => {
                        resolve(result);
                    });
                    break;

                case 'save':
                    if (Object.entries(updatedRecord[0][action.model]).length === 0) {
                        this.clickResponse = true;
                        resolve(true);
                    }
                    else {
                       /*if(fieldNameToClear[0] !== undefined){
                            for(let key in updatedRecord[0][action.model]){
                                if(updatedRecord[0][action.model][key][fieldNameToClear[0]] !== undefined){
                                    updatedRecord[0][action.model][key][fieldNameToClear[0]] = '';
                                }
                            }
                            fieldNameToClear[0] = undefined;  
                        }*/
                        recordToUpdate = [...updatedRecord[0][action.model]];
                        if (recordToUpdate[0] === undefined) {
                            recordToUpdate.shift();
                        }
                        context.upsertRecord(recordToUpdate, action.model, context).then(result => {
                            resolve(result);
                        }).catch(error => {
                            reject(error);
                        }).finally(() => {
                            this.clickResponse = true;
                        });
                    }
                    break;

                case 'workprocess':
                    for (let processIterator = 0; processIterator < lstWorkProcesses[0].length; processIterator++) {
                        if (lstWorkProcesses[0][processIterator].name === action.workProcess) {
                            context.executeWorkProcesses(lstWorkProcesses[0][processIterator], updatedRecord[0]);
                            // context.handleCalledActionForWorkprocess(lstWorkProcesses[0][processIterator], updatedRecord[0]);
                            break;
                        }
                    }
                    break;

                case 'query':
                    context.query(context.layoutItem.model, []).then(result => {
                        context.records = result.data;
                        resolve(result);
                    }).catch(error => {
                        reject(error);
                    });
                    break;

                case 'delete':
                    recordToUpdate = [...updatedRecord[0][action.model]];
                    if (recordToUpdate[0] === undefined) {
                        recordToUpdate.shift();
                    }
                    context.removeRecord(recordToUpdate, action.model, context).then(result => {
                        resolve(result);
                    }).catch(error => {
                        reject(error);
                    });
                    break;

                case 'successmessage':
                    let successMessage = action.message !== undefined ? action.message : "Record saved";
                    event = new ShowToastEvent({
                        "title": "",
                        "variant": "success",
                        "message": successMessage
                    });
                    context.dispatchEvent(event);
                    resolve(true);
                    break;

                case 'errormessage':
                    let errorMessage = action.message !== undefined ? action.message : "Error occured";
                    event = new ShowToastEvent({
                        "title": "",
                        "variant": "error",
                        "message": errorMessage
                    });
                    context.dispatchEvent(event);
                    resolve(true);
                    break;

                case 'pushmodal':
                    this.isModalOpen = true;
                    lstModalActions.push(lstActions[0]);
                    this.layoutName = action.layout;
                    lstModalContext.push(context);
                    break;
                case 'popmodal':
                    this.popModal(this.layoutItem.onclick.action);
                    break;
                default:
                    alert(action.type.toLowerCase());
                    break;
            }
        });

    }
    @api
    popModal(onClickAction) {
        lstActions.length = 0;
        if (lstModalActions.length > 0) {
            lstActions.push(lstModalActions[lstModalActions.length - 1]);
            lstModalActions.pop();
        }
        if (lstModalContext.length > 0) {
            lstModalContext.pop().isModalOpen = false;
        }
        else {
            const modalclose = new CustomEvent("modalclose", {
                detail: onClickAction.toLowerCase(),
                bubbles: true,
                composed: true
            });
            this.dispatchEvent(modalclose);
        }
    }

    handleCalledActionForWorkprocess(workprocess, records) {
        if (workprocess.actions[0].type.toLowerCase() === "save") {
            this.handleSaveUsingWorkprocess(workprocess, records, this).then(result => {
                let action = {};
                if (workprocess.onSuccess !== undefined && workprocess.onSuccess.type !== undefined) {
                    if (workprocess.onSuccess.type.toLowerCase() === "workprocess") {
                        for (let act = 0; act < lstActions[0].length; act++) {
                            if (lstActions[0][act].name === workprocess.onSuccess.action) {
                                action = lstActions[0][act];
                                break;
                            }
                        }
                    }
                    else {
                        action = workprocess.onSuccess;
                    }
                    this.calledAction(action, this);
                }
            }).catch(error => {
                if (error.success !== undefined && !error.success && error.type !== undefined && error.message !== undefined) {
                    this.calledAction(error, this);
                }
                else if (workprocess.onError !== undefined && workprocess.onError.type !== undefined) {
                    this.calledAction(workprocess.onError, this);
                }
            });
        }
        else {
            this.executeWorkProcesses(workprocess, updatedRecord[0]);
        }
    }

    handleSaveUsingWorkprocess(workprocess, records, context) {
        return new Promise(function (resolve, reject) {
            /*eslint-disable*/
            let arrayOfActions = [];
            let arrayOfRecords = [];
            let recordToProcess = [];
            for (let index in workprocess.actions) {
                arrayOfActions.push(workprocess.actions[index]);
            }
            recordToProcess = Object.entries(records);
            for (let key in recordToProcess) {
                let object = {};
                let modal;
                for (let index in recordToProcess[key]) {
                    if (index === "0") {
                        modal = recordToProcess[key][index];
                    } else {
                        object[modal] = recordToProcess[key][index];
                    }
                }
                arrayOfRecords.push(object);
            }
            context.saveRecordUsingWorkprocess(arrayOfActions, arrayOfRecords).then(result => {
                if (Object.keys(result).length > 0) {
                    updatedRecord[0] = result;
                }
                resolve(true);
            }).catch(error => {
                reject(error);
            });
        });
    }

    onloadComponent(event) {
        let eventType = event.detail.type;
        for (let act = 0; act < lstActions[0].length; act++) {
            if (lstActions[0][act].type === eventType) {
                this.calledAction(lstActions[0][act], this);
                break;
            }
        }
    }


    disconnectedCallback() {
        unregisterAllListeners(this);

    }

    handleRemoveRecord(event) {
        updatedRecord[0][event.detail.model].pop();
    }

    handleAddRecord(event) {
        let record = JSON.parse(JSON.stringify(event.detail.record));
        updatedRecord[0][event.detail.model].push(record);
    }

}