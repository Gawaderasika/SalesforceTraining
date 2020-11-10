@isTest
public with sharing class TrUTR_CreateAssignmentTest {
    
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
        
        Unit_Type_Reservation__c objOfUnitTypeReservation = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id, lstOfUnits[0].Id, 'Active','Make Reservation');
        insert objOfUnitTypeReservation;
        
        Service_Interruption__c objServiceInterruption = new Service_Interruption__c(
                                                          Start_Date__c = system.today().addDays(10),
                                                          End_Date__c = system.today().addDays(11), 
                                                          Unit__c = lstOfUnits[0].Id,
                                                          Interruption_Reason__c= 'Repair'
        );
        insert objServiceInterruption;
    }
    @isTest 
    static void createAssignmetRecord(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select Id, Start_Date__c, End_Date__c, Unit_Type__c, Unit__c, Status__c, Action__c  From Unit_Type_Reservation__c Limit 10]);
        TrUTR_CreateAssignment trUTRCreateAssgnmnt = new TrUTR_CreateAssignment();
        trUTRCreateAssgnmnt.createAssignmetRecord(new List<Unit_Type_Reservation__c>(lstUTR));
        System.assertNotEquals(null , lstUTR[0].Active_Assignment__c); 
    }
    @isTest
    static void checkValidation(){
    	List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select Id, Start_Date__c, End_Date__c, Unit_Type__c, Unit__c, Status__c, Action__c  From Unit_Type_Reservation__c Limit 10]);
        List<Contact> lstContact = [SELECT Id FROM Contact];
		List<Property__c> lstProperty = [SELECT Id FROM Property__c];
        Reservation__c objReservation = TestDataFactory.createReservation(lstContact[0].Id, lstProperty[0].Id);
        insert objReservation;
        System.assert(objReservation.Id != NULL, 'Reservation not inserted');
        Unit_Type_Reservation__c objOfUnitTypeReservation = new Unit_Type_Reservation__c(Start_Date__c = System.today().addDays(8),
                                                                                         End_Date__c = system.today().addDays(9),
                                                                                         Unit_Type__c = lstUTR[0].Unit_Type__c, 
                                                                                         Unit__c = lstUTR[0].Unit__c,
                                                                                         Reservation_Member_Name__c= lstContact[0].Id,
                                                                                         Reservation__c = objReservation.Id);
		insert objOfUnitTypeReservation;
        System.assert(objOfUnitTypeReservation.Id != NULL, 'Unit type reservation not inserted');
    }
     @isTest
    static void checkValidationForDate(){
    	List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select Id, Start_Date__c, End_Date__c, Unit_Type__c, Unit__c, Status__c, Action__c  From Unit_Type_Reservation__c Limit 10]);
        List<Contact> lstContact = [SELECT Id FROM Contact];
		List<Property__c> lstProperty = [SELECT Id FROM Property__c];
        Reservation__c objReservation = TestDataFactory.createReservation(lstContact[0].Id, lstProperty[0].Id);
        insert objReservation;
        System.assert(objReservation.Id != NULL, 'Reservation not inserted');
        Unit_Type_Reservation__c objOfUnitTypeReservation = new Unit_Type_Reservation__c(Start_Date__c = null,
                                                                                         End_Date__c = null,
                                                                                         Unit_Type__c = lstUTR[0].Unit_Type__c, 
                                                                                         Unit__c = lstUTR[0].Unit__c,
                                                                                         Reservation_Member_Name__c= lstContact[0].Id,
                                                                                     Reservation__c = objReservation.Id);
        try{
		insert objOfUnitTypeReservation;
            
        }
        catch(exception Ex)
        {
             System.assert(objOfUnitTypeReservation.Id == NULL, 'Unit type reservation not inserted');
        }
    
    }

}