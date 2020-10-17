import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class Contact extends LightningElement {
    objectApiName = CONTACT_OBJECT;
    fields=[FIRSTNAME_FIELD, LASTNAME_FIELD, EMAIL_FIELD];
    handleSuccess(event){
        const toastevent = new ShowToastEvent({
            title: "Contact created",
            message: "Record Id: "+event.detail.id,
            variant: success
        });
        this.dispatchEvent(toastevent);
    }
}