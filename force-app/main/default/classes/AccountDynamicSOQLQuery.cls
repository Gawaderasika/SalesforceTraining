/********************************************************************** 
Name: AccountDynamicSOQLQuery
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: Dynamic SOQL
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 10/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class AccountDynamicSOQLQuery {
    public String q{set;get;}
    public List<Account> a {set;get;}
    public void search(){
        //List<Account> a = [SELECT Id, Name FROM Account WHERE Name LIKE '%John%'];
        a = Database.query('SELECT Id, Name FROM Account WHERE Name LIKE \'%' + q + '%\'');
    }
}