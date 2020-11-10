@isTest
public class TrCreateService_InterruptionTest {
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
        Service_Interruption__c objServiceInterruption = new Service_Interruption__c(
            Start_Date__c = system.today().addDays(8),
            End_Date__c = system.today().addDays(9), 
            Unit__c = lstOfUnits[0].Id,
            Interruption_Reason__c= 'Repair'); 
        insert objServiceInterruption;
    }
    @isTest 
    static void createServiceInterruption(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c,Interruption_Reason__c FROM Service_Interruption__c];
        Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(Start_Date__c = system.today().addDays(9), End_Date__c = system.today().addDays(10), Unit__c = lstServiceInterruption[0].Unit__c,Interruption_Reason__c='Repair');
       
        insert objServiceInterruption1;
        System.assert(objServiceInterruption1.Id != NULL, 'Service Interruption Failed to Save');
        
        Service_Interruption__c objServiceInterruption2 = new Service_Interruption__c(Start_Date__c = system.today().addDays(9), End_Date__c = system.today().addDays(10), Unit__c = lstServiceInterruption[0].Unit__c,Interruption_Reason__c='Repair');
        try{
            insert objServiceInterruption2;
        }catch(Exception Ex)
        {
          
            System.AssertEquals(Ex.getMessage().contains('Duplicate entry found please check date and unit'), true);
        }
       
    }
        
    
    @isTest 
    static void createServiceInterruptionNullValue(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c ,Interruption_Reason__c FROM Service_Interruption__c];
        Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(Start_Date__c = null, End_Date__c = null, Unit__c = lstServiceInterruption[0].Unit__c);
        try{
        insert objServiceInterruption1;
        }catch(Exception Ex)
        {
          
            System.AssertEquals(Ex.getMessage().contains('Please Check Start Date and End Date'), false);
        }
       
    }
    
        
    @isTest 
    static void createServiceInterruptionerror(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c,Interruption_Reason__c FROM Service_Interruption__c];
        Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(Start_Date__c = system.today().addDays(-2), End_Date__c =system.today().addDays(2) , Unit__c = lstServiceInterruption[0].Unit__c);
        try{
        insert objServiceInterruption1;
        }catch(Exception Ex)
        {
          
            System.AssertEquals(Ex.getMessage().contains('Start Date should be greater then or equal to Today date'), false);
        }
       
    }
        @isTest 
    static void createServiceInterruptionEndDate(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c,Interruption_Reason__c FROM Service_Interruption__c];
        Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(Start_Date__c = system.today().addDays(2), End_Date__c =system.today().addDays(1) , Unit__c = lstServiceInterruption[0].Unit__c);
        try{
        insert objServiceInterruption1;
        }catch(Exception Ex)
        {
          
            System.AssertEquals(Ex.getMessage().contains('	End Date should be greater then Start Date'), false);
        }
       
    }
    
 
    
     
}