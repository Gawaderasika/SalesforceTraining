public with sharing class LookupControllerLWC {
    public LookupControllerLWC() {

    }

    /*
    String ObjectName,
    String FiledAPI Name,
    String searchvalue
    */
    @AuraEnabled
    public static List<sObject> findRecords(String objectName, 
    String fieldApiName, String searchValue){
        String key = '%' + searchValue + '%';
        String Query = 'Select Id, '+fieldApiName+' FROM '+objectName+' Where '+fieldApiName+ ' LIKE : key';
        List<sObject> sobjectList = Database.query(Query);
        return sobjectList;
        /*
            Select Id, Name From Account Where Name like '%a%';

        */
    }
}