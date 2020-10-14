public without sharing class StudentApexRecordSharing {
    // ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    /*public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name FROM Student__c]));
            }
            return setCon;
        }
        set;
    }
 
    // Initialize setCon and return a list of records
    public List<Student__c> getStudents() {
        return (List<Student__c>) setCon.getRecords();
    }*/
    public List<Student__c> getStudents(){
        StudentApexRecordInheritedSharing obj = new StudentApexRecordInheritedSharing();
        List<Student__c> lstStudent = obj.getAllStudents();
        return lstStudent;
    }
}