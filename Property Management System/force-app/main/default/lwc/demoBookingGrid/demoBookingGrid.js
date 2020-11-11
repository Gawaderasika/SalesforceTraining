/* eslint-disable radix */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable no-console */
/* eslint-disable no-debugger */
/* eslint-disable no-alert */
import UnitsUnavailability from '@salesforce/label/c.UnitsUnavailability';
import UnitsNotAvailable from '@salesforce/label/c.UnitsNotAvailable';
import UnitTypesNotAvailable from '@salesforce/label/c.UnitTypesNotAvailable';
import UnitsAndUnitTypeSelected from '@salesforce/label/c.UnitsAndUnitTypeSelected';
import MultipleUnitTypesValidation from '@salesforce/label/c.MultipleUnitTypesValidation';
import PastDateSelected from '@salesforce/label/c.PastDateSelected';
import DIRTY_FIELD from '@salesforce/schema/Unit__c.Dirty__c';
import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUnitRecord from '@salesforce/apex/PropertyManagementSystemController.getUnitRecord';
const monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
];
const dayNames = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
];


export default class DemoBookingGrid extends LightningElement {

    div = 0;
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    x3 = 0;
    y3 = 0;
    _templateWidth = 0;
    _cellHeight = 0;
    _cellWidth = 0;
    _selectBoxLeft = 0;
    _selectBoxTop = 0;
    _selectBoxWidth = 0;
    _selectBoxHeight = 0;
    @track selectedCellUnitType = [];
    @track selectedCellUniySubType = [];
    isExistingBookingClicked = false;
    @track _isDivVisible = false;
    @track _divSize = 'left: 0px; right: 0px; width: 0px; height: 0px;';
    @track _columnDatesWidth = 'width: 0px;'
    @track _columnWidth;
    @track _menuColumnWidth = 250;
    @track _columnDates = [];
    @track _gridWidth;
    @track _bookingEntities = [];
    @track _startDate;
    @track _endDate;
    @track _numberOfColumns;
    @track _bookingData = [];
    @track _serviceInterruptionData = [];
    @track _currentMonthAndYear;
    @track _mapBookingEntityIdRecord;
    @track _mapBookingDataIdRecord = new Map();
    @track _slectedRow = '';
    @track _hasRenderedBookingEntity = false;
    @track _newBooking;
    @track _arrbookingEntities = [];
    @track _oneDayReservation = {};
    @track _isLoaded = false;
    @track _isRenderedEntity = false;
    @track noRecordFound = false;
    @track columnMonthAndYear;
    @track _isSpinner = false;
    @track modifyData;
    @track isSelectionComplete = false;
    @track isUnityClicked = false;
    @api gridView = 'WEEKLY';
    @api gridCurrentDate = new Date();
    @api girdCurrentDate;
    @api get isSpinner() {
        return this._isSpinner;
    }
    set isSpinner(value) {
        this._isSpinner = value;
    }

    set gridWidth(value) {
        if (value)
            this._gridWidth = value;
    }
    @api
    get gridWidth() {
        return `width: ${this._gridWidth}px`;
    }

    set menuColumnWidth(value) {
        if (value)
            this._menuColumnWidth = value;
    }
    @api
    get menuColumnWidth() {
        return `width: ${this._menuColumnWidth}px;`
    }

    set columnWidth(value) {
        if (value)
            this._columnWidth = value;
    }
    @api
    get columnWidth() {
        return `width: ${this._columnWidth}px`;
    }

    set bookingData(value) {
        this._bookingData = value;
        if (value && value.length > 0) {
            //this._mapBookingDataIdRecord = new Map();
            value.forEach((record, iIndex) => {
                this._mapBookingDataIdRecord[record.id] = record;
            });
            if (this._isRenderedEntity) {
                this.renderBookingData();
                this.calculateTotalBookingUnits();
            }
        }
    }
    @api
    get bookingData() {
        return this._bookingData;
    }

    @api
    get serviceInterruptionData() {
        return this._serviceInterruptionData;
    }

    set serviceInterruptionData(value) {
        this._serviceInterruptionData = value;
        if (value && value.length > 0) {
            value.forEach((record, iIndex) => {
                this._mapBookingDataIdRecord[record.id] = record;
            });
            if (this._isRenderedEntity) {
                this.renderBookingData();
                this.calculateTotalBookingUnits();
            }
        }
    }

    set bookingEntities(value) {
        if (value && value.length > 0) {
            this._bookingEntities = value;
            this.renderBookingEntities();
        }
    }
    @api
    get bookingEntities() {
        return this._bookingEntities;
    }

    connectedCallback() {
    this.calculateColumnDates();
    }

    renderedCallback() {
        if (this._hasRenderedBookingEntity) {
            if (this._mapBookingEntityIdRecord) {
                this.renderBookingData();
                this.calculateTotalBookingUnits();
            }
            this.bindMouseEvents();
            this._hasRenderedBookingEntity = false;
            this._isLoaded = true;
            this._isRenderedEntity = true;
        }
    }

  

    setColumnWidth(column) {
        if(column.length > 0) {
            this.cellOuterWidth = column[0].offsetWidth; //outer width
            this.leftMarginFromDate = column[0].offsetLeft;
            this._columnDatesWidth = 'width:' + this.cellOuterWidth + 'px; border: 0.01rem solid #dddbda !important;border-left: none !important;';
        }
    }

    @api
    refreshGrid() {
        this._isRenderedEntity = false;
        this.isExistingBookingClicked = false;
        this.deSelectCell();
        this.selectedCellUnitType = [];
        this.selectedCellUniySubType = [];
        this.calculateColumnDates();
    }

