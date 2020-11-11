/************************************************************************************************************************************
Author 		: 	Rutuja Vatharkar
Description :   This test method is used to cover scenarios of apex classes "PropertyManagementSystemController".
History		:
-------------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    06/10/2019		  Rutuja Vatharkar      Initial Development
**************************************************************************************************************************************/
@isTest
public class PropertyManagementSystemControllerTest{
    
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
        
        Unit_Type_Reservation__c objOfUnitTypeReservation = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id, null, 'Active','Make Reservation');
        insert objOfUnitTypeReservation;
        
        Unit_Type_Reservation__c objOfUnitTypeReservation2 = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[1].Unit_Type__c, lstOfContacts[0].Id, lstOfUnits[1].Id, 'Active','Make Reservation');
        objOfUnitTypeReservation2.Start_Date__c = System.today().addDays(7);
        objOfUnitTypeReservation2.End_Date__c = System.today().addDays(8);
        insert objOfUnitTypeReservation2;
        
        Assignment__c objOfAssignment = TestDataFactory.createAssignment(objOfUnitTypeReservation.Id, lstOfUnits[2].Id, lstOfUnits[2].Unit_Type__c, lstOfContacts[0].Id, 'Check In');
        insert objOfAssignment;
             
        Service_Interruption__c objServiceInterruption = TestDataFactory.createServiceInterruption(lstOfUnits[0].Id);
        objServiceInterruption.Start_Date__c = system.today().addDays(8);
        objServiceInterruption.End_Date__c = system.today().addDays(9);
        objServiceInterruption.Interruption_Reason__c= 'Repair';
        insert objServiceInterruption;  
    }

    @isTest
    static void getBookingGridDataTest(){
        Property__c objOfProperty = [SELECT Id, Name FROM Property__c where Name = 'Property' Limit 10];
        PropertyManagementSystemController.BookingGridData objOfBookingGridData = PropertyManagementSystemController.getBookingGridData(objOfProperty.Id);
        System.assert(objOfBookingGridData != null);
        System.assert(objOfBookingGridData.jsonBookingData != null);
        System.assert(objOfBookingGridData.jsonBookingEntities != null);
    }
    
    @isTest
    static void getAssignmentTest(){
        List<Unit_Type_Reservation__c> lstUnitTypeReservation = [SELECT Id, Name FROM Unit_Type_Reservation__c Limit 10];
        List<PropertyManagementSystemController.ReservationInfo>  objOfReservationInfo = PropertyManagementSystemController.getAssignment(lstUnitTypeReservation[0].Id, 'update', null);
        System.assert(objOfReservationInfo[0] != null);
        List<PropertyManagementSystemController.ReservationInfo>  objOfReservationInfo2 = PropertyManagementSystemController.getAssignment(lstUnitTypeReservation[0].Id, 'select','2019-11-9');
        System.assert(objOfReservationInfo2.Size() == 0);
    }
    
    
 

    @isTest
    static void getServiceInterruptionTest(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id, Name, Start_Date__c, End_Date__c, Cancellation_Reason__c,Interruption_Reason__c, Other_Reason__c, Unit__r.Property__c FROM Service_Interruption__c LIMIT 10];
        String  objOfServiceInterruption = PropertyManagementSystemController.getServiceInterruptions(lstServiceInterruption[0].Id);
        System.assertNotEquals(objOfServiceInterruption, Null);
    }
    
    @isTest
    static void getCheckInCheckOutInformationTest(){
        List<Unit_Type_Reservation__c> lstUnitTypeReservation = [SELECT Id, Name FROM Unit_Type_Reservation__c Limit 10];
        List<PropertyManagementSystemController.ReservationInfo>  objOfReservationInfo = PropertyManagementSystemController.getCheckInCheckOutInformation(lstUnitTypeReservation[0].Id);
        System.assert(objOfReservationInfo[0] != null);
        List<PropertyManagementSystemController.ReservationInfo>  objOfReservationInfo2 = PropertyManagementSystemController.getCheckInCheckOutInformation(lstUnitTypeReservation[1].Id);
        System.assert(objOfReservationInfo2[0] != null);
    }
}