/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This test class is used to cover the scenarios of apex class "QueryParse".
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    09/10/2019		   Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
@isTest
public class QueryParserTest{    
    @isTest
    static void parse(){ 
        ModelWrapper objQuery = TestDataFactory.createQuery();
        String strQuery = QueryParser.parse(objQuery,false);
        System.assert(strQuery != null);       
    } 
}