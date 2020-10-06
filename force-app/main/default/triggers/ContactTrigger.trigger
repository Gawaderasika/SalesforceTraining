trigger ContactTrigger on Contact (before insert, before update) {
    
    for(Contact c : Trigger.New) {
        if(c.LastName == 'INVALIDNAME') {   //invalidname is invalid
            c.AddError('Test-Method: The Last Name "'+c.LastName+'" is not allowed for DML');
        }
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        ContactsListController.updatePhone();
    }
    
    Set <String> lstName = new Set<String>(); 
    
    for (contact con:trigger.new) {
        lstName.add(con.lastName);
    }
 
    List <Contact> contactList = new List<Contact>();
    contactlist = [SELECT lastName FROM Contact WHERE lastName IN :lstName];
 
    for (contact con:trigger.new) {
        If (contactList.size() > 0) {
            con.lastName.adderror( 'No duplicate contacts allowed' );
        }
    }
}
//RestrictContactByName
//PreventDuplicateContacts
//