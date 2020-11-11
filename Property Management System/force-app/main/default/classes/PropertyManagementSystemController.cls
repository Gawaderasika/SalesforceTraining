public with sharing class PropertyManagementSystemController {

    public static  String namespacePrefix= '';
    static {
        try{
            PostInstallPwrPMS.createTriggerConfigurationRecords();
        }
        catch(Exception exep)
        {
            System.debug('Exception : '+ exep.getLineNumber() + ' ' +exep.getMessage());
        }
        
    }
    public static Set<Id> setReservationId = new Set<Id>();
    public class PropertyEntities
    {
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public Id propertyId {get;set;}
        @AuraEnabled public List<PropertyEntities> children {get;set;}
        public PropertyEntities(String label,Id id, Id propertyId, List<PropertyEntities> children)
        {
            this.label = label;
            this.id = id;
            this.propertyId = propertyId;
            this.children = children;
        }
    }
    public class Data
    {
        @AuraEnabled public String adult;
        @AuraEnabled public String child;
        public Data(String adult,String child)
        {
            this.adult = adult;
            this.child = child;
        }
    }
    public class BookingGridData
    {
        @AuraEnabled public String jsonBookingEntities{get;set;}
        @AuraEnabled public String jsonBookingData{get;set;}
        @AuraEnabled public String jsonServiceInterruptionBookingData{get;set;}
        public BookingGridData(String jsonBookingEntities,String jsonBookingData, String jsonServiceInterruption)
        {
            this.jsonBookingEntities = jsonBookingEntities;
            this.jsonBookingData = jsonBookingData;
            this.jsonServiceInterruptionBookingData = jsonServiceInterruption;
        }
    }
    public class ReservationInfo
    {
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public Id unitTypeReservationId{get;set;}
        @AuraEnabled public Id reservationId{get;set;}
        @AuraEnabled public Id reservationMemberId{get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public Date startdate {get;set;}
        @AuraEnabled public Date enddate{get;set;}
        @AuraEnabled public Id entitytype_id{get;set;}
        @AuraEnabled public Id entitychild1_id{get;set;}
        @AuraEnabled public Id entitychild2_id{get;set;}
        @AuraEnabled public Id property_id {get;set;}
        @AuraEnabled public Data data {get;set;}
        @AuraEnabled public String serviceInerruptionReason {get;set;}
        @AuraEnabled public String status {get;set;}
         @AuraEnabled public String memberName {get;set;}
        @AuraEnabled public String propertyName {get;set;}
        @AuraEnabled public String reservationEmail {get;set;}
        @AuraEnabled public String otherReason {get;set;}
    
        @AuraEnabled public boolean dirty {get;set;}
       

        public ReservationInfo(Id unitId,String name, boolean dirty,String propertyName)
        {
            this.id = unitId;
            this.name = name;
            this.dirty = dirty;
            this.propertyName = propertyName;
           

        }
       




        public ReservationInfo(Id reservationId,String name, String memberName,String propertyName,String status)
        {
            this.id = reservationId;
            this.name = name;
            this.memberName = memberName;
            this.propertyName = propertyName;
            this.Status =status;

        }
        
        
       
        public ReservationInfo(Id id,String name,Date startdate,Date enddate,Id unitTypeId,Id unitId,Id subUnitId,Id property_id,Data data,String status)
        {
            this.id = id;
            this.name = name;
            this.startdate = startdate;
            this.enddate = enddate;
            this.entitytype_id = unitTypeId;
            this.entitychild1_id = unitId;
            this.entitychild2_id = subUnitId;
            this.property_id = property_id;
            this.data = data;
            this.Status = status;
        }
        public ReservationInfo(Id id,String name,Date startdate,Date enddate,Id unitTypeId,Id unitId,Id subUnitId,Id property_id,Data data,Id unitTypeReservationId,Id reservationId, Id reservationMemberId, String status)
        {
            this.id = id;
            this.name = name;
            this.startdate = startdate;
            this.enddate = enddate;
            this.entitytype_id = unitTypeId;
            this.entitychild1_id = unitId;
            this.entitychild2_id = subUnitId;
            this.property_id = property_id;
            this.data = data;
			this.unitTypeReservationId = unitTypeReservationId;
            this.reservationId = reservationId;
            this.reservationMemberId = reservationMemberId;
            this.status = status;
        }
        public ReservationInfo(Id id,String name,Date startdate,Date enddate,Id unitTypeId,Id unitId,Id unitTypeReservationId,Id reservationId, Id reservationMemberId, String status, String memberName)
        {
            this.id = id;
            this.name = name;
            this.startdate = startdate;
            this.enddate = enddate;
            this.entitytype_id = unitTypeId;
            this.entitychild1_id = unitId;
			this.unitTypeReservationId = unitTypeReservationId;
            this.reservationId = reservationId;
            this.reservationMemberId = reservationMemberId;
            this.status = status;
            this.memberName = memberName;
        }
        public ReservationInfo(Id id, String name, Date startdate, Id unitTypeId, Date enddate, Id unitId, Id property_id, Data data, String reason,String other_Reason){
            this.id = id;
            this.name = 'Service Interruption';
            this.startDate = startdate;
            this.entitytype_id = unitTypeId;
            this.enddate = enddate;
            this.entitychild1_id = unitId;
            this.property_id = property_id;
            this.data = data;
            this.serviceInerruptionReason = reason;
            this.otherReason = other_Reason;
        }
    }
    public static list<PropertyEntities> getUnitPropertyEntities(list<epms__Unit__c> lstUnits)
    {
        List<PropertyEntities> lstPropertyEntities = new List<PropertyEntities>();
        for(epms__Unit__c objUnit : lstUnits)
        {
            lstPropertyEntities.add(new PropertyEntities(objUnit.Name,objUnit.Id, objUnit.epms__Property__c, new List<PropertyEntities>()));
        }
        return lstPropertyEntities;
    }

    @AuraEnabled
    public static BookingGridData getBookingGridData(Id propertyId){

        return new BookingGridData(getPropertyEntities(propertyId),getPropertyReservationInfo(propertyId), getServiceInterruptions(propertyId));
    }
    public static String getPropertyEntities(Id propertyId)
    {
        try
        {
            system.debug('Form Property fetch');
            List<PropertyEntities> lstPropertyEntities = new List<PropertyEntities>();
            List<epms__Unit_Type__c> lstUnitTypes = [SELECT Id, Name, epms__Description__c, epms__Units_Available__c, epms__Property__c,(SELECT Id,Name, epms__Unit_Type__c, epms__Property__c, epms__Description__c FROM  epms__Units__r) FROM epms__Unit_Type__c WHERE epms__Property__c =:propertyId WITH SECURITY_ENFORCED limit 5000];
            System.debug('lstUnitTypes'+lstUnitTypes);
            for(epms__Unit_Type__c objUnitType : lstUnitTypes)
            {
                if(objUnitType.epms__Units_Available__c>0)
                {
                    lstPropertyEntities.add(new PropertyEntities(objUnitType.Name,objUnitType.Id, objUnitType.epms__Property__c, getUnitPropertyEntities(objUnitType.epms__Units__r)));
                }
                else
                    lstPropertyEntities.add(new PropertyEntities(objUnitType.Name,objUnitType.Id, objUnitType.epms__Property__c, new List<PropertyEntities>()));
            }
            return Json.serialize(lstPropertyEntities) ;
        }
        catch(Exception ex)
        {
            System.debug('Exception ' + ex.getMessage() + ' at line ' + ex.getLineNumber() + ' due to ' + ex.getStackTraceString());
        }
        return null;
    }

    public static String getPropertyReservationInfo(Id propertyId)
    {
        try
        {
            list<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
            List<epms__Unit_Type_Reservation__c> lstUnitTypeReservations = [SELECT Id, epms__Start_Date__c, epms__Cancellation_Reason__c, epms__End_Date__c, epms__Check_Out_Date__c, epms__Description__c, epms__Other_Reason__c, epms__Reservation__c,epms__Reservation_Member_Name__r.name, epms__Reservation_Member_Name__c, epms__Status__c, epms__Unit_Type__c,epms__Unit__c FROM epms__Unit_Type_Reservation__c WHERE epms__Unit_Type__r.epms__Property__c =: propertyId AND epms__Cancellation_Reason__c = NULL WITH SECURITY_ENFORCED LIMIT 5000];
            for(epms__Unit_Type_Reservation__c objUnitTypeReservation: lstUnitTypeReservations){
                if( objUnitTypeReservation.epms__Status__c == 'Checked Out'){
                lstReservationInfo.add(new ReservationInfo(objUnitTypeReservation.id, objUnitTypeReservation.epms__Reservation_Member_Name__r.name, objUnitTypeReservation.epms__Start_Date__c, objUnitTypeReservation.epms__Check_Out_Date__c, objUnitTypeReservation.epms__Unit_Type__c, objUnitTypeReservation.epms__Unit__c, null, null, null,objUnitTypeReservation.epms__Status__c));
                }
               else
            	lstReservationInfo.add(new ReservationInfo(objUnitTypeReservation.id, objUnitTypeReservation.epms__Reservation_Member_Name__r.name, objUnitTypeReservation.epms__Start_Date__c, objUnitTypeReservation.epms__End_Date__c, objUnitTypeReservation.epms__Unit_Type__c, objUnitTypeReservation.epms__Unit__c, null, null, null,objUnitTypeReservation.epms__Status__c));
            }
            return Json.serialize(lstReservationInfo);
        }
        catch(Exception ex)
        {
            System.debug('Exception ' + ex.getMessage() + ' at line ' + ex.getLineNumber() + ' due to ' + ex.getStackTraceString());
        }
        return null;
    }

    @AuraEnabled
    public static list<ReservationInfo> getAssignment(Id unitTypeId, String event, String selectDate){
        List<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
        List<ReservationInfo> lstReservationInfoOfResrvUTR = new list<ReservationInfo>();
        list<ReservationInfo> lstReservationInfoOfReservation = new list<ReservationInfo>();
        Map<ID,map<Id,Unit_Type_Reservation__c>> mapRevIdToMapOfIDtoUTR = new  Map<ID,map<Id,Unit_Type_Reservation__c>>();
        Map<Id,ReservationInfo> mapUTRIdToResrvInfo = new Map<Id,ReservationInfo>();
         Map<Id,ReservationInfo> mapReservationIdToResrvInfo = new Map<Id,ReservationInfo>();
        date arrivalDate;
        if(!String.isEmpty(selectDate)){
            List<String> lstAlpha = selectDate.split('-');
            string year = lstAlpha[0];
            string month = lstAlpha[1];
            string day = lstAlpha[2];
            arrivalDate = date.newInstance(Integer.valueof(year.trim()),
                                                Integer.valueof(month.trim()),
                                                Integer.valueof(day.trim()));
        }
        List<Unit_Type_Reservation__c> lstUnitTypeReservations;
        if(event == 'select'){
        	lstUnitTypeReservations = [SELECT Id, Name, Start_Date__c, Cancellation_Reason__c, End_Date__c, Description__c,Other_Reason__c , Reservation__c, Reservation_Member_Name__c, Reservation_Member_Name__r.name, Status__c, Unit_Type__c, Unit__c FROM Unit_Type_Reservation__c WHERE Unit_Type__c =: unitTypeId  AND  Start_Date__c <=: arrivalDate AND End_Date__c >=: arrivalDate WITH SECURITY_ENFORCED LIMIT 5000];

        //	lstUnitTypeReservations = [SELECT Id, Name, Start_Date__c, Cancellation_Reason__c, End_Date__c, Description__c,Other_Reason__c , Reservation__c, Reservation_Member_Name__c, Reservation_Member_Name__r.name, Status__c, Unit_Type__c, Unit__c FROM Unit_Type_Reservation__c WHERE Unit_Type__c =: unitTypeId AND Cancellation_Reason__c = NULL AND Unit__c = NULL AND Start_Date__c <=: arrivalDate AND End_Date__c >=: arrivalDate WITH SECURITY_ENFORCED LIMIT 5000];
        }
        else{
            lstUnitTypeReservations = [SELECT Id, Name, Start_Date__c, Cancellation_Reason__c, End_Date__c, Description__c, Other_Reason__c, Reservation__c, Reservation_Member_Name__c, Reservation_Member_Name__r.name, Status__c, Unit_Type__c, Unit__c FROM Unit_Type_Reservation__c WHERE Id =: unitTypeId  WITH SECURITY_ENFORCED LIMIT 5000];
		}

        for(Unit_Type_Reservation__c objUnitTypeReservation: lstUnitTypeReservations){
            mapUTRIdToResrvInfo.put(objUnitTypeReservation.Id,new ReservationInfo(objUnitTypeReservation.Id,
                                                       objUnitTypeReservation.Name,
                                                       objUnitTypeReservation.Start_Date__c,
                                                       objUnitTypeReservation.End_Date__c,
                                                       objUnitTypeReservation.Unit_Type__c,
                                                       objUnitTypeReservation.Unit__c,
                                                       objUnitTypeReservation.Id,
                                                       objUnitTypeReservation.Reservation__c,
                                                       objUnitTypeReservation.Reservation_Member_Name__c,
                                                       objUnitTypeReservation.Status__c,
                                                       objUnitTypeReservation.Reservation_Member_Name__r.name));

            if(event == 'select'){
                setReservationId.add(objUnitTypeReservation.Reservation__c);
            }
        }
        if(!setReservationId.isEmpty()){
            Map<Id,Reservation__c> mapIdtoReservation = new Map<Id,Reservation__c>([SELECT Id, Name, Status__c,Reservation_Member_Name__r.Name, Reservation_Property__r.Name, Reservation_Email__c
                                                                                    FROM Reservation__c Where ID IN : setReservationId]);
            for(Reservation__c reservation : mapIdtoReservation.values()){
                mapReservationIdToResrvInfo.put(reservation.Id,new ReservationInfo(reservation.Id,
                                                                        reservation.Name,
                                                                        reservation.Reservation_Member_Name__r.Name,
                                                                        reservation.Reservation_Property__r.Name,
                                                                        reservation.Status__c));
            }
            for(Unit_Type_Reservation__c utr : lstUnitTypeReservations){
                if(mapRevIdToMapOfIDtoUTR.containsKey(utr.Reservation__c)){
                    mapRevIdToMapOfIDtoUTR.get(utr.Reservation__c).put(utr.Id,utr);
                }
                else{
                    mapRevIdToMapOfIDtoUTR.put(utr.Reservation__c, new Map<Id,Unit_Type_Reservation__c >{utr.Id =>utr});
                }
            }
           for(Id revID : mapRevIdToMapOfIDtoUTR.keySet()){
                lstReservationInfoOfResrvUTR.add(mapReservationIdToResrvInfo.get(revID));
                    for(Id utrId :  mapRevIdToMapOfIDtoUTR.get(revID).keySet()){
                        lstReservationInfoOfResrvUTR.add(mapUTRIdToResrvInfo.get(utrId));
                    }
            }
        }
        if(!lstReservationInfoOfResrvUTR.isEmpty()){
            return lstReservationInfoOfResrvUTR;
        }
        else
            return mapUTRIdToResrvInfo.values();

    }

    @AuraEnabled
    public static String getServiceInterruptions(Id propertyId){
           boolean  isNameSpace =  getOrganizationNamespace();
                if( isNameSpace ){
                    namespacePrefix = 'epms__';
                }

        String sObjectName = propertyId.getSobjectType().getDescribe().getName();
        List<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
        List<Service_Interruption__c> lstServiceInterruption;
        if(sObjectName ==  namespacePrefix + 'Property__c'){
            lstServiceInterruption = [SELECT Id, Name, Start_Date__c, End_Date__c, Interruption_Reason__c, Other_Reason__c,Unit__c, Unit__r.Name, Unit__r.Unit_Type__c, Unit__r.Property__c FROM Service_Interruption__c WHERE Unit__r.Property__c =: propertyId AND Cancellation_Reason__c = Null];
        	
        }else if(sObjectName == namespacePrefix + 'Service_Interruption__c'){
            lstServiceInterruption = [SELECT Id, Name, Start_Date__c, End_Date__c, Interruption_Reason__c,Other_Reason__c, Unit__c, Unit__r.Name, Unit__r.Unit_Type__c, Unit__r.Property__c FROM Service_Interruption__c WHERE Id =: propertyId AND Cancellation_Reason__c = Null];
        	
        }
        for(Service_Interruption__c objServiceInterruption : lstServiceInterruption){
            lstReservationInfo.add(new ReservationInfo(objServiceInterruption.Id, objServiceInterruption.Name, objServiceInterruption.Start_Date__c, objServiceInterruption.Unit__r.Unit_Type__c, objServiceInterruption.End_Date__c, objServiceInterruption.Unit__c, objServiceInterruption.Unit__r.Property__c, Null, objServiceInterruption.Interruption_Reason__c,objServiceInterruption.Other_Reason__c));
        }
       
        return Json.serialize(lstReservationInfo);
    }

    @AuraEnabled
    public static boolean getOrganizationNamespace(){
        boolean isNameSpace;
        try{
               isNameSpace = userinfo.isCurrentUserLicensed('epms');
         }
         catch (exception ex){
             System.debug('Exception ' + ex);
             isNameSpace = true;
         }
         return isNameSpace;
      //return [SELECT NamespacePrefix FROM Organization].NamespacePrefix;
    }

    @AuraEnabled
    public static list<ReservationInfo> getCheckInCheckOutInformation(Id unitTypeReservationsId){
   		List<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
		List<Unit_Type_Reservation__c> lstUnitTypeReservations = [SELECT Id, Unit__c, Unit_Type__c, Start_Date__c, End_Date__c, Status__c,Active_Assignment__c, Active_Assignment__r.Check_In_Date__c, Active_Assignment__r.Check_Out_Date__c, Active_Assignment__r.Unit_Type__c, Active_Assignment__r.Unit__c  FROM Unit_Type_Reservation__c WHERE Id =: unitTypeReservationsId WITH SECURITY_ENFORCED LIMIT 5000];
		for(Unit_Type_Reservation__c objUnitTypeReservation : lstUnitTypeReservations){
            if(objUnitTypeReservation.Unit__c == NULL){
                lstReservationInfo.add(new ReservationInfo(objUnitTypeReservation.Id, null, objUnitTypeReservation.Start_Date__c, objUnitTypeReservation.End_Date__c, objUnitTypeReservation.Unit_Type__c, objUnitTypeReservation.Unit__c, null, null, null, objUnitTypeReservation.Id, null, null, objUnitTypeReservation.Status__c));
            }
            else{
            	lstReservationInfo.add(new ReservationInfo(objUnitTypeReservation.Id, null, objUnitTypeReservation.Active_Assignment__r.Check_In_Date__c, objUnitTypeReservation.Active_Assignment__r.Check_Out_Date__c,objUnitTypeReservation.Active_Assignment__r.Unit_Type__c, objUnitTypeReservation.Active_Assignment__r.Unit__c, null, null, null, objUnitTypeReservation.Id, objUnitTypeReservation.Active_Assignment__c, null, objUnitTypeReservation.Status__c));
            }
        }
        return lstReservationInfo;
    }
    @AuraEnabled
   public static list<ReservationInfo> getUnitRecord(Id unitId)
   {
    //String sObjectName = unitId.getSobjectType().getDescribe().getName();
    List<Unit__c> lstUnitRecords;
    List<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
    lstUnitRecords = [SELECT Id, Name, Dirty__c,Property__c FROM Unit__c WHERE Id =: unitId ];
    for(Unit__c objUnit : lstUnitRecords){

         lstReservationInfo.add(new ReservationInfo(objUnit.Id,objUnit.Name,objUnit.Dirty__c,objUnit.Property__c));
   }
    return lstReservationInfo;
   }
   @AuraEnabled
   public static list<ReservationInfo> getReservationOnfo(Id resTypeId)
   {
  
    //String sObjectName = unitId.getSobjectType().getDescribe().getName();
    List<Reservation__c> lstUnitRecords;
    List<ReservationInfo> lstReservationInfo = new list<ReservationInfo>();
    lstUnitRecords = [SELECT Id, Name, Status__c,Reservation_Member_Name__r.Name, Reservation_Property__r.Name, Reservation_Email__c FROM Reservation__c WHERE Id =: resTypeId ];
   
    for(Reservation__c reservation : lstUnitRecords){

         lstReservationInfo.add(new ReservationInfo(reservation.Id, reservation.Name, reservation.Reservation_Member_Name__r.Name,
                               reservation.Reservation_Property__r.Name,
                                reservation.Status__c));
   }
    return lstReservationInfo;
   }
}