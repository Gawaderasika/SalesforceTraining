var rasikaFactory = angular.module("rasikaFactory", []);
      
rasikaFactory.factory("rasikaFactory", function() {
    var factory = {};
    
    factory.getObjectAllField = function(sObjectName, propName){
        
        
        /*Schema.DescribeSObjectResult a_desc = sObjectName.sObjectType.getDescribe(); 
		Map<String, Schema.SObjectField> a_desc = a_desc.fields.getMap();
		for(Schema.sObjectField fld:a_fields.values()){ 
               system.debug(fld);
		}*/
       // let result = [];
       // map<string, string> fieldList = new map<string, string>();
       // map<string,SObjectField> fList = schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
       // console.log(fList);
        //for(string str: fList.keySet()){
		//	fieldList.put(fList.get(str).getDescribe().getName(), fList.get(str).getDescribe().getLabel());                
        //}
       // console.log(fList);
       // return fieldList;
        /*
        angular.forEach(fieldList,function(field){
            if(field[propName] != undefined)
                result.push(field[propName]);
            else
                result.push(field);
        });
        return result;*/
        
        /*let List < Schema.SObjectType > gd = Schema.getGlobalDescribe().Values();  
        let Map<String , Schema.SObjectType > globalDescription = Schema.getGlobalDescribe();  
        for ( Schema.SObjectType f : gd ) {  
            if(gd == sObjectName){
                Schema.sObjectType objType = globalDescription.get(f.getDescribe().getName() );  
    		Schema.DescribeSObjectResult r1 = objType.getDescribe();   
    		let Map<String , Schema.SObjectField > mapFieldList = r1.fields.getMap();    
    		for ( Schema.SObjectField field : mapFieldList.values() ) {    
        		Schema.DescribeFieldResult fieldResult = field.getDescribe();       
            	result.push(fieldResult.getName());
    		}
        }
        map<string, string> fieldList = new map<string, string>();
        map<string,SObjectField> fList = schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(string str: fList.keySet()){
			fieldList.put(str, fList.get(str).getDescribe().getLabel());                
        }
        angular.forEach(fieldList,function(field){
            result.push(field[str]);
        });*/        
        
        let result = [];
        let fields = rasikaFactory.objectSchema[sObjectName].fields; 
        angular.forEach(fields,function(field){
            if(field[propName] != undefined)
                result.push(field[propName]);
            else
                result.push(field);
        });
        return result;
        
    }
    factory.disp = function(){
        var x = document.getElementById("tDiv");
  		x.style.display = "block";
    }
    factory.hide = function(){
        var x = document.getElementById("tDiv");
  		x.style.display = "none";
    }
    factory.getObjectQuery = function(sObjectName, objectFields, limitClause){
        let query = 'SELECT ';
        angular.forEach(objectFields,function(field){
            query += field+',';
        });
        query = query.substring(0,query.length-1);
        query += ' FROM ' + sObjectName + ' ' + limitClause;
        return query;
    }
    
    factory.getRecords = function(query,onSuccess,onError){
        rasikaClass.getRecords(query,function(result,response){
            if(response.status){
                onSuccess(result);
            }else{
                onError(response.status);
            }
        });
    }
    
    factory.deleteRecord = function(sObjectName, Id, onSuccess,onError) {
        rasikaClass.deleteRecord(sObjectName, Id, function(result, response){
            if(response.status){
                onSuccess('Id',Id);
            }else{
                onError(response.message);
            }
        });
    }
    return factory;
});

rasikaFactory.objectSchema = {
    
    'Contact' : {
        apiName : 'Contact',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'AssistantName',
                apiName:'AssistantName'
            },
            {
                label:'Birthdate',
                apiName:'Birthdate'
            },
            {
                label:'AssistantPhone',
                apiName:'AssistantPhone'
            },
            
            {
                label:'Department',
                apiName:'Department'
            },
            
            {
                label:'Email',
                apiName:'Email'
            },
            {
                label:'HomePhone',
                apiName:'HomePhone'
            },
            
            {
                label:'MailingCity',
                apiName:'MailingCity'
            }
        ]
    },
    'Account' : {
        apiName : 'Account',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'Account',
                apiName:'AccountNumber'
            },
            {
                label:'Site',
                apiName:'Site'
            },
            {
                label:'AnnualRevenue',
                apiName:'AnnualRevenue'
            },
            {
                label:'BillingCity',
                apiName:'BillingCity'
            },
            {
                label:'DunsNumber',
                apiName:'DunsNumber'
            },
            
            {
                label:'NumberOfEmployees',
                apiName:'NumberOfEmployees'
            },
            
            {
                label:'Phone',
                apiName:'Phone'
            },
            
        ]
    },
    'Job_Rasika__c' : {
        apiName : 'Job_Rasika__c',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'Active',
                apiName:'Active__c'
            },
            {
                label:'Description',
                apiName:'Description__c'
            },
            {
                label:'Expires On',
                apiName:'Expires_On__c'
            },
            {
                label:'Hired Applicants',
                apiName:'Hired_Applicants__c'
            },
            {
                label:'Manager',
                apiName:'Manager__c'
            },
            {
                label:'Number of Positions',
                apiName:'Number_of_Positions__c'
            },
            {
                label:'Salary Offered',
                apiName:'Salary_Offered__c'
            },
            {
                label:'Total Applicants',
                apiName:'Total_Applicants__c'
            }
        ]
    },
    'Candidate_Rasika__c' : {
        apiName : 'Candidate_Rasika__c',
        fields : [
            {
                label:'Id',
                apiName:'Id'
            },
            {
                label:'Name',
                apiName:'Name'
            },
            {
                label:'Age',
                apiName:'Age__c'
            },
            {
                label:'Application Date',
                apiName:'Application_Date__c'
            },
            {
                label:'Country',
                apiName:'Country__c'
            },
            {
                label:'DOB',
                apiName:'DOB__c'
            },
            {
                label:'Email',
                apiName:'Email__c'
            },
            {
                label:'Expected Salary',
                apiName:'Expected_Salary__c'
            },
            {
                label:'Full Name',
                apiName:'Full_Name__c'
            },
            {
                label:'Job Rasika',
                apiName:'Job_Rasika__c'
            },
            {
                label:'PAN Card',
                apiName:'PAN_Card__c'
            },
            {
                label:'State',
                apiName:'State__c'
            },
            {
                label:'Status',
                apiName:'Status__c'
            }
        ]
    }
};   

