public class ContactHelperClass {
    
	public static void primaryLevels(List<Contact> conList){
        
        //Integer primaryLevel = 0;
        //List<Contact> ContactList = new List<Contact>([SELECT Id, AccountLevel__c, Level__c FROM Contact where AccountLevel__c!=null]);
        /*for(Contact con: conList){
            if(con.LastName == 'lastName123'){
                try{
                    //System.debug('primary');
                    //primaryLevel++;
                    //System.debug('primary');
                    con.Languages__c = 'abd';
                	//con.Account.Primary_Contact__c = 1;
                }
                catch(Exception e){
            		System.debug(e);
        		}
            }
        }*/
        for (Contact con:conList) {
        	if (con.Level__c == 'Primary') {
                try{
                    con.Account.Primary_Contact__c = 20;
                	System.debug(con.Account.Primary_Contact__c);
                }
                catch(System.NullPointerException e){
                    System.debug('This is null value');
                }
        	}
    	}
    }
    public static void duplicateContacts(List<Contact> conList){
        Set <String> lstName = new Set<String>(); 
    	for (Contact con:conList) {
        	lstName.add(con.lastName);
    	}
    	//List <Contact> contactList = new List<Contact>();
    	List <Contact> contactlist = [SELECT lastName FROM Contact WHERE lastName IN :lstName];
		for (Contact con:conList) {
        	If (contactList.size() > 0) {
            	con.lastName.adderror( 'No duplicate contacts allowed' );
        	}
    	}
    }
}