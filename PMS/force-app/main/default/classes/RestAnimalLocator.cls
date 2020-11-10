public class RestAnimalLocator {
	public static String getAnimalNameById(Integer id)
   {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        RestAnimalResult result = (RestAnimalResult) JSON.deserialize(response.getBody(), RestAnimalResult.class);
        return result.animal.name;
   }
}