trigger JobTriggerApexRecordSharing on Job_Rasika__c(after Insert, after Update){
    if(Trigger.isAfter && Trigger.isUpdate){
        //you can get required User Id by changing filter conditions
        User user = [Select Id From User Where Alias = 'DC' Limit 1];
        List<Job_Rasika__Share> objShareList = new List<Job_Rasika__Share>();
        for(Job_Rasika__c obj:Trigger.new){
            if(obj.Number_of_Positions__c >= 10){
                Job_Rasika__Share objShare = new Job_Rasika__Share();
                objShare.ParentId = obj.Id;
                objShare.UserOrGroupId = user.Id;
                //you change access level as per requirement
                objShare.AccessLevel = 'Edit';
                objShare.RowCause = 'Value more than 100';
                objShareList.add(objShare);
            }
        }
        /*if(objShareList.size() > 0){
            try{
                insert objShareList;
            }catch(Exception ex){
                System.debug(ex);
            }
        }*/
        Database.SaveResult[] jobShareInsertResult = Database.insert(objShareList,false);
    }
}