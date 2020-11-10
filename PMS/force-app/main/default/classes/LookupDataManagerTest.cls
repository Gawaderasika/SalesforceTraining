/**********************************************************************************************************************
Author 		: 	Surbhi Srivastava
Description :   This test method is used to cover the different scenarios for custom lookup component of apex class
                "LookupDataManager" .
History		:
-----------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    26/09/2019		   Surbhi Srivastava       Initial Development
2 			09/12/2019			Rupesh Patil			Modifications
***********************************************************************************************************************/
@isTest
public with sharing class LookupDataManagerTest {
    @testSetup 
    static void testSetup() {        
        List<Account> lstOfAccounts = TestDataFactory.createAccounts(10);
        insert lstOfAccounts;
        //Account accountRecord = lstOfAccounts[0];
        
        List<Contact> lstContacts = TestDataFactory.createContacts(1);
        Contact contactRecord = lstContacts[0];        
        contactRecord.AccountId = lstOfAccounts[0].Id;
        insert contactRecord;       
    }
    
    @isTest  
    static void getSearchResultTestScenarioWithAllConditions() {
        Test.startTest();
        String objectApiName = 'Contact',  fieldApiName = 'AccountId', searchText = 'Test', filterCondition = 'BillingCity = \'San Francisco\'';
        Integer numberOfRecords = 5;
        Boolean showDefault = false;     
        List<Account> lstAccountsToSearch = [SELECT Id FROM Account WHERE Name Like '%Test%' AND BillingCity = 'San Francisco' Limit 5];
        
        List<Id> fixedSearchResults= new List<Id>();
        for(Account objAccount : lstAccountsToSearch){
            fixedSearchResults.add(objAccount.Id);
        }
        Test.setFixedSearchResults(fixedSearchResults);
        
        List<LookupDataManager.LookupResult> lstLookupResults = LookupDataManager.LookupResult.getSearchResult( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition, showDefault, false );        
        System.assertEquals(5, lstLookupResults.size());
        Test.stopTest();
    }    
    @isTest  
    static void getSearchResultTestScenarioWithoutFilterCondition() {
        Test.startTest();
        String objectApiName = 'Contact',  fieldApiName = 'AccountId', searchText = 'Test', filterCondition = '';
        Integer numberOfRecords = 5;
        Boolean showDefault = false; 
        
        List<Account> lstAccountsToSearch = [SELECT Id FROM Account WHERE Name Like '%Test%' Limit 5]; 
        List<Id> fixedSearchResults= new List<Id>();
        for(Account objAccount : lstAccountsToSearch){
            fixedSearchResults.add(objAccount.Id);
        }
        Test.setFixedSearchResults(fixedSearchResults);
        
        List<LookupDataManager.LookupResult> lstLookupResults = LookupDataManager.LookupResult.getSearchResult( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition, showDefault, false);        
        System.assertEquals(5, lstLookupResults.size());
        Test.stopTest();
    }
    @isTest  
    static void getSearchResultTestScenarioWithLimitSize() {
        Test.startTest();
        String objectApiName = 'Contact',  fieldApiName = 'AccountId', searchText = 'Test', filterCondition = '';
        Integer numberOfRecords = 10; 
        Boolean showDefault = false;   
        
        List<Account> lstAccountsToSearch = [SELECT Id FROM Account WHERE Name Like '%Test%' Limit 10]; 
        List<Id> fixedSearchResults= new List<Id>();
        for(Account objAccount : lstAccountsToSearch){
            fixedSearchResults.add(objAccount.Id);
        }
        Test.setFixedSearchResults(fixedSearchResults);
        
        List<LookupDataManager.LookupResult> lstLookupResults = LookupDataManager.LookupResult.getSearchResult( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition, showDefault, false);        
        System.assertEquals(10, lstLookupResults.size());
        Test.stopTest();
    }
    @isTest  
    static void getSearchResultTestShowDefault() {
        String objectApiName = 'Contact',  fieldApiName = 'AccountId', searchText = 'Test', filterCondition = '';
        Integer numberOfRecords = 10; 
        Boolean showDefault = true;      
        Boolean isLookupClicked = false;
        List<LookupDataManager.LookupResult> lstLookupResults = LookupDataManager.LookupResult.getSearchResult( objectApiName, fieldApiName, searchText, numberOfRecords, filterCondition, showDefault, isLookupClicked);        
        System.assertEquals(10, lstLookupResults.size());
    }
    @isTest
    static void getLookupFieldValueTest(){
        Contact objContact = [SELECT Id From Contact LIMIT 1];
        Map<String, String> mapOfparentObjectIdAndName = LookupDataManager.getLookupFieldValue('Contact', 'AccountId', objContact.Id);
        System.assertEquals(2, mapOfparentObjectIdAndName.size());
        System.assertEquals(true, mapOfparentObjectIdAndName.containsKey('Name'));
        System.assertEquals(true, mapOfparentObjectIdAndName.containsKey('Id'));
    }
}