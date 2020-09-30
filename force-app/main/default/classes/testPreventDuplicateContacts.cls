@isTest
public class testPreventDuplicateContacts {
	@isTest static void duplicateContacts(){
        List<Contact> cntList = new List<Contact>();
        Contact newContact = new Contact(lastName = 'Chaudhari');
        cntList.add(newContact);
        Contact newContact1 = new Contact(lastName = 'Chaudhari');
        cntList.add(newContact1);
        Test.startTest();
        try{
            insert cntList;
        }
        catch(Exception ee){}
    	Test.stopTest();
    }
}