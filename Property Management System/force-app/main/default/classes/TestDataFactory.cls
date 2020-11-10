/************************************************************************************************************************************
Author      :   Surbhi Srivastava
Description :   This apex class is used to define the test data globally for the test classes.
History     :
----------------------------------------------------------------------------------------------------------------------------------
VERSION     DATE                  AUTHOR                    DETAIL
1           26/09/2019            Surbhi Srivastava         Initial Development
2           14/11/2019            Shahaji Mahakale          Added method to fetch data from static resource according to CMT flag value
**************************************************************************************************************************************/

public class TestDataFactory {
    public static String getStaticResource(String resourceName){
       StaticResource staticResource = [SELECT Id, NamespacePrefix, Name, ContentType, BodyLength, Body, Description, CacheControl, SystemModStamp 
                          FROM StaticResource 
                          WHERE Name =: String.escapeSingleQuotes(resourceName)
                          LIMIT 1];
        return staticResource.Body.toString();
    }

    public static Map<String,Object> createLayoutStaticResource( String layoutName){
        Map<String,Object> mapResponse = new Map<String,Object>();

        if(true){
            String body = getStaticResource(layoutName);
            if(String.isNotBlank(body)){
                mapResponse = (Map<String,Object>) JSON.deserializeUntyped(body);  
            }
        }
        return mapResponse;
    }
    // create Layout 
    public static sObject createLayout(){
        sObject objRecord = Schema.getGlobalDescribe().get('Layout__C').newSObject();
        objRecord.put('Name', 'Layout');
        objRecord.put('Layout__c', 'Standard Layout');
        objRecord.put('Label__c', 'Account Layout');
        insert objRecord;
        return objRecord;
    }
    public static ModelWrapper createStaticResource(String modelName){
        ModelWrapper modelInfo = new  ModelWrapper();

        if(true){
            String body = getStaticResource(modelName);
            if(String.isNotBlank(body)){
                modelInfo = ((ModelWrapper)JSON.deserialize(body, ModelWrapper.class));  
            }
        }
        return modelInfo;
    }
    // create ModelDef
    public static sObject createModelDef(){
        sObject objRecord = Schema.getGlobalDescribe().get('ModelDef__c').newSObject();
        sObject objDatasource = createDatasource();
        objRecord.put('Name', 'ModalDef');
        objRecord.put('Object__c', 'Account');
        objRecord.put('Datasource__c', '');
        //objRecord.put('Datasource__c', objDatasource.get('Id'));
        objRecord.put('Fields__c', 'Id, Name, AccountNumber, BillingCity, BillingCountry, BillingPostalCode');
        objRecord.put('Criteria__c', '[{ "fieldName" : "BillingCity", "key" : "billingCityKey", "operator" : "equals", "value" : "San Francisco", "valueType" : "text"}]');
        insert objRecord;
        return objRecord;
    }
    // create DataSource
    public static sObject createDatasource(){
        sObject objRecord = null;
         return objRecord;
       
    }
 
     //create Accounts     
    public static List<Account> createAccounts(Integer numOfAcc){        
        List<Account> lstOfAccounts = new List<Account>();        
        for( Integer i=0; i < numOfAcc; i++ ) {
            Account objAcc = new Account( Name='Test Account' + i, BillingCity = 'San Francisco' );
            lstOfAccounts.add(objAcc);
        }
        return lstOfAccounts;
    }
    //insert Reservation     
    public static Reservation__c insertReservation(){  
        Property__c property = createProperty();
        insert property;
        List<Contact> lstContact = createContacts(1);
        insert lstContact;
        Reservation__c obj = new Reservation__c(Reservation_Property__c =property.Id,Reservation_Member_Name__c =lstContact[0].Id, Reservation_Email__c = 'test@gmail.com');
        insert obj;
        return obj;
    }
    
    //create query and query conditions
  public static ModelWrapper createQuery(){
       List<ModelWrapper.Condition> lstOfQueryConditions = new List<ModelWrapper.Condition>();
       ModelWrapper objQuery = new ModelWrapper();
      // Organization objOrganization = [SELECT NamespacePrefix FROM Organization];
      boolean isNameSpace;
        try{
               isNameSpace = userinfo.isCurrentUserLicensed('epms');
         }
         catch (exception ex){
             System.debug('Exception ' + ex);
             isNameSpace = false;
         }
         
       if(isNameSpace){
           objQuery.objType = 'epms__Reservation__c';
           objQuery.fields = new List<String>{'name','Name'};
                     
           ModelWrapper.Condition secondQueryCondition= new ModelWrapper.Condition();
           secondQueryCondition.fieldName = 'epms__Reservation_Email__c';
           secondQueryCondition.operator = 'equals';
           secondQueryCondition.valueType = 'text';
           secondQueryCondition.value = 'test@gmail.com';
           lstOfQueryConditions.add(secondQueryCondition);
           objQuery.conditions = lstOfQueryConditions;    
           return objQuery;
       }
       else{
           objQuery.objType = 'Reservation__c';
           objQuery.fields = new List<String>{'name','Name'};
  
           ModelWrapper.Condition secondQueryCondition= new ModelWrapper.Condition();
           secondQueryCondition.fieldName = 'Reservation_Email__c';
           secondQueryCondition.operator = 'equals';
           secondQueryCondition.valueType = 'text';
           secondQueryCondition.value = 'test@gmail.com';
           lstOfQueryConditions.add(secondQueryCondition);
           objQuery.conditions = lstOfQueryConditions;    
           return objQuery;
       }
       
   }
    
