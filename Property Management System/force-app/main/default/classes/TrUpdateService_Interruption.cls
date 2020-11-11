public with sharing class TrUpdateService_Interruption implements Callable{    
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        validateRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords') ,(Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords'));
        return null;
    }
    
    public void validateRecord(List<Service_Interruption__c> lstNewServiceInterruption, Map<Id, sObject> mapOldRecords){
        List<Id> lstUnitIds = new List<Id>();
        List<Id> lstServiceInterruptionIds = new List<Id>();
        TrCreateService_Interruption objTrCreateServiceInterruption = new TrCreateService_Interruption();
        
        for(Service_Interruption__c serviceInterruptionRec : lstNewServiceInterruption){
            if(serviceInterruptionRec.Start_Date__c != NULL && serviceInterruptionRec.End_Date__c != NULL){
          
                if(serviceInterruptionRec.Start_Date__c > serviceInterruptionRec.End_Date__c){
                    serviceInterruptionRec.addError(System.label.EndDateShouldBeGreaterThenStartDate);
                    break;
                } 
                else if(serviceInterruptionRec.End_Date__c < system.today()){
                    serviceInterruptionRec.addError(System.label.EndDateShouldBeGreaterThenStartDate);  
                 }
                if(serviceInterruptionRec.Unit__c != NULL){
                    lstUnitIds.add(serviceInterruptionRec.Unit__c);
                    lstServiceInterruptionIds.add(serviceInterruptionRec.Id);
                }
            }
            else{
            	serviceInterruptionRec.addError(System.Label.PleaseCheckStartDateAndEndDate);
            }
            if(serviceInterruptionRec.Action__c == 'Cancel Interruption' && serviceInterruptionRec.Cancellation_Reason__c == Null){
                    serviceInterruptionRec.addError(System.Label.Can_t_cancel_service_interruption);
            }
            if(String.isEmpty(serviceInterruptionRec.Cancellation_Reason__c) && !String.isEmpty(serviceInterruptionRec.Interruption_Reason__c) && serviceInterruptionRec.Interruption_Reason__c.toLowerCase() != 'other'){
                serviceInterruptionRec.Other_Reason__c = null;
                 lstServiceInterruptionIds.add(serviceInterruptionRec.Id);                
            }
        }
    	Set<Id> setUnitTypeIds = new Set<Id>();
        List<Unit__c> lstUnitTypeIds = [SELECT Id, Unit_Type__c FROM Unit__c WHERE Id IN : lstUnitIds];
        Map<Id, Id> mapUnitIdsToUnitTypeId = new Map<Id, Id>();
        for(Unit__c objUnits: lstUnitTypeIds){
            setUnitTypeIds.add(objUnits.Unit_Type__c);
            mapUnitIdsToUnitTypeId.put(objUnits.Id, objUnits.Unit_Type__c);
        }
    	System.debug('setUnitTypeIds in update: '+setUnitTypeIds);
        List<Service_Interruption__c> lstOldServiceInterruption = [SELECT Id, Start_Date__c, End_Date__c, Unit__c, Unit__r.Unit_Type__c,Action__c FROM Service_Interruption__c WHERE Unit__r.Unit_Type__c IN: setUnitTypeIds AND Id NOT IN: lstServiceInterruptionIds AND Cancellation_Reason__c = Null];
        List<Unit_Type_Reservation__c> lstUnitTypeReservation = [SELECT Id, Start_Date__c, End_Date__c,Check_Out_Date__c, Unit__c, Unit_Type__c, Unit_Type__r.Units_Available__c FROM Unit_Type_Reservation__c WHERE Unit_Type__c In : setUnitTypeIds AND Status__c != 'Cancelled'];
        objTrCreateServiceInterruption.validateServiceInterruptionWithUnit(lstUnitIds, lstNewServiceInterruption, lstUnitTypeReservation, mapUnitIdsToUnitTypeId, lstOldServiceInterruption);
    	objTrCreateServiceInterruption.dateValidation(lstNewServiceInterruption,  mapOldRecords);
    }
}