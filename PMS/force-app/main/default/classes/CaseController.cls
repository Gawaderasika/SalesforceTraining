public with sharing class CaseController {
    public CaseController() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Case> getAllCases(String subject){
        String key = '%' +subject +'%';
        List<Case> caseList = [Select Id, Subject, Description, Status, Origin 
                                      FROM Case Where Subject Like: key];
        /*
            Select id,Subject,CaseNumber From Case Where Subject Like '%su%'
            Select Id, Subject, Description, Status, Origin 
                                      FROM Case Where Subject Like '%su%']

        */
        return caseList;
    }
}