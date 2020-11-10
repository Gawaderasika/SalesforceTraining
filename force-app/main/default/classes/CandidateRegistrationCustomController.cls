/********************************************************************** 
Name: CandidateRegistrationCustomController
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Custom Controller on Candidate object
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 07/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 

public class CandidateRegistrationCustomController {
    public Candidate_Rasika__c c {get; private set;}
    
    // Constructors
    public CandidateRegistrationCustomController(){
        Id id = ApexPages.currentPage().getParameters().get('id');
        //String nameproperty = ApexPages.currentPage().getParameters().get('name');
        //System.debug('nameproperty: '+nameproperty);
        c = (id == null) ? new Candidate_Rasika__c():
        	[SELECT Name,First_Name__c,Last_Name__c, Age__c,Application_Date__c,Country__c,DOB__c,Email__c,Expected_Salary__c,Job_Rasika__c,Full_Name__c,Salutation__c,State__c,Status__c FROM Candidate_Rasika__c where id = :id];
    }
    
/*******************************************************************
Purpose: Method for saving data after upsert
Parameters: [optional]
Returns: [optional]
Throws [Exceptions]: [optional]
********************************************************************/
    public PageReference save(){
        try{
            //insert new Contact(LastName = 'xyz');
            upsert(c);
        }
        catch(System.DmlException e){
            ApexPages.addMessages(e);
            throw e;
        }
        PageReference redirectSuccess = new ApexPages.StandardController(c).view();
        return(redirectSuccess);
    }
}