    renderBookingEntities() {
        if (this._bookingEntities && this._bookingEntities.length > 0) {    //_bookingEntities contains unit types with its child units.
            this._mapBookingEntityIdRecord = new Map();
            this._arrbookingEntities = [];
            for (let iIndex = 0; iIndex < this._bookingEntities.length; iIndex++) {
                let children1 = [];
                let parentPosinSet = iIndex + 1;
                if (this._bookingEntities[iIndex].children) {   //_bookingEntities.children contains children units of units types.
                    for (let jIndex = 0; jIndex < this._bookingEntities[iIndex].children.length; jIndex++) {    //this for is in used when units have subtypes.
                        let childPosinSet = jIndex + 1;
                        let children2 = [];
                        if (this._bookingEntities[iIndex].children[jIndex].children) {
                            for (let kIndex = 0; kIndex < this._bookingEntities[iIndex].children[jIndex].children.length; kIndex++) {
                                let subChildPosinSet = kIndex + 1;
                                let subChildColumns = [];
                                let subChildBooked = [];
                                this._columnDates.forEach((val, lIndex) => {
                                    let subChildColumData = {
                                        data_id: `cell_${this._bookingEntities[iIndex].children[jIndex].children[kIndex].id}_${lIndex}`,
                                        date: val.date
                                    }
                                    subChildColumns.push(subChildColumData);
                                    subChildBooked[lIndex] = 0;
                                });

                                let data = {
                                    data_id: `subchild_${this._bookingEntities[iIndex].children[jIndex].children[kIndex].id}`,
                                    label: this._bookingEntities[iIndex].children[jIndex].children[kIndex].label,
                                    id: this._bookingEntities[iIndex].children[jIndex].children[kIndex].id,
                                    propertyId: this._bookingEntities[iIndex].children[jIndex].propertyId,
                                    entitytype_id: this._bookingEntities[iIndex].id,
                                    entitychild1_id: this._bookingEntities[iIndex].children[jIndex].id,
                                    entitychild2_id: this._bookingEntities[iIndex].children[jIndex].children[kIndex].id,
                                    level: 3,
                                    setsize: this._bookingEntities[iIndex].children[jIndex].children.length,
                                    posinset: subChildPosinSet,
                                    datarowkeyvalue: this._bookingEntities[iIndex].id + '-' + jIndex + '-' + kIndex,
                                    ischild: false,
                                    columns: subChildColumns,
                                    total: '',
                                    booked: subChildBooked
                                };
                                children2.push(data);
                                this._mapBookingEntityIdRecord[this._bookingEntities[iIndex].children[jIndex].children[kIndex].id] = data;
                            }
                        }

                        let childColumns = [];
                        let childBooked = [];
                        this._columnDates.forEach((val, lIndex) => {
                            let childColumData = {
                                data_id: `cell_${this._bookingEntities[iIndex].children[jIndex].id}_${lIndex}`,
                                date: val.date
                            }
                            childColumns.push(childColumData);
                            childBooked[lIndex] = 0;
                        });

                        let data = {    //this data represents units data
                            data_id: `child_${this._bookingEntities[iIndex].children[jIndex].id}`,
                            label: this._bookingEntities[iIndex].children[jIndex].label,
                            id: this._bookingEntities[iIndex].children[jIndex].id,
                            propertyId: this._bookingEntities[iIndex].children[jIndex].propertyId,
                            entitytype_id: this._bookingEntities[iIndex].id,
                            entitychild1_id: this._bookingEntities[iIndex].children[jIndex].id,
                            entitychild2_id: '',
                            level: 2,
                            setsize: this._bookingEntities[iIndex].children.length,
                            posinset: childPosinSet,
                            datarowkeyvalue: this._bookingEntities[iIndex].id + '-' + jIndex,
                            ischild: children2.length > 0 ? true : false,
                            columns: childColumns,
                            totalchildren: children2.length,
                            children: children2,
                            total: children2.length > 0 ? children2.length : '',
                            booked: childBooked,
                            dirtyValid: false,
                            title:''
                        };
                        this.selectedUniT = `child_${this._bookingEntities[iIndex].children[jIndex].id}`;
                        this.unitIdToCheck = this._bookingEntities[iIndex].children[jIndex].id;
                        this.modifyData = data;
                        this.handleStyle(this.selectedUniT,this.modifyData);
                        data=this.modifyData
                        children1.push(data);
                        this._mapBookingEntityIdRecord[this._bookingEntities[iIndex].children[jIndex].id] = data;
                    }
                }

                let parentColumns = [];
                let parentbooked = [];
                this._columnDates.forEach((val, lIndex) => {
                    let parentColumData = {
                        data_id: `cell_${this._bookingEntities[iIndex].id}_${lIndex}`,
                        date: val.date
                    }
                    parentColumns.push(parentColumData);
                    parentbooked[lIndex] = 0;
                });

                let total = 0;
                let isSubchild = false;
                children1.forEach((val, i) => {
                    if (val.ischild) {
                        isSubchild = true;
                        total = parseFloat(total + val.total);
                    }
                    else
                        total = parseFloat(total + val.total);
                });

                if (!isSubchild) {
                    total = children1.length;
                }

                let data = {    //This data represents unit types data.
                    data_id: `parent_${this._bookingEntities[iIndex].id}`,
                    label: this._bookingEntities[iIndex].label,
                    id: this._bookingEntities[iIndex].id,
                    propertyId: this._bookingEntities[iIndex].propertyId,
                    level: 1,
                    entitytype_id: this._bookingEntities[iIndex].id,
                    entitychild1_id: '',
                    entitychild2_id: '',
                    setsize: this._bookingEntities.length,
                    posinset: parentPosinSet,
                    ischild: children1.length > 0 ? true : false,
                    totalchildren: children1.length,
                    datarowkeyvalue: this._bookingEntities[iIndex].id,
                    children: children1,
                    columns: parentColumns,
                    total: total === 0 ? '' : total,
                    booked: parentbooked
                };
                this._arrbookingEntities.push(data);
                this._mapBookingEntityIdRecord[this._bookingEntities[iIndex].id] = data;
            }
            this._hasRenderedBookingEntity = true;
        }
    }
    async handleStyle(selectedUnit,modifyData) {
        let DirtyFieldValue;
        await getUnitRecord({
            unitId: this.unitIdToCheck
        }).then(result => {
            DirtyFieldValue = JSON.parse(JSON.stringify(result[0].dirty));
            if (DirtyFieldValue !== false) {

                let selected = this.template.querySelectorAll(`[data-id="${selectedUnit}"]`);
                selected[1].classList.add('dirtyclass');
                modifyData['title'] = 'Right click here to Mark Clean';
            }else{
                 modifyData['title'] = 'Right click here to Mark Dirty';
            }
        }).catch(error => {

        });
    }

