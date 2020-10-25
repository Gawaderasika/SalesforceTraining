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
    'contact' : {
        apiName : 'contact',
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
                label:'LastName',
                apiName:'lastname'
            }
        ]
    }
};   

