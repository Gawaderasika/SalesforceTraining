public class JobBatchApex implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT id, Expires_On__c, Active__c from Job_Rasika__c WHERE Expires_On__c > Today AND Active__c = true');
    }
    
    public void execute(Database.BatchableContext bc, List<Job_Rasika__c> job){
        for(Job_Rasika__c jb: job){
            jb.Active__c = false;
        }
        UPDATE job;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}