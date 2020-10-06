public class AccountHelperClass {
    
    public static void primaryLevels(List<Account> accList){
        //Map<String, Job_Rasika__c> jobMap = new Map<String, Job_Rasika__c>([SELECT Id, Active__c from Job_Rasika__c]);
        //List<Job_Rasika__c> jobList=jobMap.values();
        //System.debug(jobMap);
        
        /*for(Account acc: accList){
            if(acc.Level__c = 'Primary'){
                integer countPrimary = accList.size();
    			System.debug(countPrimary);
            }
        }*/
    }
    
}
/*public static void applyInactiveJob(List<Candidate_Rasika__c> cndList){
        Map<String, Job_Rasika__c> jobMap = new Map<String, Job_Rasika__c>([SELECT Id, Active__c from Job_Rasika__c]);
        List<Job_Rasika__c> jobList=jobMap.values();
        //System.debug('List: '+jobList);
        for(Candidate_Rasika__c c: cndList){
        	if(!jobMap.get(c.Job_Rasika__c).Active__c){
            	c.addError('Trigger error: This Job is not active. You can not apply for this job');
            }  
        }
    }*/