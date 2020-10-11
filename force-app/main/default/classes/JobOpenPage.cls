public class JobOpenPage {
    
	public Job_Rasika__c selectJob{get;set;}
    List<Job_Rasika__c> lstJob = new List<Job_Rasika__c>([SELECT Id, Name from Job_Rasika__c where Active__c = true]);
    public String jobId{get;set;}
    public JobOpenPage(){
    }
     
    public List<SelectOption> getJobsOptions() {
        List<SelectOption> jobOptions = new List<SelectOption>();
        for(Job_Rasika__c jb : lstJob){
            jobOptions.add(new SelectOption(jb.Name, jb.Name));
            jobId = jb.Name;
        }
        return jobOptions;
    }
    
    public String getOpen(){
        return(jobId);
    }
    public PageReference save(){
        PageReference candidateForm = new PageReference('/apex/CandidateRegistrationCustom');
        return(candidateForm);
    }
}