    renderBookingData() {
        if (this._mapBookingEntityIdRecord) {
            //Removed exsting booked div
            let existingBookedAndInterruptedDivs = this.template.querySelectorAll('[class="booked"], [class="interrupted"]');

            if (existingBookedAndInterruptedDivs && existingBookedAndInterruptedDivs.length > 0) {
                for (let div of existingBookedAndInterruptedDivs) {
                    div.parentNode.innerHTML = '';
                }
            }
            //Booking grid right click disable 
            let a =this.template.querySelector('.slds-grid.slds-wrap.slds-p-around_x-small.booking-grid')
             if(a){
                    a.addEventListener('contextmenu', function (e) {  
                        e.preventDefault(); 
                    }, false);
            }
            this._templateWidth = this.template.querySelectorAll("[class='slds-grid slds-wrap slds-p-around_x-small booking-grid']")[0].offsetWidth;
            //Determine first column so based on which reservation divs can be calculated
            let firstCol = this.template.querySelectorAll("[data-id=date_0]");
            this.setColumnWidth(firstCol);
            let cellInnerWidth = firstCol[0].clientWidth; //inner width
            this._oneDayReservation = {};
            this._mapEntityRowIdWithoutUnit = new Map();
            for (let iIndex = 0; iIndex < this._bookingData.length; ++iIndex) {
                let bookingRecord = this._bookingData[iIndex];
                let bookingdataRowId;
                let row;
                let rowId;

                if (!bookingRecord.entitytype_id)
                    continue;

                let startDate = new Date(bookingRecord.startdate);
                startDate.setHours(0, 0, 0, 0);
                let endDate = new Date(bookingRecord.enddate);
                endDate.setHours(0, 0, 0, 0);
                //end date is less then current column date then skip
                if (endDate < this._columnDates[0].date || startDate > this._columnDates[this._columnDates.length - 1].date)
                    continue;

                if (bookingRecord.entitytype_id && !bookingRecord.entitychild1_id && !bookingRecord.entitychild2_id) {
                    this.calculateTotalBookedUnit(startDate, endDate, bookingRecord.entitytype_id, true);
                    //if child row is exists do not render booking info on parent cell cells
                    if (this._mapBookingEntityIdRecord[bookingRecord.entitytype_id] !== undefined && this._mapBookingEntityIdRecord[bookingRecord.entitytype_id].ischild) {
                        continue;
                    }
                    rowId = bookingRecord.entitytype_id;
                    row = this.template.querySelectorAll(`[data-id="parent_${rowId}"]`);
                } else {
                    if (bookingRecord.entitytype_id && bookingRecord.entitychild1_id && !bookingRecord.entitychild2_id) {
                        this.calculateTotalBookedUnit(startDate, endDate, bookingRecord.entitytype_id, false);
                        this.calculateTotalBookedUnit(startDate, endDate, bookingRecord.entitychild1_id, true);
                        if (this._mapBookingEntityIdRecord[bookingRecord.entitychild1_id] !== undefined && this._mapBookingEntityIdRecord[bookingRecord.entitychild1_id].ischild) {
                            continue;
                        }
                        rowId = bookingRecord.entitychild1_id;
                        row = this.template.querySelectorAll(`[data-id="child_${rowId}"]`);
                    } else if (bookingRecord.entitytype_id && bookingRecord.entitychild1_id && bookingRecord.entitychild2_id) {
                        this.calculateTotalBookedUnit(startDate, endDate, bookingRecord.entitytype_id, false);
                        this.calculateTotalBookedUnit(startDate, endDate, bookingRecord.entitychild1_id, false);
                        rowId = bookingRecord.entitychild2_id;
                        row = this.template.querySelectorAll(`[data-id="subchild_${rowId}"]`);
                    }
                }
                bookingdataRowId = 'booked_' + rowId;
                if (rowId) {
                    this.setReservedDataOnGrid(bookingdataRowId, 'booked', bookingRecord, row, rowId, cellInnerWidth, startDate, endDate);
                }
            }
            //End for

            for (let iIndex = 0; iIndex < this._serviceInterruptionData.length; ++iIndex) { //data for service interruption
                let serviceInterruptionRecord = this._serviceInterruptionData[iIndex];
                let row;
                let rowId;

                if (!serviceInterruptionRecord.entitychild1_id) {
                    continue;
                }

                let startDate = new Date(serviceInterruptionRecord.startdate);
                startDate.setHours(0, 0, 0, 0);
                let endDate = new Date(serviceInterruptionRecord.enddate);
                endDate.setHours(0, 0, 0, 0);

                if (endDate < this._columnDates[0].date || startDate > this._columnDates[this._columnDates.length - 1].date) {
                    continue;
                }


                if (serviceInterruptionRecord.entitytype_id && serviceInterruptionRecord.entitychild1_id && !serviceInterruptionRecord.entitychild2_id) {
                    this.calculateTotalBookedUnit(startDate, endDate, serviceInterruptionRecord.entitytype_id, false);
                    this.calculateTotalBookedUnit(startDate, endDate, serviceInterruptionRecord.entitychild1_id, false);
                    if (this._mapBookingEntityIdRecord[serviceInterruptionRecord.entitychild1_id] !== undefined && this._mapBookingEntityIdRecord[serviceInterruptionRecord.entitychild1_id].ischild) {
                        continue;
                    }
                    rowId = serviceInterruptionRecord.entitychild1_id;
                    row = this.template.querySelectorAll(`[data-id="child_${rowId}"]`);
                } else if (serviceInterruptionRecord.entitytype_id && serviceInterruptionRecord.entitychild1_id && serviceInterruptionRecord.entitychild2_id) {
                    this.calculateTotalBookedUnit(startDate, endDate, serviceInterruptionRecord.entitychild1_id, false);
                    rowId = serviceInterruptionRecord.entitychild2_id;
                    row = this.template.querySelectorAll(`[data-id="subchild_${rowId}"]`);
                }
                let serviceInterruptionDataRow = 'interrupted_' + rowId;
                if (rowId) {
                    this.setReservedDataOnGrid(serviceInterruptionDataRow, 'interrupted', serviceInterruptionRecord, row, rowId, cellInnerWidth, startDate, endDate);
                }
            }
            let newBookedDivs = this.template.querySelectorAll('[class="booked"], [class="interrupted"]');
            if (newBookedDivs && newBookedDivs.length > 0) {
                for (let div of newBookedDivs) {
                    if (div.className === 'booked') {
                        div.addEventListener('mousedown', this.existingBookingClicked.bind(this));
                    } else {
                        div.addEventListener('mousedown', this.existingInterruptionClicked.bind(this));
                    }
                    div.addEventListener('contextmenu', function (event) { event.preventDefault(); }, false);
                }
            }
        }
 }
   

