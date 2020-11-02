/********************************************************************** 
Name: TestVerifyDate
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Test method for VerifyDate
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/ 
@isTest
private class TestVerifyDate {
    
    @isTest static void fun1(){
        Date startDate1 = Date.parse('12/10/2015');
        Date endDate1 = Date.parse('12/15/2015');
        Date ans1 = VerifyDate.CheckDates(startDate1, endDate1);
        System.assertEquals(endDate1, ans1);
    }
       
    @isTest static void fun2(){
        Date startDate2 = Date.parse('12/20/2015');
        Date endDate2 = Date.parse('12/15/2015');
        Date ans2 = VerifyDate.CheckDates(startDate2, endDate2);
        System.assertEquals(Date.parse('12/31/2015'), ans2);
    }    
    @isTest static void fun3(){
        Date startDate3 = Date.parse('10/15/2015');
        Date endDate3 = Date.parse('12/15/2015');
        Date ans3 = VerifyDate.CheckDates(startDate3, endDate3);
        System.assertEquals(Date.parse('10/31/2015'), ans3);
    }
}