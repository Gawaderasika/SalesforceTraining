/* eslint-disable no-empty */
/* eslint-disable no-console */
import { api, track, wire } from "lwc";
import { fireEvent, registerListener, unregisterAllListeners } from "c/pubSubHandler";
import { CurrentPageReference } from "lightning/navigation";
import { isErrorOccur } from "c/errorHelper";
import Service from "c/service";

const mapStep = {
  "0": "1",
  "1": ".1",
  "2": ".01",
  "3": ".001",
  "4": ".0001",
  "5": ".00001",
  "6": ".000001",
  "7": ".0000001",
  "8": ".00000001",
  "9": ".000000001",
  "10": ".0000000001",
  "11": ".00000000001"
};

export default class Field extends Service {
  isNotFirstTime = false;
  @track showInputComponent = false;
  @track isSingleSelect = false;
  @track isMultiSelect = false;
  @track isLookup = false;
  @track isEncryptedField = false;
  @track isRichTextarea = false;
  @track isTextarea = false;
  @track showDateFormat = false;
  @api fieldId ;
  @api apiName;
  @api label;
  @api type;
  @api isAccessible;
  @api isUpdateable;
  @api isRequired;
  @api isDisabled;
  @api maxLength;
  @api minLength; 
  @api isHtmlFormatted;
  @api maskType;
  @api maskCharacter;
  @api min;
  @api max;
  @api isReadOnly;
  @api fieldSchema;
  @api picklistValues;
  @api record = {};
  @api updatedRecord = {};
  @api placeholder;
  @api variant;
  @api fieldLevelHelp;
  @api messageWhenValueMissing;
  @api disabled;
  @api required;
  @api sourceLabel;
  @api selectedLabel;
  @api name;
  @api value;
  @api requiredOptions;
  @api size;
  @api disableReordering;
  @api showActivityIndicator;
  @api addButtonLabel;
  @api removeButtonLabel;
  @api upButtonLabel;
  @api downButtonLabel;
  @api messageWhenBadInput;
  @api messageWhenPatternMismatch;
  @api messageWhenRangeOverflow;
  @api messageWhenRangeUnderflow;
  @api messageWhenStepMismatch;
  @api messageWhenTooShort;
  @api messageWhenTooLong;
  @api messageWhenTypeMismatch;
  @api messageToggleActive;
  @api messageToggleInactive;
  @api ariaLabel;
  @api ariaControls;
  @api ariaLabelledBy;
  @api ariaDescribedBy;
  @api formatter;
  @api pattern;
  @api accept;
  @api accessKey;
  @api disabledCategories;
  @api formats;
  @api shareWithEntityId;
  @api valid;
  @api spinnerActive;
  @api lookupData = [];
  @api lookupDataRes =[];
  @api selectedRecord;
  @api showLabel;
  @api debounceDelay;
  @api minimumCharacterToSearch;
  @api dropdownHeight;
  @api objectApiName;
  @api fieldApiName;
  @api recordLimit;
  @api filterCondition;
  @api recordId;
  @api isChecked;
  @api reference;
  @api referenceField;
  @track selectedFields;
  @track isAccessible = false;
  @api isInvalidEntry = 'no';
  @track isRecordSelected = false;
  @track checkLookupListFlag = true;
  @track createRecord;
  @track searchvalueTExt = '';
  @wire(CurrentPageReference) pageRef;
  @track searchvalue;
  @track searchvalue1;
  @track insideLookup = false ;
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
 
