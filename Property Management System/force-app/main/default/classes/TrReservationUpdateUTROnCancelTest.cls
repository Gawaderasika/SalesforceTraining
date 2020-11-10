@isTest
public  with sharing class TrReservationUpdateUTROnCancelTest {
    @testSetup
    static void testSetup(){
        Property__c objOfProperty = TestDataFactory.createProperty();
        insert objOfProperty; 
        
        List<Unit_Type__c> lstOfUnitTypes = TestDataFactory.createUnitTypes(5);
        for(Unit_Type__c unitType : lstOfUnitTypes){
            unitType.Property__c = objOfProperty.Id;            
        }
      
        insert lstOfUnitTypes;
        
        List<Unit__c> lstOfUnits = new List<Unit__c>();
        for(Unit_Type__c unitType : lstOfUnitTypes){           
            lstOfUnits.addAll(TestDataFactory.createUnits(unitType, 2)); 
        }
       
        insert lstOfUnits;
        
        List<Contact> lstOfContacts = TestDataFactory.createContacts(2);
       
        insert lstOfContacts;
        
        List<Reservation__c> lstOfReservation = new List<Reservation__c>();
        for(Contact objOfContact : lstOfContacts){
            Reservation__c objOfReservation = TestDataFactory.createReservation(objOfContact.Id, objOfProperty.Id);
            lstOfReservation.add(objOfReservation);            
        }
         insert lstOfReservation;
        
        
       
        
        
        
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>();
        Unit_Type_Reservation__c objOfUnitTypeReservation = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id,lstOfUnits[0].Id,'Active','Make Reservation');
        lstUTR.add(objOfUnitTypeReservation);
        Unit_Type_Reservation__c objOfUnitTypeReservationChkOut = TestDataFactory.createUnitTypeReservation(lstOfReservation[1].Id, lstOfUnits[1].Unit_Type__c, lstOfContacts[1].Id,lstOfUnits[1].Id,'Active','Make Reservation');
        lstUTR.add(objOfUnitTypeReservationChkOut);
        
        insert lstUTR;
        
        
        

        
    }
    
         @isTest
       static void UpdateUTRAftrCancelReservation() {
       List<Reservation__c> lstResData = [Select Cancellation_Reason__c,Id,Reservation_Member_Name__c,Action__c
                                                                    From Reservation__c  Where Cancellation_Reason__c=null Limit 10];
           
           
           system.assert(lstResData[0].Cancellation_Reason__c == null);
           
            
         lstResData[0].Action__c='Cancel Reservation';
         lstResData[0].Cancellation_Reason__c='Death';
         
        upsert lstResData[0];
           
        
           lstResData[1].Action__c='Cancel Reservation';
           try{
            upsert lstResData[1];
           }
           catch(Exception e)
           {
               system.debug(e);
           }
                   
        
           
       }
    
    @isTest
    static void UpdateUTRAftrCancelResWithoutCancel() {
        List<Reservation__c> lstResData = [Select Cancellation_Reason__c,Id,Reservation_Member_Name__c,Action__c
                                           From Reservation__c  Limit 10];
        
        
        system.assert(lstResData[0].Cancellation_Reason__c == null);
        system.debug('lstResData=>'+lstResData);
        
        lstResData[0].Action__c='Cancel Reservation';
         
        try
        {upsert lstResData[0];}
        catch(Exception Ex){
          System.AssertEquals(ex.getMessage().contains('You cannot cancel reservation without cancellation reason'), true);  
        }
        
    }
    
    
    
    
    
    
    
    
  
          
        
        


}