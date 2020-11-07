import { api, track, wire } from 'lwc';
import Element from 'c/element';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
export default class Datatable extends NavigationMixin(Element) {

    @track recordstoShow;
    @track showrecords = false;
    @api columns;
    @api rowAction;
    @api tableAction;
    @api model;
    @api label;
   // @api records;
    @api get records() {
        return this.recordstoShow;
    }
    set records(value) {
        this.recordstoShow = value;
    }

    @api keyField;
    @api hideCheckboxColumn;
    @api showRowNumberColumn;
    @api rowNumberOffset;
    @api resizeColumnDisabled;
    @api minColumnWidth;
    @api maxColumnWidth;
    @api resizeStep;
    @api sortedBy;
    @api sortedDirection;
    @api defaultSortDirection;
    @api enableInfiniteLoading;
    @api loadMoreOffset;
    @api isLoading;
    @api maxRowSelection;
    @api selectedRows;
    @api errors;
    @api draftValues;
    @api hideTableHeader;
    @api suppressBottomBar;
    @api objectName;
    @api title;
    @track iconName;
    @track tableColumns = [];
    @track showModal;
    @track headerText;
    @track modalContent;
    @api cancelButtonStyle;
    
    connectedCallback() {
        if(this.recordstoShow.length > 0 ){
            this.showrecords = true;
        }
        this.headerText = 'Delete Record';
        this.modalContent ='Are you sure you want to delete this record?';
        this.cancelButtonStyle = 'outline: -webkit-focus-ring-color auto 0.1px;';
        // eslint-disable-nex
        var columnData = [];
        var columnObject;
        if (this.keyField === undefined)
            this.keyField = 'Id';

        if (this.columns) {
            for (let a = 0; a < this.columns.length; a++) {
                columnObject = {};
                columnObject.fieldName = this.columns[a].path;
                columnObject.label = this.columns[a].label;
                columnObject.type = this.columns[a].type;
                columnData.push(columnObject);
            }
            // eslint-disable-next-line vars-on-top
            var objAction = {};
            objAction.type = 'action';
            objAction.typeAttributes = {};
            objAction.typeAttributes.rowActions = this.rowAction;
            columnData.push(objAction);
            this.tableColumns = columnData;
        }
        if (this.tableAction)
            this.hasTableActions = true;
    }
    @wire(getObjectInfo, { objectApiName: '$objectName' })
    getObjectInfo({ error, data }) {
        if (data) {
            if (this.title === undefined || this.title === '')
                this.title = data.labelPlural; 
            if (this.iconName === undefined || this.iconName === '') {
                if (data.custom) {
                    this.iconName = 'custom:' + data.themeInfo.iconUrl.substring(data.themeInfo.iconUrl.lastIndexOf("/") + 1).split(".")[0].split('_')[0];
                }
                else
                    this.iconName = 'standard:' + this.objectName.toLowerCase();
            }
        }
        else {
            // eslint-disable-next-line no-console
            console.log('' + error);
        }
    }
    handleConfirmButtonAction(event)
    {
        const actionName = event.target.name;
        this.showModal = false;
        this.dispatchEvent(new CustomEvent('rowaction', { detail: {actionName:actionName,data:this.selectedRow} }));
    }
    handleButtonAction(event)
    {
        const actionName = event.target.name;
        this.dispatchEvent(new CustomEvent('tableaction', { detail: {actionName:actionName} }));
    }
    handleCloseModal(event)
    {
        this.showModal = event.detail.value;
    }
    handleRowAction(event) {
        let isActionPresent = false;
        var actionColumn = this.tableColumns.filter(val => val.type === 'action')[0];
        var rowActions = actionColumn.typeAttributes.rowActions;
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.selectedRow = row;
         for (let a = 0; a < rowActions.length; a++) {
             if (rowActions[a].name === actionName)
                isActionPresent = true;
         }
        if(actionName === 'Delete')               
        this.showModal = true;
        else if(isActionPresent)
            this.dispatchEvent(new CustomEvent('rowaction', { detail: {actionName:actionName,data:row} }));
    }
}