  connectedCallback () {
    registerListener(
      "setDependentPicklistValues",
      this.setDependentPicklist,
      this
    );
    registerListener(
      "updatedFieldValues",
      this.setUpdatedRecords,
      this
    );
    //this.checkFieldSchema();
    if (this.record) {
      this.value = this.record[this.apiName];
      this.updatedRecord = this.deepCloneObject(this.record);
    }
    
    if (this.fieldSchema !== undefined) {
      this.type = this.fieldSchema.dataType;
      if (this.fieldApiName === undefined) {
        this.fieldApiName = this.fieldSchema.apiName;
      }
      if (this.objectApiName === undefined) {
        this.objectApiName = this.fieldSchema.objectApiName;
      }
      if (this.label === undefined) {
        this.label = this.fieldSchema.label;
      }
      if (this.isHtmlFormatted === undefined) {
        this.isHtmlFormatted = this.fieldSchema.isHtmlFormatted;
      }
      if (this.maxLength === undefined) {
        this.maxLength = this.fieldSchema.maxLength;
      }
      if(this.fieldSchema.required !== undefined && this.fieldSchema.required === true) {
        this.isRequired = true;
      }else if(this.fieldSchema.isDbRequired !== undefined && this.fieldSchema.isDbRequired === true){
        this.isRequired = true;
      }else{
        this.isRequired = false;
      } 
      if(this.fieldSchema.readOnly !== undefined) {
        this.isReadOnly = this.checkConditionalReadOnly(this.fieldSchema) ? true : this.fieldSchema.readOnly === true ? true : !this.fieldSchema.isUpdateable;
      }else {
        this.isReadOnly = false;
      }
      if(this.fieldSchema.disabled !== undefined) {
        this.isDisabled = this.checkConditionalDisable(this.fieldSchema) ? true : this.fieldSchema.disabled === true ? this.fieldSchema.disabled : !this.fieldSchema.isUpdateable;
      }else{
        this.isDisabled = false;
      }
      this.isAccessible = this.fieldSchema.isAccessible;
    }
    if (this.value === true) {
      this.isChecked = "true";
    }
    this.initializeDataForFieldType();
  }

  checkFieldSchema(){
    if (this.record) {
      this.value = this.record[this.apiName];
      this.updatedRecord = this.deepCloneObject(this.record);
    }
    if (this.fieldSchema !== undefined) {
      this.type = this.fieldSchema.dataType;
      if (this.fieldApiName === undefined) {
        this.fieldApiName = this.fieldSchema.apiName;
      }
      if (this.objectApiName === undefined) {
        this.objectApiName = this.fieldSchema.objectApiName;
      }
      if (this.label === undefined) {
        this.label = this.fieldSchema.label;
      }
      if (this.isHtmlFormatted === undefined) {
        this.isHtmlFormatted = this.fieldSchema.isHtmlFormatted;
      }
      if (this.maxLength === undefined) {
        this.maxLength = this.fieldSchema.maxLength;
      }
      if(this.fieldSchema.required !== undefined && this.fieldSchema.required === true) {
        this.isRequired = true;
      }else if(this.fieldSchema.isDbRequired !== undefined && this.fieldSchema.isDbRequired === true){
        this.isRequired = true;
      }else{
        this.isRequired = false;
      } 
      if(this.fieldSchema.readOnly !== undefined) {
        this.isReadOnly = this.checkConditionalReadOnly(this.fieldSchema) ? true : this.fieldSchema.readOnly === true ? true : !this.fieldSchema.isUpdateable;
      }else {
        this.isReadOnly = false;
      }
      if(this.fieldSchema.disabled !== undefined) {
        this.isDisabled = this.checkConditionalDisable(this.fieldSchema) ? true : this.fieldSchema.disabled === true ? this.fieldSchema.disabled : !this.fieldSchema.isUpdateable;
        if(this.fieldSchema.dataType === 'REFERENCE' && this.isDisabled){
          this.template.querySelector("c-lookup").setDisable();
        }
        else{
          this.template.querySelector("c-lookup").removeDisable();
        }
      }else{
        this.isDisabled = false;
      }
      this.isAccessible = this.fieldSchema.isAccessible;
    }
    if (this.value === true) {
      this.isChecked = "true";
    }
  }
  setAttributeForEncryptedType () {
    if (this.maskType === undefined && this.fieldSchema) {
      this.maskType = this.fieldSchema.maskType;
    }
    if (this.maskCharacter === undefined && this.fieldSchema) {
      this.maskCharacter = this.fieldSchema.maskCharacter;
    }
  }
 
  setAttributeToMultipicklist () {
    if (this.sourceLabel === undefined && this.fieldSchema) {
      this.sourceLabel = this.fieldSchema.sourceLabel;
    }
    if (this.selectedLabel === undefined && this.fieldSchema) {
      this.selectedLabel = this.fieldSchema.selectedLabel;
    }
  }

  setDependentPicklist (parentValue) {
    let options = this.fieldSchema.mapControllingDependentPicklistValues[
      parentValue
    ];
    this.picklistValues = options;
  }

