/********************************************************************** 
Name: JobRegistrationCustomController
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Custom Controller on Job object
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 07/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 

public class JobRegistrationCustomController {
    public Job_Rasika__c c {get; set;}
    
    // Constructors
    public JobRegistrationCustomController(){
        Id id = ApexPages.currentPage().getParameters().get('id');
        c = (id == null) ? new Job_Rasika__c():
        	[SELECT Name,Certification_Required__c,Description__c,Expires_On__c,Hired_Applicants__c,Manager__c,Name__c,Number_of_Positions__c,Qualifications_Required__c,Required_Skills__c,Salary_Offered__c,Total_Applicants__c FROM Job_Rasika__c where id = :id];
    }
    
/*******************************************************************
Purpose: Method for saving data after upsert
Parameters: [optional]
Returns: [optional]
Throws [Exceptions]: [optional]
********************************************************************/
    public PageReference save(){
        try{
            upsert(c);
        }
        catch(System.DmlException e){
            ApexPages.addMessages(e);
            return null;
        }
        PageReference redirectSuccess = new ApexPages.StandardController(c).view();
        return(redirectSuccess);
    }
}