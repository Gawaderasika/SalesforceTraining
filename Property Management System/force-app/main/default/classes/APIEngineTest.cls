@isTest
public class APIEngineTest {
	@isTest static void query() {
        sObject newObject = TestDataFactory.createDatasource();        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        ModelWrapper objQuery = TestDataFactory.createQuery();
        List<ModelWrapper.Condition> conditions = objQuery.conditions;
        Result result = APIEngine.query(objQuery,true,newObject);
        System.assert(result != null);
       	Test.stopTest();
    }
    @isTest
    static void save(){
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert(); 
        sObject newObject = TestDataFactory.createDatasource();      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Result result = APIEngine.save(lstOfJsonObject, 'Account', newObject);
        System.assert(result != null);
        Test.stopTest();

    }       
    @isTest
    static void remove(){
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate(); 
        sObject newObject = TestDataFactory.createDatasource();       
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Result result = APIEngine.remove(lstOfJsonObject, 'Account', newObject);
        System.assert(result != null);
        Test.stopTest();
    } 
}