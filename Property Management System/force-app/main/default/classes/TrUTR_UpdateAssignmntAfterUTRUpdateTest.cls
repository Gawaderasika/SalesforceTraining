@isTest
public with sharing class TrUTR_UpdateAssignmntAfterUTRUpdateTest {
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
        objOfUnitTypeReservation.Start_Date__c = system.today().addDays(8);
        objOfUnitTypeReservation.End_Date__c = system.today().addDays(9);
        lstUTR.add(objOfUnitTypeReservation); 
        Unit_Type_Reservation__c objOfUTRChkIn = TestDataFactory.createUnitTypeReservation(lstOfReservation[0].Id, lstOfUnits[0].Unit_Type__c, lstOfContacts[0].Id,lstOfUnits[0].Id,'Checked In','Check In');
        lstUTR.add(objOfUTRChkIn);
        insert lstUTR;
        
        
        List<Assignment__c> lstAssgnmnt = new List<Assignment__c>();
        Assignment__c AssgnmntChkIn = TestDataFactory.createAssignment(lstUTR[0].Id,lstUTR[0].Unit__c,lstUTR[0].Unit_Type__c,lstUTR[0].Reservation_Member_Name__c, 'Make Reservation');
        lstAssgnmnt.add(AssgnmntChkIn);
        Assignment__c AssgnmntChkOut = TestDataFactory.createAssignment(lstUTR[0].Id,lstUTR[0].Unit__c,lstUTR[0].Unit_Type__c,lstUTR[0].Reservation_Member_Name__c,'Check In');
        lstAssgnmnt.add(AssgnmntChkOut);
        insert lstAssgnmnt;
        
        lstUTR[0].Active_Assignment__c = lstAssgnmnt[0].Id;
        lstUTR[1].Active_Assignment__c = null;
        upsert lstUTR;
    }
    @isTest
    static void UpdtUTRChngUnt(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c ,Active_Assignment__c
                                                                                    from Unit_Type_Reservation__c where Action__c = 'Make Reservation' AND Active_Assignment__c != null ]);
        set<Id> setUntTypId = new set<Id>();
        setUntTypId.add(lstUTR[0].Unit_Type__c);
        List<Unit__c> lstUnt =  new List<Unit__c>([Select id from Unit__c where Unit_Type__c IN :setUntTypId]);
        lstUTR[0].Action__c = 'Update Reservation';
        lstUTR[0].Unit__c = lstUnt[1].Id;
        Upsert lstUTR;
        List<Assignment__c> lstAssgnmnt = new  List<Assignment__c>([Select id,Unit__c,Check_Out_Date__c from Assignment__c  where Id =: lstUTR[0].Active_Assignment__c ] );
        System.assert(lstUTR[0].Unit__c == lstAssgnmnt[0].Unit__c );
        
    } 
    @isTest
    static void UpdtUTRChngUntAftrChkIn(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,Active_Assignment__c 
                                                                                    from Unit_Type_Reservation__c where Status__c = 'Checked In' ]);
        set<Id> setUntTypId = new set<Id>();
        setUntTypId.add(lstUTR[0].Unit_Type__c);
        List<Unit__c> lstUnt =  new List<Unit__c>([Select id from Unit__c where Unit_Type__c IN :setUntTypId]);
        lstUTR[0].Action__c = 'Update Reservation';
        lstUTR[0].Unit__c = lstUnt[1].Id;
        Upsert lstUTR;
        List<Unit_Type_Reservation__c> lstUTRAftrUdt = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,Active_Assignment__c 
                                                                                           from Unit_Type_Reservation__c where Id =: lstUTR[0].Id ]);
        List<Assignment__c> lstAssgnmnt = new  List<Assignment__c>([Select id,Unit__c,Check_Out_Date__c from Assignment__c  where Id =: lstUTRAftrUdt[0].Active_Assignment__c ] );
        System.assert(lstUTR[0].Unit__c == lstAssgnmnt[0].Unit__c );
    } 
    @isTest 
    static void UpdtAnyFldofUTR(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,End_Date__c,Active_Assignment__c
                                                                                    from Unit_Type_Reservation__c where  Active_Assignment__c != null ]);
        lstUTR[0].Action__c = 'Update Reservation';
        lstUTR[0].End_Date__c = ((Date)lstUTR[0].End_Date__c).addDays(1);
        Upsert lstUTR;
        List<Unit_Type_Reservation__c> lstUTRAftrUdt = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,Active_Assignment__c 
                                                                                           from Unit_Type_Reservation__c where Id =: lstUTR[0].Id ]);
        List<Assignment__c> lstAssgnmnt = new  List<Assignment__c>([Select id,Unit__c,Check_Out_Date__c from Assignment__c where Id =: lstUTRAftrUdt[0].Active_Assignment__c] );
        System.assert(lstUTRAftrUdt[0].Unit__c == lstAssgnmnt[0].Unit__c );
        
    }
    @isTest
    static void canclResrvatn(){
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c, Start_Date__c, End_Date__c ,Active_Assignment__c
                                                                                    from Unit_Type_Reservation__c where Status__c = 'Active' ]);
        
        lstUTR[0].Action__c = 'Cancel Reservation';
        lstUTR[0].Cancellation_Reason__c='Death';
        lstUTR[0].Start_Date__c = system.today().addDays(7);
        lstUTR[0].End_Date__c = system.today().addDays(8);
        Upsert lstUTR;
        
        List<Assignment__c> lstAssgnmnt = new  List<Assignment__c>([Select id,Action__c from Assignment__c where Id =: lstUTR[0].Active_Assignment__c] );
        System.assert( lstAssgnmnt[0].Action__c == 'Cancel Reservation' );
    }
    @isTest 
    static void canclResrvatnError(){
        try{
            List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,End_Date__c 
                                                                                        from Unit_Type_Reservation__c where Status__c = 'Checked In' ]);
            lstUTR[0].Action__c = 'Cancel Reservation';
            Upsert lstUTR;
        }
        catch(Exception ex){
            System.AssertNotEquals(ex.getMessage().contains('Cannot Cancel Reservation'), true); 
        }
    } 
    @isTest
    static void extndResrvatn(){
        List<Unit_Type_Reservation__c> lstUTR1 = new List<Unit_Type_Reservation__c>([Select id,Status__c, End_Date__c, Unit_Type__c, Unit__c
                                                                                     from Unit_Type_Reservation__c]);
        delete lstUTR1[1];
        
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,End_Date__c,Active_Assignment__c 
                                                                                    from Unit_Type_Reservation__c where Status__c = 'Active' ]);
        lstUTR[0].Action__c = 'Change Reservation';
        lstUTR[0].End_Date__c = ((Date)lstUTR[0].End_Date__c).addDays(1);
        Upsert lstUTR;
        List<Assignment__c> lstAssgnmnt = new  List<Assignment__c>([Select id,Check_Out_Date__c from Assignment__c where Id =: lstUTR[0].Active_Assignment__c] );
        System.assert(lstUTR[0].End_Date__c == lstAssgnmnt[0].Check_Out_Date__c );
    } 
    @isTest
    static void extndResrvatnError(){
        try{
            List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,End_Date__c 
                                                                                        from Unit_Type_Reservation__c where Status__c = 'Active' ]);
            lstUTR[0].Action__c = 'Change Reservation';
            Upsert lstUTR;
            
        }
        catch(Exception ex){
            
            System.AssertEquals(ex.getMessage().contains('Cannot Change the Reservation. Please select valid date'), true);
        }
    }
    
    @isTest
    static void ChangeResrvatnError(){
        try{
            List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c,End_Date__c 
                                                                                        from Unit_Type_Reservation__c where Status__c = 'Active' ]);
            lstUTR[0].Action__c = 'Change Reservation';
            lstUTR[0].End_Date__c = Date.today();
            Upsert lstUTR;
            
        }
        catch(Exception ex){
            
            System.AssertEquals(ex.getMessage().contains('Cannot Change the Reservation. Please select valid date'), false);
        }
    }
    
      @isTest
    static void UpdtUTRChngUntwthSIUnit(){
        List <Service_Interruption__c> lstServiceI =new List<Service_Interruption__c>([SELECT Id, Start_Date__c, End_Date__c, Unit__c FROM Service_Interruption__c ]);
        system.debug('lstServiceI'+lstServiceI);
        List<Unit_Type_Reservation__c> lstUTR = new List<Unit_Type_Reservation__c>([Select id,Action__c,Unit_Type__c, Unit__c ,Active_Assignment__c
                                                                                    from Unit_Type_Reservation__c where Action__c = 'Make Reservation' AND Active_Assignment__c != null ]);
        system.debug('lstUTR'+lstUTR);
        set<Id> setUntTypId = new set<Id>();
        setUntTypId.add(lstUTR[0].Unit_Type__c);
        List<Unit__c> lstUnt =  new List<Unit__c>([Select id from Unit__c where Unit_Type__c IN :setUntTypId]);
        lstUTR[0].Action__c = 'Update Reservation';
        lstUTR[0].Unit__c = lstUnt[1].Id;
        Upsert lstUTR;
        List<Assignment__c> lstAssgnmnt = new  List<Assignment__c>([Select id,Unit__c,Check_Out_Date__c from Assignment__c  where Id =: lstUTR[0].Active_Assignment__c ] );
        System.assert(lstUTR[0].Unit__c == lstAssgnmnt[0].Unit__c );
        
    }
    
}