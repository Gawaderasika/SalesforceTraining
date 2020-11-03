trigger ServiceInterruptionTrigger on Service_Interruption__c (before insert, before update) {
	TriggerManager.execute('Service_Interruption__c');
}