/********************************************************************** 
Name: CandidateTrigger
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Candidate object -Trigger Test Methods
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
trigger CandidateTrigger on Candidate_Rasika__c (before insert, after update,after insert) {
    
    /*****************************************************************************************************************
	Checking custom setting for trigger    
	*****************************************************************************************************************/
    Trigger_settings__c TS = Trigger_settings__c.getInstance( UserInfo.getUserID());
    if(TS.CandidateTrigger__c == true){
        
        if(Trigger.isBefore && Trigger.isInsert){
            System.debug('*************************Whether expected salery is missing*************************');
            TriggerHelperClass.expectedSalary(Trigger.new);
            System.debug('*************************Candidate cannot apply to inactive job*************************');
            TriggerHelperClass.applyInactiveJob(Trigger.new);
    	}
        
    	else if(Trigger.isAfter && Trigger.isUpdate){
            System.debug('*************************Application date cannot be modified*************************');
            TriggerHelperClass.applicationDate(Trigger.old, Trigger.new);	
    	}
        
        else if(Trigger.isAfter && Trigger.isInsert){
            System.debug('*************************Delete candidate if Expected_Salary__c >=100000*************************');
            TriggerHelperClass.deleteCandidate();
        }
    }
    else{}
}