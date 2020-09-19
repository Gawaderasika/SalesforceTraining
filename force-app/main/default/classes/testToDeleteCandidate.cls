public class testToDeleteCandidate {
    public static void deleteCan()
    {
         List<Candidate_Rasika__c> lstObj=[SELECT ID from Candidate_Rasika__c where Expected_Salary__c >=100000];
         delete lstObj;
    }

}