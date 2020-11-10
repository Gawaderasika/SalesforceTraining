@isTest
public with sharing class  UtilityTest {
    
    @isTest 
    static void getActiveRecordTypesByDevName(){
        List<Contact> lstOfContacts = TestDataFactory.createContacts(2);
        system.assertEquals(lstOfContacts[0].Id != Null,false);

        insert lstOfContacts;
         Map<String, Id> mapRecordTypes = Utility.getActiveRecordTypesByDevName(lstOfContacts[0]);
         system.assertEquals(lstOfContacts[0].Id != Null,true);

    }
}