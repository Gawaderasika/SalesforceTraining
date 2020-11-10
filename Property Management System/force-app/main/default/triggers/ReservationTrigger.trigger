trigger ReservationTrigger on Reservation__c (before insert, after insert, before update, after update, before delete, after delete) {
	TriggerManager.execute('Reservation__c');
}