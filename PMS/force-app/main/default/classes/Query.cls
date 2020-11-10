/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is a wrapper for the "QueryParser" apex class.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    08/10/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/

public class Query {
    @AuraEnabled
    public String objType{get;set;}   
    @AuraEnabled
    public  List<String> fields{get;set;}
    @AuraEnabled
    public  List<Condition> conditions{get;set;}
    @AuraEnabled
    public  String datasourceId{get;set;}
    @AuraEnabled
    public String modelId{get;set;}
    
   public class Condition{
       @AuraEnabled
       public String fieldName{get;set;}
       @AuraEnabled
       public String operator{get;set;}
       @AuraEnabled
       public String valueType{get;set;}
       @AuraEnabled
       public String value{get;set;}
       @AuraEnabled
       public String key{get;set;}
    }
}