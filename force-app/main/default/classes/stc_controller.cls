/********************************************************************** 
Name: stc_controller
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Standard controller for controller_ext.vfp
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 21/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class stc_controller {
 
    //private final Account acct;
    public String a;
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public stc_controller() {
        String a = 'Hello';
    }
 	
    public String getGreeting() {
        return a;
    }
}