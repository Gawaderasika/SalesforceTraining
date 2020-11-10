/********************************************************************** 
Name: ext
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Extension controller for controller_ext.vfp
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class ext {
 
    public String b;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    /*public stc_controller(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }
 	*/
    public ext(stc_controller controller) {
        String b = 'world';
    }
    public String getGreeting1() {
        return 'world1';
    }
}