trigger UnitTypeReservationTrigger on Unit_Type_Reservation__c (before insert, after insert, before update, after update, before delete, after delete) {
	TriggerManager.execute('Unit_Type_Reservation__c');
}