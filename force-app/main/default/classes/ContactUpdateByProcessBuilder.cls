/********************************************************************** 
Name: ContactUpdateByProcessBuilder
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Call apex from process builder
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 07/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
public class ContactUpdateByProcessBuilder {
    
	@invocableMethod
    public static void updateContact(List<Id> accId){
        List<Contact> con = [SELECT Id, contactAddress__c, Email FROM Contact WHERE Account.Id in :accId
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
                TriggerHelperClass.sendMail(c.Email,'Test','This is test mail');
            }
            catch(Exception ee){}
        }
    }
}