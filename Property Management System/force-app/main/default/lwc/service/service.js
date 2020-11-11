/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
/* eslint-disable no-useless-constructor */
import {
    LightningElement
} from 'lwc';
import getDescribeField from '@salesforce/apex/Engine.getDescribeField';
import getLookupData from "@salesforce/apex/Engine.getLookupData";
import getLookupFieldValue from "@salesforce/apex/Engine.getLookupFieldValue";
import saveRecord from '@salesforce/apex/Engine.saveRecord';
import removeRecord from '@salesforce/apex/Engine.removeRecord';
import query from '@salesforce/apex/Engine.query';
import fetchLayout from '@salesforce/apex/Engine.getLayout';
import fetchModel from '@salesforce/apex/Engine.getModel';
import getModelDef from '@salesforce/apex/Engine.getModelDef';
import getModelDefByModel from '@salesforce/apex/Engine.getModelDefByModel';
import getModelDefObjectName from '@salesforce/apex/Engine.getModelDefObjectName';
//import getDatasourceName from '@salesforce/apex/pwrEngine.getDatasourceName';
//import getDatasource from '@salesforce/apex/pwrEngine.getDatasource';
import {getQueryParams, getCookie} from './ServiceUtils';
//import saveRecordUsingWorkprocess from '@salesforce/apex/WorkprocessManager.saveRecordUsingWorkprocess';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//import getLookupFieldValue from "@salesforce/apex/pwrLookupWrapperController.getLookupFieldValue";
export default class Service extends LightningElement {

    getDescribeField(modelName, lstFieldApiName) {
        return new Promise(function (resolve, reject) {
            getDescribeField({
                modelName: modelName,
                lstFieldApiName: lstFieldApiName
            }).then(result => {
                resolve(result);
            }).catch(error => {
                reject(error);
            })
        })
    }
    getLookupFieldValue(objectApiName, fieldApiName, recordId) {
        return new Promise(function (resolve, reject) {
            getLookupFieldValue({
                objectApiName: objectApiName,
                fieldApiName: fieldApiName,
                recordId: recordId
            }).then(result => {
                resolve(result);
            }).catch(error => {
                reject(error);
            })
        });
    }
    showToastMessage(title,variant,message){
        const event = new ShowToastEvent({
            "title": title,
            "variant":variant,
            "message": message
        });
        this.dispatchEvent(event);
    }
    //save and update record in salesfroce
    saveRecord(lstJsonObject, modelName) {
        return new Promise(function (resolve, reject) {
            saveRecord({
                    lstJsonObject: lstJsonObject,
                    modelName: modelName
                }).then(result => {
                    if(result.data === undefined){
                        if(result.success !== undefined && ! result.success){
                            //result.type = 'errormessage';
                            // eslint-disable-next-line no-throw-literal
                            throw ({'type':'errormessage','success':result.success,'message':result.message});
                        }
                        else 
                            resolve(result);
                    }else{
                        resolve(result.data);
                    } 
                })
                .catch(error => {
                    reject(error);
                   console.log(error);
                });
        })
    }
   
    /*saveRecordUsingWorkprocess(actions,lstSobject){
        return new Promise(function (resolve, reject) {
            saveRecordUsingWorkprocess({
                workprocess: actions,
                lstRecordToUpsert: lstSobject
            })
            .then((result) => {
                if(result.data === undefined){
                    resolve(result);
                }else{
                    resolve(result.data);
                } 
            })
            .catch((error) => {
                reject(error);
            });
        })
    }*/
    //remove any salesforce record
    removeRecord(lstJsonObject, modelName) {
        return new Promise(function (resolve, reject) {
            removeRecord({
                    lstJsonObject: lstJsonObject,
                    modelName: modelName
                }).then(result => {
                    resolve(result.data);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    //query any record from salesforce
    query(modelName, condition) {
        
        /* conditions : [{ fieldName:'name',operator:'equals',valueType:'String',value:'test'}] */
        return new Promise(function (resolve, reject) {
            query({
                    modelName: modelName,
                    conditions: condition
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        })
    }
    //fetch layout
    fetchLayout(layoutName) {
        return new Promise(function (resolve, reject) {
            fetchLayout({
                    layoutName: layoutName
                }).then(result => {
                    // this.assignLayout( result );
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    //fetch modelDef
    getModelDef(modelDefName) {
        return new Promise(function (resolve, reject) {
            getModelDef({
                    modelDefName: modelDefName
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    //fetch modelDefbyModel
    getModelDefByModel(modelName) {
        return new Promise(function (resolve, reject) {
            getModelDefByModel({
                    modelName: modelName
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    //fetch model
    fetchModel(modelName) {
        return new Promise(function (resolve, reject) {
            fetchModel({
                    modelName: modelName
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    //fetch Datasource name
   /* getDatasourceName(modelName) {
        return new Promise(function (resolve, reject) {
            getDatasourceName({
                    modelName: modelName
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }*/
    //fetch datasource
   /* getDatasource(modelName) {
        return new Promise(function (resolve, reject) {
            getDatasource({
                    modelName: modelName
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }*/
    //fetch model
    getModelDefObjectName(modelName) {
        return new Promise(function (resolve, reject) {
            getModelDefObjectName({
                    modelName: modelName
                }).then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    getLookupData(objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition, showDefault, isLookupClicked) {
        return new Promise(function (resolve, reject) {
            getLookupData({
                objectApiName: objectApiName,
                fieldApiName: fieldApiName,
                searchText: searchText,
                numberOfRecords: numberOfRecords,
                filterCondition: filterCondition,
                showDefault: showDefault,
                isLookupClicked: isLookupClicked
            }).then(result => {
               resolve(result);
            }).catch(error => {
                reject(error)
            });
        });
    }

    getParams( criteria , context){
        let allParams = {};
        criteria.conditions.forEach( condition  => {
            if( condition !== undefined && condition !== null && condition.valueType !== undefined && condition.valueType !== null){
                switch ( condition.valueType.toLowerCase()){
                    case "cookies":
                        if (!allParams.hasOwnProperty("cookies") && getCookie(condition.value)) {
                            allParams.cookies = {}
                        }
                        if (getCookie(condition.value)) {
                            allParams.cookies[condition.value] = getCookie(condition.value);
                        }
                        break;
                    
                    case "querystring":
                        if (!allParams.hasOwnProperty("queryString")) {
                            allParams.queryString = {}
                        }
                        if (getQueryParams()) {
                            allParams.queryString[condition.value] = getQueryParams()[condition.value];
                        }
                        break;
                    
                    case "localstorage":
                        if (!allParams.hasOwnProperty("localStorage") && localStorage.getItem(condition.value)) {
                            allParams.localStorage = {}
                        }
                        if (localStorage.getItem(condition.value)) {
                            allParams.localStorage[condition.value] = localStorage.getItem(condition.value);
                        }
                        break;

                    case "static":
                        if (!allParams.hasOwnProperty("static") && localStorage.getItem(condition.value)) {
                            allParams.localStorage = {}
                        }
                        if (localStorage.getItem(condition.value)) {
                            allParams.localStorage[condition.value] = localStorage.getItem(condition.value);
                        }
                        break;
                    
                    default :
                        break;
                }
            }
            
        });
        return allParams;
    }

   
}