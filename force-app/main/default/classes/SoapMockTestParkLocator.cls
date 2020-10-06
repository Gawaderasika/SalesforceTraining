@isTest
global class SoapMockTestParkLocator implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        parksServices.byCountryResponse response_x = 
            new parksServices.byCountryResponse();
            
        List<String> myStrings = new List<String> {'Park1','Park2','Park3'};
    
        response_x.return_x = myStrings;
        // end
        response.put('response_x', response_x); 
   }
}