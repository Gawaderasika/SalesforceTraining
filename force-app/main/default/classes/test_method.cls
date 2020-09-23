@isTest
public class test_method {
    @isTest static void expected_salary(){
        List<Candidate_Rasika__c> can = new List<Candidate_Rasika__c>();
        Candidate_Rasika__c c1 = new Candidate_Rasika__c(First_Name__c='fname',Last_Name__c = 'lname', email__c = 'rsk@gmail.com', status__c = 'Hired', Job_Rasika__c='a0B2w000001hhYuEAI');
        can.add(c1);
        Test.startTest();
        try{insert can;}
        catch(Exception ee){}
    	Test.stopTest();
    }
    @isTest static void inactiveJOb(){
        List<Candidate_Rasika__c> can = new List<Candidate_Rasika__c>();
        Candidate_Rasika__c c1 = new Candidate_Rasika__c(First_Name__c='fname',Last_Name__c = 'lname', email__c = 'rsk@gmail.com', status__c = 'Hired', Job_Rasika__c='a0B2w000001hhZT');
        can.add(c1);
        Test.startTest();
        try{insert can;}
        catch(Exception ee){}
    	Test.stopTest();
    }
    @isTest static void applicationDate(){
        List<Candidate_Rasika__c> can = new List<Candidate_Rasika__c>();
        Candidate_Rasika__c c1 = new Candidate_Rasika__c(First_Name__c='fname',Last_Name__c = 'lname', email__c = 'rsk@gmail.com', status__c = 'Hired', Job_Rasika__c='a0B2w000001hhZT', Application_Date__c = Date.parse('09/20/2020'));
        can.add(c1);
        Test.startTest();
        try{insert can;}
        catch(Exception ee){}
        c1.Application_Date__c = Date.parse('09/25/2020');
    	Test.stopTest();
    }
    @isTest static void cannotDeleteActiveJob(){
        List<Job_Rasika__c> jb = new List<Job_Rasika__c>();
        Job_Rasika__c j1 = new Job_Rasika__c(Number_of_Positions__c = 2, Manager__c = '0032w00000JBmQM', Required_Skills__c = 'Team Player', Certification_Required__c = '(MPM) Master Project Manager', Qualifications_Required__c='MBA', Active__c = true);
        jb.add(j1);
        Test.startTest();
        try{insert jb;
           delete(jb);}
        catch(Exception ee){}
    	Test.stopTest();
    }
    @isTest static void activeFalse(){
        Job_Rasika__c j2 = new Job_Rasika__c();
        j2.id = 'a0B2w000001hf1b';
        Test.startTest();
       	j2.Number_of_Positions__c = 0;
    	Test.stopTest();
    }
    @isTest static void activeTrue(){
        Job_Rasika__c j3 = new Job_Rasika__c();
        j3.id = 'a0B2w000001hhLy';
        Test.startTest();
       	j3.Number_of_Positions__c = 0;
    	Test.stopTest();
    }
}