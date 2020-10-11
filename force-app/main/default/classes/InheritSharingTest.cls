@isTest
public class InheritSharingTest {
    
    @isTest()
	public static void testRunAs() {
        User u = [SELECT Id FROM User WHERE Id = '0052w000006NQ8L'];
        System.runAs(u) {
        	Student__c stud = new Student__c(Student_Name__c='testName');
			insert stud ;
			//then call the method
			Test.startTest();
			JobApexRecordWithoutSharing s=new JobApexRecordWithoutSharing();
 			s.getStudents();
            System.debug('success');
            Test.stopTest();
        }
    }
}