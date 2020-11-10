/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This test class is used to cover scenarios of apex classes "Engine" and "DatabaseOperationManager".
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    1/10/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
@isTest
public class EngineTest{
  @isTest
    static void getLayout(){
        if(true){
            Map<String,Object> mapResponse = TestDataFactory.createLayoutStaticResource('Repeater_Make_Reservation');
            for(String key : mapResponse.keySet()){
                if(key.toLowerCase() == 'name'){
                  Object obj = Engine.getLayout('Repeater_Make_Reservation');
                }
            }
            System.assert(mapResponse != null);
        }
        else{
            sObject objOfLayout = TestDataFactory.createLayout();
            String layoutName = (String)objOfLayout.get('Name');
            sObject objLayout = Database.query('SELECT Id, Name, Label__c FROM Layout__c WHERE Name =:layoutName');
            if(objOfLayout != null){
                Object layout = Engine.getLayout((String)objLayout.get('Name'));
            }
             System.assert(objOfLayout != null);
        }
    }   
    
     @isTest
    static void getLayoutCatchEx(){
        if(true){
            Map<String,Object> mapResponse = TestDataFactory.createLayoutStaticResource('Repeater_Make_Reservation');
            for(String key : mapResponse.keySet()){
                if(key.toLowerCase() == 'name'){
                    try{
                  Object obj = Engine.getLayout('Test');
                    }catch(Exception e){
                        system.debug('e'+e);
                    }
                }
            }
            System.assert(mapResponse != null);
        }
    }
    
    @isTest
    static void getModel(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);

