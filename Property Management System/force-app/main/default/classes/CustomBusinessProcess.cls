public class CustomBusinessProcess {
    
    //  Trigger_configuration__mdt configuration;
        sObject configuration;
      List<sObject> lstNewRecords;
      Map<Id, sObject> mapOldRecords;
      Boolean isExecuted = true;
      public Type classToExecute;
      
      public CustomBusinessProcess(sObject  triggerConfig){
          this.configuration = triggerConfig;
          if( String.isNotBlank((String)triggerConfig.get('Class_Name__c'))){
              classToExecute = Type.forName((String)triggerConfig.get('Class_Name__c'));
          } 
      }
      
  
      
      
      
      /*********************************************************************************************************************************
          Description  :   This method will fire the appropriate methods of the specified class.
      *********************************************************************************************************************************/
      public void execute() {
          if( isExecuted ) {
              lstNewRecords = getTriggerNewList(configuration);
              mapOldRecords = getTriggerOldMap(configuration);
              Double recursionTime = ((Double)configuration.get('Recursion_times__c'));
              configuration.put('Recursion_times__c',--recursionTime);
         //    --configuration.Recursion_times__c;
              if(configuration.get('Recursion_times__c')==0) {
                  isExecuted = false;
              }
              Callable callableInstance = (Callable)classToExecute.newInstance();
              Map<String,Object> mapOldAndNewRecords = new Map<String,Object>();
              mapOldAndNewRecords.put('lstNewRecords',lstNewRecords);
              mapOldAndNewRecords.put('mapOldRecords',mapOldRecords);
              callableInstance.call('', mapOldAndNewRecords);             
          }
      }
      
      /*********************************************************************************************************************************
          Description  :   This method is used to return a List of filtered records based on the record types and fields that are 
                           mentioned in custom metadata type from Trigger.old or Trigger.new.
      *********************************************************************************************************************************/
     // List<sObject> getTriggerNewList(Trigger_configuration__mdt configuration) {
             List<sObject> getTriggerNewList(sObject configuration) {
          List<sObject> lstRecordsToReturn;
          lstRecordsToReturn = filterRecordsbyRecordType((String)configuration.get('Object_API_Name__c'),(String) configuration.get('Record_Types_API_Names__c'), Trigger.isDelete ? Trigger.old : Trigger.new);
          if( Trigger.isUpdate){
              if(String.isNotBlank((String)configuration.get('UpdatedFields__c'))){
                  lstRecordsToReturn = filterRecordsByUpdatedField(lstRecordsToReturn, (String)configuration.get('UpdatedFields__c'), Trigger.oldMap, Trigger.newMap);
              }
          }
          return lstRecordsToReturn;
      }
      
      /*********************************************************************************************************************************
          Description  :   This method is used to return a map of filtered records based on the record types and fields that are 
                           mentioned in custom metadata type from Trigger.oldMap.
      *********************************************************************************************************************************/
      Map<Id, sObject> getTriggerOldMap(sObject configuration) {
          if(!Trigger.isInsert){
              Map<Id, sObject> mapFilteredRecords = new Map<Id, sObject>(filterRecordsbyRecordType((String)configuration.get('Object_Api_Name__c'),(String) configuration.get('Record_Types_API_Names__c'), Trigger.oldMap.values()));
              mapFilteredRecords = getfilterRecordsByUpdatedFieldOldMap(configuration, mapFilteredRecords);
              return mapFilteredRecords;
          } 
          return null;
      }
      
      /*********************************************************************************************************************************
          Description  :   This method returns the filtered records of the given record types mentioned in custom metadata type.
      *********************************************************************************************************************************/
      Map<Id, sObject> getfilterRecordsByUpdatedFieldOldMap(sObject configuration, Map<Id, sObject> mapOldRecords){
          Map<Id, sObject> mapSortedRecords = new Map<Id, sObject>();
          for(sObject objRecord : filterRecordsByUpdatedField(mapOldRecords.values(), (String)configuration.get('UpdatedFields__c'), mapOldRecords, Trigger.newMap)){
              mapSortedRecords.put(objRecord.Id, objRecord);
          }
          return mapSortedRecords;
      }
      
      /*********************************************************************************************************************************
          Description  :   This method return the filtered records based on the fields given in custom metadata type.
      *********************************************************************************************************************************/
      List<sObject> filterRecordsByUpdatedField(List<sObject> lstRecords, string strUpdatedFields, Map<id, sObject> oldMap, Map<id, sObject> newMap) {
          List<sObject> lstRecordsToReturn = new List<sObject>();
          try{
              if(strUpdatedFields != null) {
                  for(sObject record : lstRecords) {
                      Id recordId = String.valueOf((record.get('id')));
                      for(String field : strUpdatedFields.split(',')) {
                          if(oldMap.get(recordId).get(field) != newMap.get(recordId).get(field)) {
                              lstRecordsToReturn.add(record);
                          }
                      }
                  }
                  return lstRecordsToReturn;  
              }else{
                  return lstRecords;
              }  
          }Catch(exception ex){
              return lstRecords;
          }
      }
      
      /*********************************************************************************************************************************
          Description  :   This method returns the filtered records of the given record types mentioned in custom metadata type.
      *********************************************************************************************************************************/
      List<sObject> filterRecordsbyRecordType(string strObjectName, string strFilterByRecordTypes, List<sObject> lstRecords) {
          if(String.isNotBlank(strFilterByRecordTypes) && !lstRecords.isEmpty()){
              try{
                  Map<String, Id> mapRecordTypes = Utility.getActiveRecordTypesByDevName(lstRecords[0]);
                  Set<String> setRecordTypeName = new  Set<String>(((String)configuration.get('Record_Types_API_Names__c')).split(','));
                  Set<Id> setRecTypeIds = new Set<Id>();
                  List<sObject> lstSortedsObject = new List<sObject>();
                  for(String strRecType : setRecordTypeName){
                      if(mapRecordTypes.get(strRecType.trim()) != null){
                          setRecTypeIds.add(mapRecordTypes.get(strRecType.trim()));
                      }
                  }
                  
                  for(sObject objRecord : lstRecords){
                      if(setRecTypeIds.contains(objRecord.get('RecordTypeId').toString())){
                          lstSortedsObject.add(objRecord);
                      }
                  }
                  return lstSortedsObject;
              }catch(Exception exc){
                  System.debug('Exception---'+exc.getLineNumber());
                  return lstRecords;
              }
          } 
          return lstRecords;
      }
  }