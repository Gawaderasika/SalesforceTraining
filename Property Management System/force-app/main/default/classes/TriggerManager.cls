/************************************************************************************************************************************
Author 		: 	Enzigma Software Pvt LTD.
Description :   Standard class to manage all trigger classes.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					       DETAIL
1	 	05/02/2019			Enzigma Software Pvt LTD.
**************************************************************************************************************************************/
public with sharing class TriggerManager {
    
    public static Map <String, Map<String, List<CustomBusinessProcess>>> mapBusinessProcesses = new Map <String, Map<String, List<CustomBusinessProcess>>>();
    
    public static void execute(String strObjectName) {
        strObjectName = strObjectName.toLowerCase();
        System.debug('In TriggerManager Trigger.operationType---'+strObjectName);
        System.debug('In TriggerManager Trigger.operationType---'+Trigger.operationType);
        List<CustomBusinessProcess> lstBusinessProcesses = getBusinessProcesses(strObjectName, String.valueOf(Trigger.operationType));
        if(lstBusinessProcesses != null) {
            for(CustomBusinessProcess process : lstBusinessProcesses) {
                process.execute();
            }
        }
    }
    
    /*********************************************************************************************************************************
        Description  :   This method will create an object according to every Custom Metadata type and returns the List of CustomBusinessProcess .
    *********************************************************************************************************************************/
    public static List<CustomBusinessProcess> getBusinessProcesses(String strObjectName, String operationType) {
        if(!mapBusinessProcesses.containsKey(strObjectName)) {
            Map<String, List<CustomBusinessProcess>> mapEventProcessess = new Map<String, List<CustomBusinessProcess>>();
             List<sObject> lstTriggerConfig = new List<sObject> ();
            if(!Test.isRunningTest()) {
               
               lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c, SortOrder__c, Event_Type__c,  Record_Types_API_Names__c, Recursion_times__c, UpdatedFields__c FROM Trigger_configuration__mdt WHERE Object_API_Name__c LIKE: strObjectName AND Is_Active__c = true ORDER BY SortOrder__c') ; 
            } else {
                lstTriggerConfig = Database.query('SELECT Class_Name__c, Object_API_Name__c, SortOrder__c, Event_Type__c, Record_Types_API_Names__c, Recursion_times__c, UpdatedFields__c FROM Trigger_configuration__mdt WHERE Object_API_Name__c LIKE: strObjectName ORDER BY SortOrder__c');
            }
            if(Test.isRunningTest()){
				System.debug('here :: isRunningTest');
                lstTriggerConfig = PostInstallPwrPMS.getTriggerConfigurationRecordForTest(strObjectName, lstTriggerConfig);
            }
            if(lstTriggerConfig!= null) {
                List<CustomBusinessProcess> lstBusinessProcesses;                
                for(sObject triggerConfig : lstTriggerConfig) {
                    if(mapEventProcessess.containsKey((String)triggerConfig.get('Event_Type__c'))){
                        lstBusinessProcesses = mapEventProcessess.get((String)triggerConfig.get('Event_Type__c'));
                    }else{
                        lstBusinessProcesses = new List<CustomBusinessProcess>();
                    }
                   lstBusinessProcesses.add(new CustomBusinessProcess(triggerConfig));
                    mapEventProcessess.put((String)triggerConfig.get('Event_Type__c'), lstBusinessProcesses);
                }
                mapBusinessProcesses.put(strObjectName, mapEventProcessess); 
            }
        }
        return mapBusinessProcesses.get(strObjectName).get(operationType);
    }
}