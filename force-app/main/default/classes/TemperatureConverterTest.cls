@isTest
public class TemperatureConverterTest {
    @isTest static void fun1(){
        decimal f1 = TemperatureConverter.f2c(70);
        System.assertEquals(21.11, f1,'Boiling point temperature is not expected.');
    }
}