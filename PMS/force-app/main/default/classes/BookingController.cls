public class BookingController {
    
    public class PropertyEntities
    {
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public List<PropertyEntities> children {get;set;}
        public PropertyEntities(String label,Id id, List<PropertyEntities> children)
        {
            this.label = label;
            this.id = id;
            this.children = children;
        }
    }
    
    public class ReservationInfo
    {
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public Date startdate {get;set;}
        @AuraEnabled public Date enddate{get;set;}
        @AuraEnabled public Id entitytype_id{get;set;}
        @AuraEnabled public Id entitychild1_id{get;set;}
        @AuraEnabled public Id entitychild2_id{get;set;}
        @AuraEnabled public Id property_id {get;set;}
        public ReservationInfo(Id id,String name,Date startdate,Date enddate,Id unitTypeId,Id unitId,Id subUnitId,Id property_id)
        {
            this.id = id;
            this.name = name;
            this.startdate = startdate;
            this.enddate = enddate;
            this.entitytype_id = unitTypeId;
            this.entitychild1_id = unitId;
            this.entitychild2_id = subUnitId;
            this.property_id = property_id;            
        }
    }
        
    @AuraEnabled (cacheable = true)
    public Static string getBookingEntity(String parentObjectApiName , String childObjectApiName, String subChildObjectApiName){
        map<Id,Sobject> mapIdwithParents ;
        map<Id,Sobject> mapIdWithChilds;
        map<Id,Sobject> mapIdWithSubChilds;            	
        try{
            if(String.isNotBlank(parentObjectApiName)){
                mapIdwithParents = new Map<Id, SObject>((List<SObject>)Database.query('SELECT Id, Name FROM '+ parentObjectApiName +' LIMIT 50000'));
            }if(String.isNotBlank(childObjectApiName)){
                SET<ID> setParentIds = mapIdwithParents.keyset();
                String childQuery = 'SELECT Id, Name, '+parentObjectApiName+' FROM '+ childObjectApiName +' WHERE '+parentObjectApiName+' IN : setParentIds LIMIT 50000'; 
                mapIdWithChilds =  new Map<Id, SObject>((List<SObject>)database.query(childQuery));
            }if(String.isNotBlank(subChildObjectApiName)){
                SET<ID> setChildIds = mapIdWithChilds.keyset();
                String subChildQuery = 'SELECT Id, Name, '+childObjectApiName+' FROM '+ subChildObjectApiName +' WHERE '+childObjectApiName+' IN : setChildIds LIMIT 50000'; 
                mapIdWithSubChilds =  new Map<Id, SObject>( (List<SObject>) Database.query(subChildQuery) ); 
            }            
            List<PropertyEntities> lstPropertyEntities = new List<PropertyEntities>(); 
            if(mapIdwithParents != null){
                for(Sobject objParent : mapIdwithParents.values()){
                    List<PropertyEntities> lstChilds = new List<PropertyEntities>();
                    if(mapIdWithChilds != null){
                        for(Sobject objChild : mapIdWithChilds.values()){
                            List<PropertyEntities> lstSubChilds = new List<PropertyEntities>();
                            Id parentId = (Id) objChild.get(parentObjectApiName);
                            if(mapIdWithSubChilds != null ){
                                for(Sobject objSubChild : mapIdWithSubChilds.values()){    
                                    Id childId = (Id) objSubChild.get(childObjectApiName);
                                    if(childId == objChild.Id){
                                        lstSubChilds.add(new PropertyEntities((String)objSubChild.get('Name'),objSubChild.Id,new List<PropertyEntities>()));
                                    }                                                               
                                }
                            }
                            if(parentId == objParent.Id){                    
                                lstChilds.add(new PropertyEntities((String)objChild.get('Name'),objChild.Id,lstSubChilds));
                            }
                        }
                    }
                    lstPropertyEntities.add(new PropertyEntities((String)objParent.get('Name'),objParent.Id,lstChilds));            
                }
            }
            return Json.serialize(lstPropertyEntities); 
        }catch(Exception ex){
            System.debug('Line Number ::'+ex.getLineNumber());
            System.debug('Error ::'+ ex.getMessage());
            System.debug('Error ::'+ ex.getCause());
            System.debug('Error ::'+ ex.getStackTraceString());
        }
        return null;        
    }
    
    @AuraEnabled (cacheable = true)
    public Static string getBookingData(String bookingObjectApiName, String parentFieldApiName, String childFieldApiName, String subChildFieldApiName, String startDateFieldApiName, String endDateFieldApiName){
        list<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
        try{
            if(String.isNotBlank(BookingObjectApiName)){ 
                String parentFieldApiNameValue = '', childFieldApiNameValue='',subChildFieldApiNameValue='';
                String query = 'SELECT Id, Name';
                if(String.isNotBlank(parentFieldApiName)){
                    query+= ', '+parentFieldApiName;
                }
                if(String.isNotBlank(childFieldApiName)){
                    query+= ', '+childFieldApiName;
                }
                if(String.isNotBlank(subChildFieldApiName)){
                    query+= ', '+subChildFieldApiName;
                }
                if(String.isNotBlank(StartDateFieldApiName)){
                    query+= ', '+StartDateFieldApiName;
                }
                if(String.isNotBlank(EndDateFieldApiName)){
                    query+= ', '+EndDateFieldApiName;
                }
                query+= ' FROM '+BookingObjectApiName+' LIMIT 50000';
                
                List<Sobject> lstBookingData = Database.query(query);            
                for(Sobject objBookingData : lstBookingData){
                    String subChildId = NULL;
                    if(subChildFieldApiName != NULL)
                        subChildId = (String)objBookingData.get(subChildFieldApiName);
                    
                    lstReservationInfo.add(new ReservationInfo(objBookingData.Id,
                        (String)objBookingData.get('Name'),
                        (Date)objBookingData.get(StartDateFieldApiName),
                        (Date)objBookingData.get(EndDateFieldApiName), 
                        (String)objBookingData.get(parentFieldApiName),
                        (String)objBookingData.get(childFieldApiName),
                        subChildId,
                        null));                                   
                }
                return Json.serialize(lstReservationInfo);
            }  
        }catch(Exception ex){
            System.debug('Line Number ::'+ex.getLineNumber());
            System.debug('Error ::'+ ex.getMessage());
            System.debug('Error ::'+ ex.getCause());
            System.debug('Error ::'+ ex.getStackTraceString());
        }
        
	return null;
    }
    
}