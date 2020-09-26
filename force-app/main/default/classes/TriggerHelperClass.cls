/********************************************************************** 
Name: TriggerHelperClass
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Helper class for JobTrigger and CandidateTrigger
------- 
====================================================== 
====================================================== 
History 
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 10/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class TriggerHelperClass {
    
    /*******************************************************************
	Purpose: Send email to manager
	********************************************************************/
	public static void sendMail(String address, String subject, String body) {
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {address};
       mail.setToAddresses(toAddresses);
       mail.setSubject(subject);
       mail.setPlainTextBody(body);
       Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       inspectResults(results);
       System.debug('email sending');
   }
   //check status of email
   private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
       Boolean sendResult = true;
       for (Messaging.SendEmailResult res : results) {
           if (res.isSuccess()) {
               System.debug('Email sent successfully');
           }
           else {
               sendResult = false;
               System.debug('The following errors occurred: ' + res.getErrors());                
           }
       }
       return sendResult;
   }
    
    /*******************************************************************
	Purpose: Active job cannot be deleted
	********************************************************************/
    public static void isJobActive(List<Job_Rasika__c> jobList){
        for(Job_Rasika__c job: jobList){
        	if(job.Active__c == True){
        		job.addError('Trigger error: This Job is active and can not be deleted');
        	}
        }
    }
    
    /*******************************************************************
	Purpose: Deactivate job when no.of positions are equal to hired candidates
	********************************************************************/
    public static void isHired(List<Job_Rasika__c> jobList){
        for(Job_Rasika__c job: jobList){
        	if(job.Number_of_Positions__c == job.Hired_Applicants__c){
                if(job.Active__c == true){
                	job.Active__c = false;
                }
            }
        }
    }
    
    /*******************************************************************
	Purpose: Activate job when no.of positions are more than hired candidates
	********************************************************************/
    public static void activateJob(List<Job_Rasika__c> jobList){
        for(Job_Rasika__c job: jobList){
            if(job.Number_of_Positions__c > job.Hired_Applicants__c){
                if(job.Active__c == false){
                	job.Active__c = true;
                }
            }
        }
    }
    
    /*******************************************************************
	Purpose: Expected salary missing error
	********************************************************************/
    public static void expectedSalary(List<Candidate_Rasika__c> cndList){
        for(Candidate_Rasika__c c: cndList){
        	if(c.Expected_Salary__c == null){
            	c.addError('Test-method: Trigger error: Expected Salary field is missing');
            }
        }
    }
    
    /*******************************************************************
	Purpose: Cannot apply to inactive job
	********************************************************************/
    public static void applyInactiveJob(List<Candidate_Rasika__c> cndList){
        Map<String, Job_Rasika__c> jobMap = new Map<String, Job_Rasika__c>([SELECT Id, Active__c from Job_Rasika__c]);
        List<Job_Rasika__c> jobList=jobMap.values();
        //System.debug('List: '+jobList);
        for(Candidate_Rasika__c c: cndList){
        	if(!jobMap.get(c.Job_Rasika__c).Active__c){
            	c.addError('Trigger error: This Job is not active. You can not apply for this job');
            }  
        }
    }
    
    /*******************************************************************
	Purpose: Cannot modify application date
	********************************************************************/
    public static void applicationDate(List<Candidate_Rasika__c> oldList, List<Candidate_Rasika__c> newList){
        for(Candidate_Rasika__c oldDate: oldList){
        	for(Candidate_Rasika__c newDate: newList){
            	if(oldDate.Id == newDate.Id && oldDate.Application_Date__c != newDate.Application_Date__c){
                	newDate.addError('Trigger error: Application date cannot be changed');
                }
            }
        }
    }
    
    /*******************************************************************
	Purpose: Delete candidate if Expected_Salary__c >=100000
	********************************************************************/
   	public static void deleteCandidate()
    {
         List<Candidate_Rasika__c> cnd=[SELECT ID from Candidate_Rasika__c where Expected_Salary__c >=100000];
         delete cnd;
    }
}