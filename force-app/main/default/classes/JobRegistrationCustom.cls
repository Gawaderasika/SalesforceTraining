public class JobRegistrationCustom {
    public Job_Rasika__c c {get; private set;}
    public JobRegistrationCustom(){
        Id id = ApexPages.currentPage().getParameters().get('id');
        c = (id == null) ? new Job_Rasika__c():
        	[SELECT Name,Certification_Required__c,Description__c,Expires_On__c,Hired_Applicants__c,Manager__c,Name__c,Number_of_Positions__c,Qualifications_Required__c,Required_Skills__c,Salary_Offered__c,Total_Applicants__c FROM Job_Rasika__c where id = :id];
    }
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