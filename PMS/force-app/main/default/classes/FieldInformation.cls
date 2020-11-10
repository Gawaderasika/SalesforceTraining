public with sharing class FieldInformation{
        @AuraEnabled
        public String apiName {get ; set;}
        @AuraEnabled
        public String dataType {get ; set;}
        @AuraEnabled
        public string label{ get; set;}
        @AuraEnabled
        public string relationshipName{ get; set;}
        @AuraEnabled
        public string relatedToObjectApiName{ get; set;}
        @AuraEnabled
        public string lookupToObjectApiName{ get; set;}
        @AuraEnabled
        public Boolean isUpdateable{ get; set;}
        @AuraEnabled
        public Boolean isDbRequired{ get; set;}
        @AuraEnabled
        public Boolean isAccessible{ get; set;}
        @AuraEnabled
        public Integer maxLength{ get; set;}
        @AuraEnabled
        public Boolean isHtmlFormatted{ get; set;}
        @AuraEnabled
        public string maskCharacter{ get; set;}
        @AuraEnabled
        public List <KeyValueWrapper> picklistValues { get; set;}
        @AuraEnabled
        public string maskType{ get; set;}
        @AuraEnabled
        public Integer numbersOnRightOfDecimal { get; set;}
        @AuraEnabled
        public String objectApiName { get; set;}
        @AuraEnabled
        public Boolean isDependent { get; set;}
        @AuraEnabled
        public String controllingFieldApiName { get; set;}
        @AuraEnabled
        public Map<String, List<FieldInformation.KeyValueWrapper>> mapControllingDependentPicklistValues{ get; set;}
        
        public FieldInformation( String apiName , String dataType, String label,String relatedToObjectApiName, String relationshipName, Boolean isRequired, Boolean isAccessible ,Boolean isUpdateable, Integer maxLength, Boolean isHtmlFormatted ,String maskCharacter, String maskType,Integer numbersOnRightOfDecimal,  List <KeyValueWrapper> picklistValues , String objectApiName, Boolean isDependent, String controllingFieldApiName, Map<String, List<FieldInformation.KeyValueWrapper>> mapControllingDependentPicklistValues){
            this.apiName = apiName;
            this.dataType = dataType;
            this.label = label;
            this.relatedToObjectApiName = relatedToObjectApiName;
            this.relationshipName = relationshipName;
            this.isUpdateable = isUpdateable;
            this.isDbRequired = isRequired;
            this.isAccessible = isAccessible;
            this.maxLength = maxLength;
            this.isHtmlFormatted = isHtmlFormatted;
            this.maskCharacter = maskCharacter;
            this.maskType = maskType;
            this.numbersOnRightOfDecimal = numbersOnRightOfDecimal;
            this.picklistValues = picklistValues;
            this.objectApiName = objectApiName;
            this.isDependent = isDependent;
            this.controllingFieldApiName = controllingFieldApiName;
            this.mapControllingDependentPicklistValues = mapControllingDependentPicklistValues;

        }
        public class KeyValueWrapper {
            @AuraEnabled
            public string value {get ; set;}
            @AuraEnabled
            public string label {get ; set;}
            public KeyValueWrapper( String value , String label){
                this.value = value;
                this.label = label;
            }
        }
    }