    setReservedDataOnGrid(dataRowId, className, recordDetails, row, rowId, cellInnerWidth, startDate, endDate) {
        let left = 0, width = cellInnerWidth;
        let startCellPos = 0;
        let strTitle = className === 'booked' ? recordDetails.name + "(" + recordDetails.status + ")" : recordDetails.name;
        //assigend left -8 for width adjustment and 0.5 added to cellOuterWidth to adjust width
        if (this.getDiffDays(startDate, endDate) === 0) {
            startCellPos = this.getDiffDays(this._columnDates[0].date, startDate);
            left = Math.floor(this.cellOuterWidth * 1 / 4) - 8;
            width = cellInnerWidth / 2;
        } else {
            if (startDate < this._columnDates[0].date) {
                //continuefromleft
                left = -8;
            }
            else {
                left = Math.floor(this.cellOuterWidth / 2) - 8;
                startCellPos = this.getDiffDays(this._columnDates[0].date, startDate);
            }
            if (endDate > this._columnDates[this._columnDates.length - 1].date) {
                //'continuetoright'
                width = Math.floor((1 + this.getDiffDays(startDate, this._columnDates[this._columnDates.length - 1].date)) * cellInnerWidth) - Math.floor(cellInnerWidth / 2);
                if (endDate > this._columnDates[this._columnDates.length - 1].date && startDate <= this._columnDates[0].date) {
                    width = (1 + this.getDiffDays(this._columnDates[0].date, this._columnDates[this._columnDates.length - 1].date)) * this.cellOuterWidth;
                }
            }
            else {
                if (startDate < this._columnDates[0].date) {
                    width = this.getDiffDays(this._columnDates[0].date, endDate) * this.cellOuterWidth + Math.floor(this.cellOuterWidth / 2);
                }
                else {
                    width = this.getDiffDays(startDate, endDate) * (this.cellOuterWidth + 0.5);
                }
            }
        }

        let strStyle = recordDetails.status === 'Checked In' ? (" left: " + left + "px;width: " + width + "px; background-color: #4bca81;") :
            recordDetails.status === 'Checked Out' ? (" left: " + left + "px;width: " + width + "px; background-color: #ea7470;") :
                (" left: " + left + "px;width: " + width + "px");
        //let strStyle = " left: " + left + "px;width: " + width + "px";
        let divBooked = `<div title="${strTitle}" style="${strStyle}" class="${className}" data-row-id="${dataRowId}" data-id="${recordDetails.id}">${recordDetails.name}</div>`;
        if(row[0].querySelectorAll(`[data-id="cell_${rowId}_${startCellPos}"]`)[0] !== undefined) {
            row[0].querySelectorAll(`[data-id="cell_${rowId}_${startCellPos}"]`)[0].innerHTML = divBooked;
        }
    }

