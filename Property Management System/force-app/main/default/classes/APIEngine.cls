/************************************************************************************************************************************
Author 		: 	Shahaji Mahakale
Description :   This apex class is used to construct the CRUD operation through API when datasource adapter type is salesforce.
History		: changes
----------------------------------------------------------------------------------------------------------------------------------
VERSION		DATE				AUTHOR					DETAIL
1	 	    8/11/2019		    Shahaji Mahakale       Initial Development
**************************************************************************************************************************************/

public with sharing class APIEngine {
    
    public static HttpRequest connect(sObject datasourceRecord){
        HttpRequest oauthRequest=new HttpRequest();
        oauthRequest.setMethod('POST');
        oauthRequest.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        Map<String, Object> results;
        /* Not Used for PWR Property Manager
            Object authorizationMethod = datasourceRecord.get('AuthorizationMethod__c');
            Object username = datasourceRecord.get('Username__c');
            Object password = datasourceRecord.get('Password__c');
            Object refreshToken = datasourceRecord.get('RefreshToken__c');
		*/
        Object authorizationMethod = 'password';
        Object username = 'Password';
        Object password = '';
        Object refreshToken = ''; 
        oauthRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        if(authorizationMethod == 'password' || authorizationMethod == 'Password' ){
            oauthRequest.setBody('grant_type=password&client_id=3MVG9GYWKbMgBvbzkZ7nZUe17G5YVWhIlqWxFyOrWFK3kLbC43AJUmuaKaE3tvqP.06IOq1VE_YD.z0z4vBU9&client_secret=E6E49F9A0ABC14D005C0A3826633EAE6147A1BE75484B6AE461DBEE7345BB22A&username='+username+'&password='+password);
            HttpResponse response = http.send(oauthRequest);
            results= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        } else {
            oauthRequest.setBody('grant_type=authorization_code&client_id=3MVG9GYWKbMgBvbzkZ7nZUe17G5YVWhIlqWxFyOrWFK3kLbC43AJUmuaKaE3tvqP.06IOq1VE_YD.z0z4vBU9&client_secret=E6E49F9A0ABC14D005C0A3826633EAE6147A1BE75484B6AE461DBEE7345BB22A&code='+refreshToken);
            HttpResponse response = http.send(oauthRequest);
            results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
        }
        request.setHeader('Authorization', String.valueOf(results.get('token_type')) +' '+String.valueOf(results.get('access_token')));
        if(results.get('instance_url') != null){
            request.setEndpoint(String.valueOf(results.get('instance_url')));
        }
        return request;
    }
    
    public static Result save(List<Object> lstJsonObject, String objectName, sObject datasourceRecord){
  		Http http = new Http();
        RecordWrapper recordObject = new  RecordWrapper();
        Result result = new Result(false);
        if(lstJsonObject != null)
        {
            HttpRequest request = connect(datasourceRecord);
            recordObject.compositeRequest = RecordWrapper.getCompositeRequestData(lstJsonObject,objectName);
            request.setEndpoint(request.getEndpoint()+'/services/data/v43.0/composite/');
			request.setBody(JSON.serialize(recordObject));
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                for(String key : mapResponse.keySet()){
                    String data = JSON.serialize(mapResponse.get(key));
                    String record = data.substringAfter('body":');
                    if(record != null && record != ''){
                        Object objRecord = JSON.deserializeUntyped(record);
                        return new Result(objRecord);
                    }
                    else{
                        return new Result(mapResponse.get(key));
                    }
                }
            }
        }
        return result;
    }
    public static Result remove(List<Object> lstJsonObject, String objectName , sObject datasourceRecord){
        List<Id> lstIds = new List<Id>();
        Http http = new Http();
        Result result = new Result(false);
        for(Object objJson : lstJsonObject){
           Map<String, Object> mapField = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objJson));
            for(String key : mapField.keySet()){
                if(key.toLowerCase() == 'id'){
                   lstIds.add((Id)mapField.get(key));
                }
            }
        }
        HttpRequest request = connect(datasourceRecord);
        request.setEndpoint(request.getEndpoint()+'/services/data/v43.0/composite/sobjects?ids='+ String.join(lstIds, ','));
        request.setMethod('DELETE');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
                return new Result(JSON.deserializeUntyped(response.getBody()));
        }
        return result;
    }
    public static Result query(ModelWrapper query,Boolean isStaticResourceCall,sObject datasourceRecord){
        Http http = new Http();
        Result result = new Result(false);
        String strQuery = QueryParser.parse(query,isStaticResourceCall);
        HttpRequest request = connect(datasourceRecord);
        request.setEndpoint(request.getEndpoint()+'/services/data/v43.0/query/?q='+strQuery.replace(' ', '+'));
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            Map<String, Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            String data = JSON.serialize(mapResponse.get('records'));
            data = data.substringBefore(',"attributes":{')+ data.substringAfter('}');
            Object records = JSON.deserializeUntyped(data);
            return new Result(records);
        }
        return result;
    }
}