@isTest
public class PostInstallPwrPMSTest {
	@isTest
    public static void testInstallScript() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        List<Sobject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt');
        System.assert(lstTriggerConfig != null);
      }
     @isTest
    public static void createRecordtest() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
         PostInstallPwrPMS.createRecords();
        System.assert(customMetadata != null);
      }

    @isTest
    public static void createCustomMetadataRecord() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
         customMetadata = PostInstallPwrPMS.getCustomMetadataRecord('TrReservationUpdateUTROnCancel','TrReservationUpdateUTROnCancel',
                                                                                      'TrReservationUpdateUTROnCancel', 'AFTER_UPDATE', true, 'Reservation__c',
                                                                                      1);
        System.assert(customMetadata != null);
      }
    @isTest
    public static void createTriggerConfigurationRecordstest() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        List<sObject> lstRecordsToReturn = new List<sObject>();
       lstRecordsToReturn.add(PostInstallPwrPMS.creatTriggerConfigurationRecordForTest('TrReservationUpdateUTROnCancel', 'Reservation__c', 'BEFORE_UPDATE', '',1,'',true));
        system.assert(lstRecordsToReturn != null);
      }
          
     @isTest
    public static void getTriggerConfigurationRecordFortest() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        List<Sobject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt');
        System.assert(lstTriggerConfig != null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        PostInstallPwrPMS.getTriggerConfigurationRecordForTest('Reservation__c',lstTriggerConfig);
        
      }   
           
     @isTest
    public static void getTriggerConfigurationRecordFortestassignment() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        List<Sobject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt');
        System.assert(lstTriggerConfig != null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        PostInstallPwrPMS.getTriggerConfigurationRecordForTest('assignment__c',lstTriggerConfig);
        
      } 
      @isTest
    public static void getTriggerConfigurationRecordFortestserviceinterruption() {
       PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        List<Sobject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt');
        System.assert(lstTriggerConfig != null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        PostInstallPwrPMS.getTriggerConfigurationRecordForTest('service_interruption__c',lstTriggerConfig);
        
      } 
      @isTest
    public static void getTriggerConfigurationRecordFortestunittypereservatio() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        List<Sobject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt');
        System.assert(lstTriggerConfig != null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        PostInstallPwrPMS.getTriggerConfigurationRecordForTest('unit_type_reservation__c',lstTriggerConfig);
        
      }
       @isTest
    public static void getTriggerConfigurationRecordFortestunit() {
      PostInstallPwrPMS postinstall = new PostInstallPwrPMS();
        Test.testInstall(postinstall, null);
        List<Sobject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt');
        System.assert(lstTriggerConfig != null);
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        PostInstallPwrPMS.getTriggerConfigurationRecordForTest('',lstTriggerConfig);
        
      }
          
    
}