    // This method is used to calculate booked units on that particular day
    calculateTotalBookedUnit(startDate, endDate, entityId, isWithoutUnitBooking) {
        let iStart = this.getDiffDays(this._columnDates[0].date, startDate);
        let iEnd = this.getDiffDays(this._columnDates[0].date, endDate);
        let oneDayRes = iStart === iEnd;
        iStart = (iStart < 0) ? 0 : iStart;
        iEnd = (iEnd > this._columnDates.length - 1) ? this._columnDates.length - 1 : iEnd;

        if (oneDayRes) {
            if (this._mapBookingEntityIdRecord[entityId] && this._mapBookingEntityIdRecord[entityId].booked && this.getDiffDays(this._columnDates[0].date, startDate) >= 0)
                this._oneDayReservation[entityId + '_' + iStart] = iStart;
        } else {
            let iEndCount = (this.getDiffDays(this._columnDates[0].date, endDate) > this._columnDates.length - 1) ? this._columnDates.length : iEnd;
            for (let iCol = iStart; iCol < iEndCount; iCol++) {
                if (this._mapBookingEntityIdRecord[entityId] && this._mapBookingEntityIdRecord[entityId].booked) {
                    if (!this._mapBookingEntityIdRecord[entityId].booked[iCol])
                        this._mapBookingEntityIdRecord[entityId].booked[iCol] = 0;
                    ++this._mapBookingEntityIdRecord[entityId].booked[iCol];
                    if (isWithoutUnitBooking) {
                        this._mapEntityRowIdWithoutUnit[entityId + "_" + iCol] = true;
                    }
                }
            }
        }
    }

    //This method is used to calculate total remaining units
    calculateTotalBookingUnits() {
        let columnDates = this._columnDates;
        let oneDayReservation = this._oneDayReservation;
        let template = this.template;
        let mapBookingRowIdWithoutUnit = this._mapEntityRowIdWithoutUnit;
        Object.values(this._mapBookingEntityIdRecord).forEach(function (bookingEntity) {
            columnDates.forEach((date, iCol) => {
                let totalCount = bookingEntity.total;
                if (totalCount === '')
                    return;
                let cell = template.querySelector(`[data-id="cell_${bookingEntity.id}_${iCol}"]`);
                let divdata = ` <div class="slds-grid slds-grid_vertical-align-center slds-has-flexi-truncate slds-align_absolute-center bookingCell ">${totalCount}</div>`;
                if (bookingEntity.booked[iCol] === 0) {
                    divdata = ` <div class="slds-grid slds-grid_vertical-align-center slds-has-flexi-truncate slds-align_absolute-center bookingCell"><a data-id="${bookingEntity.id}" class="entitybooking">${totalCount}</a></div>`;
                    if (mapBookingRowIdWithoutUnit && mapBookingRowIdWithoutUnit[bookingEntity.id + '_' + iCol]) {
                        divdata = ` <div class="slds-grid slds-grid_vertical-align-center slds-has-flexi-truncate slds-align_absolute-center bookingCell "><a data-id="${bookingEntity.id}" class="entitybooking">${totalCount}</a></div>`;
                    }
                    if(cell !== null) {
                        cell.innerHTML = divdata;
                    }
                } else {
                    let totalAvailable = totalCount - bookingEntity.booked[iCol];
                    divdata = ` <div class="slds-grid slds-grid_vertical-align-center slds-has-flexi-truncate slds-align_absolute-center bookingCell"><a data-id="${bookingEntity.id}" class="entitybooking">${totalAvailable}</a></div>`;
                    // divdata = ` <div class="slds-grid slds-grid_vertical-align-center slds-has-flexi-truncate slds-align_absolute-center">${totalAvailable}578</div>`;
                    if (mapBookingRowIdWithoutUnit && mapBookingRowIdWithoutUnit[bookingEntity.id + '_' + iCol]) {
                        divdata = ` <div class="slds-grid slds-grid_vertical-align-center slds-has-flexi-truncate slds-align_absolute-center bookingCell "><a data-id="${bookingEntity.id}" class="entitybooking">${totalAvailable}</a></div>`;
                    }
                    if(cell !== null) {
                        cell.innerHTML = divdata;
                    }
                }
            });
        });
        //End for
        let entitybookings = this.template.querySelectorAll('[class="entitybooking"]');
        if (entitybookings && entitybookings.length > 0) {
            for (let entitybooking of entitybookings) {
                entitybooking.addEventListener('click', this.entityBookingClicked.bind(this));
            }
        }
    }
    unitClicked(event) {
        if (event.which === 1) {//mouse left click

        } else {
            event.preventDefault();
            this.isunitClicked = true;
            if (window.scrollY > 0) {
                this.x3 = event.pageX;
                this.y3 = event.pageY;
            } else {
                this.x3 = event.clientX;
                this.y3 = event.clientY;
            }
            this.isunitClicked = true;
            let selectedCellId = event.currentTarget.parentElement.getAttribute('data-id');
            this.selectedUniT = selectedCellId;
            const onunitclicked = new CustomEvent("unitclicked", {
                detail: {
                    selectedCellId: selectedCellId,
                    eventDetails: event,
                    bubbles: true,
                    composed: true
                }
            });
            this.isUnityClicked = true;
            this.dispatchEvent(onunitclicked);

        }

    }
    @api addstyle() {
        let selected = this.template.querySelectorAll(`[data-id="${this.selectedUniT}"]`);
        selected[1].classList.add('dirtyclass');
       this.renderBookingEntities();

    }
    @api removestyle() {

        let selected = this.template.querySelectorAll(`[data-id="${this.selectedUniT}"]`);
        selected[1].classList.remove('dirtyclass');

        this.renderBookingEntities();
    }
    getDiffDays(date1, date2) {
        date1.setHours(0, 0, 0, 0);
        date2.setHours(0, 0, 0, 0);
        const diffTime = Math.abs(new Date(date2) - new Date(date1));
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        if (date1 > date2)
            return -diffDays;
        return diffDays;
    }

