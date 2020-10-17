public inherited sharing class contactCrud {
    
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts(){
        return [SELECT Id, FirstName,LastName, Phone FROM Contact ORDER BY CreatedDate desc];
    }
    
    @AuraEnabled
    public static void deleteContacts(list<Id> lstConIds){
        try {
            list<Contact> lstConsToDelete = new list<Contact>();
            System.debug('lstConIds ====> '+lstConIds);
            for(Id idCon : lstConIds) {
                lstConsToDelete.add(new Contact(Id = idCon));
            }
            if(!lstConsToDelete.isEmpty()) {
                delete lstConsToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}