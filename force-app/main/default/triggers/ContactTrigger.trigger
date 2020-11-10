trigger ContactTrigger on Contact (before insert, before update, after Insert, after Update) {
    
    /*for(Contact c : Trigger.New) {
        if(c.LastName == 'INVALIDNAME') {   //invalidname is invalid
            c.AddError('Test-Method: The Last Name "'+c.LastName+'" is not allowed for DML');
        }
    }
    if(Trigger.isBefore && Trigger.isInsert){
        ContactsListController.updatePhone();
    }
    */
    if(Trigger.isBefore && Trigger.isInsert){
        ContactHelperClass.duplicateContacts(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        ContactHelperClass.primaryLevels(Trigger.new);
    }
}
//RestrictContactByName
//PreventDuplicateContacts
//