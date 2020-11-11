public class TrReservationUpdateUTROnCancel implements Callable{
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        updateUTROnCancelReservation( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords'), (Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords'));
        return null;
    }
    
    public void updateUTROnCancelReservation(List<Reservation__c> lstReservations, Map<Id, SObject> mapOldReservations){
        Set<Id> setReservationIds = new Set<Id>();
        for(Reservation__c objReservation: lstReservations){
            Reservation__c objOldReservation = (Reservation__c)mapOldReservations.get(objReservation.Id);
            if(objReservation.Action__c == 'Cancel Reservation' && objReservation.Cancellation_Reason__c == Null){
                objReservation.addError('You cannot cancel reservation without cancellation reason');
            }else if(objReservation.Action__c == 'Cancel Reservation' && objReservation.Cancellation_Reason__c != objOldReservation.Cancellation_Reason__c){
                setReservationIds.add(objReservation.Id);
            }
        }
        List<Unit_Type_Reservation__c> lstUTRToUpdate = new List<Unit_Type_Reservation__c>();
        for(Unit_Type_Reservation__c objUTR: [SELECT Id ,Name, Action__c, Cancellation_Reason__c, Other_Reason__c, Reservation__c, Status__c, Unit_Type__c, Unit__c FROM Unit_Type_Reservation__c WHERE Reservation__c IN: setReservationIds WITH SECURITY_ENFORCED]){
            if(Schema.sObjectType.Unit_Type_Reservation__c.fields.Cancellation_Reason__c.isUpdateable()){
                objUTR.Cancellation_Reason__c = 'Reservation Cancelled';
            }
            if(Schema.sObjectType.Unit_Type_Reservation__c.fields.Status__c.isUpdateable()){
                objUTR.Status__c = 'Cancelled';
            }
            lstUTRToUpdate.add(objUTR);
        }
        if(!lstUTRToUpdate.isEmpty() && Schema.sObjectType.Unit_Type_Reservation__c.isUpdateable()){
            Update lstUTRToUpdate;
        }
    }
}