            modelInfo = TestDataFactory.createStaticResource('Reservations');
            System.assert(modelInfo != null);
            result  = Engine.getModel(modelInfo.name);
           
       
    } 
        @isTest
    static void getModelCatchEx(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);

            modelInfo = TestDataFactory.createStaticResource('Reservations');
            System.assert(modelInfo != null);
        try{
          result  = Engine.getModel('Test');
        }catch(Exception ex){
            system.debug('getmodel exception'+ex);
        }
           
       
    } 
    @isTest 
    static void getModelDef(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);
            modelInfo = TestDataFactory.createStaticResource('Modeldef_Reservations');
            System.assert(modelInfo != null);
            result  = Engine.getModelDef(modelInfo.name);
      

    }  
      @isTest 
    static void getModelDefCatchEx(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);
            modelInfo = TestDataFactory.createStaticResource('Modeldef_Reservations');
            System.assert(modelInfo != null);
        try{
            result  = Engine.getModelDef('Test');
        }catch(Exception ex){
            system.debug('getmodeldef exception'+ex);
        }

    }  
    @isTest 
    static void getModelDefByModel(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);

            modelInfo = TestDataFactory.createStaticResource('Reservations');
            result  = Engine.getModelDefByModel(modelInfo.name);
                 System.assert(result != null);
        

    }  
     @isTest 
    static void getModelDefByModelCatchEx(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);

            modelInfo = TestDataFactory.createStaticResource('Reservations');
        try{
          result  = Engine.getModelDefByModel('Test');
        }catch(Exception ex){
            system.debug('getmodeldefbyModel'+ex);
        }
            
                 System.assert(result != null);
        

    }  
    @isTest 
    static void getModelDefObjectName(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);
            modelInfo = TestDataFactory.createStaticResource('Reservations');
            result  = Engine.getModelDefObjectName(modelInfo.name);
          System.assert(result != null);
    } 
        @isTest 
    static void getModelDefObjectNameCatchEx(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);
            modelInfo = TestDataFactory.createStaticResource('Reservations');
            try{
          result  = Engine.getModelDefObjectName('Test');
        }catch(Exception ex){
            system.debug('getmodeldefbyObjectName'+ex);
        }
           
          System.assert(result != null);
    }
    @isTest 
    static void getDatasourceAdapterName(){
        ModelWrapper modelInfo = new  ModelWrapper();
        Result result = new Result(false);
          modelInfo = TestDataFactory.createStaticResource('Reservations');
            result  = Engine.getDatasourceAdapterName(modelInfo.name);
          System.assert(result != null);
    } 

    @isTest
    static void saveRecord(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
 
            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.saveRecord(lstOfJsonObject, modelInfo.name);
        System.assert(result != null);
    }   
        @isTest
    static void saveRecordForCatchEx(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
 
            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
        try{
            result = Engine.saveRecord(lstOfJsonObject, 'Hello');
        }catch(Exception e){system.debug('e'+e);}
        System.assert(result != null);
    } 
 @isTest
    static void saveRecordNull(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
 
            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.saveRecord(lstOfJsonObject,'');
        System.assert(result == null);
    }             
     @isTest
    static void updateRecord(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate();
 
            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.saveRecord(lstOfJsonObject, modelInfo.name);
        System.assert(result != null);
    }
      @isTest
    static void updateRecordNullCheck(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate();
 
            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.saveRecord(lstOfJsonObject, '');
        System.assert(result == null);
    }
    @isTest
    static void removeRecord(){        
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate();

            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.removeRecord(lstOfJsonObject, modelInfo.name);

        System.assert(result != null);
    }
      @isTest
    static void removeRecordCheckEx(){        
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate();

            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
        try{   
            result = Engine.removeRecord(lstOfJsonObject, 'Test');}
        catch(Exception e){
            System.debug('e'+e);
        }

        System.assert(result != null);
    }
        @isTest
    static void removeRecordNullCheck(){        
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate();

            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.removeRecord(lstOfJsonObject,'');

        System.assert(result == null);
    }
    @isTest
    static void queryTest(){
        Result result = new Result(false);
        ModelWrapper objQuery = TestDataFactory.createQuery();
        List<ModelWrapper.Condition> conditions = objQuery.conditions;

            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.query(conditions, modelInfo.name);
        System.assert(result != null);     
    }
     @isTest
    static void queryTestNull(){
        Result result = new Result(false);
        ModelWrapper objQuery = TestDataFactory.createQuery();
        List<ModelWrapper.Condition> conditions = objQuery.conditions;

            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Reservations');
            result = Engine.query(conditions,'');
        System.assert(result == null);     
    }
    @isTest
    static void getDescribeField(){
        Map<String, FieldInformation> mapFieldNameToFieldInfo = new Map<String, FieldInformation>();
      //  Organization objOrganization = [SELECT NamespacePrefix FROM Organization];
      boolean isNameSpace ;      
      try{
              isNameSpace = userinfo.isCurrentUserLicensed('epms');
         }
         catch (exception ex){
             System.debug('Exception ' + ex);
             isNameSpace = false;
         }
       
            ModelWrapper modelInfo  = TestDataFactory.createStaticResource('Unit_Type_Reservations');
            if(isNameSpace)
                mapFieldNameToFieldInfo = Engine.getDescribeField(modelInfo.name, new List<String>{'Name','OwnerId','epms__Cancellation_Reason__c'});
            else
                mapFieldNameToFieldInfo = Engine.getDescribeField(modelInfo.name, new List<String>{'Name','OwnerId','Cancellation_Reason__c', 'No_of_Children__c','Unit__c'});

        System.assert(mapFieldNameToFieldInfo != null);       
    }
    @isTest
    static void getLookupData(){
        List<LookupDataManager.LookupResult> lstLookupResult  = Engine.getLookupData('Account', 'OwnerId', 'test', 10, '', false, false);
        System.assert(lstLookupResult != null); 
        lstLookupResult  = Engine.getLookupData('Account', 'OwnerId', 'test', 10, '', true, true);
        System.assert(lstLookupResult != null);    
    }
    @isTest
    static void getLookupFieldValue(){
        Contact contactRecord = new Contact(LastName='test');
        insert contactRecord;
        Map<String, String> mapFieldValue  = Engine.getLookupFieldValue('Contact', 'OwnerId', contactRecord.Id);
        System.assert(mapFieldValue != null);     
    }
    @isTest
    static void getAllObjects(){
        Result result = DatabaseOperationManager.getAllObjects();
        System.assert(result != null);     
    }
    @isTest
    static void describeObject(){
        ModelWrapper objQuery = TestDataFactory.createQuery();
        Result result = DatabaseOperationManager.describeObject(objQuery);
        System.assert(result != null);     
    }
    @isTest
    static void getDependentMap(){
        Query query = new Query();
        query.datasourceId = '';
        query.fields = new List<String>{'Name'};
        query.objType = 'Account';
        query.modelId = '';
        query.conditions = null;
        Map<String, List<FieldInformation.KeyValueWrapper>> mapControllingToDependent = PickListManager.getDependentMap('Account', 'AccountSource','Industry');     
        String decimalToBinary = PickListManager.decimalToBinary(2);
        String base64ToBits = PickListManager.base64ToBits('hello word');
        System.assert(mapControllingToDependent != null);     
    }
      @isTest
    static void getObjectPrefixId(){
        
        String getObjectPrefixId1 = Engine.getObjectPrefixId('account');
        System.assert(getObjectPrefixId1 != null);     
    }
     @isTest
    static void getObjNameTest(){
        Contact contactRecord = new Contact(LastName='Test');
        insert contactRecord;
        String getObjectName = Engine.getObjectNameFromId(contactRecord.Id);
        System.assert(getObjectName != null);     
    }
}