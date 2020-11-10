/************************************************************************************************************************************
Author 		: 	Poonam Jadhav
Description :   This apex class is used create Assignment record if Unit__c in UTR is avilable.
History		:
**************************************************************************************************************************************/

public with sharing class TrUTR_CreateAssignment implements Callable{
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        if( ! ((List<sObject>)mapOldAndNewRecords.get('lstNewRecords')).isEmpty() ){
            validateRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords') );
            createAssignmetRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords') );
        }
        return null;
    }
    
    //Create Assignment__c record before UTR get create and populate respective Assignment__c ID in UTR Active_Assignment__c
    public void createAssignmetRecord(List<Unit_Type_Reservation__c> lstUTR){
        List<Assignment__c> lstAssignmntToInsrt = new List<Assignment__c>();
        List<Unit_Type_Reservation__c> lstUTRwithAssgnmnt = new List<Unit_Type_Reservation__c>();
        
        boolean isNameSpace =false;
        String objName;
        List<String> lstFieldsCheckUpdateble = new List<String>();
        try{
            isNameSpace = userinfo.isCurrentUserLicensed('epms');
        }
        catch (exception ex){
            System.debug('Exception ' + ex);
            isNameSpace = false;
        }
        if(isNameSpace){
            objName = 'epms__Assignment__c';
            lstFieldsCheckUpdateble.addAll(new List<String>{'epms__Check_In_Date__c', 'epms__Check_Out_Date__c', 'epms__Unit_Type__c', 'epms__Unit__c', 'epms__Unit_Type_Reservation__c'}) ;
        }
        else{
            objName = 'Assignment__c';
            lstFieldsCheckUpdateble.addAll(new List<String>{'Check_In_Date__c', 'Check_Out_Date__c', 'Unit_Type__c', 'Unit__c', 'Unit_Type_Reservation__c'});
        }
        
        for(Unit_Type_Reservation__c utr : lstUTR){
            if(utr.Unit__c != null){
                lstUTRwithAssgnmnt.add(utr);
            }
        }
        for(Unit_Type_Reservation__c utr :  lstUTR){
            if(utr.Unit__c != null && utr.Unit_Type__c != null){
                if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Update')){
                    Assignment__c assgnmt = new Assignment__c();
                    assgnmt.Check_In_Date__c = utr.Start_Date__c;
                    assgnmt.Check_Out_Date__c = utr.End_Date__c;
                    assgnmt.Unit_Type__c = utr.Unit_Type__c;
                    assgnmt.Unit__c = utr.Unit__c;
                    assgnmt.Action__c = utr.Action__c;
                    lstAssignmntToInsrt.add(assgnmt);
                }
            }
        }
        Database.SaveResult[] srLstAssngmt;
        if(!lstAssignmntToInsrt.isEmpty()){
            if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Create')){
                srLstAssngmt = Database.insert(lstAssignmntToInsrt, false);
            }
            for(integer index = 0 ; index < lstUTRwithAssgnmnt.size() ; index++ ){
                lstUTRwithAssgnmnt[index].Active_Assignment__c  = srLstAssngmt[index].Id;
                lstUTRwithAssgnmnt[index].Status__c  = 'Active';
            }
        }
    }
    
    public void validateRecord(List<Unit_Type_Reservation__c> lstUTR){
    	List<Id> lstUnitTypeIds = new List<Id>();
        List<Id> lstUnitIds = new List<Id>();
        
        dateValidation(lstUTR);
        
        for(Unit_Type_Reservation__c unitTypeReservationRec : lstUTR){
            if(unitTypeReservationRec.Start_Date__c != NULL && unitTypeReservationRec.End_Date__c != NULL){
                lstUnitTypeIds.add(unitTypeReservationRec.Unit_Type__c);
                lstUnitIds.add(unitTypeReservationRec.Unit__c); 
            }
            else{//record does not having date's then show error message
                unitTypeReservationRec.addError(System.Label.ArrivaldateOrDeparturedateismissing);
            }
        }
        if(lstUnitTypeIds.size() > 0 && lstUTR.size() > 0){
            validationForUnit(lstUnitTypeIds, lstUnitIds, lstUTR, Null);
        }
    }
    
    public void dateValidation(List<Unit_Type_Reservation__c> lstNewUTR){
      

        Set<String> strRecord = new Set<String>();
        List<Unit_Type_Reservation__c> lstUnitTypeReservation = new List<Unit_Type_Reservation__c>();
        for(Unit_Type_Reservation__c unitTypeReservationRec : lstNewUTR){
            
            if(unitTypeReservationRec.Start_Date__c != NULL && unitTypeReservationRec.End_Date__c != NULL){

                if(unitTypeReservationRec.Start_Date__c < system.today()) {
                  // unitTypeReservationRec.addError(System.Label.ArrivalDateShouldBeGreaterThenOrEqualToTodayDate);
                }else if(unitTypeReservationRec.Start_Date__c >= unitTypeReservationRec.End_Date__c ){
                    unitTypeReservationRec.addError(System.Label.DepartureDateShouldBeGreaterThenArrivalDate);
                }
                else{
                    if(unitTypeReservationRec.Unit__c != NULL){
                        String record = unitTypeReservationRec.Start_Date__c+'-'+unitTypeReservationRec.End_Date__c+'-'+unitTypeReservationRec.Unit_Type__c+'-'+unitTypeReservationRec.Unit__c;
                        if( strRecord.contains(record) ){
                            unitTypeReservationRec.addError(System.Label.DuplicateEntryFoundPleaseCheckDateAndUnit);
                        }
                        else{
                            strRecord.add(record);
                            for(Unit_Type_Reservation__c unitTypeReservationRecord : lstUnitTypeReservation){
                                   //Check new booking Start Date is in between older booking record Start Date and End Date
                                if(unitTypeReservationRecord.Start_Date__c <= unitTypeReservationRec.Start_Date__c && 
                                   unitTypeReservationRecord.End_Date__c > unitTypeReservationRec.Start_Date__c &&
                                   unitTypeReservationRecord.Unit_Type__c == unitTypeReservationRec.Unit_Type__c &&
                                   unitTypeReservationRecord.Unit__c == unitTypeReservationRec.Unit__c){
                                   unitTypeReservationRec.addError(System.Label.DuplicateEntryFoundPleaseCheckDateAndUnit);
                                }
                                //Check new booking End Date is in between older booking record Start Date and End Date
                                else if(unitTypeReservationRecord.Start_Date__c < unitTypeReservationRec.End_Date__c && 
                                        unitTypeReservationRecord.End_Date__c >= unitTypeReservationRec.End_Date__c &&
                                        unitTypeReservationRecord.Unit_Type__c == unitTypeReservationRec.Unit_Type__c &&
                                        unitTypeReservationRecord.Unit__c == unitTypeReservationRec.Unit__c){
                                    	unitTypeReservationRec.addError(System.Label.DuplicateEntryFoundPleaseCheckDateAndUnit);
                                }
                                //Check old booking Start Date is in between new booking record Start Date and End Date
                                else if(unitTypeReservationRec.Start_Date__c <= unitTypeReservationRecord.Start_Date__c && 
                                        unitTypeReservationRec.End_Date__c > unitTypeReservationRecord.Start_Date__c &&
                                        unitTypeReservationRecord.Unit_Type__c == unitTypeReservationRec.Unit_Type__c &&
                                        unitTypeReservationRecord.Unit__c == unitTypeReservationRec.Unit__c){
                                    	unitTypeReservationRec.addError(System.Label.DuplicateEntryFoundPleaseCheckDateAndUnit);
                                }
                            }
                            lstUnitTypeReservation.add(unitTypeReservationRec);
                        }
                    }
                }
            }
            else{
                unitTypeReservationRec.addError(System.Label.ArrivaldateOrDeparturedateismissing);
            }
        }
    }
    
    public static void validationForUnit(List<Id> lstUnitTypeIds, List<Id> lstUnitIds, List<Unit_Type_Reservation__c> lstUTR, List<Id> lstUnitTypeReservationIds){
        List<Unit_Type_Reservation__c> lstUnitTypeReservation = new List<Unit_Type_Reservation__c>();
		List<Service_Interruption__c> lstServiceInterruption = [SELECT Id, Name, Start_Date__c, End_Date__c, Interruption_Reason__c, Unit__c, Unit__r.Name, Unit__r.Unit_Type__c, Unit__r.Unit_Type__r.Units_Available__c FROM Service_Interruption__c WHERE Unit__r.Unit_Type__c In : lstUnitTypeIds AND Cancellation_Reason__c = Null];
        if(lstUnitTypeReservationIds == Null){//beforeInsert
            lstUnitTypeReservation = [SELECT Id,Start_Date__c, End_Date__c, Unit__c,Check_Out_Date__c, Unit_Type__c, Unit_Type__r.Units_Available__c FROM Unit_Type_Reservation__c WHERE Unit_Type__c In : lstUnitTypeIds AND Status__c != 'Cancelled'];
        }else{//beforeUpdate
            lstUnitTypeReservation = [SELECT Id,Start_Date__c, End_Date__c, Unit__c,Check_Out_Date__c, Unit_Type__c, Unit_Type__r.Units_Available__c FROM Unit_Type_Reservation__c WHERE Unit_Type__c In : lstUnitTypeIds AND Id Not IN : lstUnitTypeReservationIds AND Status__c != 'Cancelled'];
        }
        Map<Id, Map<Date, Integer>> mapUnitTypeIdToDateToCount = new Map<Id, Map<Date, Integer>>();
        Map<Id, Integer> mapUnitTypeIdToUnitAvailable = new Map<Id, Integer>();
        Map<Id, Map<Date, Boolean>> mapUnitIdToDateToIsReserved = new Map<Id, Map<Date, Boolean>>();
        
        for(Unit_Type_Reservation__c objOldUTR: lstUnitTypeReservation){ //oldBooking
            Date oldUTREndDateOrCheckOutDate = objOldUTR.Check_Out_Date__c != Null ? objOldUTR.Check_Out_Date__c : objOldUTR.End_Date__c;
            
            mapUnitTypeIdToUnitAvailable.put(objOldUTR.Unit_Type__c, (Integer)objOldUTR.Unit_Type__r.Units_Available__c);
            Integer daysBetweenOldStartAndEndDate = objOldUTR.Start_Date__c.daysBetween(oldUTREndDateOrCheckOutDate);
            
            for(Integer i = 0; i < daysBetweenOldStartAndEndDate; i++){
                if(objOldUTR.Unit__c != Null){
                    if(!mapUnitIdToDateToIsReserved.isEmpty() && mapUnitIdToDateToIsReserved.containsKey(objOldUTR.Unit__c) && !mapUnitIdToDateToIsReserved.get(objOldUTR.Unit__c).containsKey(objOldUTR.Start_Date__c.addDays(i))){
                        mapUnitIdToDateToIsReserved.get(objOldUTR.Unit__c).put(objOldUTR.Start_Date__c.addDays(i), True);
                    }else if(mapUnitIdToDateToIsReserved.isEmpty() || !mapUnitIdToDateToIsReserved.containsKey(objOldUTR.Unit__c)){
                        mapUnitIdToDateToIsReserved.put(objOldUTR.Unit__c, new Map<Date, Boolean>{objOldUTR.Start_Date__c.addDays(i) => True});
                    }
                    
                    if(!mapUnitIdToDateToIsReserved.isEmpty() && mapUnitIdToDateToIsReserved.containsKey(objOldUTR.Unit__c) && mapUnitIdToDateToIsReserved.get(objOldUTR.Unit__c).containsKey(objOldUTR.Start_Date__c.addDays(i))){
                        mapUnitIdToDateToIsReserved.get(objOldUTR.Unit__c).put(objOldUTR.Start_Date__c.addDays(i), True);
                    }
                }
                
                if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(objOldUTR.Unit_Type__c) && !mapUnitTypeIdToDateToCount.get(objOldUTR.Unit_Type__c).containsKey(objOldUTR.Start_Date__c.addDays(i))){
                    mapUnitTypeIdToDateToCount.get(objOldUTR.Unit_Type__c).put(objOldUTR.Start_Date__c.addDays(i), 0);
                }else if(mapUnitTypeIdToDateToCount.isEmpty() || !mapUnitTypeIdToDateToCount.containsKey(objOldUTR.Unit_Type__c)){
                    mapUnitTypeIdToDateToCount.put(objOldUTR.Unit_Type__c, new Map<Date, Integer>{objOldUTR.Start_Date__c.addDays(i) => 0});
                }
                
                if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(objOldUTR.Unit_Type__c) && mapUnitTypeIdToDateToCount.get(objOldUTR.Unit_Type__c).containsKey(objOldUTR.Start_Date__c.addDays(i))){
                    Integer tempCount = mapUnitTypeIdToDateToCount.get(objOldUTR.Unit_Type__c).get(objOldUTR.Start_Date__c.addDays(i));
                    mapUnitTypeIdToDateToCount.get(objOldUTR.Unit_Type__c).put(objOldUTR.Start_Date__c.addDays(i), ++tempCount);
                }
            }
        }
        
        for(Service_Interruption__c objServiceInterruption: lstServiceInterruption){
            Integer daysBetweenOldInterruptionStartAndEndDate = objServiceInterruption.Start_Date__c.daysBetween(objServiceInterruption.End_Date__c);
            for(Integer i = 0; i < daysBetweenOldInterruptionStartAndEndDate; i++){
                if(objServiceInterruption.Unit__c != Null){
                    if(!mapUnitIdToDateToIsReserved.isEmpty() && mapUnitIdToDateToIsReserved.containsKey(objServiceInterruption.Unit__c) && !mapUnitIdToDateToIsReserved.get(objServiceInterruption.Unit__c).containsKey(objServiceInterruption.Start_Date__c.addDays(i))){
                        mapUnitIdToDateToIsReserved.get(objServiceInterruption.Unit__c).put(objServiceInterruption.Start_Date__c.addDays(i), True);
                    }else if(mapUnitIdToDateToIsReserved.isEmpty() || !mapUnitIdToDateToIsReserved.containsKey(objServiceInterruption.Unit__c)){
                        mapUnitIdToDateToIsReserved.put(objServiceInterruption.Unit__c, new Map<Date, Boolean>{objServiceInterruption.Start_Date__c.addDays(i) => True});
                    }
                    
                    if(!mapUnitIdToDateToIsReserved.isEmpty() && mapUnitIdToDateToIsReserved.containsKey(objServiceInterruption.Unit__c) && mapUnitIdToDateToIsReserved.get(objServiceInterruption.Unit__c).containsKey(objServiceInterruption.Start_Date__c.addDays(i))){
                        mapUnitIdToDateToIsReserved.get(objServiceInterruption.Unit__c).put(objServiceInterruption.Start_Date__c.addDays(i), True);
                    }
                }
                
                if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(objServiceInterruption.Unit__r.Unit_Type__c) && !mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).containsKey(objServiceInterruption.Start_Date__c.addDays(i))){
                    mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).put(objServiceInterruption.Start_Date__c.addDays(i), 0);
                }else if(mapUnitTypeIdToDateToCount.isEmpty() || !mapUnitTypeIdToDateToCount.containsKey(objServiceInterruption.Unit__r.Unit_Type__c)){
                    mapUnitTypeIdToDateToCount.put(objServiceInterruption.Unit__r.Unit_Type__c, new Map<Date, Integer>{objServiceInterruption.Start_Date__c.addDays(i) => 0});
                }
                
                if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(objServiceInterruption.Unit__r.Unit_Type__c) && mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).containsKey(objServiceInterruption.Start_Date__c.addDays(i))){
                    Integer tempCount = mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).get(objServiceInterruption.Start_Date__c.addDays(i));
                    mapUnitTypeIdToDateToCount.get(objServiceInterruption.Unit__r.Unit_Type__c).put(objServiceInterruption.Start_Date__c.addDays(i), ++tempCount);
                }
            }
        }
        
        for(Unit_Type_Reservation__c unitTypeReservation : lstUTR){ //newBooking
            Date newBookingCheckOutorEndDate = unitTypeReservation.Check_Out_Date__c != Null ? unitTypeReservation.Check_Out_Date__c : unitTypeReservation.End_Date__c;
            if(unitTypeReservation.Status__c != 'Cancelled'){
                Integer daysBetween = unitTypeReservation.Start_Date__c.daysBetween(newBookingCheckOutorEndDate);
                for(Integer i = 0; i < daysBetween; i++){
                    if(unitTypeReservation.Unit__c != Null){
                        if(!mapUnitIdToDateToIsReserved.isEmpty() && 
                           mapUnitIdToDateToIsReserved.containsKey(unitTypeReservation.Unit__c) && 
                           mapUnitIdToDateToIsReserved.get(unitTypeReservation.Unit__c).containsKey(unitTypeReservation.Start_Date__c.addDays(i)) &&
                          mapUnitIdToDateToIsReserved.get(unitTypeReservation.Unit__c).get(unitTypeReservation.Start_Date__c.addDays(i)) == True){
                            unitTypeReservation.addError(System.Label.UnitIsNotAvailable);
                        }
                    }
                    
                    Integer tempCount = !mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(unitTypeReservation.Unit_Type__c) && mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).containsKey(unitTypeReservation.Start_Date__c.addDays(i)) ? mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).get(unitTypeReservation.Start_Date__c.addDays(i)) : Null;
                    
                    if(!mapUnitTypeIdToDateToCount.isEmpty() && mapUnitTypeIdToDateToCount.containsKey(unitTypeReservation.Unit_Type__c) && !mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).containsKey(unitTypeReservation.Start_Date__c.addDays(i))){
                        mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).put(unitTypeReservation.Start_Date__c.addDays(i), 0);
                    }else if(mapUnitTypeIdToDateToCount.isEmpty() || !mapUnitTypeIdToDateToCount.containsKey(unitTypeReservation.Unit_Type__c)){
                        mapUnitTypeIdToDateToCount.put(unitTypeReservation.Unit_Type__c, new Map<Date, Integer>{unitTypeReservation.Start_Date__c.addDays(i) => 0});
                    }
                    
                    if(tempCount != Null){
                        mapUnitTypeIdToDateToCount.get(unitTypeReservation.Unit_Type__c).put(unitTypeReservation.Start_Date__c.addDays(i), ++tempCount); //Adding count for new UTRs to be inserted
                        if(tempCount > mapUnitTypeIdToUnitAvailable.get(unitTypeReservation.Unit_Type__c)){
                            unitTypeReservation.addError(System.Label.UnitIsNotAvailable);
                        }
                    }
                }
            }
        }
    }
    
    public static Boolean isWithinRange(Date startDate, Date endDate, Date testDate) {
        if(startDate < testDate && endDate > testDate){
            return true;
        }
        return false;
    }
}