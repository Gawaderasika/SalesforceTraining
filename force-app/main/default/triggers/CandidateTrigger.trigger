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
trigger CandidateTrigger on Candidate_Rasika__c (before insert, before update, after update,after insert) {
    
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
            try{
            List<Candidate_Rasika__c> con = new List<Candidate_Rasika__c>([SELECT Id, Email__c, Status__c FROM Candidate_Rasika__c WHERE Status__c = 'HIRED']);
            for(Candidate_Rasika__c c: con){
                if(c.Status__c == 'Hired'){
                    CandidateFutureApexSendEmail.SendToCandidate(c.Id, c.Email__c);
                }
            }
        }
        catch(Exception ee){}
        }
        
        else if(Trigger.isAfter && Trigger.isUpdate){
            System.debug('*************************Application date cannot be modified*************************');
            TriggerHelperClass.applicationDate(Trigger.old, Trigger.new);   
        }
        
        else if(Trigger.isAfter && Trigger.isInsert){
            System.debug('*************************Delete candidate if Expected_Salary__c >=100000*************************');
            TriggerHelperClass.deleteCandidate();
        }
        /*else if(Trigger.isbefore && Trigger.isUpdate){
        try{
            List<Candidate_Rasika__c> con = new List<Candidate_Rasika__c>([SELECT Id, Email__c, Status__c FROM Candidate_Rasika__c WHERE Status__c = 'HIRED']);
            for(Candidate_Rasika__c c: con){
            if(c.Status__c == 'Hired'){
                SendEmail.SendToCandidate(c.Id, c.Email__c);
            }
        }
        }
        catch(Exception ee){}
    }*/
    }
    else{}
}

//EmailHired