/************************************************************************************************************************************
Author 		  :   Surbhi Srivastava
Description   :   This apex class is used to get the lookup data for lookup lightning web component.
History	   	  :     This class is Taken from deleted class enziLookupWrapperController.
----------------------------------------------------------------------------------------------------------------------------------
VERSION	  	DATE			   	  AUTHOR			            	DETAIL
1	 	    16/09/2019			Surbhi Srivastava           Initial Development
2           17/10/2019          Nitin Ghuge                 Code Optimization
3			09/12/2019			Rupesh Patil				Converted SOQL to SOSL in getSearchResult method
**************************************************************************************************************************************/
public with sharing class LookupDataManager {
    @AuraEnabled(cacheable=true)
    public static List<LookupResult> getSearchResult( String objectApiName, String fieldApiName, String searchText, Integer numberOfRecords, String filterCondition,  Boolean showDefault, Boolean isLookupClicked) {      
        String parentObjectName = getParentName(objectApiName , fieldApiName);
        String nameField;
        List<LookupResult> lstLookupResults = new List<LookupResult>();
        nameField = getNameField(parentObjectName);
        String query;
        List<sObject> lstSearchResults = new List<sObject>();
        List<List<SObject>> lstResults = new List<List<SObject>>();
        if(isLookupClicked != Null && isLookupClicked){
            query =  'SELECT Id,' +nameField+ ' FROM ' +parentObjectName;
            if(String.isNotEmpty(filterCondition)){
                query += ' Where '+filterCondition;
            }
            query += ' order by LastModifiedDate desc LIMIT '+numberOfRecords;
            lstSearchResults = Database.query(query);
        }else if(showDefault != null && showDefault){
            if(!String.isEmpty(searchText) && searchText.length() > 0){
                query =  'SELECT Id,' +nameField+ ' FROM ' +parentObjectName+ ' WHERE ';
                if(String.isNotEmpty(filterCondition)){
                    query += filterCondition + ' AND ';
                }
                query += nameField+ ' LIKE \'%' +searchText+ '%\' order by LastModifiedDate desc LIMIT '+numberOfRecords;                
            }else{
                query =  'SELECT Id,' +nameField+ ' FROM ' +parentObjectName+ ' order by LastModifiedDate desc LIMIT 1';
            }
            lstSearchResults = Database.query(query);
        }else{
            String searchTerm = String.escapeSingleQuotes(searchText);
            searchTerm = '*' + searchTerm + '*';
            if(searchTerm != ''){
                query = 'FIND \''+searchTerm+'\' IN '+nameField+ ' FIELDS RETURNING ' + parentObjectName+ '(Id, '+nameField+ '';  
                if(String.isNotEmpty(filterCondition)){
                    query += ' Where '+filterCondition;
                 }
                query += ')';
            }
            if(numberOfRecords != null) {            
                query += ' LIMIT '+numberOfRecords;
            }
            System.debug('query: '+query);
            if(query != ''){
                lstResults = search.query(query);
            }
        }
        if(!lstSearchResults.isEmpty()){
            for(sObject objRec: lstSearchResults){
                lstLookupResults.add(new LookupResult((String)objRec.get(nameField), objRec.Id));
            }
            return lstLookupResults;
        }else if(!lstResults.isEmpty()){
            for(List<sObject> lstsObject : lstResults){
                for(sObject searchRecord : lstsObject) {
                    String fieldValue = (String) searchRecord.get(nameField);                 
                    lstLookupResults.add(new LookupResult(fieldvalue, searchRecord.Id));
                }
            }
            return lstLookupResults;
        }
        return Null;
    } 
  
    public Static String getParentName( String objectName, String fieldName){
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields
            .getMap()
            .get(fieldName)
            .getDescribe();
        String parentObjectName = f.getReferenceTo()[0].getDescribe().getName();
        return parentObjectName == 'Queue' || parentObjectName == 'Group' ? 'User' : parentObjectName;
    }
    
    public Static String getNameField( String objectName){
        String nameField = Null;
        Map<String,Schema.SObjectField> f = Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields
            .getMap(); 
        for( String fld : f.keySet() ){
            if( f.get(fld).getDescribe().isNameField()){
                nameField = fld;
                break;
            }
        }
        
        return nameField;
    }
    public class LookupResult {
        @AuraEnabled 
        public String recordName;
        
        @AuraEnabled
        public Id recordId;
        
        public LookupResult( String recordNameTemp, Id recordIdTemp ) {
            recordName = recordNameTemp;
            recordId = recordIdTemp;
        }
    }
    @AuraEnabled(cacheable=true)
    public static Map<string,String> getLookupFieldValue( String objectApiName, String fieldApiName, String recordId){           
        Map<string,String> mapOfParentObjectIdAndName = new Map<String, String>();
        String apiName = '';
        if(recordId != NULL){
            String keyCode = recordId.subString(0,3);  
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();  
            for(Schema.SObjectType objectInstance : gd.values()) {  
                if(objectInstance.getDescribe().getKeyPrefix() == keyCode) {    
                    apiName = objectInstance.getDescribe().getName();   
                }  
            }
            List<SObject> childObjectRecordlst = Database.Query('SELECT ' +fieldApiName+ ' FROM ' +objectApiName+ ' WHERE Id =: recordId');       
            if(childObjectRecordlst.Size() > 0){
                String parentObjectId = (String) childObjectRecordlst[0].get(fieldApiName);        
                String parentObjectName = getParentName(objectApiName, fieldApiName);
                String nameField = getNameField(parentObjectName);
                sObject parentObjectRecord = Database.Query('SELECT Id,' +nameField+ ' FROM ' +parentObjectName+ ' WHERE Id =: parentObjectId');
                mapOfParentObjectIdAndName.put('Name',(String) parentObjectRecord.get(nameField));
                mapOfParentObjectIdAndName.put('Id', parentObjectId);
            }
            else{ 
               SObject sObjectRecord = Database.Query('SELECT Id, Name FROM ' +apiName+ ' WHERE Id =: recordId');
               mapOfParentObjectIdAndName.put('Name',(String) sObjectRecord.get('Name'));
               mapOfParentObjectIdAndName.put('Id',(String) sObjectRecord.get('Id'));
            }
        }
        return mapOfParentObjectIdAndName;                  
    }

}