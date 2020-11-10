global with sharing class PostInstallPwrPMS implements InstallHandler, Metadata.DeployCallback {
    global void onInstall(InstallContext context) {
        createTriggerConfigurationRecords();
    }

    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
        } else {
        }
    }

    @future
    public static void creatMDTrecordsInFuture(){
        createRecords();
    }

    public static void createRecords(){
            Sobject sobjectRecord ;
            while( sobjectRecord==null){
                if(System.Type.forName('Trigger_configuration__mdt') != null){
                    sobjectRecord =  (Sobject)System.Type.forName('Trigger_configuration__mdt').newInstance();
                }
            }

            List<String> lstClassname = new List<String>();
            List<sObject> lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c FROM Trigger_configuration__mdt LIMIT 200');
            if(lstTriggerConfig != NULL){
                for(sObject triggerConfigurationRecord : lstTriggerConfig){
                    lstClassname.add((String)triggerConfigurationRecord.get('Class_Name__c'));
                }
            }

            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            if( ! lstClassname.contains('TrReservationUpdateUTROnCancel') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrReservationUpdateUTROnCancel', 'TrReservationUpdateUTROnCancel', 'TrReservationUpdateUTROnCancel', 'AFTER_UPDATE', true, 'Reservation__c', 1));

            if( ! lstClassname.contains('TrReservationStatusUpdateonUTR') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrReservationStatusUpdateonUTR', 'TrReservationStatusUpdateonUTR', 'TrReservationStatusUpdateonUTR', 'AFTER_UPDATE', true, 'Unit_Type_Reservation__c', 1));

            if( ! lstClassname.contains('TrAssignment_UpdtAsgmtAftrChkIn') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrAssignment_UpdateAssgnmntAfterChkIn', 'TrAssignment_UpdateAssgnmntAfterChkIn', 'TrAssignment_UpdtAsgmtAftrChkIn', 'BEFORE_UPDATE', true, 'Assignment__c', 1));

            if( ! lstClassname.contains('TrAssignment_CrtAsngmtAftrChkIn') )
              mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrAssignment_CreatAssngmntAfterCheckIn', 'TrAssignment_CreatAssngmntAfterCheckIn', 'TrAssignment_CrtAsngmtAftrChkIn', 'AFTER_INSERT', true, 'Assignment__c', 1));

            if( ! lstClassname.contains('TrCreateService_Interruption') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrCreateService_Interruption', 'TrCreateService_Interruption', 'TrCreateService_Interruption', 'BEFORE_INSERT', true, 'Service_Interruption__c', 1));

            if( ! lstClassname.contains('TrUpdateService_Interruption') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrUpdateService_Interruption', 'TrUpdateService_Interruption', 'TrUpdateService_Interruption', 'BEFORE_UPDATE', true, 'Service_Interruption__c', 1));

            if( ! lstClassname.contains('TrUTR_CreateAssignment') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrUTR_CreateAssignment', 'TrUTR_CreateAssignment', 'TrUTR_CreateAssignment', 'BEFORE_INSERT', true, 'Unit_Type_Reservation__c', 1));

            if( ! lstClassname.contains('TrUTR_UpdateAssignmntAfterUTRInsrt') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrUTR_UpdateAssignmntAfterUTRInsrt', 'TrUTR_UpdateAssignmntAfterUTRInsrt', 'TrUTR_UpdateAssignmntAfterUTRInsrt', 'AFTER_INSERT', true, 'Unit_Type_Reservation__c', 1));

            if( ! lstClassname.contains('TrUTR_UpdateAssignmntAfterUTRUpdate') )
                mdContainer.addMetadata(getCustomMetadataRecord('Trigger_configuration.TrUTR_UpdateAssignmntAfterUTRUpdate', 'TrUTR_UpdateAssignmntAfterUTRUpdate', 'TrUTR_UpdateAssignmntAfterUTRUpdate', 'BEFORE_UPDATE', true, 'Unit_Type_Reservation__c', 1));

            PostInstallPwrPMS callback = new PostInstallPwrPMS();
            if( mdContainer.getMetadata().Size() > 0  )
                String jobId = Test.isRunningTest() ? '' :Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }

    public static void createTriggerConfigurationRecords(){

        try{
            Sobject sobjectRecord =  (Sobject)System.Type.forName('Trigger_configuration__mdt').newInstance();
        }
        catch(exception ex){
            CreateCustommetadata.createMetadata();
            creatMDTrecordsInFuture();
        }
    }
    public static Metadata.CustomMetadata getCustomMetadataRecord(String customMetadataFullName, String customMetadataLabel, String className, String eventType, Boolean isActive, String onjectApiName, Integer recursionTime){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = customMetadataFullName;
        customMetadata.label = customMetadataLabel;

        //add field value
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'Class_Name__c';
        customField.value = className;
        customMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'Event_Type__c';
        customField.value = eventType;
        customMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'Is_Active__c';
        customField.value = isActive;
        customMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'Object_Api_Name__c';
        customField.value = onjectApiName;
        customMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'Recursion_times__c';
        customField.value = recursionTime;
        customMetadata.values.add(customField);
        return customMetadata;

    }
    Public static Sobject creatTriggerConfigurationRecordForTest(String ClassName, String ObjectAPIName, String EventType, String RecordTypAPIName, integer RecursionTime, String UpdatedField, boolean IsActive){
        Sobject sobjectRecord =  (Sobject)System.Type.forName('Trigger_configuration__mdt').newInstance();
                sobjectRecord.put('Class_Name__c', ClassName);
                sobjectRecord.put('Object_API_Name__c', ObjectAPIName);
                sobjectRecord.put('Event_Type__c', EventType);
                sobjectRecord.put('Record_Types_API_Names__c', RecordTypAPIName);
                sobjectRecord.put('Recursion_times__c', RecursionTime);
                sobjectRecord.put('UpdatedFields__c', UpdatedField);
                sobjectRecord.put('Is_Active__c', IsActive);
        return sobjectRecord;
    }
    public static List<sObject> getTriggerConfigurationRecordForTest(String strObjectName, List<sObject> lstTriggerConfig){
        switch on strObjectName {
            when 'Reservation__c' {
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrReservationUpdateUTROnCancel', 'Reservation__c', 'BEFORE_UPDATE', '',1,'',true ));
            }
            when 'assignment__c' {
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrAssignment_CrtAsngmtAftrChkIn', 'Assignment__c', 'AFTER_INSERT', '',1,'',true ));
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrAssignment_UpdtAsgmtAftrChkIn', 'Assignment__c', 'BEFORE_UPDATE', '',1,'',true ));
            }
            when 'service_interruption__c' {
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrCreateService_Interruption', 'Service_Interruption__c', 'BEFORE_INSERT', '',1,'',true ));
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrUpdateService_Interruption', 'Service_Interruption__c', 'BEFORE_UPDATE', '',1,'',true ));
            }
            when 'unit_type_reservation__c' {
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrUTR_CreateAssignment', 'Unit_Type_Reservation__c', 'BEFORE_INSERT', '',1,'',true ));
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrUTR_UpdateAssignmntAfterUTRInsrt', 'Unit_Type_Reservation__c', 'AFTER_INSERT', '',1,'',true ));
                lstTriggerConfig.add(creatTriggerConfigurationRecordForTest('TrUTR_UpdateAssignmntAfterUTRUpdate', 'Unit_Type_Reservation__c', 'BEFORE_UPDATE', '',1,'',true ));
            }
            when else {
            }
        }
        return lstTriggerConfig;
    }
}