    viewChange(event) {
        this._isLoaded = false;
        this._isSpinner = true;
        setTimeout(() => {
            this.gridView = event.detail.view;
            this.gridCurrentDate  = event.detail.selecteddate;
            this.calculateColumnDates();
            this.renderBookingEntities();
            this._isSpinner = false;
        }, 500);
    }

    // calulates dates
    calculateColumnDates() {
        // assign column date empty and recalutale on view change
        this._columnDates = [];
        let tempGridCurrentDate = new Date(this.gridCurrentDate );
        this.gridView = this.gridView.toUpperCase();
        switch (this.gridView) {
            case "WEEKLY":
                this._numberOfColumns = 7;
                break;
            case "BI-WEEKLY":
                this._numberOfColumns = 15;
                break;
            case "MONTHLY":
                this._numberOfColumns = this.daysInMonth(this.gridCurrentDate .getMonth() + 1, this.gridCurrentDate .getFullYear());
                if (this._numberOfColumns == 31 || this._numberOfColumns == 30)
                    tempGridCurrentDate = new Date(tempGridCurrentDate.setDate(16));
                else
                    tempGridCurrentDate = new Date(tempGridCurrentDate.setDate(15));
                break;
            default:
                this.gridView = "WEEKLY";
                this._numberOfColumns = 7;
        }

        let cureentDateRowNumber = Math.floor(this._numberOfColumns / 2);
        this._startDate = new Date(
            tempGridCurrentDate.setDate(tempGridCurrentDate.getDate() - cureentDateRowNumber)
        );

        let itrDate = new Date(this._startDate);
        itrDate.setHours(0, 0, 0, 0);
        for (let index = 0; index < this._numberOfColumns; index++) {
            let itrTempDate = new Date(itrDate);
            itrTempDate.setHours(0, 0, 0, 0);
            let date = {
                key: `date_${index}`,
                date: itrTempDate,
                day: `${itrTempDate.getDate()}`,
                dayName: `${dayNames[itrTempDate.getDay()].substring(0, 3)}`,
                dayFullName: `${dayNames[itrTempDate.getDay()]}`,
                month: `${itrTempDate.getMonth()}`,
                monthName: `${monthNames[itrTempDate.getMonth()].substring(0, 3)}`,
                monthFullName: `${monthNames[itrTempDate.getMonth()]}`,
                year: `${itrTempDate.getFullYear().toString().substr(-2)}`,
                monthAndYear: `${monthNames[itrTempDate.getMonth()]}_${itrTempDate.getFullYear()}`
            };
            this._columnDates.push(date);
            itrDate = new Date(itrDate.setDate(itrDate.getDate() + 1));
        }
        this._endDate = new Date(this._columnDates[this._columnDates.length - 1].date);

        if (this._startDate.getMonth() === this._endDate.getMonth()) {
            this._currentMonthAndYear = `${monthNames[this._startDate.getMonth()]} - ${this._startDate.getFullYear()}`;
        } else {
            this._currentMonthAndYear = `${monthNames[this._startDate.getMonth()].substring(0, 3)}-${monthNames[this._endDate.getMonth()].substring(0, 3)} - ${this._startDate.getFullYear()}`;
        }
    }

    //returns number of days in month
    daysInMonth(month, year) {
        return new Date(year, month, 0).getDate();
    }

    handleCollapseExpand(event) {
        let parentTr = event.target.closest('tr');
        let data_row_key_val = parentTr.getAttribute('data-row-key-value');
        if (data_row_key_val) {
            let isExpandParentTr = parentTr.getAttribute('aria-expanded');
            isExpandParentTr = isExpandParentTr === "true" ? "false" : "true";
            let ischildTr = this.template.querySelectorAll(`[data-row-key-value="${data_row_key_val}-0"]`);
            if (ischildTr && ischildTr.length > 0) {
                let getNumberofChilds = ischildTr[0].getAttribute('aria-setsize');
                for (let iIndex = 0; iIndex < getNumberofChilds; iIndex++) {
                    let childTr = this.template.querySelectorAll(`[data-row-key-value="${data_row_key_val}-${iIndex}"]`);
                    let isExpandChild = childTr[0].getAttribute('aria-expanded');
                    isExpandChild = isExpandParentTr === "false" ? "false" : isExpandChild;
                    let isSubChildTr = this.template.querySelectorAll(`[data-row-key-value="${data_row_key_val}-${iIndex}-0"]`);
                    if (isSubChildTr && isSubChildTr.length > 0) {
                        let getNumberofSubChilds = isSubChildTr[0].getAttribute('aria-setsize');
                        for (let jIndex = 0; jIndex < getNumberofSubChilds; jIndex++) {
                            let subChildTr = this.template.querySelectorAll(`[data-row-key-value="${data_row_key_val}-${iIndex}-${jIndex}"]`);
                            if (isExpandChild === "false") {
                                subChildTr[0].setAttribute('class', 'hide');
                            }
                            else {
                                subChildTr[0].setAttribute('class', 'slds-hint-parent');
                            }
                        }
                    }
                    if (isExpandParentTr === "false") {
                        childTr[0].setAttribute('class', 'hide');
                    }
                    else {
                        childTr[0].setAttribute('class', 'slds-hint-parent');
                    }
                    childTr[0].setAttribute('aria-expanded', isExpandChild);
                }
            }
            parentTr.setAttribute('aria-expanded', isExpandParentTr);
        }
    }

