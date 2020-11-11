public with sharing class TrReservationStatusUpdateonUTR implements Callable{
    public TrReservationStatusUpdateonUTR() {
    }
    public Object call(String Status, Map<String, Object> mapOldAndNewRecords){
        updateReservationRecord( (List<sObject>)mapOldAndNewRecords.get('lstNewRecords'),(Map<Id, sObject>)mapOldAndNewRecords.get('mapOldRecords'));
        return null;
    }
    public void updateReservationRecord(List<Unit_Type_Reservation__c> lstUTR , map<id,sObject> mapOldUTR)
    {
        Set<Id> setUTRIdsChecked = new Set<Id>();
        Set<Id> setReservationIds = new Set<Id>();
        Set<Id> setUTRIdsCheckedOut = new Set<Id>();
        Set<Id> setUTRIdsActive = new Set<Id>();
        Set<Id> setUTRIdsCancelled = new Set<Id>();
        List<Reservation__c> lstReservationUPSRT = new List<Reservation__c>();
        for(Unit_Type_Reservation__c utr : lstUTR){ 
            setReservationIds.add(utr.Reservation__c);
        }
        
        map<Id,Reservation__c> mapReservations =new map<Id,Reservation__c>([SELECT Id, Status__c, (SELECT Id, Status__c,Reservation__c FROM Unit_Type_Reservations__r) FROM Reservation__c WHERE Id IN:setReservationIds]);
        boolean isNameSpace =false;
        String objReservationToChkFLS;
        String objUTRToChkFLS;
        List<String> lstFieldsReservationToChkFLS = new List<String>();
        List<String> lstFieldsUTRToChkFLS = new List<String>();
        try{
            isNameSpace = userinfo.isCurrentUserLicensed('epms');
        }
        catch (exception ex){
            System.debug('Exception ' + ex);
            isNameSpace = false;
        }
        if(isNameSpace){
            objReservationToChkFLS = 'epms__Reservation__c';
            objUTRToChkFLS = 'epms__Unit_Type_Reservation__c';
            lstFieldsReservationToChkFLS.addAll(new List<String>{'epms__Status__c'}) ;
            lstFieldsUTRToChkFLS.addAll(new List<String>{'epms__Status__c','epms__Reservation__c'}) ;
        }
        else{
            objReservationToChkFLS = 'Reservation__c';
            objUTRToChkFLS = 'Unit_Type_Reservation__c';
            lstFieldsReservationToChkFLS.addAll(new List<String>{'Status__c'}) ;
            lstFieldsUTRToChkFLS.addAll(new List<String>{'Status__c','Reservation__c'}) ;
        }
        List<Unit_Type_Reservation__c>  lstUtrs = new List<Unit_Type_Reservation__c>();
        
        if(!mapReservations.isEmpty()) {    
            if(Engine.checkFieldAccess(objReservationToChkFLS, lstFieldsReservationToChkFLS, 'Update') && Engine.checkFieldAccess(objUTRToChkFLS, lstFieldsUTRToChkFLS, 'Update')){
            for(Reservation__c  objReservation : mapReservations.values()) {
                List<Unit_Type_Reservation__c> lstchildUtrss = objReservation.Unit_Type_Reservations__r;
                for(Unit_Type_Reservation__c  objUtr : lstchildUtrss){
                    if(objReservation.Id == objUtr.Reservation__c){
                        if(objUtr.Status__c == 'Checked In') {
                            setUTRIdsChecked.add(objUtr.Id);                            
                        }else if(objUtr.Status__c == 'Checked Out') {                            
                            setUTRIdsCheckedOut.add(objUtr.Id);                            
                        } else if(objUtr.Status__c == 'Cancelled') {
                            setUTRIdsCancelled.add(objUtr.Id);
                        } else {
                            setUTRIdsActive.add(objUtr.Id);                            
                        }                        
                    }
                }
                if(setUTRIdsChecked.size() == lstchildUtrss.size()){
                    objReservation.Status__c = 'Checked In';   
                }else if(setUTRIdsCheckedOut.size() == lstchildUtrss.size()){
                    objReservation.Status__c = 'Checked Out';   
                    
                }else if(setUTRIdsCancelled.size() == lstchildUtrss.size()){
                    objReservation.Status__c = 'Cancelled';   
                    
                }
                else if(setUTRIdsChecked.size() == 0 && setUTRIdsActive.size() == 0 && setUTRIdsCheckedOut.size() > 0 && setUTRIdsCancelled.size() > 0){
                    objReservation.Status__c = 'Checked Out';  
                    
                }
                else if(setUTRIdsChecked.size() == 0 && (setUTRIdsCheckedOut.size() > 0 || setUTRIdsCancelled.size() > 0) && setUTRIdsActive.size() > 0 ){
                    objReservation.Status__c = 'Active';  
                    
                }
                else if(setUTRIdsChecked.size() > 0){
                    objReservation.Status__c = 'Partially Checked In';   
                    
                }
                else {
                    objReservation.Status__c = 'Active';  
                    
                }     
                lstReservationUPSRT.add(objReservation);
            }
        }
        }
        if(!lstReservationUPSRT.isEmpty()) {
            update lstReservationUPSRT;
        }        
    }
}