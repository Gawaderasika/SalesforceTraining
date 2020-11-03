/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to construct the sObject and perform the CRUD operations dynamically.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    3/09/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
public with sharing class DatabaseOperationManager {
    public static Result query(ModelWrapper queryModel, Boolean isStaticResourceCall){
        String strQuery = QueryParser.parse(queryModel, isStaticResourceCall);
        return new Result(System.Database.query(strQuery));
    }
    public static Result saveRecord(List<sObject> lstRecord){
        List<Database.SaveResult> lstResult = new List<Database.SaveResult>();
        List<sObject> recordsToInsert = new List<sObject>();
        List<sObject> recordsToUpdate = new List<sObject>();
        List<Id> lstIds = new List<Id>();
        for(sObject record : lstRecord){
            if(String.isNotBlank(String.valueOf(record.get('id'))) || String.isNotBlank(String.valueOf(record.get('Id')))){
                recordsToUpdate.add(record);
            }else{
                recordsToInsert.add(record);
            }
        }
       if(recordsToInsert.size() > 0){
           lstResult = System.Database.Insert(recordsToInsert);
        }
       if(recordsToUpdate.size() > 0){
            lstResult = System.Database.update(recordsToUpdate);
        }
        for(Database.SaveResult saveResult : lstResult){
            lstIds.add(saveResult.getId());
        }
        return new Result(lstIds);
    }
    public static Result removeRecord(List<sObject> lstRecord){
        List<Id> lstIds = new List<Id>();
        List<sObject> lstRecordToDelete = new List<sObject>();
        Schema.DescribeSObjectResult drSObj;
        for(sObject record : lstRecord){
            if(record.Id != Null && drSObj == Null){
                drSObj = record.Id.getSobjectType().getDescribe();
            }
            if(record.Id != null){
                lstRecordToDelete.add(record);     
            }
        }
        List<Database.DeleteResult> lstResult = new List<Database.DeleteResult>();
        if (drSObj != Null && drSObj.isDeletable()) {
            lstResult = System.Database.delete(lstRecordToDelete);
        }
        if(!lstResult.isEmpty()){
            for(Database.DeleteResult deleteResult : lstResult){
                lstIds.add(deleteResult.getId());
            }
        }
        
        return new Result(lstIds);
    }
    public static Result getAllObjects(){
        list<schema.sObjectType> allObjects = Schema.getGlobalDescribe().Values();
        List<Schema.DescribeSObjectResult> objectsDescription = new List<Schema.DescribeSObjectResult>();
        for(schema.sObjectType val:allObjects){
            objectsDescription.add(val.getDescribe());
        }            
        return new Result(objectsDescription);
    }
    public static Result describeObject(ModelWrapper query){
        Schema.SObjectType objSchema = Schema.getGlobalDescribe().get(query.objType);
        Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
        List<Schema.DescribeFieldResult> lstFieldDescription = new List<Schema.DescribeFieldResult>();
        List<String> fieldLst =new List<String>();
        if(query.fields !=null){
            for(String val : query.fields){
                fieldLst.add(val.toLowerCase());
            }
            query.fields=fieldLst;
        }
        
        for(String field : fieldMap.keySet()){
            if(query.fields !=null)
            {
                if(query.fields.contains(field))
                {
                    Schema.DescribeFieldResult fieldDescription = fieldMap.get(field).getDescribe();
                    lstFieldDescription.add(fieldDescription);
                }
            }
            else{
                Schema.DescribeFieldResult fieldDescription = fieldMap.get(field).getDescribe();     
                lstFieldDescription.add(fieldDescription);
            }
            
        }
        return new Result(lstFieldDescription);
    }
    public static sObject constructSobject(String sObjectApiName, String jSONSObject){
        try{
            Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped(jSONSObject);
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectApiName);
            SObject newSobject = targetType.newSObject();
            Map<String, Schema.sObjectField> targetFields = targetType.getDescribe().fields.getMap();
            for (String key : fieldMap.keySet()){               
                Object value = fieldMap.get(key);
                if(targetFields.get(key) != NULL){
                   	Schema.DisplayType valueType = targetFields.get(key).getDescribe().getType();
                    if (value instanceof String && valueType != null && valueType != Schema.DisplayType.String){
                        String svalue = (String)value;
                        if (valueType == Schema.DisplayType.Date){
                            newSobject.put(key, Date.valueOf(svalue));
                        }
                        else if(valueType == Schema.DisplayType.DateTime){
                            newSobject.put(key, (DateTime)JSON.deserialize('"' + svalue + '"', DateTime.class));
                           // newSobject.put(key, DateTime.valueOfGMT(svalue));
                        }
                        else if(valueType == Schema.DisplayType.Time){
                            newSobject.put(key, (Time)JSON.deserialize('"' + svalue + '"', Time.class));
                        }
                        else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency){
                            newSobject.put(key, svalue == '' ? null : Decimal.valueOf(svalue));
                        }
                        else if (valueType == Schema.DisplayType.Double){
                            newSobject.put(key, svalue == '' ? null : Double.valueOf(svalue));
                        }
                        else if (valueType == Schema.DisplayType.Integer){
                            newSobject.put(key, svalue == '' ? null : Integer.valueOf(svalue));
                        }
                        else if (valueType == Schema.DisplayType.Base64){
                            newSobject.put(key, Blob.valueOf(svalue));
                        }
                        else{
                            newSobject.put(key, svalue);
                        }
                    }
                    else{
                        newSobject.put(key, value);
                    } 
                }
            }
            return newSobject;
        }
        catch(Exception ex){
            system.debug('Exception occured while creating sObject:'+ex.getMessage());
            return null;
        }
    }
}