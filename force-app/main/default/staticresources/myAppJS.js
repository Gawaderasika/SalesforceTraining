var myApp = angular.module("myApp", ["myFactory","myList"]);
myApp.controller("myController", ['$scope','myFactory',function($scope,factory) {
    /*$scope.currentPage = 0;
    myapp.filter('displayPageData', function() {    
                return function(input, start) {    
                start = +start; //parse to int    
                return input.slice(start);    
    	}    
             }); */
    $scope.first = 1;
    $scope.last;
    $scope.start;
    $scope.end;
    $scope.IsVisible = true;
    $scope.objName;
    $scope.result = [];
    $scope.viewRecords = function(){
    	$scope.last;
    	$scope.start = $scope.first;
    	$scope.end = $scope.first+9;
    }
    $scope.selectButton = function(obj){
        $scope.objName = obj;
        $scope.fields = factory.getObjectAllField($scope.objName);
    	var query = factory.getObjectQuery($scope.objName,'LIMIT 10');
    	factory.getRecords(query,getRecordsSuccess,onError);
    }
   
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
        alert(message);
    }
}]);

