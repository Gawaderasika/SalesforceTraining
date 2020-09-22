@isTest
private class TestRestrictContactByName {
    @isTest static void TestRestrict() {
    	List<Contact> con = new List<Contact>();
        Contact c1 = new Contact(FirstName='abcd',LastName = 'INVALIDNAME');
        con.add(c1);
        Test.startTest();
        try{insert con;}
        catch(Exception ee){}
        Test.stopTest();
    }
}