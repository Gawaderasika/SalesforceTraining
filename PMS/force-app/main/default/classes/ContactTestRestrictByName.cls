/********************************************************************** 
Name: ContactTestRestrictByName
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Test method for ContactTrigger
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class ContactTestRestrictByName {
    @isTest static void TestRestrict() {
    	List<Contact> con = new List<Contact>();
        Contact c1 = new Contact(FirstName='abcd',LastName = 'INVALIDNAME');
        con.add(c1);
        Test.startTest();
        try{insert con;}	//remove try-catch
        catch(Exception ee){}
        Test.stopTest();
    }
}
//TestRestrictByName