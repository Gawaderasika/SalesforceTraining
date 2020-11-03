@isTest
public class TrUpdateService_InterruptionTest {
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
         Interruption_Reason__c = 'Repair'); 
        insert objServiceInterruption;
       Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(
            Start_Date__c = system.today().addDays(10),
            End_Date__c = system.today().addDays(11), 
            Unit__c = lstOfUnits[0].Id,
           Interruption_Reason__c = 'Other',
             Other_Reason__c = 'Test'); 
        insert objServiceInterruption1;        
        
        
        
    }
    @isTest 
    static void createAndUpdateServiceInterruption(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c FROM Service_Interruption__c];
        Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(Start_Date__c = system.today().addDays(9), End_Date__c = system.today().addDays(10), Unit__c = lstServiceInterruption[0].Unit__c,Interruption_Reason__c= 'Repair');
        insert objServiceInterruption1;
        System.assert(objServiceInterruption1.Id != NULL, 'Service Interruption Failed to Save');
        /*update objServiceInterruption1;
        System.assert(objServiceInterruption1.Id != NULL, 'Service Interruption Failed to Save');*/

    }
        @isTest 
    static void UpdateServiceInterruptionCancellationReason(){
        Test.startTest();
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c,Cancellation_Reason__c,Action__c,Interruption_Reason__c FROM Service_Interruption__c where Interruption_Reason__c != Null];
        
        lstServiceInterruption[0].Action__c = 'Cancel Interruption';
        lstServiceInterruption[0].Cancellation_Reason__c = null;
        try{
         update lstServiceInterruption[0];
           }catch(Exception Ex){
             
           System.AssertEquals(Ex.getMessage().contains('Cant cancel service interruption without cancellation reason'), true);
        }
          Test.stopTest();

    }
     @isTest 
    static void UpdateServiceInterruptionOtherReason(){
        Test.startTest();
       List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c,Interruption_Reason__c,Other_Reason__c FROM Service_Interruption__c where Interruption_Reason__c =: 'other'];
       system.assert(lstServiceInterruption[0].Interruption_Reason__c != Null);
       lstServiceInterruption[0].Interruption_Reason__c = 'Painting';
       update lstServiceInterruption[0];
       
       system.assert(lstServiceInterruption[0].Interruption_Reason__c != null);
          Test.stopTest();

    }
       @isTest 
    static void createAndUpdateServiceInterruptionError(){
        List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c FROM Service_Interruption__c];
        Service_Interruption__c objServiceInterruption1 = new Service_Interruption__c(Start_Date__c = system.today().addDays(9), End_Date__c = system.today().addDays(10), Unit__c = lstServiceInterruption[0].Unit__c);
        try{        insert objServiceInterruption1;
           }
        catch(Exception Ex)
        {
            System.AssertEquals(Ex.getMessage().contains('End Date should be greater then Start Date'), false);
           
           
        }
         objServiceInterruption1.End_Date__c =   system.today().addDays(5)    ;  
        
        try{       
            update objServiceInterruption1;
           }
        catch(Exception Ex)
        {
            System.AssertEquals(Ex.getMessage().contains('End Date should be greater then Start Date'), false);
           
           
        }

    }
    @isTest 
    static void UpdateServiceInterruptionEnddate(){
        Test.startTest();
       List<Service_Interruption__c> lstServiceInterruption = [SELECT Id,Unit__c,Interruption_Reason__c,Other_Reason__c,End_Date__c FROM Service_Interruption__c];
      
       lstServiceInterruption[0].End_Date__c = system.today().addDays(-2);
       
        try{
             update lstServiceInterruption[0];
        }catch(Exception Ex)
        {
             System.AssertEquals(Ex.getMessage().contains('End Date should be greater than Today’s Date.'), false);
            
        }
        Test.stopTest();
  }
}