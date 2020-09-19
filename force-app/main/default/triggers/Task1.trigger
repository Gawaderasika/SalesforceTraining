trigger Task1 on Candidate_Rasika__c (before insert, after update,after insert) {
    if(Trigger.isBefore){
        List<Job_Rasika__c> cnd = new List<Job_Rasika__c>();
        if(Trigger.isInsert){
            for(Candidate_Rasika__c obj1: Trigger.new){
                if(obj1.Expected_Salary__c == null){
                    obj1.addError('Trigger error: Expected Salary field is missing');
                }
            }
            Map<String, Job_Rasika__c> mapjob = new Map<String, Job_Rasika__c>([SELECT Id, Active__c from Job_Rasika__c]);
            List<Job_Rasika__c> lstObj=mapjob.values();
            System.debug('List: '+lstObj);
            for(Candidate_Rasika__c candidate: Trigger.new){
                if(!mapjob.get(candidate.Job_Rasika__c).Active__c){
                    candidate.addError('Trigger error: This Job is not active. You can not apply for this job');
                }  
                
            }
        }
    }
    else if(Trigger.isAfter){
        if(Trigger.isUpdate){
            for(Candidate_Rasika__c oldDate: Trigger.old){
                for(Candidate_Rasika__c newDate: Trigger.new){
                    if(oldDate.Id == newDate.Id && oldDate.Application_Date__c != newDate.Application_Date__c){
                        newDate.addError('Trigger error: Application date');
                    }
                }
            }
            testToDeleteCandidate.deleteCan();
        }
        if(Trigger.isInsert){
            testToDeleteCandidate.deleteCan();
        }
    }
}