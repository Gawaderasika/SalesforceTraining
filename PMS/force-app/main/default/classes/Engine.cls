/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to construct the sObject and perform the CRUD operations dynamically.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    3/10/2019		    Shahaji Mahakale       Initial Development
2           17/10/2019          Nitin Ghuge            Added getLookupData method
3           12/11/2019          Shahaji Mahakale       Added extra generic method to get model/modeDef/Datasource related info

**************************************************************************************************************************************/

public with sharing class Engine {
   
    
    @AuraEnabled
    public static Result saveRecord(List<Object> lstJsonObject, String modelName){
        if(String.isNotBlank(modelName)){
           
            try{
                    return StaticResourceController.saveRecord(lstJsonObject, modelName);
            }
            catch(Exception ex){
                return new Result(ex);
            }
            
        }
        return null;
    }
    @AuraEnabled
    public static Result removeRecord(List<Object> lstJsonObject, String modelName){
        if(String.isNotBlank(modelName)){
            try{
                	return StaticResourceController.removeRecord(lstJsonObject, modelName);
            }
            catch(Exception ex){
                System.debug('Exception ::'+ex);
                return new Result(ex);
            }   
        }
        return null;
    }
    @AuraEnabled(cacheable = true)
    public static Result query(List<ModelWrapper.Condition> conditions,String modelName){
        if(String.isNotBlank(modelName)){
                return StaticResourceController.query(conditions, modelName);
        }
        return null;
    }
    @AuraEnabled(cacheable = true)
    public static Object getLayout(String layoutName){
        try{
            if(String.isNotBlank(layoutName)){
                   return StaticResourceController.getlayout(layoutName);
            }
            return null;
        }
        catch(QueryException ex){
            throw new SecurityException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static Result getModel(String modelName){
        Result result = new Result(false);
        try{
            if(String.isNotBlank(modelName)){
                    result.data = StaticResourceController.getModel(modelName);
            }
            return result;
        }
        catch(QueryException ex){
            throw new SecurityException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static Result getModelDef(String modelDefName){
        Result result = new Result(false);
        try{
            if(String.isNotBlank(modelDefName)){
                    result.data = StaticResourceController.getModelDef(modelDefName);
            }
            return result;
        }
        catch(QueryException ex){
            throw new SecurityException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static Result getModelDefByModel(String modelName){
        Result result = new Result(false);
        try{
            if(String.isNotBlank(modelName)){
                    result.data = StaticResourceController.getModelDefByModel(modelName);
            }
            return result;
        }
        catch(QueryException ex){
            throw new SecurityException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static Result getModelDefObjectName(String modelName){
        Result result = new Result(false);
        try{
            if(String.isNotBlank(modelName)){
                    result.data = StaticResourceController.getModelDefObjectName(modelName);
            }
            return result;
        }
        catch(QueryException ex){
            throw new SecurityException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static Result getDatasourceAdapterName(String modelName){
        Result result = new Result(false);
        if(String.isNotBlank(modelName)){
                result.data = StaticResourceController.getDatasourceName(modelName);
        }
        return Result;
    }
   
    @AuraEnabled(cacheable = true)
    public static Map<String, FieldInformation> getDescribeField( String modelName, List<String> lstFieldApiName){
        String objectName = (String)getModelDefObjectName(modelName).data;
        return getObjInfo(objectName, lstFieldApiName);
    }
    
    @AuraEnabled(cacheable = true)
    public static Map<String, FieldInformation> getObjInfo(String objName, List<String> lstFieldApiName){
        Map<String, FieldInformation> mapFieldNameToFieldInfo = new Map<String, FieldInformation>();
        String relationshipName = Null;
        String relatedObjectName;
        Boolean isRequired = false;
        Boolean isDependent = false;
        String type ; 
        Integer maxLength;
        List <FieldInformation.KeyValueWrapper> lstPicklistEntries = null; 
        Map<String, List<FieldInformation.KeyValueWrapper>> mapControllingDependentPicklistValues = null;
        String controllingFieldApiName = null;
        Schema.DescribeFieldResult fieldResult;
        objName = objName == 'Owner' || objName == 'CreatedBy' ||  objName == 'LastModifiedBy' ? 'User' : objName;
        Map<String , Schema.SObjectField> mapFieldsInfo = Schema.getGlobalDescribe()
            .get(objName)
            .getDescribe()
            .fields
            .getMap();
        for( String fieldApiName : lstFieldApiName){
            if( mapFieldsInfo.keySet().contains(fieldApiName.toLowerCase())){
                fieldResult = mapFieldsInfo.get(fieldApiName).getDescribe();
            }
            else{
                return null;
            }
            type = String.valueOf(fieldResult.getType());
            isRequired =  fieldResult.isNameField() ? true : type == 'Boolean' ? false : !fieldResult.isNillable();
            if( type == 'REFERENCE' ){
                relatedObjectName = String.valueOf(fieldResult.getReferenceTo()[0]);
                relationshipName = fieldResult.getRelationshipName();
            }
            else if( relationshipName == Null){
                relatedObjectName = objName;
                relationshipName = objName;
            }
            if(type.toUpperCase()=='DOUBLE'|| type.toUpperCase() == 'CURRENCY' || type.toUpperCase() == 'PERCENT' || type.toUpperCase() == 'NUMBER'){
                maxLength = fieldResult.getPrecision();
            }
            else{
                maxLength = fieldResult.getLength();
            }
            if( type.toUpperCase() == 'PICKLIST' || type.toUpperCase() == 'MULTIPICKLIST' ) {
                lstPicklistEntries = new List <FieldInformation.KeyValueWrapper>();
                for(Schema.PicklistEntry pickListEntry : fieldResult.getPicklistValues()){
                    FieldInformation.KeyValueWrapper objKeyValueWrapper = new FieldInformation.KeyValueWrapper( pickListEntry.getLabel(),pickListEntry.getValue());
                    lstPicklistEntries.add( objKeyValueWrapper );
                }
            }
            isDependent = fieldResult.isDependentPicklist();
            if( isDependent ){
                controllingFieldApiName = String.valueOf(fieldResult.getController());
                mapControllingDependentPicklistValues = PickListManager.getDependentMap(objName,controllingFieldApiName,fieldApiName);
            }
            mapFieldNameToFieldInfo.put(fieldApiName,new FieldInformation(fieldResult.getName(),type, fieldResult.getLabel(), type == 'REFERENCE'? relatedObjectName : objName , relationshipName, isRequired, fieldResult.isAccessible(), fieldResult.isUpdateable(),maxLength, fieldResult.isHtmlFormatted(), fieldResult.getMask(), fieldResult.getMaskType(), fieldResult.getScale(), lstPicklistEntries, objName, isDependent,controllingFieldApiName ,mapControllingDependentPicklistValues ));
        }
        return mapFieldNameToFieldInfo;
    }
    
    @AuraEnabled(cacheable = true)
    public static List<LookupDataManager.LookupResult> getLookupData( String objectApiName, String fieldApiName, String searchText, Integer numberOfRecords, String filterCondition, Boolean showDefault, Boolean isLookupClicked){
        return LookupDataManager.getSearchResult( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition, showDefault, isLookupClicked);
    }

    @AuraEnabled(cacheable = true)
    public static Map<String, String> getLookupFieldValue( String objectApiName, String fieldApiName, String recordId ){
        return LookupDataManager.getLookupFieldValue( objectApiName, fieldApiName, recordId );
    }
    
    @AuraEnabled(cacheable = true)
    public static String getObjectPrefixId(String objName){
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe();
        Schema.SObjectType s = m.get(objName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        return keyPrefix;
    }
    
    @AuraEnabled(cacheable = true)
    public static Boolean checkFieldAccess(String sObjectName, List<String> lstField, String access){
        try{
            Map<String,Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap(); 
            List<String> lstAccessDenyFields = NEW List<String>();
            List<String> lstFieldsNotAvilable = NEW List<String>();
            if(mapFields != NULL && !mapFields.isEmpty()){
                switch on access{
                    when 'Create'{  
                        if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isCreateable()){
                            for(String field : lstField){
                                if(mapFields.get(field) != NULL && !mapFields.get(field).getDescribe().isCreateable()){
                                    lstAccessDenyFields.add(mapFields.get(field).getDescribe().getLabel()); 
                                }
                                else if(mapFields.get(field) == NULL)
                                {
                                    lstFieldsNotAvilable.add(field);
                                }
                            }
                            if(!lstFieldsNotAvilable.isEmpty()){
                                return FALSE;
                            }
                            if(!lstAccessDenyFields.isEmpty()){
                                return FALSE;
                            }else{
                                return TRUE;
                            }
                        }

                    }
                    when 'Read'{
                        if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isAccessible()){
                            for(String field : lstField){
                                if (mapFields.get(field) != NULL && !mapFields.get(field).getDescribe().isAccessible()){
                                    lstAccessDenyFields.add(mapFields.get(field).getDescribe().getLabel()); 
                                }
                                else if(mapFields.get(field) == NULL){
                                    lstFieldsNotAvilable.add(field);                                    
                                }
                            }
                            if(!lstFieldsNotAvilable.isEmpty()){
                                return FALSE;
                            }
                            
                            if(!lstAccessDenyFields.isEmpty()){
                                return FALSE;
                            }else{
                                return TRUE; 
                            }
                        }
                    }
                    when 'Update'{
                        if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isUpdateable()){
                            for(String field : lstField){
                                if (mapFields.get(field) != NULL && !mapFields.get(field).getDescribe().isUpdateable()){
                                    lstAccessDenyFields.add(mapFields.get(field).getDescribe().getLabel());
                                }
                                else if(mapFields.get(field) == NULL)
                                {
                                    lstFieldsNotAvilable.add(field);
                                }
                            }
                            if(!lstFieldsNotAvilable.isEmpty()){
                                return FALSE;                            
                            }
                            if(!lstAccessDenyFields.isEmpty()){
                                return FALSE;
                            }else {
                                return TRUE;  
                            }
                        }
                    }
                    when 'Delete'{
                            if (!Schema.getGlobalDescribe().get(sObjectName).getDescribe().isDeletable()){
                                return FALSE;
                            }else {
                                return TRUE;
                            }
                    }
                    when else{
                        return FALSE;
                    }  
                }
            }
            else{
                return FALSE;
            }
        }
        catch(Exception ex)
        {
            throw(ex);
        }
        return FALSE;
    }
    
    @AuraEnabled(cacheable = true)
    public static String getObjectNameFromId(Id recordId){
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        return sObjName;
    }
    
    public class SecurityException extends Exception{}
}