    deSelectCell() {
        let selected = this.template.querySelectorAll('.bg-selected-cell');
        for (let index = 0; index < selected.length; index++) {
            if (selected[index].getAttribute('class').includes('bg-selected-cell'))
                selected[index].classList.remove("bg-selected-cell");
        }
    }

    bindMouseEvents() {
        let listOfCell = this.template.querySelectorAll(".bookingCell");
        for (let iIndex = 0; iIndex < listOfCell.length; iIndex++) {
            let cell = listOfCell[iIndex];
            // eslint-disable-next-line no-loop-func
            cell.addEventListener('mouseup', (event) => {
                if (event.target.getAttribute('class').includes('bookingCell') || (!event.target.getAttribute('class').includes('booked') && !event.target.getAttribute('class').includes('interrupted'))) {
                    this.isMouseDown = false;
                    let selectedElement;
                    let selectedUnitElements = [];
                    this.selectedCellUnitType = [];
                    this.selectedCellUniySubType = [];
                    this.isSelectedUnitBooked = false;

                    if (window.scrollY > 0) {
                        this.x3 = event.pageX;
                        this.y3 = event.pageY;
                    }
                    else {
                        this.x3 = event.clientX;
                        this.y3 = event.clientY;
                    }

                    let element = this.template.elementFromPoint(this.x1, this.y1 - window.scrollY);
                    let startElement;
                    if(element.getAttribute('class').includes('entitybooking')){
                        startElement = element.parentElement.parentElement;
                    }else{
                        startElement = element.parentElement.getAttribute('class').includes('bookingCell') ? element.parentElement : element;
                    }
                    let date = new Date();

                    let startCell = startElement.getAttribute('data-id').split('_')[2];
                    
                    if (element.getAttribute('class').includes('selectmulticell')) {
                        element.style.display = 'none';
                    }
                    let endElement = this.template.elementFromPoint(this.x3, this.y3 - window.scrollY);
                    let endCellElement;
                    if(endElement.getAttribute('class').includes('entitybooking')){
                        endCellElement = endElement.parentElement.parentElement;
                    }else{
                        endCellElement = endElement.parentElement.getAttribute('class').includes('bookingCell') ? endElement.parentElement : endElement;
                    }
                    let endCell = endCellElement.getAttribute('data-id').split('_')[2];

                    let selectedCellHeight = Math.ceil(this._selectBoxHeight / this._cellHeight);
                    let selectedCellWidth = Math.ceil(this._selectBoxWidth / this._cellWidth);
                    for (let index = 0; index < selectedCellHeight; index++) {
                        for (let indexTwo = 0; indexTwo < selectedCellWidth; indexTwo++) {
                            if (this.x1 < this.x2 && this.y1 < this.y2) {
                                selectedElement = this.template.elementFromPoint((this.x1 + (indexTwo * this._cellWidth)), ((this.y1 + (index * this._cellHeight)) - window.scrollY));
                            }
                            else if (this.x1 < this.x2 && this.y1 > this.y2) {
                                selectedElement = this.template.elementFromPoint((this.x1 + (indexTwo * this._cellWidth)), ((this.y2 + (index * this._cellHeight)) - window.scrollY));
                            }
                            else if (this.x1 > this.x2 && this.y1 < this.y2) {
                                selectedElement = this.template.elementFromPoint((this.x2 + (indexTwo * this._cellWidth)), ((this.y1 + (index * this._cellHeight)) - window.scrollY));
                            }
                            else if (this.x1 > this.x2 && this.y1 > this.y2) {
                                selectedElement = this.template.elementFromPoint((this.x2 + (indexTwo * this._cellWidth)), ((this.y2 + (index * this._cellHeight)) - window.scrollY));
                            }
                            selectedElement = selectedElement.parentElement.getAttribute('class').includes('bookingCell') ? selectedElement.parentElement : selectedElement;

                            if (startCell && endCell && (this._columnDates[startCell].date < date.setHours(0, 0, 0, 0) || this._columnDates[endCell].date < date.setHours(0, 0, 0, 0))) {
                                this.showNotification('', PastDateSelected, 'error');
                                return false;
                            }

                            selectedUnitElements.push(parseInt(selectedElement.innerText, 0));
                            let num = parseInt(selectedElement.innerText, 0);
                            // eslint-disable-next-line @lwc/lwc/no-inner-html
                            if (selectedElement.innerHTML !== "") {
                                if (!Number.isInteger(num) && (selectedElement.firstChild.getAttribute('class').includes('booked') || selectedElement.firstChild.getAttribute('class').includes('interrupted'))) {
                                    this.isSelectedUnitBooked = true;
                                    this.selectedCellUniySubType.length = 0;
                                    break;
                                } else {
                                    if(selectedElement.parentElement.getAttribute('data-id').includes('cell')){
                                        this.selectedCellUnitType.push(selectedElement.parentElement);
                                    }else{
                                        this.selectedCellUnitType.push(selectedElement);
                                    }
                                }
                            }
                            else {
                                this.selectedCellUniySubType.push(selectedElement);
                            }
                        }
                    }
                    let isValidBookingForReservation = this.isValidBooking(selectedUnitElements);
                    if (isValidBookingForReservation && !this.isSelectedUnitBooked) {
                        if (this.selectedCellUnitType.length > 0) {
                            for (let index = 0; index < this.selectedCellUnitType.length; index++) {
                                this.selectedCellUnitType[index].classList.add('bg-selected-cell');
                            }
                            this.selectedItemForBooking(this.selectedCellUnitType);
                        }
                        else if (this.selectedCellUniySubType.length > 0) {
                            for (let index = 0; index < this.selectedCellUniySubType.length; index++) {
                                this.selectedCellUniySubType[index].classList.add('bg-selected-cell');
                            }
                            this.selectedItemForBooking(this.selectedCellUniySubType);
                        }
                        else {
                            if (this.isExistingBookingClicked || this.isSelectionComplete || this.isUnityClicked) {
                                const selectionComplete = new CustomEvent("selectioncomplete", {
                                    detail: ''
                                });
                                this.dispatchEvent(selectionComplete);
                            }
                            this.isUnityClicked = false;
                            this.isSelectionComplete = false;
                            this.isExistingBookingClicked = false;
                        }
                    }

                    this._isDivVisible = false;
                }
                return true;
            });
            cell.addEventListener('mousedown', (event) => {
                if (event.target.getAttribute('class').includes('bookingCell') || (!event.target.getAttribute('class').includes('booked') && !event.target.getAttribute('class').includes('interrupted'))) {
                    this.isMouseDown = true;
                    this._isDivVisible = true;
                    this.x1 = 0;
                    this.y1 = 0;
                    this.x2 = 0;
                    this.y2 = 0;
                    this._selectBoxLeft = 0;
                    this._selectBoxTop = 0;
                    this._selectBoxWidth = 0;
                    this._selectBoxHeight = 0;
                    this._divSize = 'left:' + this._selectBoxLeft + 'px; top:' + this._selectBoxTop + 'px; width:' + this._selectBoxWidth + 'px; height:' + this._selectBoxHeight + 'px;';

                    if (window.scrollY > 0) {
                        this.x1 = event.pageX;
                        this.y1 = event.pageY;
                    }
                    else {
                        this.x1 = event.clientX;
                        this.y1 = event.clientY;
                    }
                    let domElementFirst = this.template.elementFromPoint(this.x1, this.y1 - window.scrollY);
                    this._cellHeight = domElementFirst.clientHeight;
                    this._cellWidth = domElementFirst.clientWidth;
                    this.deSelectCell();
                }

            })
            cell.addEventListener('mousemove', (event) => {
                if (this.isMouseDown === true && event.which === 1) {
                    if (window.scrollY > 0) {
                        this.x2 = event.pageX;
                        this.y2 = event.pageY;
                    }
                    else {
                        this.x2 = event.clientX;
                        this.y2 = event.clientY;
                    }
                    this.reCalcalCulation();
                }
                else {
                    this.x1 = 0;
                    this.y1 = 0;
                    this.x2 = 0;
                    this.y2 = 0;
                    this._selectBoxLeft = 0;
                    this._selectBoxTop = 0;
                    this._selectBoxWidth = 0;
                    this._selectBoxHeight = 0;
                    this._divSize = 'left:' + this._selectBoxLeft + 'px; top:' + this._selectBoxTop + 'px; width:' + this._selectBoxWidth + 'px; height:' + this._selectBoxHeight + 'px;';

                }
            });
        }
    }

    

