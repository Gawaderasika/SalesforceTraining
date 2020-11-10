public with sharing class TrCreateService_Interruption implements Callable{
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        validateRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords') ,(Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords'));
        return null;
    }
    public void validateRecord(List<Service_Interruption__c> lstNewServiceInterruption, map<id,sObject> mapOldServiceIT){
        List<Id> lstUnitIds = new List<Id>();        
        for(Service_Interruption__c serviceInterruptionRec : lstNewServiceInterruption){
            if(serviceInterruptionRec.Start_Date__c != NULL && serviceInterruptionRec.End_Date__c != NULL){
                  if(serviceInterruptionRec.Unit__c != NULL){
                       lstUnitIds.add(serviceInterruptionRec.Unit__c);
                     }
            } 
            else{
            	serviceInterruptionRec.addError('Please Check Start Date and End Date');
            }
            if (!String.isEmpty(serviceInterruptionRec.Interruption_Reason__c) && serviceInterruptionRec.Interruption_Reason__c.toLowerCase() != 'other'){
               // system.debug('other reason '+serviceInterruptionRec.Interruption_Reason__c.toLowerCase());
                serviceInterruptionRec.Other_Reason__c = null;
             }
        }
        Set<Id> setUnitTypeIds = new Set<Id>();
        List<Unit__c> lstUnitTypeIds = [SELECT Id, Unit_Type__c FROM Unit__c WHERE Id IN : lstUnitIds];
        Map<Id, Id> mapUnitIdsToUnitTypeId = new Map<Id, Id>();
        for(Unit__c objUnits: lstUnitTypeIds){
            setUnitTypeIds.add(objUnits.Unit_Type__c);
            mapUnitIdsToUnitTypeId.put(objUnits.Id, objUnits.Unit_Type__c);
        }
        List<Unit_Type_Reservation__c> lstUnitTypeReservation = [SELECT Id, Start_Date__c, End_Date__c, Check_Out_Date__c, Unit__c, Unit_Type__c, Unit_Type__r.Units_Available__c FROM Unit_Type_Reservation__c WHERE Unit_Type__c In : setUnitTypeIds AND Status__c != 'Cancelled'];
        List<Service_Interruption__c> lstOldServiceInterruption = [SELECT Id, Start_Date__c, End_Date__c, Unit__c, Unit__r.Unit_Type__c FROM Service_Interruption__c WHERE Unit__r.Unit_Type__c IN: setUnitTypeIds AND Cancellation_Reason__c = Null];
        validateServiceInterruptionWithUnit(lstUnitIds, lstNewServiceInterruption, lstUnitTypeReservation, mapUnitIdsToUnitTypeId, lstOldServiceInterruption);
    
    	dateValidation(lstNewServiceInterruption, mapOldServiceIT);
    }
    
    public void dateValidation(List<Service_Interruption__c> lstNewServiceInterruption,map<id,sObject> mapOldServiceIT){
        Set<String> strRecord = new Set<String>();
        for(Service_Interruption__c serviceInterruptionRec : lstNewServiceInterruption){
            if(serviceInterruptionRec.Start_Date__c != NULL && serviceInterruptionRec.End_Date__c != NULL ){
               
                if(serviceInterruptionRec.Start_Date__c < system.today()  ) {
                        if(mapOldServiceIT.containsKey(serviceInterruptionRec.Id) && serviceInterruptionRec.Start_Date__c != ((Service_Interruption__c)(mapOldServiceIT.get(serviceInterruptionRec.Id))).Start_Date__c){
                       serviceInterruptionRec.addError(System.Label.StartDateShouldBeGreaterThenOrEqualToTodayDate);
                    }
                    else if(! mapOldServiceIT.containsKey(serviceInterruptionRec.ID)){
                        serviceInterruptionRec.addError(System.Label.StartDateShouldBeGreaterThenOrEqualToTodayDate);
                    }else  if(serviceInterruptionRec.End_Date__c < system.today()){
                        serviceInterruptionRec.addError(System.label.EndDateShouldBeGreaterThanTodayDate);               
                    }

                }else if(serviceInterruptionRec.Start_Date__c >= serviceInterruptionRec.End_Date__c ){
                    serviceInterruptionRec.addError(System.label.EndDateShouldBeGreaterThenStartDate);
                }
                else{
                    if(serviceInterruptionRec.Unit__c != NULL){
                        String record = serviceInterruptionRec.Start_Date__c+'-'+serviceInterruptionRec.End_Date__c+'-'+serviceInterruptionRec.Unit__c;
                        if( strRecord.contains(record) ){
                            serviceInterruptionRec.addError(System.Label.DuplicateEntryFoundPleaseCheckDateAndUnit);
                        }
                        else{
                            strRecord.add(record); 
                        }
                    }
                }
            }
            else{
                serviceInterruptionRec.addError(System.Label.PleaseCheckStartDateAndEndDate);
            }
        }
    }
    
    public void  validateServiceInterruptionWithUnit(List<Id> lstUnitIds, List<Service_Interruption__c> lstNewItems, List<Unit_Type_Reservation__c> lstUnitTypeReservation, Map<Id, Id> mapUnitIdsToUnitTypeId, List<Service_Interruption__c> lstOldServiceInterruption){
        Map<Id, Map<Date, Integer>> mapUnitTypeIdToDateToCount = new Map<Id, Map<Date, Integer>>();
        Map<Id, Integer> mapUnitTypeIdToUnitAvailable = new Map<Id, Integer>();
        for(Service_Interruption__c serviceInterruption : lstNewItems){//new Service Interruption
            Integer daysBetween = serviceInterruption.Start_Date__c.daysBetween(serviceInterruption.End_Date__c);
            Id unitTypeId = mapUnitIdsToUnitTypeId.get(serviceInterruption.Unit__c);
            for(Integer i = 0; i < daysBetween; i++){
                if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(unitTypeId)){
                    mapUnitTypeIdToDateToCount.get(unitTypeId).put(serviceInterruption.Start_Date__c.addDays(i), 0);
                }else{
                    mapUnitTypeIdToDateToCount.put(unitTypeId, new Map<Date, Integer>{serviceInterruption.Start_Date__c.addDays(i) => 0});
                }
            }
            
            for(Unit_Type_Reservation__c unitTypeReservation:  lstUnitTypeReservation){
            	if(serviceInterruption.Unit__c == unitTypeReservation.Unit__c){
                    //Check new booking Start Date is in between service interruption record Start Date and End Date
                    if(unitTypeReservation.Start_Date__c <= serviceInterruption.Start_Date__c && 
                      ( (unitTypeReservation.Check_Out_Date__c == null) ? unitTypeReservation.End_Date__c : unitTypeReservation.Check_Out_Date__c) > serviceInterruption.Start_Date__c){
                        serviceInterruption.addError(System.Label.ReservationIsPresent);
                    }
                    //Check new booking End Date is in between service interruption record Start Date and End Date
                    else if(unitTypeReservation.Start_Date__c < serviceInterruption.End_Date__c && ((unitTypeReservation.Check_Out_Date__c == null) ? unitTypeReservation.End_Date__c : unitTypeReservation.Check_Out_Date__c) >= serviceInterruption.End_Date__c){
                        serviceInterruption.addError(System.Label.ReservationIsPresent);
                    }
                    //Check Service interruption Start Date is in between new booking record Start Date and End Date
                    else if(serviceInterruption.Start_Date__c <= unitTypeReservation.Start_Date__c && serviceInterruption.End_Date__c > unitTypeReservation.Start_Date__c){
                        serviceInterruption.addError(System.Label.ReservationIsPresent);
                    }
                }
                mapUnitTypeIdToUnitAvailable.put(unitTypeReservation.Unit_Type__c, (Integer)unitTypeReservation.Unit_Type__r.Units_Available__c);
                Integer daysBetweenOldStartAndEndDate = unitTypeReservation.Start_Date__c.daysBetween(unitTypeReservation.End_Date__c);
                for(Integer i = 0; i < daysBetweenOldStartAndEndDate; i++){
                    if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(unitTypeReservation.Unit_Type__c) && mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).containsKey(unitTypeReservation.Start_Date__c.addDays(i))){
                        Integer tempCount = (Integer)mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).get(unitTypeReservation.Start_Date__c.addDays(i));
                        mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).put(unitTypeReservation.Start_Date__c.addDays(i), ++tempCount);
                    }
                }
            }
            
            for(Service_Interruption__c objServiceInterruption: lstOldServiceInterruption){//Old Service Interruption
                Integer daysBetweenOldInterruptionStartAndEndDate = objServiceInterruption.Start_Date__c.daysBetween(objServiceInterruption.End_Date__c);
                for(Integer i = 0; i < daysBetweenOldInterruptionStartAndEndDate; i++){
                    if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(objServiceInterruption.Unit__r.Unit_Type__c) && mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).containsKey(objServiceInterruption.Start_Date__c.addDays(i))){
                        Integer tempCount = (Integer)mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).get(objServiceInterruption.Start_Date__c.addDays(i));
                        mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).put(objServiceInterruption.Start_Date__c.addDays(i), ++tempCount);
                    }
                }
                if(serviceInterruption.Unit__c != NULL && serviceInterruption.Unit__c == objServiceInterruption.Unit__c){
                    if(TrUTR_CreateAssignment.isWithinRange(objServiceInterruption.Start_Date__c, objServiceInterruption.End_Date__c, serviceInterruption.Start_Date__c) || 
                       TrUTR_CreateAssignment.isWithinRange(objServiceInterruption.Start_Date__c, objServiceInterruption.End_Date__c, serviceInterruption.End_Date__c)){
                           serviceInterruption.addError(System.Label.Interruption_is_already_reserved);
                       }else if(TrUTR_CreateAssignment.isWithinRange(serviceInterruption.Start_Date__c, serviceInterruption.End_Date__c, objServiceInterruption.Start_Date__c) || 
                                TrUTR_CreateAssignment.isWithinRange(serviceInterruption.Start_Date__c, serviceInterruption.End_Date__c, objServiceInterruption.End_Date__c)){
                                    serviceInterruption.addError(System.Label.Interruption_is_already_reserved);
                                }else if(serviceInterruption.Start_Date__c == objServiceInterruption.Start_Date__c && serviceInterruption.End_Date__c == objServiceInterruption.End_Date__c){
                                        serviceInterruption.addError(System.Label.Interruption_is_already_reserved);
                                    }
                }
            }
            
            for(Integer i = 0; i < daysBetween; i++){
                Integer currentCount = (mapUnitTypeIdToDateToCount.containsKey(unitTypeId) && mapUnitTypeIdToDateToCount.get(unitTypeId).containsKey(serviceInterruption.Start_Date__c.addDays(i))) ? mapUnitTypeIdToDateToCount.get(unitTypeId).get(serviceInterruption.Start_Date__c.addDays(i)) : Null;
                if(currentCount != Null && mapUnitTypeIdToUnitAvailable.get(unitTypeId) == currentCount){
                    serviceInterruption.addError('Unit is not available for Service Interruption');
                }
            }
        }
    }
}