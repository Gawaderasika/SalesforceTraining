public class SoapParkLocator {
	/*
    public static String[] country(String country){
        ParkServices.ParksImplPort parks = new ParkServices.ParksImplPort();
        String[] parksname = parks.byCountry(country);
        return parksname;
    }
*/
    public static List<String> country(String countryName){
        parksServices.ParksImplPort park = new parksServices.ParksImplPort();
        return (List<String>)park.byCountry(countryName);
    }
}