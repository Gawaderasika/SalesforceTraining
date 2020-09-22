public class TemperatureConverter {
    public static decimal f2c(decimal f){
        decimal c = (f - 32) * 5/9;
        return c.setScale(2);
    }
}