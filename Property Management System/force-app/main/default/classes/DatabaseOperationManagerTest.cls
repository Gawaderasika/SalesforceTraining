/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This test class is used to cover scenarios of apex class DatabaseOperationManager.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    20/11/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
@isTest
public class DatabaseOperationManagerTest {
     @isTest
    static void getAllObjects(){
        Result result = DatabaseOperationManager.getAllObjects();
        System.assert(result != null);
    } 
    @isTest
    static void describeObject(){
         ModelWrapper objQuery = TestDataFactory.createQuery();
         Result result = DatabaseOperationManager.describeObject(objQuery);
         System.assert(result != null);
    }
}