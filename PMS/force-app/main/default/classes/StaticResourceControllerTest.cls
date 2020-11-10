@isTest
public class StaticResourceControllerTest {
    @isTest private static void getLayout(){
        Object layout = StaticResourceController.getlayout('Repeater_Make_Reservation');
        System.assert(layout != null);
    } 
    
    @isTest private static void getModel(){
        ModelWrapper modelInfo = New ModelWrapper();
        modelInfo = StaticResourceController.getModel('Reservations');
        System.assert(modelInfo != null);
    } 
    @isTest private static void getModelDef(){
        ModelWrapper modelInfo = New ModelWrapper();
        modelInfo = StaticResourceController.getModelDef('Reservations');
        System.assert(modelInfo != null);
        
    } 
    @isTest private static void getModelDefByModel(){
        ModelWrapper modelInfo = New ModelWrapper();
        modelInfo = StaticResourceController.getModelDefByModel('Reservations');
        System.assert(modelInfo != null);
        
    } 
    @isTest
    static void saveRecord(){
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForInsert(); 
        Result result = StaticResourceController.saveRecord(lstOfJsonObject, 'Reservations');
        System.assert(result != null);
    }         
    @isTest
    static void updateRecord(){
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate(); 
        Result result = StaticResourceController.saveRecord(lstOfJsonObject, 'Reservations');
        System.assert(result != null);
    }
    @isTest
    static void removeRecord(){
        List<Object> lstOfJsonObject = TestDataFactory.createJSONObjectsForUpdate();          
        Result result = StaticResourceController.removeRecord(lstOfJsonObject, 'Reservations');
        System.assert(result != null);
    } 
    @isTest
    static void queryTest(){
        ModelWrapper objQuery = TestDataFactory.createQuery();
        List<ModelWrapper.Condition> conditions = objQuery.conditions;
        Result result = StaticResourceController.query(conditions,  'Reservations');
        System.assert(result != null);     
    }
}