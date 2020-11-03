/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to construct the Json record stored in static resource dynamically .
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    29/10/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/

public with sharing class StaticResourceController {
    public static String resourceName{get;set;}
    public static String body{get;set;}
    public static StaticResource staticResource{get;set;}
    public static String objectName{get;set;}
    public static String datasourceName{get;set;}
    public static ModelWrapper modelInfo{get;set;}
    public static sObject datasourceRecord{get;set;}
    public static String getStaticResource(String resourceName){
        staticResource = [SELECT Id, NamespacePrefix, Name, ContentType, BodyLength, Body, Description, CacheControl, SystemModStamp 
                          FROM StaticResource 
                          WHERE Name =: String.escapeSingleQuotes(resourceName)
                          LIMIT 1];
        body = staticResource.Body.toString();
        return body;
    }
    public static Object getlayout(String layoutName){
        resourceName = layoutName.trim();
        body = getStaticResource(resourceName);
        if(String.isNotBlank(body)){
            return JSON.deserializeUntyped(body);  
        }
        return null;
    }
    public static ModelWrapper getModel(String modelName){
        resourceName = modelName.trim();
        body = getStaticResource(resourceName);
        if(String.isNotBlank(body)){
            modelInfo = ((ModelWrapper)JSON.deserialize(body, ModelWrapper.class));
        }
     //   modelInfo.ObjectName = getModelDefObjectName(modelName);
        return modelInfo;
    }
    public static ModelWrapper getModelDef(String modelDefName){
        resourceName = modelDefName.trim();
        body = getStaticResource(resourceName);
        if(String.isNotBlank(body)){
            modelInfo = ((ModelWrapper)JSON.deserialize(body, ModelWrapper.class));
        }
        return modelInfo;
    }
    public static ModelWrapper getModelDefByModel(String modelName){
        modelInfo = getModel(modelName);
        resourceName = modelInfo.modelDef.trim();
        body = getStaticResource(resourceName);
        if(String.isNotBlank(body)){
            modelInfo = ((ModelWrapper)JSON.deserialize(body, ModelWrapper.class));
        }
        return modelInfo;
    }
    public static String getModelDefObjectName(String modelName){
        Map<String, Object> mapModelDef =  getModelDefByModelName(modelName);
        if(mapModelDef != null){
            for(String modelDefField : mapModelDef.keySet()){
                if(modelDefField.toLowerCase() == 'object'){
                    objectName = (String) mapModelDef.get(modelDefField); 
                }
            } 
        }
        return objectName;
    }
    public static String getDatasourceName(String modelName){
        Map<String, Object> mapModelDef =  getModelDefByModelName(modelName);
        if(mapModelDef != null){
            for(String modelDefField : mapModelDef.keySet()){
                if(modelDefField.toLowerCase() == 'datasource'){
                    datasourceName = (String) mapModelDef.get(modelDefField); 
                }
            } 
        }
        return datasourceName;
    }
    public static Map<String, Object> getModelDefByModelName( String modelName){
        modelInfo = getModel(modelName);
        resourceName = modelInfo.modelDef.trim();
        staticResource = [SELECT Id, NamespacePrefix, Name, ContentType, BodyLength, Body, Description, CacheControl, SystemModStamp 
                          FROM StaticResource 
                          WHERE Name =: String.escapeSingleQuotes(resourceName)
                          LIMIT 1];
        body = staticResource.Body.toString();
        return (Map<String, Object>)JSON.deserializeUntyped(body);
    }
    public static sObject getDatasource(String datasourceName){
        /*List<Datasources__c> lstDatasources = Datasources__c.getall().values();
        if(lstDatasources.size() > 0){
            for(Datasources__c datasource : lstDatasources){
                if(datasource.Name == datasourceName){
                    return (sObject)datasource;
                }
            }
        }*/
        return null;
    }
    public static Result saveRecord(List<Object> lstJsonObject, String modelName){
        objectName = StaticResourceController.getModelDefObjectName(modelName);
        datasourceName = StaticResourceController.getDatasourceName(modelName);
        datasourceRecord = StaticResourceController.getDatasource(datasourceName);
        return NativeEngine.saveRecord(lstJsonObject, objectName, datasourceName, null, datasourceRecord);
    }
    public static Result removeRecord(List<Object> lstJsonObject, String modelName){
        objectName = StaticResourceController.getModelDefObjectName(modelName);
        datasourceName = StaticResourceController.getDatasourceName(modelName);
        datasourceRecord = StaticResourceController.getDatasource(datasourceName);
        return NativeEngine.removeRecord(lstJsonObject, objectName, datasourceName,null,datasourceRecord);
    }
    public static Result query(List<ModelWrapper.Condition> conditions, String modelName){
        datasourceName = StaticResourceController.getDatasourceName(modelName);
        datasourceRecord = StaticResourceController.getDatasource(datasourceName);
        return NativeEngine.query(conditions, modelName, datasourceName,datasourceRecord);
    }
}