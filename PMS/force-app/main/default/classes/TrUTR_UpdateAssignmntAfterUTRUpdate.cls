/************************************************************************************************************************************
Author 		: 	Poonam Jadhav
Description :   This apex class is used to handle the UTR action and update respective Assignment record
History		:
**************************************************************************************************************************************/
public with sharing class TrUTR_UpdateAssignmntAfterUTRUpdate implements Callable{
    List<String> lstFieldsCheckUpdateble = new List<String>();
    String objName;
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        validateRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords'),(Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords')  );
        updateAssignmetRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords'),  (Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords') );
        return null;
    }

    public void updateAssignmetRecord(List<Unit_Type_Reservation__c> lstUTR , map<id,sObject> mapOldUTR){
        List<Assignment__c> lstAssignmntToUpsert = new List<Assignment__c>();
        Boolean isAllFieldsUpdateable = true;
        for(Unit_Type_Reservation__c utr : lstUTR){
            boolean isNameSpace =false;
            
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
               
            if((utr.Action__c == 'Update Reservation' || utr.Action__c == 'Change Unit') && utr.Active_Assignment__c != null ) {
                if(utr.Action__c == 'Change Unit' && utr.Unit__c == Null){
                    utr.addError('You must enter unit', false);
                }
                if(((Unit_Type_Reservation__c)(mapOldUTR.get(utr.Id))).Unit__c  != utr.Unit__c){
                    //IF unit of UTR is changed after 'Checked In' then new Assgnmnet record get created
                    if(utr.Status__c == 'Checked In'){ 
                        if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Update')){
                            lstAssignmntToUpsert.add(new Assignment__c (Id= utr.Active_Assignment__c,Check_Out_Date__c = Date.today()  ));
                            Assignment__c assgnmt = new Assignment__c();
                            assgnmt.Check_In_Date__c = Date.today();
                            assgnmt.Check_Out_Date__c = utr.End_Date__c;
                            assgnmt.Unit_Type__c = utr.Unit_Type__c;
                            assgnmt.Unit__c = utr.Unit__c;
                            assgnmt.Unit_Type_Reservation__c = utr.Id;
                            assgnmt.Action__c = utr.Action__c;
                            lstAssignmntToUpsert.add(assgnmt);
                        }
                    }
                    //IF unit of UTR is changed before 'Checked In' then new Assgnmnet record should not get created
                    else if(utr.Status__c == 'Active'){
                        if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Update')){
                            Assignment__c assgnmt = new Assignment__c();
                            assgnmt.Id= utr.Active_Assignment__c;
                            assgnmt.Check_In_Date__c = utr.Start_Date__c;
                            assgnmt.Check_Out_Date__c = utr.End_Date__c;
                            assgnmt.Unit_Type__c = utr.Unit_Type__c;
                            assgnmt.Unit__c = utr.Unit__c;
                            assgnmt.Unit_Type_Reservation__c = utr.Id;
                            lstAssignmntToUpsert.add(assgnmt);
                        }
                    }
                }
                //If any field of UTR (other then Unit__c) is changed then update the respective Assignment record
                else{
                    if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Update')){
                        Assignment__c assgnmt = new Assignment__c();
                        assgnmt.Id = utr.Active_Assignment__c;
                        assgnmt.Check_In_Date__c = utr.Start_Date__c;
                        assgnmt.Check_Out_Date__c = utr.End_Date__c;
                        assgnmt.Unit_Type__c = utr.Unit_Type__c;
                        assgnmt.Unit__c = utr.Unit__c;
                        assgnmt.Unit_Type_Reservation__c = utr.Id;
                        lstAssignmntToUpsert.add(assgnmt);
                    }
                }
            }
            if((utr.Action__c == 'Update Reservation' || utr.Action__c == 'Change Unit') && utr.Active_Assignment__c == null ){
                if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Update')){
                    Assignment__c assgnmt = new Assignment__c();
                    assgnmt.Check_In_Date__c = utr.Start_Date__c;
                    assgnmt.Check_Out_Date__c = utr.End_Date__c;
                    assgnmt.Unit_Type__c = utr.Unit_Type__c;
                    assgnmt.Unit__c = utr.Unit__c;
                    assgnmt.Unit_Type_Reservation__c = utr.Id;
                    lstAssignmntToUpsert.add(assgnmt);
                }  
            }
            else if(utr.Action__c == 'Cancel Reservation' && utr.Status__c != 'Cancelled'){
                if(utr.Status__c == 'Active' && utr.Cancellation_Reason__c != Null){
                    utr.Status__c = 'Cancelled';
                    lstAssignmntToUpsert.add(new Assignment__c (Id= utr.Active_Assignment__c,Action__c = utr.Action__c));
                }
                else{
                    utr.addError('You must enter cancellation reason to cancel reservation', false);
                }
            }
            else if(utr.Action__c == 'Change Reservation'){
                if(utr.End_Date__c > ((Unit_Type_Reservation__c)(mapOldUTR.get(utr.Id))).Start_Date__c && utr.End_Date__c >= Date.today())
                {
                    lstAssignmntToUpsert.add(new Assignment__c (Id= utr.Active_Assignment__c,Check_Out_Date__c = utr.End_Date__c, Action__c = utr.Action__c));
                }
                else {
                       utr.addError(System.Label.EndDateShouldBeGreaterThanTodayDate);
                   // utr.addError(' Cannot change the reservation. Please select valid date ', false);
                 }
                }
        }
        Database.UpsertResult[] srLstAssngmt;
        if(Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Update') && Engine.checkFieldAccess(objName, lstFieldsCheckUpdateble, 'Create')){
            srLstAssngmt = Database.upsert(lstAssignmntToUpsert, false);
        }
        
        map<id,Unit_Type_Reservation__c> mapUTR = new Map<id,Unit_Type_Reservation__c> (lstUTR);

        for(Integer index = 0; index < srLstAssngmt.size() ; index++){
            if(srLstAssngmt[index].isSuccess() && srLstAssngmt[index].isCreated()){
                mapUTR.get(lstAssignmntToUpsert[index].Unit_Type_Reservation__c).Active_Assignment__c = lstAssignmntToUpsert[index].id;
            }
        }
        
    }
    
    public void validateRecord(List<Unit_Type_Reservation__c> lstUTR, map<id,sObject> mapOldUTR){
    	List<Id> lstUnitTypeIds = new List<Id>();
        List<Id> lstUnitIds = new List<Id>();
        List<Id> lstUnitTypeReservationIds = new List<Id>();
        for(Unit_Type_Reservation__c unitTypeReservationRec : lstUTR){
           if(unitTypeReservationRec.Start_Date__c != NULL && unitTypeReservationRec.End_Date__c != NULL && unitTypeReservationRec.Action__c != 'Cancel Reservation'){
                lstUnitTypeIds.add(unitTypeReservationRec.Unit_Type__c);
                lstUnitIds.add(unitTypeReservationRec.Unit__c);
                lstUnitTypeReservationIds.add(unitTypeReservationRec.Id);
            }
            else{
                if(unitTypeReservationRec.Action__c != 'Cancel Reservation')
                	unitTypeReservationRec.addError(System.Label.ArrivaldateOrDeparturedateismissing);
            }
        }
        if(lstUnitTypeIds.size() > 0 && lstUnitIds.size() > 0 && lstUTR.size() > 0){
            TrUTR_CreateAssignment.validationForUnit(lstUnitTypeIds, lstUnitIds, lstUTR, lstUnitTypeReservationIds);
        } 
        dateValidation(lstUTR , mapOldUTR);
    }
    
    public void dateValidation(List<Unit_Type_Reservation__c> lstNewUTR , map<id,sObject> mapOldUTR){
        Set<String> strRecord = new Set<String>();
        for(Unit_Type_Reservation__c unitTypeReservationRec : lstNewUTR){
            if(unitTypeReservationRec.Action__c != 'Check Out'){
                
               if(unitTypeReservationRec.Start_Date__c != NULL && unitTypeReservationRec.End_Date__c != NULL ){
                   
                if(unitTypeReservationRec.Start_Date__c != ((Unit_Type_Reservation__c)(mapOldUTR.get(unitTypeReservationRec.Id))).Start_Date__c && unitTypeReservationRec.Start_Date__c < system.today() && unitTypeReservationRec.Action__c != 'Change Unit' && unitTypeReservationRec.Action__c != 'Check In' && unitTypeReservationRec.Action__c != 'Change Reservation') {
                    unitTypeReservationRec.addError(System.Label.ArrivalDateShouldBeGreaterThenOrEqualToTodayDate);
                }
                   else if(unitTypeReservationRec.Check_In_Date__c < system.today() && unitTypeReservationRec.Action__c != 'Change Unit' && unitTypeReservationRec.Action__c == 'Check In' ) {
                    unitTypeReservationRec.addError(System.Label.ArrivalDateShouldBeGreaterThenOrEqualToTodayDate);
                }else if(unitTypeReservationRec.End_Date__c < system.today()){
                    unitTypeReservationRec.addError(System.Label.EndDateShouldBeGreaterThanTodayDate);
                }

                   else if(unitTypeReservationRec.Start_Date__c >= unitTypeReservationRec.End_Date__c ){
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
                        }
                    }
                }
                }
                else{
                    unitTypeReservationRec.addError(System.Label.ArrivaldateOrDeparturedateismissing);
                } 
            }
        }
    }
}