  setPicklistOptions (fieldSchema) {
    if (fieldSchema.isDependent) {
      registerListener(
        fieldSchema.controllingFieldApiName + "model" + fieldSchema.model,
        this.setDependentPicklist,
        this
      );
      let detail = {};
      detail.controllingFieldApiName = fieldSchema.controllingFieldApiName;
      detail.model = fieldSchema.model;
      fireEvent(this.pageRef, "getDependentPicklistValues", detail);
    } else {
      this.picklistValues = this.fieldSchema.picklistValues;
    }
  }

  initializeDataForFieldType () {
    if (this.type && this.isAccessible) {
      switch (this.type.toUpperCase()) {
        case "PICKLIST":
          if(this.checkVisibility(this.fieldSchema)) {
            this.isSingleSelect = true;
          }else{
            this.isSingleSelect = false;
          }
          this.setPicklistOptions(this.fieldSchema);
          break;

        case "MULTIPICKLIST":
          if(this.checkVisibility(this.fieldSchema)) {
            this.isMultiSelect = true;
          }else {
            this.isMultiSelect = false;
          }
          this.picklistValues = this.fieldSchema.picklistValues;
          this.setAttributeToMultipicklist();
          this.setSelectedPicklistValues();
          break;

        case "REFERENCE":
          if(this.checkVisibility(this.fieldSchema)) {
            this.isLookup = true;
          }else {
            this.isLookup = false;
          }
          if(this.recordId !== undefined) {
            this.getLookupFieldValue(
              this.objectApiName,
              this.fieldApiName,
              this.recordId
            ).then(result => {
              this.template
                .querySelector("c-lookup")
                .setSelectedRecordName(result);
            });
          }else if (this.value !== '') {
            this.getLookupFieldValue(
              this.objectApiName,
              this.fieldApiName,
              this.value
            ).then(result => {
              this.template
                .querySelector("c-lookup")
                .setSelectedRecordName(result);
            });
          }
          break;

        case "ENCRYPTEDSTRING":
          if(this.checkVisibility(this.fieldSchema)) {
            this.isEncryptedField = true;
          }else {
            this.isEncryptedField = false;
          }
          this.setAttributeForEncryptedType();
          break;

        case "TEXTAREA":
          if(this.checkVisibility(this.fieldSchema)) {
            if (this.isHtmlFormatted) {
              this.isRichTextarea = true;
            }else {
              this.isTextarea = true;
            }
          }else{
            this.isRichTextarea = false;
            this.isTextarea = false;
          }
          break;

        case "INTEGER":
        case "CURRENCY":
        case "PERCENT":
        case "DOUBLE":
          this.formatter =  this.type === "DOUBLE" ? "Decimal" : this.type === "PERCENT" ? "percent-fixed" : this.type === "CURRENCY" ? "Currency" : "number";
          this.type = "Number";
          this.step = mapStep[this.fieldSchema.numbersOnRightOfDecimal];
          if(this.checkVisibility(this.fieldSchema)) {
            this.showInputComponent = true;
          }else {
            this.showInputComponent = false;
          }
          break;

        case "DATETIME":
        case "DATE":
        case "TIME":
          if(this.checkVisibility(this.fieldSchema)) {
            this.showDateFormat = true;
          }else {
            this.showDateFormat = false;
          }
          break;

        case "BOOLEAN":
          if(this.checkVisibility(this.fieldSchema)) {
            this.showInputComponent = true;
          }else {
            this.showInputComponent = false;
          }
          this.type = "checkbox";
          break;

        case "CHECKBOX":
          if(this.checkVisibility(this.fieldSchema)) {
            this.showInputComponent = true;
          }else {
            this.showInputComponent = false;
          }
          this.type = "checkbox";
          break;
      
        case "PHONE":
          if(this.checkVisibility(this.fieldSchema)) {
            this.showInputComponent = true;
          }else {
            this.showInputComponent = false;
          }
          this.type = "tel";
          break;
        
        case "TEXT":
        case "STRING":
          this.type = "Text";
          if(this.checkVisibility(this.fieldSchema)) {
            this.showInputComponent = true;
          }else {
            this.showInputComponent = false;
          }
          break;

        default:
          this.showInputComponent = true;
          break;
      }
    }
    else{
      this.showInputComponent = false;
    }
  }



  checkConditionalDisable(fieldSchema) {
    if(fieldSchema !== undefined && fieldSchema.visibility !== undefined && fieldSchema.visibility.visibilityAction === 'disabled') {
      return this.executeConditions(fieldSchema.visibility.criteria);
    }
      return false;
  }

