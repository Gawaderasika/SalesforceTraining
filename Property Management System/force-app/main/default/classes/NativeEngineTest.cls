/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This test class is used to cover scenarios of apex class NativeEngine.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    20/11/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
@isTest
public class NativeEngineTest {
    @isTest
    static void saveRecord(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
        sObject newObject = TestDataFactory.createDatasource();
        boolean isNameSpace;
       
        try{
            isNameSpace = userinfo.isCurrentUserLicensed('epms');
        }
        catch (exception ex){
            System.debug('Exception ' + ex);
            isNameSpace = false;
        }
        if(true){     
            if(isNameSpace){
            
            	result = NativeEngine.saveRecord(lstOfJsonObject, 'epms__Reservation__c', 'PMS_Manage_Package', 'passthrough', newObject);

            }
            else{
			
				result = NativeEngine.saveRecord(lstOfJsonObject, 'Reservation__c', 'PMS_Manage_Package', 'passthrough', newObject);

            }
        }
        
        System.assert(result != null);
    } 
    
        @isTest
    static void saveRecordReturnNull(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
        sObject newObject = TestDataFactory.createDatasource();
        boolean isNameSpace;
       
        try{
            isNameSpace = userinfo.isCurrentUserLicensed('epms');
        }
        catch (exception ex){
            System.debug('Exception ' + ex);
            isNameSpace = false;
        }
        if(true){     
            if(isNameSpace){
            
            	result = NativeEngine.saveRecord(lstOfJsonObject, '', 'PMS_Manage_Package', 'passthrough', newObject);
              
                 System.assert(result == null);
            }
            else{
			
				result = NativeEngine.saveRecord(lstOfJsonObject, '', 'PMS_Manage_Package', 'passthrough', newObject);
                System.assert(result == null);
               

            }
        }
       
       
    } 
    
    
    @isTest
    static void removeRecord(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
        system.debug('lstOfJsonObject: '+lstOfJsonObject);
        sObject newObject = TestDataFactory.createDatasource();
        //Setting__mdt setting =  TestDataFactory.getSetting();
       // Organization objOrganization = [SELECT NamespacePrefix FROM Organization];
        //if(setting != null && setting.FetchFromStaticResource__c){
            boolean isNameSpace =false;
            try{
                 isNameSpace = userinfo.isCurrentUserLicensed('epms');
            }
            catch (exception ex){
                System.debug('Exception ' + ex);
                isNameSpace = false;
            }
        if(true){
           if(isNameSpace){
            	result = NativeEngine.removeRecord(lstOfJsonObject, 'epms__Reservation__c', 'PMS_Manage_Package', 'passthrough', newObject);
                 
           }
            else{
				result = NativeEngine.removeRecord(lstOfJsonObject, 'Reservation__c', 'PMS_Manage_Package', 'passthrough', newObject);
            }
        }
        System.assert(result != null);
   }
     
    @isTest
    static void removeRecordReturnNull(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
        system.debug('lstOfJsonObject: '+lstOfJsonObject);
        sObject newObject = TestDataFactory.createDatasource();
        //Setting__mdt setting =  TestDataFactory.getSetting();
       // Organization objOrganization = [SELECT NamespacePrefix FROM Organization];
        //if(setting != null && setting.FetchFromStaticResource__c){
            boolean isNameSpace =false;
            try{
                 isNameSpace = userinfo.isCurrentUserLicensed('epms');
            }
            catch (exception ex){
                System.debug('Exception ' + ex);
                isNameSpace = false;
            }
        if(true){
           if(isNameSpace){
            	result = NativeEngine.removeRecord(lstOfJsonObject, '', 'PMS_Manage_Package', 'passthrough', newObject);
                               System.assert(result == null);
          
            }
            else{
				result = NativeEngine.removeRecord(lstOfJsonObject, '', 'PMS_Manage_Package', 'passthrough', newObject);
                System.assert(result == null);
            }
        }
      
   }

    @isTest
    static void query(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
        sObject newObject = TestDataFactory.createDatasource();
        ModelWrapper objQuery = TestDataFactory.createQuery();
   		ModelWrapper modelInfo = TestDataFactory.createStaticResource('Reservations');
        
        result = NativeEngine.query(objQuery.conditions, modelInfo.name, 'PMS_Manage_Package', newObject);
        System.assert(result != null);
        result = NativeEngine.query(objQuery.conditions, 'Reservation__c', '', null, null, 'PMS_Manage_Package', 'passthrough', newObject);
        System.assert(result != null); 
    }
       
      @isTest
    static void queryWithNofields(){
        Result result = new Result(false);
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert();
        sObject newObject = TestDataFactory.createDatasource();
        ModelWrapper objQuery = TestDataFactory.createQuery();
   		ModelWrapper modelInfo = TestDataFactory.createStaticResource('Reservations');
        
        result = NativeEngine.query(objQuery.conditions, modelInfo.name, 'PMS_Manage_Package', newObject);
        System.assert(result != null);
        result = NativeEngine.query(objQuery.conditions, 'Reservation__c', 'Name', null, null, 'PMS_Manage_Package', null, newObject);
        System.assert(result != null);
    }
  
}