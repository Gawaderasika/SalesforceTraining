public inherited sharing class StudentApexRecordInheritedSharing {
	public List<Student__c> getAllStudents(){
        return [SELECT Id, Name, Admission_Date__c FROM Student__c];
    }
}