/************************************************************************************************************************************
Author 		: 	Poonam Jadhav
Description :   This apex class is used to update UTR after Chek In and Check Out is done from Grid.
History		:
**************************************************************************************************************************************/
public with sharing class TrAssignment_UpdtAsgmtAftrChkIn implements Callable{
    
    public Object call(String action, Map<String, Object> mapOldAndNewRecords) {
        if( ! ((List<sObject>)mapOldAndNewRecords.get('lstNewRecords')).isEmpty() ){
            updateAssignmentAndUTR( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords'), (Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords') );
        }
        return null;
    }
    
    public void updateAssignmentAndUTR(List<Assignment__c> lstAssgnment ,Map<Id, SObject> mapOldAssgnmnt){
        map<Id,Assignment__c> mapAssgnmnt = new map<Id,Assignment__c> (lstAssgnment);
        map<Id, Unit_Type_Reservation__c> mapUTR = new map<Id, Unit_Type_Reservation__c>([SELECT Id, Start_Date__c,Check_Out_Date__c,Check_In_Date__c, Status__c,End_Date__c,Action__c FROM Unit_Type_Reservation__c Where Active_Assignment__c IN: mapAssgnmnt.keySet()]);
        Boolean isUTRUpdate = false;
        for(Assignment__c assgmnt : lstAssgnment ){
            if(assgmnt.Unit_Type_Reservation__c != NULL && mapUTR.get(assgmnt.Unit_Type_Reservation__c) != NULL && assgmnt.Action__c == 'Check In'){
                if(assgmnt.Check_In_Date__c >= mapUTR.get(assgmnt.Unit_Type_Reservation__c).Start_Date__c){
                    mapUTR.get(assgmnt.Unit_Type_Reservation__c).Status__c = 'Checked In' ;
                    mapUTR.get(assgmnt.Unit_Type_Reservation__c).Unit__c = assgmnt.Unit__c;
                    mapUTR.get(assgmnt.Unit_Type_Reservation__c).Action__c = assgmnt.Action__c;
                    mapUTR.get(assgmnt.Unit_Type_Reservation__c).Check_In_Date__c = Date.today();
                    isUTRUpdate = true;
                }
                else {
                    assgmnt.addError('Error while Check In, Please check respective record for Unit Type Reservation ', false);
                }
            }
            if(assgmnt.Action__c == 'Check Out'  ){ //&& ((Assignment__c)mapOldAssgnmnt.get(assgmnt.Id)).Action__c == 'Check In')
                if( mapUTR.get(assgmnt.Unit_Type_Reservation__c).Check_In_Date__c == Date.today()) {
                    assgmnt.Check_Out_Date__c = Date.today() + 1;
                    mapUTR.get(assgmnt.Unit_Type_Reservation__c).Check_Out_Date__c = Date.today() +1;
                }
                else{
                    assgmnt.Check_Out_Date__c = Date.today() ;
                    mapUTR.get(assgmnt.Unit_Type_Reservation__c).Check_Out_Date__c = Date.today();
                }
                mapUTR.get(assgmnt.Unit_Type_Reservation__c).Status__c = 'Checked Out' ;
                mapUTR.get(assgmnt.Unit_Type_Reservation__c).Action__c = assgmnt.Action__c ;
                isUTRUpdate = true;
            }
        }
        if(isUTRUpdate){
            try{
                update mapUTR.values();
            }catch(Exception ex){
                lstAssgnment[0].addError(ex.getMessage());
            }
        }
        
    }
}