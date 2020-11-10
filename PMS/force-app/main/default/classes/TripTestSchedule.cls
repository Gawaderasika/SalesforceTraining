@isTest
public class TripTestSchedule {
    
    //Test Methods
    @isTest static void inactiveTrip(){
        Date dt = Date.parse('9/27/2020');
        List<Trip__c> trp = new List<Trip__c>();
        Trip__c t = new Trip__c(Date__c = dt, Starting_Mile__c = 1, Ending_Mileage__c = 10, Description__c = 'test', Account__c='0012w00000MWvuK', Status__c = true);
        Trp.add(t);
        Test.startTest();
        try{
            insert Trp;
        }
        catch(Exception ee){}
        
    	Test.stopTest();
    }
}