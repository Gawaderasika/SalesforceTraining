public with sharing class AccountWithSharing {
    public account c {get; set;}
	//List<account> lstAcc = new List<account>(Select Id, Name from account where name Like 'Account-%');
    public AccountWithSharing(){
        Id id = ApexPages.currentPage().getParameters().get('id');
        c = [SELECT Id, Number_of_Contacts__c FROM account where id = :id];
    }
}