  checkConditionalReadOnly(fieldSchema) {
    if(fieldSchema !== undefined && fieldSchema.visibility !== undefined && fieldSchema.visibility.visibilityAction === 'readOnly') {
      return this.executeConditions(fieldSchema.visibility.criteria);
    }
      return false;
  }
   
  
  checkVisibility(fieldSchema) {
    if(fieldSchema !== undefined && fieldSchema.visibility !== undefined && fieldSchema.visibility.visibilityAction === 'hide') {
      return this.executeConditions(fieldSchema.visibility.criteria);
    }
    return true;
  }

  executeConditions(criteria) {
   if(criteria.hasOwnProperty('conditions') && criteria.conditions.length > 0) {
    const criterias = [];
    for(const condition of criteria.conditions) {
      const result = this.executeSingleCondition(condition);
      criterias.push(result);
      switch(criteria.evaluationCriteria.toLowerCase()) {
        case 'or':
          if(result) {
            return result;
          }
          if(criterias.length === criteria.conditions.length) {
            return false;
          }
          break;
        case 'custom':

          break;
        case 'not':
          if(result) {
            return !result;
          }
          if(criterias.length === criteria.conditions.length) {
            return true;
          }
          break;
        default: //evaluationCriteria=='and'
          if(!result) {
            return false;
          }
          if(criterias.length === criteria.conditions.length) {
            return true;
          }
          break;
      }
    }
  }
   return true;
  }

  executeSingleCondition(condition) {
    if(Object.keys(condition).length > 0) {
      const source = this.getValue(condition.source ? condition.source.split('.') : null);
      const destination = this.getValue(condition.destination ? condition.destination.split('.') : null);
      if(source !== undefined && destination !== undefined) {
        return this.evaluateExpression(source, condition.operator, destination);
      }
      return false;
    }
    return true;
  }

  getValue(elements) {
    let data;
    let modelField;
    switch(elements[0].toLowerCase()) {
      case 'static':
        data = elements[1];
        break;
      case 'model':
        modelField = elements.splice(2, elements.length - 1);
        data = this.updatedRecord[modelField[0]]; 
        break; 
      case 'cookies':
        break;
      case 'query':
        break;  
      case 'localStorage':
        break;
      case 'loggedInUser':
        break;
      case 'response':
        break;
      case 'params':
        break;
      case 'input':
        break; 
      default:
        break;
    }
    return data;
  }

  evaluateExpression(source, operator, destination) {
    switch (operator.toLowerCase()) {
      case 'equals':
        return source === destination;
      case 'not equals':
        return source !== destination;
      case 'contains':
        return source.indexOf(destination) !== -1;
      case 'starts with':
        return source.startWith(destination);
      case 'ends with':
        return source.endsWith(destination);
      case 'less than':
        return source < destination;
      case 'greater than':
        return source > destination;
      case 'less than equal to':
        return source <= destination;
      case 'greater than equal to':
        return source >= destination;
      default:
        return false;
    }
  }
 
  setSelectedPicklistValues () {
    if (this.record && this.record[this.apiName]) {
      let selectedPicklistValues;
      if (this.record[this.apiName].indexOf(";") > 0) {
        selectedPicklistValues = this.record[this.apiName].split(";");
      } else {
        selectedPicklistValues = [];
        selectedPicklistValues.push(this.record[this.apiName]);
      }
      let selectedValues = [];
      for (let a = 0; a < selectedPicklistValues.length; a++) {
        let selectedOption = this.picklistValues.filter(
          val => val.value === selectedPicklistValues[a]
        );
        selectedValues.push(selectedOption[0].value);
      }
      this.selectedFields = selectedValues;
    }
  }

