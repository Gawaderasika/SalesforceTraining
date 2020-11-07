/************************************************************************************************************************************
Author 		: 	Poonam Jadhav
Description :   This apex class is used to update Unit_Type_Reservation__c field of Assignment with respective UTR Id after UTR insert.
History		:
**************************************************************************************************************************************/
public with sharing class 	TrUTR_UpdateAssignmntAfterUTRInsrt implements Callable{
    
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        if( ! ((List<sObject>)mapOldAndNewRecords.get('lstNewRecords')).isEmpty() ){
            updateAssignmetRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords') );
        }
        return null;
    }
    
    // Update Assignmnet record of respective UTR with UTR Id in Unit_Type_Reservation__c field
    public void updateAssignmetRecord(List<Unit_Type_Reservation__c> lstUTR){
        set<Id> setUTRId = new set<Id>();
        for(Unit_Type_Reservation__c utr : lstUTR){
            setUTRId.add(utr.Active_Assignment__c);
        }
        map<Id,Assignment__c> mapAssngmnt = new map<Id,Assignment__c>([Select  Unit_Type_Reservation__c from Assignment__c 
                                                                       where Id IN: setUTRId]);
        
        for(Unit_Type_Reservation__c utr : lstUTR){
            if(utr.Action__c == 'Make Reservation'){
                if(mapAssngmnt.containsKey(utr.Active_Assignment__c)){
                    mapAssngmnt.get(utr.Active_Assignment__c).Unit_Type_Reservation__c =  utr.Id;
                }
            }
        }  
        update mapAssngmnt.values();
    }
}