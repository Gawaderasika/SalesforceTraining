var myList = angular.module("myList", []);
myList.directive("myList",function(){
    var directive = {};
    directive.restrict = 'E';   
    directive.scope = {
        sObjectName : "@",
        fields : "=",
        records : "=",
        deleteAction : "&"
    },
    directive.controller = function($scope){
    	$scope.nullVal = "NULL VALUE";
        $scope.start = 0;
        $scope.delete = function(recordId) {
            $scope.deleteAction({
                sObjectName : $scope.sObjectName,
                Id : recordId,
            });
        }
        $scope.previous = function(){
            if($scope.start != 0){
                $scope.start = $scope.start - 5;
            }
    	}
    	$scope.next = function(){
    		$scope.start = $scope.start + 5;
    	}
	}
    directive.template = 
    `
    	<div id = "divTable">
     		<table class="table table-bordered" id = "recordTable">
                <thead><tr class = "tableHeader">
            		<th ng-repeat = "field in fields" class="my-list-border" ng-show = "field.selected" class = "tHeader">
                		{{field.label}}
            		</th>
        		</tr></thead>
                 	<tr ng-repeat = "record in records" class = "tableRecords">
                 
                 {{i}}
        			
                 </tr>
     		</table>
     		<button class="button btnPrev" ng-click = "previous()">previous</button>
     		<button class="button btnNext" ng-click = "next()">next</button>
     	</div>
    `;
    return directive;
});