    reCalcalCulation() {
        if (this.x1 < this.x2) {
            this._selectBoxLeft = Math.ceil(this.x1);
            this._selectBoxTop = this.y1 < this.y2 ? Math.ceil(this.y1 - window.scrollY) : Math.ceil(this.y2 - window.scrollY);
        }
        else if (this.x1 > this.x2) {
            this._selectBoxLeft = Math.ceil(this.x2);
            this._selectBoxTop = this.y1 < this.y2 ? Math.ceil(this.y1 - window.scrollY) : Math.ceil(this.y2 - window.scrollY);
        }
        this._selectBoxWidth = Math.ceil(Math.abs(this.x2 - this.x1));
        this._selectBoxHeight = Math.ceil(Math.abs((this.y2 - window.scrollY) - (this.y1 - window.scrollY)));
        this._divSize = 'left:' + this._selectBoxLeft + 'px; top:' + this._selectBoxTop + 'px; width:' + this._selectBoxWidth + 'px; height:' + this._selectBoxHeight + 'px;';
    }

    

    handleSearch(event) {
        let filter, table, tr, td, i, txtValue;
        filter = event.target.value.toUpperCase();
        table = this.template.querySelectorAll("tbody");
        tr = table[0].getElementsByTagName("tr");
        let capturedRowCount = 0;
        for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td")[0];
            if (td) {
                txtValue = td.querySelector('div').textContent || td.querySelector('div').innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    capturedRowCount++;
                    tr[i].style.display = "";
                    this.noRecordFound = false;
                } else {
                    tr[i].style.display = "none";
                    if (capturedRowCount === 0) {
                        this.noRecordFound = true;
                    }
                }
            }
        }
    }

    
    entityBookingClicked(event) {
        let entityId = event.target.getAttribute('data-id');
        let cellarr = event.target.parentElement.parentElement.getAttribute('data-id').split('_');
        let itemNew = new Object();
        itemNew.id = entityId;
        itemNew.selectDate = this._columnDates[cellarr[2]].date;
        const onentityBookingClicked = new CustomEvent("entitybookingclicked", {
            detail: itemNew
        });
        this.dispatchEvent(onentityBookingClicked);
    }

    showNotification(_title, _message, _variant) {
        const evt = new ShowToastEvent({
            title: _title,
            message: _message,
            variant: _variant,
        });
        this.dispatchEvent(evt);
    }

    @api
    clearSelectedCell() {
        let listOfSelectedCell = this.template.querySelectorAll(".selected");
        if (listOfSelectedCell && listOfSelectedCell.length > 0) {
            listOfSelectedCell.forEach(function (cell) {
                cell.classList.remove("selected");
            });
        }
    }
}