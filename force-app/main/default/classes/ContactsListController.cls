/********************************************************************** 
Name: ContactsListController
Copyright © 2009 Enzigma Software Pvt Ltd. 
====================================================== 
====================================================== 
Purpose: 
------- 
====================================================== 
====================================================== 
History 
------- 
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP 
1.0 - Name 10/09/2020 INITIAL DEVELOPMENT 
***********************************************************************/
public class ContactsListController {
    private String sortOrder = 'LastName';
	public List<Contact> getContacts() {
    	List<Contact> results = Database.query(
        	'SELECT Id, FirstName, LastName, Title, Email ' +
        	'FROM Contact ' +
        	'ORDER BY ' + sortOrder + ' ASC ' +
        	'LIMIT 10'
    	);
    	return results;
	}
}