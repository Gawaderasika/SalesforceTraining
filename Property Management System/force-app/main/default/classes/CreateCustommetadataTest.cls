@isTest
public class CreateCustommetadataTest {

    @isTest
    static void createMetadata(){
        
          Test.startTest();
        CreateCustommetadata.createMetadata();
        String jobId = CreateCustommetadata.chktestrunning();
        System.assert(jobId != null);
          Test.stopTest();
    }

    
}