  setUpdatedRecords (recordInformation) {
    this.record = this.deepCloneObject(recordInformation.parentValue);
   // this.checkFieldSchema();
    //Clear child dependent lookups if parent lookup clears
    if(recordInformation.parentValue.dependentChildLookupsToClear !== undefined && recordInformation.parentValue.operation !== undefined && recordInformation.parentValue.operation === 'clearLookup'){
      let lookupFieldsToClear = recordInformation.parentValue.dependentChildLookupsToClear;
      if(lookupFieldsToClear.includes(this.fieldApiName)){
        this.template.querySelector('c-lookup').clearDependentChildLookups();
      }
    }
       
    //After updating fields, visibility criteria needs to be re-evaluate
    if(this.fieldSchema !== undefined && this.fieldSchema.visibility !== undefined && this.fieldSchema.visibility.visibilityAction === 'hide') {
      this.updatedRecord = this.deepCloneObject(this.record);
     
      this.initializeDataForFieldType();
    }
    if(this.fieldSchema !== undefined && this.fieldSchema.visibility !== undefined && this.fieldSchema.visibility.visibilityAction === 'disabled') {
      this.updatedRecord = this.deepCloneObject(this.record);
     
      this.checkFieldSchema();
     // this.initializeDataForFieldType();
      
    }
  }
  
  handleInputChange (event) {
    this.dispatchEvent(
      new CustomEvent("updatefieldvalue", {
        detail: { apiName: this.apiName, value: event.detail }
      })
    );
  }
 
  handleSelect (event) {
    if(this.isInvalidEntry == 'yes')
    this.isInvalidEntry = 'no';
    isErrorOccur[0]  =  this.isInvalidEntry == 'yes' ? true : false;
    let recordValue;
    let recordOperation;
    if (typeof event.detail !== "object") {
      recordValue = event.target.value !== undefined ? event.target.value : event.detail;
    } else {
      if (this.isMultiSelect === true && event.detail) {
        recordValue = event.detail.join(";");
      } else if (this.type === "checkbox") {
        recordValue = event.target.checked;
      } else if (this.isLookup) {
        recordValue = event.detail.selectedRecordId;
        recordOperation = event.detail.operation;
        this.searchvalue = recordValue;
      } else if (event.target.value !== undefined) {
        recordValue = event.target.value;
      } else {
        recordValue = event.detail;
      }
    }
    
    
    this.updatedRecord = this.deepCloneObject(this.record);
    if(recordOperation === 'selectLookup'){
      this.createRecord = false;
      this.lookupData = [];
      this.isRecordSelected = true;
      this.searchvalue1 = false;
      }else if(recordOperation === 'clearLookup'){
      this.isRecordSelected = false;
      this.searchvalue1 = true;
      this.insideLookup = false;
    }
    this.operationOnField = recordOperation;
    this.updatedRecord[this.fieldApiName] = recordValue; 
    this.validateField(event);
  
    //For Dependent Picklist
    if (this.type.toUpperCase() === "PICKLIST") {
      fireEvent(
        this.pageRef,
        this.apiName + "model" + this.fieldSchema.model,
        recordValue
      );
    }
    this.dispatchEvent(
      new CustomEvent("updatefieldvalue", {
        detail: { apiName: this.apiName, value: recordValue, operation: recordOperation }
      })
    );
    
  }

  validateField(event) {
    if(this.fieldSchema !== undefined && this.fieldSchema.validation !== undefined && this.fieldSchema.validation.length > 0) {
      const validationLists = this.fieldSchema.validation;
      for(let key = 0; key < validationLists.length; key++) {
         if(this.executeConditions(validationLists[key].criteria)) {
          event.target.setCustomValidity(validationLists[key].errorMessage);
          event.target.reportValidity();
          break;
         }else {
          event.target.setCustomValidity('');
          event.target.reportValidity();
         }
      }
    }  
  }

