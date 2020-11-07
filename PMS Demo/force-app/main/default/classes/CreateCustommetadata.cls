public without sharing class CreateCustommetadata implements Metadata.DeployCallback{
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
        } else {
        }
    }
    
    //Method to create fields for Custom metadata object
    public  static MetadataService.CustomField createField(String fullName,String description,string fieldManageability , String label, String type, integer length,boolean required, String defaultValue,integer precision,integer scale,integer visibleLines){
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = fullName;
        customField.description = description;
        customField.fieldManageability = fieldManageability;
        customField.label = label;
        customField.type_x = type;
        if(length > 0)
            customField.length = length;
        customField.required = required;
        if(!String.isBlank(defaultValue)){
            customField.defaultvalue = defaultValue;
        }
        if(type == 'Number')
        {
            customField.precision = precision;
            customField.scale = scale;
        }
        if(visibleLines > 0){
            customField.visibleLines = visibleLines;
        }
        return customField;
    }
    
    // method to create picklist values for picklist datatype field
    public static MetadataService.CustomValue creatPkLstValues(String fullName, boolean defaultvalue, String label ){
        MetadataService.CustomValue value = new MetadataService.CustomValue();
        
        value.fullname = fullName;
        value.default_x = defaultvalue;
        value.label = label;
        return value;
    }
    
    //method to create metadata
    public static void createMetadata(){             
        MetadataService.MetadataPort metadataservice = new MetadataService.MetadataPort();
        metadataservice.SessionHeader = new MetadataService.SessionHeader_element();
        if(Test.isRunningTest()){
            metadataservice.SessionHeader.sessionId = UserInfo.getSessionId();
        }else{
            metadataservice.SessionHeader.sessionId = Page.GetSessionIdForLWC.getContent().toString();
        }
        
        List<MetadataService.Metadata> customObj = new List<MetadataService.Metadata>();
        
        MetadataService.CustomObject customobject = new MetadataService.CustomObject();
        customobject.fullName = 'Trigger_configuration__mdt';
        customobject.description = 'Trigger configuration to run trigger classes';
        customobject.label = 'TriggerConfiguration';
        customobject.pluralLabel = 'TriggerConfiguration'; 
        customobject.visibility = 'Public';
        customObj.add(customobject);
        if(!Test.isRunningTest()){
            metadataservice.createMetadata(customObj);
        }
        List<MetadataService.Metadata> lstFieldsToCreat = new List<MetadataService.Metadata>();
        
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.Class_Name__c','Class name to execute','DeveloperControlled', 'ClassName', 'Text', 60,true, null,0,0,0));
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.Is_Active__c','Turn ON and OFF trigger classes','SubscriberControlled','IsActive','Checkbox',0 ,false,'true',0,0,0));
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.Object_Api_Name__c','Name of object for which you want to run this class','DeveloperControlled','ObjectApiName','Text',80,true, null,0,0,0));
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.Record_Types_API_Names__c','Record types for which this class should execute','DeveloperControlled','RecordTypesAPINames','TextArea',0,false,null,0,0,0));
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.Recursion_times__c','','DeveloperControlled','Recursion_times','Number',0,false,'ABS(1)',1,0,0));
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.SortOrder__c','','SubscriberControlled','SortOrder','Number',0,false,null,3,0,0));
        lstFieldsToCreat.add(createField('Trigger_configuration__mdt.UpdatedFields__c','','DeveloperControlled','UpdatedFields','LongTextArea',32768,false,null,0,0,3));
        
        // creating picklist field
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = 'Trigger_configuration__mdt.Event_Type__c';
        customField.label = 'EventType';
        customField.type_x = 'Picklist';
        customField.description = '';
        customField.fieldManageability = 'DeveloperControlled';
        customField.required = true;
        
        List<MetadataService.CustomValue> lstValues = new List<MetadataService.CustomValue>();
        lstValues.add(creatPkLstValues('AFTER_INSERT', true, 'AFTER_INSERT'));
        lstValues.add(creatPkLstValues('AFTER_UPDATE', false, 'AFTER_UPDATE'));
        lstValues.add(creatPkLstValues('AFTER_UNDELETE', false, 'AFTER_UNDELETE'));
        lstValues.add(creatPkLstValues('AFTER_DELETE', false, 'AFTER_DELETE'));
        lstValues.add(creatPkLstValues('BEFORE_INSERT', false, 'BEFORE_INSERT'));
        lstValues.add(creatPkLstValues('BEFORE_UPDATE', false, 'BEFORE_UPDATE'));
        lstValues.add(creatPkLstValues('BEFORE_DELETE', false, 'BEFORE_DELETE'));
        System.debug('lstValues: '+lstValues);
        //valueSetDefinition
        MetadataService.ValueSetValuesDefinition vsd = new MetadataService.ValueSetValuesDefinition();
        vsd.value = lstValues;
        vsd.sorted = false;
        //valueSet
        MetadataService.ValueSet vs = new MetadataService.ValueSet();
        vs.valueSetDefinition = vsd;
        vs.restricted = true;
        //Set valueSet
        customField.valueSet = vs;
        lstFieldsToCreat.add(customField);
        if(!Test.isRunningTest()){
            try{
                List<MetadataService.SaveResult> results = metadataservice.createMetadata(lstFieldsToCreat);
            }
            catch (exception ex){
                System.debug('exception -- ' + ex);
            }
        }      
    }
    
    
    public static string chktestrunning(){
        string jobId ;
        if(Test.isRunningTest()){
            jobId = 'abx0978y63423' ;
        }
        else
            jobId = '';
        return jobId;
    }
    
}