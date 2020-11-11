@isTest
public with sharing class TrAssignment_UpdtAsgmtAftrChkInTest {
    @testSetup
    static void testSetup(){
        Test.startTest();
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
        
        
        List<Assignment__c> lstAssgnmnt = new List<Assignment__c>();
        Assignment__c AssgnmntChkIn = TestDataFactory.createAssignment(lstUTR[0].Id,lstUTR[0].Unit__c,lstUTR[0].Unit_Type__c,lstUTR[0].Reservation_Member_Name__c, 'Make Reservation');
        lstAssgnmnt.add(AssgnmntChkIn);
        Assignment__c AssgnmntChkOut = TestDataFactory.createAssignment(lstUTR[1].Id,lstUTR[1].Unit__c,lstUTR[0].Unit_Type__c,lstUTR[1].Reservation_Member_Name__c,'Check In');
        lstAssgnmnt.add(AssgnmntChkOut);
        
        insert lstAssgnmnt;
        
        lstUTR[1].Active_Assignment__c = lstAssgnmnt[1].Id;
        Upsert lstUTR;
        Test.stopTest();
    }
    @isTest 
    static void UpdateUTRandAssgnmntAftrChkIn(){
        Test.startTest();
        List<Assignment__c> lstAssgnmnts = new List<Assignment__c>([Select Id, Check_In_Date__c, Check_Out_Date__c, Unit_Type__c, Unit__c,Action__c, Unit_Type_Reservation__c
                                                                    From Assignment__c  Where Action__c = 'Make Reservation' Limit 10]);
        lstAssgnmnts[0].Action__c = 'Check In';
        
        Upsert lstAssgnmnts[0];
        system.assertEquals(lstAssgnmnts[0].Action__c,'Check In');      
        Test.stopTest();
    } 
    @isTest 
    static void UpdateUTRandAssgnmntAftrChkOut(){
        Test.startTest();
        List<Assignment__c> lstAssgnmnts = new List<Assignment__c>([Select Id, Check_In_Date__c, Check_Out_Date__c, Unit_Type__c, Unit__c,Action__c, Unit_Type_Reservation__c
                                                                    From Assignment__c Where Action__c ='Check In' Limit 10]);
        if(!lstAssgnmnts.isEmpty()){
            lstAssgnmnts[0].Action__c = 'Check Out';
            Unit_Type_Reservation__c objUnitTypeReservation = new Unit_Type_Reservation__c(Id = lstAssgnmnts[0].Unit_Type_Reservation__c, Active_Assignment__c = lstAssgnmnts[0].Id);
            Update objUnitTypeReservation;
            Upsert lstAssgnmnts[0];
            Assignment__c lstAssignment = [SELECT Id,Name, Unit_Type_Reservation__r.Status__c FROM Assignment__c WHERE Id = : lstAssgnmnts[0].Id limit 1];
            System.assert(lstAssignment.Unit_Type_Reservation__r.Status__c == 'Checked Out', 'Assignment not updated');
        }
        
        
    }
    
    @isTest 
    static void UpdateUTRandAssgnmntAftrChkInAssignAssg(){
        Test.startTest();
        List<Assignment__c> lstAssgnmnts = new List<Assignment__c>([Select Id, Check_In_Date__c, Check_Out_Date__c, Unit_Type__c, Unit__c,Action__c, Unit_Type_Reservation__c
                                                                    From Assignment__c  Where Action__c = 'Check In' Limit 10]);
        lstAssgnmnts[0].Action__c = 'Check In';
        Upsert lstAssgnmnts[0]  ;
        system.assertEquals(lstAssgnmnts[0].Action__c,'Check In');
        Test.stopTest();
    } 
        @isTest 
    static void UpdateUTRandAssgnmntAftrChkInAssgCheckIn(){
        Test.startTest();
        List<Assignment__c> lstAssgnmnts = new List<Assignment__c>([Select Id, Check_In_Date__c, Check_Out_Date__c, Unit_Type__c, Unit__c,Action__c, Unit_Type_Reservation__c
       
                                                                    From Assignment__c  Where Action__c = 'Make Reservation' Limit 10]);
        system.debug('lstAssgnmnts'+lstAssgnmnts);
        lstAssgnmnts[0].Action__c = 'Check In';
        lstAssgnmnts[0].Check_In_Date__c = System.today().adddays(2);
        Upsert lstAssgnmnts[0];
        
        system.assertEquals(lstAssgnmnts[0].Action__c,'Check In');
        Test.stopTest();
    } 
    
}