    //create list of object for insert scenario
 public static List<Object> createJSONObjectsForInsert(){
       Property__c property = createProperty();
       insert property;
       List<Contact> lstContact = createContacts(1);
       insert lstContact;
       List<Object> lstOfJsonObject = new List<Object>();
      // Organization objOrganization = [SELECT NamespacePrefix FROM Organization];
      boolean isNameSpace;
        try{
               isNameSpace = userinfo.isCurrentUserLicensed('epms');
         }
         catch (exception ex){
             System.debug('Exception ' + ex);
             isNameSpace = false;
         }
       Map<String, String> mapOfStringObject = new Map<String, String>();
       if(isNameSpace){
           mapOfStringObject.put('epms__Reservation_Member_Name__c', lstContact[0].Id);
           mapOfStringObject.put('epms__Reservation_Property__c',property.Id );
           mapOfStringObject.put('epms__Reservation_Email__c', 'test@gmail.com');
       }
       else{
           mapOfStringObject.put('Reservation_Member_Name__c', lstContact[0].Id);
           mapOfStringObject.put('Reservation_Property__c',property.Id );
           mapOfStringObject.put('Reservation_Email__c', 'test@gmail.com');
       }
       lstOfJsonObject.add(mapOfStringObject);  
       return lstOfJsonObject;
   }
    //create list of object for Update scenario
    public static List<Object> createJSONObjectsForUpdate(){ 
        List<Object> lstOfJsonObject = new List<Object>();
        Reservation__c reservation = insertReservation();
        Map<String, String> mapOfStringObject = new Map<String, String>();
        mapOfStringObject.put('Id', reservation.Id);
        mapOfStringObject.put('Reservation_Email__c', 'test@gmail.com');
        lstOfJsonObject.add(mapOfStringObject);  
        return lstOfJsonObject;
    } 
    
    // create Property 
    public static Property__c createProperty(){
        Property__c objOfProperty = new Property__c(Name = 'Property', Property_Reservation_Email_Address__c = 'airbnb@ex.com', Property_Address__c = '888 Brannan Street, in San Francisco, California',
                                                    Location__c = 'California');
        return objOfProperty;
    }
    
    // create Unit Type 
    public static List<Unit_Type__c> createUnitTypes(Integer numOfUnitType){
        List<Unit_Type__c> lstOfUnitTypes = new List<Unit_Type__c>();        
        for( Integer i=0; i < numOfUnitType; i++ ) {
            Unit_Type__c objOfUnitType = new Unit_Type__c(Name = 'UnitType'+i, Description__c = 'This is the unit type(hotel) of airbnb property');
            lstOfUnitTypes.add(objOfUnitType);
        }
        return lstOfUnitTypes;
    }
   
    //create units
   public static List<Unit__c> createUnits(Unit_Type__c unitType, Integer numOfUnits){
          List<Unit__c> lstOfUnits = new List<Unit__c>(); 
            for( Integer i=0; i < numOfUnits; i++ ){
                Unit__c objUnit = new Unit__c(Name = unitType.Name +i, Description__c = 'This is the unit of unit type', Property__c = unitType.Property__c,
                                              Unit_Type__c = unitType.Id);
                lstOfUnits.add(objUnit);
            }
        return lstOfUnits;
    }
    
    //create Contacts     
    public static List<Contact> createContacts(Integer numOfContacts){
        List<Contact> lstOfContact = new List<Contact>();         
        for(Integer i=0; i < numOfContacts; i++ ){
            Contact objOfContact = new Contact(FirstName = 'Test', LastName = 'Contact'+i, Email = 'testContact'+i+'@ex.com');
            lstOfContact.add(objOfContact);
        }
        return lstOfContact;
    }  
    
    //create Reservation     
    public static Reservation__c createReservation(Id contactId, Id propertyId){
        Reservation__c objOfReservation = new Reservation__c(Reservation_Email__c = 'testContact@ex.com',
                                                             Reservation_Member_Name__c = contactId, 
                                                             Reservation_Property__c = propertyId);
        return objOfReservation;
    }
    
    //create unit type reservation
    public static Unit_Type_Reservation__c createUnitTypeReservation(Id reservationId, Id unitTypeId, Id contactId, Id unitId,String status, String action){
        Unit_Type_Reservation__c objOfUnitTypeReservation = new Unit_Type_Reservation__c(Unit_Type__c = unitTypeId,
            																			 Reservation__c = reservationId,
                                                                                         No_of_Children__c = 2,
                                                                                         No_of_Adults__c = 2,
                                                                                         Reservation_Member_Name__c = contactId,
                                                                                         Unit__c = unitId,
                                                                                         Start_Date__c = System.today(),
                                                                                         End_Date__c = system.today().addDays(7),
                                                                                        Status__c = status,
                                                                                        Action__c = action );
        return objOfUnitTypeReservation;
    }

    //create Assignments     
    public static Assignment__c createAssignment(Id unitTypeReservationId, Id unitId, Id unitTypeId, Id contactId, String action){
        Assignment__c objOfAssignment = new Assignment__c(Description__c = 'Units are assigned',  
                                                          Check_In_Date__c = system.today(),
                                                          Check_Out_Date__c = system.today().addDays(7), 
                                                          Unit__c = unitId,
                                                          Unit_Type__c = unitTypeId,
                                                          Unit_Type_Reservation__c = unitTypeReservationId,
                                                          Action__c = action);
        return objOfAssignment;
    }   

    public static Service_Interruption__c createServiceInterruption(Id unitId){
        Service_Interruption__c objServiceInterruption = new Service_Interruption__c(
                                                          Start_Date__c = system.today(),
                                                          End_Date__c = system.today().addDays(7), 
                                                          Unit__c = unitId); 
        return objServiceInterruption;
    }
  
}