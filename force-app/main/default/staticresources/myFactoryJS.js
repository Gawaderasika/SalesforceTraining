var myFactory = angular.module("myFactory", []);
      
myFactory.factory("myFactory", function() {
    var factory = {};
    factory.getObjectAllField = function(sObjectName, propName,objectFields){
        let result = [];
        let fields = myFactory.objectSchema[sObjectName].fields; 
        angular.forEach(fields,function(field){
            if(field[propName] != undefined)
                result.push(field[propName]);
            else
                result.push(field);
        });
        return result;
    }
    factory.getObjectQuery = function(sObjectName, limitClause, objectFields){
        let query = 'SELECT ';
        //let fields = this.getObjectAllField(sObjectName,'apiName', objectFields); 
        angular.forEach(objectFields,function(field){
            query += field+',';
        });
        query = query.substring(0,query.length-1);
        query += ' FROM ' + sObjectName + ' ' + limitClause;
        return query;
    }
    factory.getRecords = function(query,onSuccess,onError){
        AngularAssignmentController.getRecords(query,function(result,response){
            if(response.status){
                onSuccess(result);
            }else{
                onError(response.status);
            }
        });
    }
    factory.deleteRecord = function(sObjectName, Id, onSuccess,onError) {
        AngularAssignmentController.deleteRecord(sObjectName, Id, function(result, response){
            if(response.status){
                onSuccess('Id',Id);
            }else{
                onError(response.message);
            }
        });
    }
    
    return factory;
});

myFactory.objectSchema = {
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
                label:'CleanStatus',
                apiName:'CleanStatus'
            },
            {
                label:'Owner',
                apiName:'Owner'
            },
            {
                label:'Department',
                apiName:'Department'
            },
            {
                label:'DoNotCall',
                apiName:'DoNotCall'
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
                label:'LeadSource',
                apiName:'LeadSource'
            },
            {
                label:'MailingAddress',
                apiName:'MailingAddress'
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
                label:'Owner',
                apiName:'Owner'
            },
            {
                label:'RecordType',
                apiName:'RecordType'
            },
            {
                label:'Site',
                apiName:'Site'
            },
            {
                label:'AccountSource',
                apiName:'AccountSource'
            },
            {
                label:'AnnualRevenue',
                apiName:'AnnualRevenue'
            },
            {
                label:'CleanStatus',
                apiName:'CleanStatus'
            },
            {
                label:'NumberOfEmployees',
                apiName:'NumberOfEmployees'
            },
            {
                label:'Industry',
                apiName:'Industry'
            },
            {
                label:'Ownership',
                apiName:'Ownership'
            },
            {
                label:'Phone',
                apiName:'Phone'
            },
            {
                label:'ShippingAddress',
                apiName:'ShippingAddress'
            },
            {
                label:'Type',
                apiName:'Type'
            }
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
                label:'Certification',
                apiName:'Certification_Required__c'
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
                label:'Qualifications',
                apiName:'Qualifications_Required__c'
            },
            {
                label:'Required Skills',
                apiName:'Required_Skills__c'
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
                label:'Full Name',
                apiName:'Full_Name__c'
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

