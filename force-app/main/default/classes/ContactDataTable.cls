public with sharing class ContactDataTable {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [
            SELECT firstname, lastname, phone
            FROM Contact
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate desc
            limit 9
        ];
    }
}
