public class ParkLocator {
	/*
    public static String[] country(String country){
        ParkService.ParksImplPort parks = new ParkService.ParksImplPort();
        String[] parksname = parks.byCountry(country);
        return parksname;
    }
*/
    public static List<String> country(String countryName){
        ParkService.ParksImplPort park = new ParkService.ParksImplPort();
        return (List<String>)park.byCountry(countryName);
    }
}