var myFactory = angular.module("myFactory", []);
      
myFactory.factory("myFactory", function() {
    var factory = {};
    factory.getObjectAllField = function(sObjectName, propName){
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
    factory.getObjectQuery = function(sObjectName, limitClause){
        let query = 'SELECT ';
        let fields = this.getObjectAllField(sObjectName,'apiName'); 
        angular.forEach(fields,function(field){
            query += field + ',';
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
                label:'Department',
                apiName:'Department'
            },
            {
                label:'Phone',
                apiName:'Phone'
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
                label:'Phone',
                apiName:'Phone'
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
                label:'Description',
                apiName:'Description__c'
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
                label:'Full Name',
                apiName:'Full_Name__c'
            },
            {
                label:'Status',
                apiName:'Status__c'
            }
        ]
    }
};   

