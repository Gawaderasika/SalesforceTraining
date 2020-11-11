public with sharing class ModelWrapper {
    @AuraEnabled
    public String name{get;set;}
    @AuraEnabled
    public String label{get;set;}
	@AuraEnabled
    public List<String> fields{get;set;}
    @AuraEnabled
    public Criteria criteria{get;set;}
    @AuraEnabled
    public String modelDef{get;set;}
    @AuraEnabled
    public Boolean isWritable{get;set;}
    @AuraEnabled
    public String objType{get;set;}
    @AuraEnabled
    public String type{get;set;}
    @AuraEnabled
    public String sourceType{get;set;}
    @AuraEnabled
    public String datasource{get;set;}
    @AuraEnabled
    public String ObjectName{get;set;}
    @AuraEnabled
    public  List<Condition> conditions{get;set;}
    public class Criteria{
       @AuraEnabled
       public List<Condition> conditions{get;set;}
       @AuraEnabled
       public String evaluationCriteria{get;set;}
       @AuraEnabled 
       public String evaluation{get;set;}
    }
    public class Condition{
       @AuraEnabled
       public String fieldName{get;set;}
       @AuraEnabled
       public String operator{get;set;}
       @AuraEnabled
       public String valueType{get;set;}
       @AuraEnabled
       public String value{get;set;}
    }
}