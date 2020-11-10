/********************************************************************** 
Name: FutureApex
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Future apex (Asynchronous Apex)
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 25/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class FutureApex {
    public FutureApex(){
        morning();
        afternoon();
        evening();
        night();
    }
    public static void morning(){
        System.debug('Good Morning');
    }
    public static void afternoon(){
        System.debug('Good Afternoon');
    }
    @future
    public static void evening(){
        System.debug('Good Evening');
    }
    public static void night(){
        System.debug('Good Night');
    }
}