/************************************************************************************************************************************
Author 		: 	Poonam Jadhav
Description :   This apex class is used to update UTR after Chek In is done from table
History		:
**************************************************************************************************************************************/
public with sharing class TrAssignment_CrtAsngmtAftrChkIn  implements Callable{
    public TrAssignment_CrtAsngmtAftrChkIn() {
        
    }
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        if( ! ((List<sObject>)mapOldAndNewRecords.get('lstNewRecords')).isEmpty() ){
            createAssignmetRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords') );
        }
        return null;
    }

    public void createAssignmetRecord(List<Assignment__c> lstAssgnmnt){
        Map<Id,Assignment__c> mapassgnmnt = new Map<Id,Assignment__c>(lstAssgnmnt);
        set<Id> setUTRId = new set<Id>();
        for(Assignment__c assgnmnt : mapassgnmnt.values() ){
            if(assgnmnt.Action__c == 'Check In' && assgnmnt.Unit_Type_Reservation__c != null){
                setUTRId.add(assgnmnt.Unit_Type_Reservation__c);
            }
        }
        if(!setUTRId.isEmpty()){ 
            map<Id,Unit_Type_Reservation__c> mapUTRToUpdate = new map<Id,Unit_Type_Reservation__c> ([SELECT Id, Status__c, Active_Assignment__c FROM Unit_Type_Reservation__c
                                                                                                     Where Id IN: setUTRId]);
            if(!mapUTRToUpdate.isEmpty()){
                for(Assignment__c assgnmnt : mapassgnmnt.values() ){
                    mapUTRToUpdate.get(assgnmnt.Unit_Type_Reservation__c).Active_Assignment__c = assgnmnt.Id;
                    mapUTRToUpdate.get(assgnmnt.Unit_Type_Reservation__c).Status__c = 'Checked In';
                    mapUTRToUpdate.get(assgnmnt.Unit_Type_Reservation__c).Unit__c = assgnmnt.Unit__c ;
                    mapUTRToUpdate.get(assgnmnt.Unit_Type_Reservation__c).Action__c = assgnmnt.Action__c ;
                    mapUTRToUpdate.get(assgnmnt.Unit_Type_Reservation__c).Check_In_Date__c = Date.today();
                }
                try{
                    update mapUTRToUpdate.values();
                }
                catch(Exception ex){
                    lstAssgnmnt[0].addError(ex.getMessage());
                }
            }
        }
    }
}