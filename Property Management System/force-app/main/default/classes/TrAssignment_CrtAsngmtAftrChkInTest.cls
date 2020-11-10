@isTest
public with sharing class TrAssignment_CrtAsngmtAftrChkInTest {
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
        
        Unit_Type_Reservation__c objOfUnitTypeReservation = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id,lstOfUnits[0].Id,'Active','Make Reservation');
        insert objOfUnitTypeReservation;
    }
     @isTest 
    static void createAssignmetRecord(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select Id, Start_Date__c, End_Date__c, Unit_Type__c, Unit__c,Active_Assignment__c 
                                                                                    From Unit_Type_Reservation__c Limit 10]);
        TrAssignment_CrtAsngmtAftrChkIn trAssgnmntCreateAssgnmntAftrChkIn = new TrAssignment_CrtAsngmtAftrChkIn();
        Assignment__c assgnmt = new Assignment__c();
                assgnmt.Check_In_Date__c = lstUTR[0].Start_Date__c;
                assgnmt.Check_Out_Date__c = lstUTR[0].End_Date__c;
                assgnmt.Unit_Type__c = lstUTR[0].Unit_Type__c;
                assgnmt.Unit__c = lstUTR[0].Unit__c;
        		assgnmt.Unit_Type_Reservation__c = lstUTR[0].Id;
                assgnmt.Action__c = 'Check In';
        List<Assignment__c> lstAssgnmnt = new List<Assignment__c>();
        lstAssgnmnt.add(assgnmt);
		insert lstAssgnmnt;
        trAssgnmntCreateAssgnmntAftrChkIn.createAssignmetRecord(lstAssgnmnt);
    	System.assertNotEquals(null , lstUTR[0].Active_Assignment__c);
        
    } 
}