@isTest
public class BookingControllerTest {
	
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
        
        //Unit_Type_Reservation__c objOfUnitTypeReservation = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, null);
        //insert objOfUnitTypeReservation;
        
        //Assignment__c objOfAssignment = TestDataFactory.createAssignment(objOfUnitTypeReservation.Id, lstOfUnits[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id);
        //insert objOfAssignment;  
    }
    
    @isTest
    static void getBookingEntityTest(){
        String PropertyEntities = BookingController.getBookingEntity('Unit_Type__c','Unit__c','');
        System.assert(PropertyEntities != null);
    }
        @isTest
    static void getBookingEntitySubChildTest(){
        String PropertyEntities = BookingController.getBookingEntity('Unit_Type__c','Unit__c','Unit__c');
        System.assert(PropertyEntities == null);
    }
    
    @isTest
    static void getBookingDataTest(){
        String bookingData = BookingController.getBookingData('Assignment__c','Unit_Type__c','Unit__c',NULL,'Check_In_Date__c','Check_Out_Date__c');
        System.assert(bookingData != null);
    }
     @isTest
    static void getBookingDataSubChildTest(){
        String bookingData = BookingController.getBookingData('Assignment__c','Unit_Type__c','Unit__c','Unit__c','Check_In_Date__c','Check_Out_Date__c');
        System.assert(bookingData == null);
    }
}