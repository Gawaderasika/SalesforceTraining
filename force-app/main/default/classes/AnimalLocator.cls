public class AnimalLocator {
	public static String getAnimalNameById(Integer id)
   {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        AnimalResult result = (AnimalResult) JSON.deserialize(response.getBody(), AnimalResult.class);
        return result.animal.name;
   }
}