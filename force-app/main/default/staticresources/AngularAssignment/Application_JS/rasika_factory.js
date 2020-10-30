var rasika_factory = angular.module("rasika_factory", []);
      
rasika_factory.factory("rasika_factory", function() {
    var factory = {};
    factory.getObjectAllField = function(sObjectName, propName){
        let result = [];
        let fields = rasika_factory.objectSchema[sObjectName].fields; 
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
        rasika_class.getRecords(query,function(result,response){
            if(response.status){
                onSuccess(result);
            }else{
                onError(response.status);
            }
        });
    }
    
    factory.deleteRecord = function(sObjectName, Id, onSuccess,onError) {
        rasika_class.deleteRecord(sObjectName, Id, function(result, response){
            if(response.status){
                onSuccess('Id',Id);
            }else{
                onError(response.message);
            }
        });
    }
    return factory;
});

rasika_factory.objectSchema = {
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

