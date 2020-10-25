var myApp = angular.module("myApp", ["myFactory","myList"]);
         
myApp.controller("myController", ['$scope','myFactory',function($scope,factory) {
    $scope.result = [];
    
    $scope.fields = factory.getObjectAllField('contact');
    var query = factory.getObjectQuery('contact','LIMIT 5');
    factory.getRecords(query,getRecordsSuccess,onError);

    $scope.deleteRecord = function(sObjectName, Id, onSuccess,onError) {
        factory.deleteRecord(sObjectName, Id, removeRecord,onError);
    }
    removeRecord = function(key, value){
        let count;
        for( i= 0; i<$scope.result.length; i++){
            if($scope.result[i][key] == value){
                count = i;
                break;
            }
        }        
        $scope.result.splice(count,1);
        $scope.$apply();
        alert('record remove successfully');
    }
    
    function getRecordsSuccess(result){
        $scope.result = result;
        $scope.$apply();
    }
    
    function onError(message){
        alert('Error occured : '+message);
    }
}]);

