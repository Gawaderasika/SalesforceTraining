@isTest
public class InheritSharingTest {
    
    @isTest()
	public static void testRunAs() {
        User u = [SELECT Id FROM User WHERE Id = '0052w000006NQ8L'];
        System.runAs(u) {
        	System.debug('Current User: ' + UserInfo.getUserName());
            
        }
    }
}