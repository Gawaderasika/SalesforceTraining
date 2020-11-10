@isTest
public with sharing class TrReservationStatusUpdateonUTRTest {
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
            lstOfUnits.addAll(TestDataFactory.createUnits(unitType, 5)); 
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
        Unit_Type_Reservation__c objOfUnitTypeReservationCheck = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id,lstOfUnits[0].Id,'Active','Make Reservation');
        lstUTR.add(objOfUnitTypeReservationCheck);
        Unit_Type_Reservation__c objOfUnitTypeReservationChkOut = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[1].Id,lstOfUnits[1].Id,'Active','Make Reservation');
        lstUTR.add(objOfUnitTypeReservationChkOut);
        Unit_Type_Reservation__c objOfUnitTypeReservationCancel= TestDataFactory.createUnitTypeReservation(lstOfReservation[1].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id,lstOfUnits[2].Id,'Checked In','Check In');
        lstUTR.add(objOfUnitTypeReservationCancel);
        
        insert lstUTR;
        
        
    }
    @isTest
    static void UpdateResaftrUTRUpdate() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[1].Id];
        
        system.assertEquals(lstResData[0].Status__c!=null, true);
        List<Unit_Type_Reservation__c> lstUTRRec = new List<Unit_Type_Reservation__c>();
        for(Unit_Type_Reservation__c utrrecord:lstResData){
            
            
            utrrecord.Action__c='Check In';
            utrrecord.Status__c='Checked In';
            lstUTRRec.add(utrrecord) ;
            
        }
        update lstUTRRec;
        
    }
    @isTest
    static void UpdateResaftrUTRCheckedOut() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[1].Id ];
        List<Unit_Type_Reservation__c> lstUTRRecancel = new List<Unit_Type_Reservation__c>();
        for(Unit_Type_Reservation__c obUTR : lstResData )
        {
            obUTR.Action__c = 'Check Out';
            obUTR.Status__c='Checked Out';
            lstUTRRecancel.add(obUTR);
        }
        update lstUTRRecancel;
        system.assertEquals(lstUTRRecancel[0].Status__c=='Checked Out', true);
        
    }
    @isTest
    static void UpdateResaftrUTRCancelled() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[1].Id ];
        List<Unit_Type_Reservation__c> lstUTRRecancel = new List<Unit_Type_Reservation__c>();
        for(Unit_Type_Reservation__c obUTR : lstResData )
        {
            obUTR.Action__c = 'Cancel';
            obUTR.Status__c='Cancelled';
            lstUTRRecancel.add(obUTR);
        }
        update lstUTRRecancel;
        system.assertEquals(lstUTRRecancel[0].Status__c, 'Cancelled');
        
        
        
    }
    @isTest
    static void UpdateResaftrUTRForAll() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[0].Id ];
        
        
        
        lstResData[0].Action__c='Check Out';
        lstResData[0].Status__c='Checked Out';
        update lstResData[0];
        system.assertEquals(lstResData[0].Status__c, 'Checked Out');
        
        lstResData[1].Action__c='Cancel';
        lstResData[1].Status__c='Cancelled';
        
        update lstResData[1];
        
        
        
    }

    @isTest
    static void UpdateResaftrUTRPartCheck() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[0].Id ];
        
         
        
        lstResData[0].Action__c='Check In';
        lstResData[0].Status__c='Checked In';
        update lstResData[0];
        
        system.assertEquals(lstResData[0].Status__c, 'Checked In');
        
        
        
        
    }
    
    @isTest
    static void UpdateResaftrUTRActive() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[0].Id ];
        
        
        
        lstResData[0].Action__c='Make Reservation';
        lstResData[0].Status__c='Active';
        update lstResData[0];
        system.assertEquals(lstResData[0].Status__c, 'Active');
        
        
        
        
        
    }
    @isTest
    static void UpdateResaftrUTRCancelledANDCheckOut() {
        List<Reservation__c> lstReservationUPSRT = [Select Id From Reservation__c ];
        List<Unit_Type_Reservation__c> lstResData = [Select Id,Action__c,Status__c
                                                     From Unit_Type_Reservation__c  Where  Unit_Type_Reservation__c.Reservation__c =: lstReservationUPSRT[0].Id ];
        
        
        
        lstResData[0].Action__c='Check Out';
        lstResData[0].Status__c='Checked Out';
        update lstResData[0];
        
        
        lstResData[1].Action__c='Cancel';
        lstResData[1].Status__c='Cancelled';
        
        update lstResData[1];
          system.assertEquals(lstResData[1].Status__c, 'Cancelled');
        
        
    }
    
    
    
    
    
}