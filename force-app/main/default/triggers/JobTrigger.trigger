/********************************************************************** 
Name: JobTrigger
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Job object -Trigger Test Methods
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
trigger JobTrigger on Job_Rasika__c (before delete, after insert, before update) {
    
    /*****************************************************************************************************************
	Checking custom setting for trigger    
	*****************************************************************************************************************/
    Trigger_settings__c TS = Trigger_settings__c.getInstance( UserInfo.getUserID());
    if(TS.JobTrigger__c == true){
        
        if(Trigger.isBefore && Trigger.isDelete){
            System.debug('*************************Checking if the job is active or not*************************');
            System.debug('*************************Active job cannot be deleted*********************************');
        	TriggerHelperClass.isJobActive(Trigger.old);
    	}
        
        
    	else if(Trigger.isAfter && Trigger.isInsert){
            System.debug('*************************Whether no.of positions is euqal to hired candidates*************************');
            System.debug('*************************then deactivate the job*********************************************************');
            System.debug('*************************send email to manager***********************************************************');
            System.debug('*************************else activate the job***********************************************************');
        	TriggerHelperClass.isHired(Trigger.new);
            TriggerHelperClass.sendMail('gawaderasika4@gmail.com','Regarding Hiring process','Test Email');
    	}
        
        
        else if(Trigger.isBefore && Trigger.isUpdate){
            System.debug('*************************Whether if no.of positions is euqal to hired candidates*************************');
            System.debug('*************************then deactivate the job*********************************************************');
            System.debug('*************************send email to manager***********************************************************');
            System.debug('*************************else activate the job***********************************************************');
        	TriggerHelperClass.activateJob(Trigger.new);
        }
    }
    else{}
}