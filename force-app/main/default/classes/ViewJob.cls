public class ViewJob {
    public List<Job_Rasika__c> job{get;set;}
    public List<Candidate_Rasika__c> records{get;set;}
    public List<String> fields{get;set;}
    public List<String> fields1{get;set;}
    public ViewJob(){
        String Id = ApexPages.currentPage().getParameters().get('id');
        job=[Select Name,Description__c,Number_of_positions__c,Manager__c,Required_skills__c,Certification_Required__c,
             Qualifications_Required__c FROM Job_Rasika__c WHERE Id = :Id];
        fields1 = new List<String>{'Name', 'Description', 'No_of_positions', 'Manager', 'Required_Skills', 'Certification_Required',
            						'Qualifications_Required'};
        records= [Select Name, Full_Name__c, Email__c, Status__c FROM Candidate_Rasika__c WHERE Job_Rasika__c = :Id];
        fields = new List<String>{'Name', 'Full_Name', 'Email', 'Status'};
    }
}