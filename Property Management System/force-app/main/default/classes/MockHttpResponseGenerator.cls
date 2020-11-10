/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to generate mock http response for callout.
History		:
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    17/11/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
     global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"name":"test"}');
        res.setStatusCode(200);
        return res;
    }
}