  closeOpenedLookupMenu(event) {
    setTimeout(() => {
      if(this.lookupData){
        if(event.detail.searchTerm === ''){
          this.isInvalidEntry = 'no';
          isErrorOccur[0] = false;
        }else{
          this.isInvalidEntry = 'yes';
          isErrorOccur[0] = true;
        }
        
        if(this.lookupData.length > 0){
          this.lookupData = [];
        }
        this.createRecord = false;
      }
  }, 300);//timeout is provided because to capture selection option click event meanwhile
  }
  handleSearch (event) {
    this.template.querySelector("c-lookup").removeInvalidEntry();
    if(this.isDisabled === false) {
      let searchText = event.currentTarget.finalSearchTerm;
      let recordLimit = event.currentTarget.recordLimit;
      let objectApiName = event.currentTarget.objectApiName;
      let fieldApiName = event.currentTarget.fieldApiName;
      let filterCondition;
      let showDefault = false;
      let isLookupClicked = false;
      this.searchvalueTExt = searchText;
      //For dependent lookup, filter conditions are added
      if( this.fieldSchema.reference !== undefined && this.fieldSchema.referenceField !== undefined ){
        let checkFilterCondition = this.record !== undefined ? this.record[this.fieldSchema.referenceField] !== undefined ? this.record[this.fieldSchema.referenceField] !== '' ? true : false : false : false;
        if(checkFilterCondition) {
          filterCondition = this.fieldSchema.referenceField + ' = \'' + this.record[this.fieldSchema.referenceField]+'\'';        
        }
      }
      if(searchText && searchText.length < 2) {//When searchText is not geting undefined
        showDefault = true;
        this.isRecordSelected = 'invalid';
      }else if(searchText === '' || this.isRecordSelected === false) {//clear lookup is pressed then this.isRecordSelected = false
        isLookupClicked = true;                                         //searchText === '' is true when typed string is cleared by backspace
        //this.checkLookupListFlag = false;
                                                 
      }
      
      if(searchText && searchText.length !== 0) {//When typed some char and clicked
        isLookupClicked = false; 
      }
      this.searchvalue1 =isLookupClicked ;
      this.searchvalueTExt = searchText;
      if(this.isRecordSelected !== true) {
        this.getLookupData(objectApiName, fieldApiName, searchText, recordLimit, filterCondition, showDefault, this.searchvalue1)
        .then(results => {
            if(results !== null) {
              this.lookupData = results.map(result => {
                this.createRecord = true;
                return result;
              });
            
            }
            
          }).catch(error => {
            console.log(error);
          });
      }
     
    }
   
  }
  handleSearchOnClick (event) {
    this.template.querySelector("c-lookup").removeInvalidEntry();
      
    if(this.isDisabled === false && (this.operationOnField !== undefined || event.currentTarget.selectedRecordId === undefined )) {
      let searchText = event.currentTarget.finalSearchTerm;
      let recordLimit = event.currentTarget.recordLimit;
      let objectApiName = event.currentTarget.objectApiName;
      let fieldApiName = event.currentTarget.fieldApiName;
      let filterCondition;
      let showDefault = false;
      let isLookupClicked = true;
      this.insideLookup = true;
      this.createRecord = true;
      //For dependent lookup, filter conditions are added
      if( this.fieldSchema.reference !== undefined && this.fieldSchema.referenceField !== undefined ){
        let checkFilterCondition = this.record !== undefined ? this.record[this.fieldSchema.referenceField] !== undefined ? this.record[this.fieldSchema.referenceField] !== '' ? true : false : false : false;
        if(checkFilterCondition) {
          filterCondition = this.fieldSchema.referenceField + ' = \'' + this.record[this.fieldSchema.referenceField]+'\'';        
        }
      }
      if(searchText === undefined){
        isLookupClicked = true;  
        searchText = '';
      }else if(searchText.length !==0){
        this.isInvalidEntry  = 'no';
       this.createRecord = true;
       isLookupClicked = false;
     }
 
      if(searchText && searchText.length < 2) {//When searchText is not geting undefined
        showDefault = true;
        this.isRecordSelected = 'invalid';
        isLookupClicked = false;
       }
        if( this.searchvalue1 === true && this.operationOnField === 'clearLookup') {//clear lookup is pressed then this.isRecordSelected = false
           isLookupClicked = true;                                         //searchText === '' is true when typed string is cleared by backspace
           //this.checkLookupListFlag = false;
           searchText = '';
          //this.isInvalidEntry ='no';
      }else  if(this.operationOnField === 'selectLookup' && this.isRecordSelected === true){
        this.isRecordSelected = true;
        searchText = '';
     }
       this.searchvalue1 =isLookupClicked ;
       if(searchText !== ''){
        this.searchvalueTExt = searchText;
       }else{
        this.searchvalueTExt = '';
       }
       
      
      if(this.isRecordSelected !== true  ) {
        this.getLookupData(objectApiName, fieldApiName, searchText, recordLimit, filterCondition, showDefault, this.searchvalue1)
        .then(results => {
            if(results !== null) {
              this.lookupData = results.map(result => {
               if(this.operationOnField !== 'selectLookup'){
                this.createRecord = true;
                return result;
               }
              });
            }
            this.createRecord = true;
          }).catch(error => {
            console.log(error);
          });
      }else{
        this.createRecord = false;
      }
    }else{
      this.createRecord = false;
    }
  }

  disconnectedCallback () {
    unregisterAllListeners(this);
  }
}