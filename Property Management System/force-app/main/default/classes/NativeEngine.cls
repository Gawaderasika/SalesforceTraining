/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to construct the CRUD operation dynamically in Salesforce when datasource adapter type is passthrough.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    3/11/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/

public with sharing class NativeEngine {

    public static ModelWrapper modelInfo{get;set;}
    public static String adapterType{get;set;}
    public static Result saveRecord(List<Object> lstJsonObject, String objectName, String datasourceName, String adapterName, sObject datasourceRecord){
        List<sObject> lstNewSobject = new List<sObject>();
        if(adapterName != null){
            adapterType = adapterName;
        }else{
               adapterType = getAdapterType(datasourceName);
        }
        
        if(String.isNotBlank(objectName)){
            if(adapterType.toLowerCase() == 'salesforce'){
                return APIEngine.save(lstJsonObject, objectName, datasourceRecord);
            }
            else{
                For(Object jsonObject : lstJsonObject ){
                    sObject newSobject = DatabaseOperationManager.constructSobject(objectName, json.serialize(jsonObject)); 
                    lstNewSobject.add(newSobject);
                }
                return DatabaseOperationManager.saveRecord(lstNewSobject);
            }
        }
        return null;
    }
    public static Result removeRecord(List<Object> lstJsonObject, String objectName, String datasourceName, String adapterName, sObject datasourceRecord){
        List<sObject> lstNewSobject = new List<sObject>();
        if(adapterName != null){
            adapterType = adapterName;
        }else{
            adapterType = getAdapterType(datasourceName);
        }
        if(String.isNotBlank(objectName)){
            if(adapterType.toLowerCase() == 'salesforce'){
                return APIEngine.remove(lstJsonObject, objectName, datasourceRecord);
            }
            else{
                For(Object jsonObject : lstJsonObject ){
                    sObject newSobject = DatabaseOperationManager.constructSobject(objectName, json.serialize(jsonObject)); 
                    lstNewSobject.add(newSobject);
                }
                return DatabaseOperationManager.removeRecord(lstNewSobject);
            }
        }
        return null;
    }   
    
    public static Result query(List<ModelWrapper.Condition> conditions, String objectName, String fields, String modelCriteria, String modelDefCriteria, String datasourceName, String adapterName, sObject datasourceRecord){
        ModelWrapper query = new ModelWrapper();
        List<ModelWrapper.Condition> lstCondition = new List<ModelWrapper.Condition>();
        List<String> lstField = new List<String>();
        if( String.isNotBlank(fields)){
            lstField = fields.split(',');
        }
        if(String.isNotBlank(modelCriteria)){
            lstCondition.addAll((List<ModelWrapper.Condition>)JSON.deserialize(modelCriteria, List<ModelWrapper.Condition>.class));
        }
        if(String.isNotBlank(modelDefCriteria)){
            lstCondition.addAll((List<ModelWrapper.Condition>)JSON.deserialize(modelDefCriteria, List<ModelWrapper.Condition>.class));
        }
        if(conditions != null){
            lstCondition.addAll(conditions);
        }
        query.fields = lstField;
        query.objType = objectName;
        query.conditions = lstCondition;
        if(adapterName != null){
            adapterType = adapterName;
        }else{
            adapterType = getAdapterType(datasourceName);
        }
        if(adapterType.toLowerCase() == 'salesforce'){
            return APIEngine.query(query,false,datasourceRecord);
        }
        else{
            return DatabaseOperationManager.query(query,false);
        }
    }
    //to query using staticresource 
    public static Result query(List<ModelWrapper.Condition> lstCondition, String modelName, String datasourceName, sObject datasourceRecord){
        ModelWrapper queryModel = new ModelWrapper();
        ModelWrapper.criteria criteria = new ModelWrapper.criteria();
        String objectName = StaticResourceController.getModelDefObjectName(modelName);
        if(String.isNotBlank(objectName)){
            queryModel.objType = objectName; 
            modelInfo = StaticResourceController.getModel(modelName);
            if(modelInfo != null){
                queryModel.fields = modelInfo.fields;
                criteria = modelInfo.criteria;
                criteria.evaluationCriteria = modelInfo.criteria.evaluationCriteria;
            }
            modelInfo = StaticResourceController.getModelDefByModel(modelName);  
            if(modelInfo != null){
                criteria.conditions.addAll(modelInfo.criteria.conditions);
                criteria.evaluationCriteria = criteria.evaluationCriteria +','+modelInfo.criteria.evaluationCriteria;
            }
           if(lstCondition != null){
				criteria.conditions.addAll(lstCondition);
			}
            queryModel.criteria = criteria;
            queryModel.criteria.conditions = criteria.conditions;
            queryModel.criteria.evaluationCriteria = criteria.evaluationCriteria;
            adapterType = getAdapterType(datasourceName);
            if(adapterType.toLowerCase() == 'salesforce'){
                return APIEngine.query(queryModel,true,datasourceRecord);
            }
            else{
                return DatabaseOperationManager.query(queryModel,true);
            }
        }
        return null;
    }
    public static String getAdapterType(String datasourceName){
        /*List<Datasources__c> lstDatasources = Datasources__c.getall().values();
        if(lstDatasources.size() > 0){
            for(Datasources__c datasource : lstDatasources){
                if(datasource.Name == datasourceName){
                    return datasource.Adapter__c;
                }
            }
        }*/
        return 'passthrough';
    }
}