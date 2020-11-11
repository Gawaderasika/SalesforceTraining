import { LightningElement, api, track } from 'lwc';

export default class DemoBookingGridHeader extends LightningElement {

    @track _totalColumns;
    @api selectedDate = new Date();
    @api numberOfColumns;
    @api view = "WEEKLY";
    @api currentMonthYear;
    @track _selectedDate;
    @api isSpinner;

    connectedCallback() {
        this.setSelectedDate();
    }

    setSelectedDate() {
        if (this.selectedDate)
            this._selectedDate = this.formatDate(new Date(this.selectedDate));
    }

    viewChange(event) {
        this.view = event.target.innerHTML.toUpperCase();
        this.handleViewChange();
    }

    handelDateChange(event) {
        if (event && event.target.value) {
            let date = event.target.value;
            this.selectedDate = new Date(date);
        }
        this.handleViewChange();
    }

    handleViewChange() {
        this.setSelectedDate();       
        const selectedEvent = new CustomEvent("viewchange", {
            detail: {
                view: this.view,
                selecteddate: this.selectedDate,
                numberOfcolumns: this.numberOfColumns
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    previous() {
        switch (this.view) {
            case "WEEKLY":
                this.selectedDate = new Date(
                    this.selectedDate.setDate(this.selectedDate.getDate() - 7)
                );
                this.handleViewChange();
                break;

            case "BI-WEEKLY":
                this.selectedDate = new Date(
                    this.selectedDate.setDate(this.selectedDate.getDate() - 15)
                );
                this.handleViewChange();
                break;

            case "MONTHLY":
                this.selectedDate = new Date(
                    this.selectedDate.setDate(this.selectedDate.getDate() - 30)
                );
                this.handleViewChange();
                break;
            default:
                break;
        }

    }
    next() {
        switch (this.view) {
            case "WEEKLY":
                this.selectedDate = new Date(
                    this.selectedDate.setDate(this.selectedDate.getDate() + 7)
                );
                this.handleViewChange();
                break;

            case "BI-WEEKLY":
                this.selectedDate = new Date(
                    this.selectedDate.setDate(this.selectedDate.getDate() + 15)
                );
                this.handleViewChange();
                break;

            case "MONTHLY":
                this.selectedDate = new Date(
                    this.selectedDate.setDate(this.selectedDate.getDate() + 30)
                );
                this.handleViewChange();
                break;
            default:
                break;
        }

    }


    formatDate(date) {
        let d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;

        return [year, month, day].join('-');
    }
}