public class TripInactiveSchedule implements Schedulable{
    
    public void execute(SchedulableContext sc){
        
        //Any code written in this method can be schedulled
        List<Trip__c> trp = [SELECT id, Date__c, Status__c FROM Trip__c WHERE Date__c > Today];
        for(Trip__c t: trp){
            t.Status__c = false;
        }
        UPDATE trp;
        
        //Database.executeBatch(new TestScheduleBatch());
    }

}