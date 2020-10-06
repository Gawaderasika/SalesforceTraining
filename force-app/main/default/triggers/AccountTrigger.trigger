trigger AccountTrigger on Account (after insert, after update, before delete, after delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        System.enqueueJob(new ContactCreationqueueable(Trigger.new)); //Trigger.new has list of accounts that are created
        //helperClassCountContactLevels.primaryLevels(Trigger.new);
        //List<Contact> cntList = new List<Contact>([SELECT Id, Level__c FROM Contact WHERE Level__c = 'Primary']);
    	//integer count = cntList.size();
    	//System.debug(count);
    }
    
    // Prevent the deletion of accounts if they have related opportunities.
    for (Account a : [SELECT Id FROM Account
                     WHERE Id IN (SELECT AccountId FROM Opportunity) AND
                     Id IN :Trigger.old]) {
        Trigger.oldMap.get(a.Id).addError(
            'Test-method: Cannot delete account with related opportunities.');
    }
}

//AccountTriggerForContact
//AccountDeletion
//countContactLevels