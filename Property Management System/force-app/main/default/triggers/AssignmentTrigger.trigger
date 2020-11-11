trigger AssignmentTrigger on Assignment__c (before insert, after insert, before update, after update, before delete, after delete) {
TriggerManager.execute('Assignment__c');
}