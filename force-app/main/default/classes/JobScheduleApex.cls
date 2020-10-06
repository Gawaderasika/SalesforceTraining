public class JobScheduleApex implements Schedulable{
    
    public void execute(SchedulableContext sc){
        
        //Any code written in this method can be schedulled
        List<Job_Rasika__c> job = [SELECT id, Expires_On__c, Active__c FROM Job_Rasika__c WHERE Expires_On__c > Today AND Active__c = true];
        for(Job_Rasika__c jb: job){
            jb.Active__c = false;
        }
        UPDATE job;
        
        //Database.executeBatch(new JobScheduleBatch());
    }

}
//jobscheduler