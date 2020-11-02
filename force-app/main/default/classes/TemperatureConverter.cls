/********************************************************************** 
Name: TemperatureConverter
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Temperature Converter
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 07/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
public class TemperatureConverter {
    public static decimal f2c(decimal f){
        decimal c = (f - 32) * 5/9;
        return c.setScale(2);
    }
}