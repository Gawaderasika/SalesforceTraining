/********************************************************************** 
Name: TestMethodsTrigger
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Test Methods for TriggerHelperClass
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
@isTest
public class TestMethodsTrigger {
    
    //Test Methods
    @isTest static void expected_salary(){
        List<Candidate_Rasika__c> candidate = new List<Candidate_Rasika__c>();
        Candidate_Rasika__c c1 = new Candidate_Rasika__c(First_Name__c='fname',Last_Name__c = 'lname', email__c = 'rsk@gmail.com', status__c = 'Hired', Job_Rasika__c='a0B2w000001hhYuEAI');
        candidate.add(c1);
        Test.startTest();
        try{insert candidate;}
        catch(Exception ee){}
    	Test.stopTest();
    }
    @isTest static void inactiveJOb(){
        List<Candidate_Rasika__c> candidate = new List<Candidate_Rasika__c>();
        Candidate_Rasika__c c = new Candidate_Rasika__c(First_Name__c='fname',Last_Name__c = 'lname', email__c = 'rsk@gmail.com', status__c = 'Hired', Job_Rasika__c='a0B2w000001hhZT');
        candidate.add(c);
        Test.startTest();
        try{insert candidate;}
        catch(Exception ee){}
    	Test.stopTest();
    }
    @isTest static void applicationDate(){
        List<Candidate_Rasika__c> candidate = new List<Candidate_Rasika__c>();
        Candidate_Rasika__c c = new Candidate_Rasika__c(First_Name__c='fname',Last_Name__c = 'lname', email__c = 'rsk@gmail.com', status__c = 'Hired', Job_Rasika__c='a0B2w000001hhZT', Application_Date__c = Date.parse('09/20/2020'));
        candidate.add(c);
        Test.startTest();
        try{insert candidate;}
        catch(Exception ee){}
        c.Application_Date__c = Date.parse('09/25/2020');
    	Test.stopTest();
    }
    @isTest static void cannotDeleteActiveJob(){
        List<Job_Rasika__c> job = new List<Job_Rasika__c>();
        Job_Rasika__c j = new Job_Rasika__c(Number_of_Positions__c = 2, Manager__c = '0032w00000JBmQM', Required_Skills__c = 'Team Player', Certification_Required__c = '(MPM) Master Project Manager', Qualifications_Required__c='MBA', Active__c = true);
        job.add(j);
        Test.startTest();
        try{insert job;
           delete(job);}
        catch(Exception ee){}
    	Test.stopTest();
    }
    @isTest static void activeFalse(){
        Job_Rasika__c j = new Job_Rasika__c();
        j.id = 'a0B2w000001hf1b';
        Test.startTest();
       	j.Number_of_Positions__c = 0;
    	Test.stopTest();
    }
    @isTest static void activeTrue(){
        Job_Rasika__c j = new Job_Rasika__c();
        j.id = 'a0B2w000001hhLy';
        Test.startTest();
       	j.Number_of_Positions__c = 0;
    	Test.stopTest();
    }
}