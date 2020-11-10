/********************************************************************** 
Name: TemperatureConverterTest
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Test method for TemperatureConverter
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 07/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
@isTest
public class TemperatureConverterTest {
    @isTest static void fun1(){
        decimal f1 = TemperatureConverter.f2c(70);
        System.assertEquals(21.11, f1,'Boiling point temperature is not expected.');
    }
}