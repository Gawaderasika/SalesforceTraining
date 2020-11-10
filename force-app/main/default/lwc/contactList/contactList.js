import { LightningElement, wire } from 'lwc';
import FirstName_Field from '@salesforce/schema/Contact.FirstName';
import LastName_Field from '@salesforce/schema/Contact.LastName';
import Phone_Field from '@salesforce/schema/Contact.Phone';
import getContacts from '@salesforce/apex/ContactDataTable.getContacts';

const COLUMNS = [
    { label: 'First Name', fieldName: FirstName_Field.fieldApiName, type: 'text' },
    { label: 'Last Name', fieldName: LastName_Field.fieldApiName, type: 'text' },
    { label: 'Phone', fieldName: Phone_Field.fieldApiName, type: 'number' }
];

export default class ContactList extends LightningElement {
    columns = COLUMNS;
    @wire(getContacts)
    contacts;
}