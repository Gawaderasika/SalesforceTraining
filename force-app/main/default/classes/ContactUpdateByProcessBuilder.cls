public class ContactUpdateByProcessBuilder {
	@invocableMethod
    public static void updateContact(List<Id> accId){
        List<Contact> con = [SELECT Id,contactAddress__c FROM Contact WHERE Account.Id in :accId
                           and Name Like '%test%'];
        Account acc = [SELECT Id,accountAddress__c FROM Account WHERE Account.Id in :accId];
        for(Contact c: con){
        	try{
                System.debug('contact address: '+c.contactAddress__c);
                System.debug('account address: '+acc.accountAddress__c);
                c.contactAddress__c = acc.accountAddress__c;
                System.debug('contact address: '+c.contactAddress__c);
                System.debug('account address: '+acc.accountAddress__c);
                update con;
            }
            catch(Exception ee){}
        }
    }
    /*public static void emailContact(List<String> emailId){
        List<Contact> con = [SELECT Id FROM Contact WHERE Account.AccountEmail__c in :emailId
                           and Name = 'test'];
        for(Contact c: con){
        	try{
                
            }
            catch(Exception ee){}
        }
    }*/
}