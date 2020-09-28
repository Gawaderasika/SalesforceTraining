@isTest
public class TestJobScheduler {
    
    //Test Methods
    @isTest static void inactiveJob(){
        Date dt = Date.parse('9/27/2020');
        List<Job_Rasika__c> job = new List<Job_Rasika__c>();
        Job_Rasika__c jb = new Job_Rasika__c(Expires_On__c = dt, Number_of_Positions__c = 1, Manager__c = '0032w00000JD0gS', Certification_Required__c = 'PMP (Project Management Professional', Qualifications_Required__c = 'BBA', Required_Skills__c = 'Team Player');
        job.add(jb);
        Test.startTest();
        try{
            insert job;
        }
        catch(Exception ee){}
        
    	Test.stopTest();
    }
}