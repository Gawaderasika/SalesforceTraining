@isTest
public with sharing class TrUTR_UpdateAssignmntAfterUTRInsrtTest {
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
        insert lstUTR;
        
        
        List<Assignment__c> lstAssgnmnt = new List<Assignment__c>();
        Assignment__c AssgnmntChkIn = TestDataFactory.createAssignment(lstUTR[0].Id,lstUTR[0].Unit__c,lstUTR[0].Unit_Type__c,lstUTR[0].Reservation_Member_Name__c, 'Make Reservation');
        lstAssgnmnt.add(AssgnmntChkIn);
        insert lstAssgnmnt;
    }
    @isTest 
    static void UpdateUTRAftrAssgnmntInsrt(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select Id, Active_Assignment__c  from Unit_Type_Reservation__c Limit 10]);
        Set<Id> setUTRId = new Set<Id>();
        for(Unit_Type_Reservation__c  utr : lstUTR){
            setUTRId.add(utr.Id);
        }
        List<Assignment__c> lstAssgnmnt = [Select id,Unit_Type_Reservation__c from Assignment__c where Unit_Type_Reservation__c IN : setUTRId ];
        System.assert(lstAssgnmnt != null);
        lstUTR[0].Active_Assignment__c = lstAssgnmnt[0].Id;
        
        upsert lstUTR[0];
        
    }
    
}