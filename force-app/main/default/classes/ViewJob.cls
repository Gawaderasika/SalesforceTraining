/********************************************************************** 
Name: ViewJob
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: To view job details and related candidates details
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 08/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
global class ViewJob {
    
    public List<Job_Rasika__c> job{get;set;}
    public List<Candidate_Rasika__c> candidate{get;set;}
    public List<String> jobRecords{get;set;}
    public List<String> candidateRecords{get;set;}
    public Candidate_Rasika__c c {get; set;}
	Public Boolean PBFlag{get;set;}    
    public static Job_Rasika__c job{get;set;}
    public String JobId {get; set;}
    public ViewJob(){
        
        String Id = ApexPages.currentPage().getParameters().get('id');
        jobRecords = new List<String>{'Name', 'Description', 'No_of_positions', 'Manager', 'Required_Skills', 'Certification_Required',
            						'Qualifications_Required'};
        job=[Select Name,Description__c,Number_of_positions__c,Required_skills__c,Certification_Required__c,
             Qualifications_Required__c , Active__c, (Select Name, Full_Name__c, Email__c, Status__c FROM Candidates_Rasika__r)
 			 FROM Job_Rasika__c WHERE Id =: id];
        candidateRecords = new List<String>{'Name', 'Full_Name', 'Email', 'Status'};
        candidate = job[0].Candidates_Rasika__r;
        c = new Candidate_Rasika__c();
    }
    
    public PageReference save(){
        try{
            upsert(c);
        }
        catch(System.DmlException e){
            ApexPages.addMessages(e);
            throw e;
        }
        PageReference viewJobDetails = new ApexPages.StandardController(c).view();
        return(viewJobDetails);
    }
    @RemoteAction
    global static Job_Rasika__c getJobs(String JobId) {
        job = [SELECT Number_of_positions__c FROM Job_Rasika__c WHERE Id = :JobId];
        job.Number_of_positions__c = job.Number_of_positions__c+1;
        update job;
        return job;
    }
    public PageReference createForm(){
        PageReference candidateForm = new PageReference('/apex/CandidateRegistrationCustom');
        return(candidateForm);
    }
    public void ShowPB(){
  		PBFlag= true;
  	}
}