public with sharing class contactLWC {
    public contactLWC(){
        
    }
    @AuraEnabled(cacheable=true)
    public static list<Contact> getContacts(){
        return [Select id, firstname, lastname, email from contact];
    }
}