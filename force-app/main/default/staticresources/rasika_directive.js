var rasika_directive = angular.module("rasika_directive", []);

/*function ShowHide(){
    var checkBox = document.getElementById("field.label");
    var val = checkBox.value;
    if (checkBox.checked == true){
    alert(val);
    }
}*/
rasika_directive.directive("rasika_directive",function(){
    var directive = {};
    directive.restrict = 'E';   
    directive.scope = {
        sObjectName : "@",
        fields : "=",
        records : "=",
        deleteAction : "&"
    },
    directive.controller = function($scope){
        $scope.delete = function(recordId) {
            $scope.deleteAction({
                sObjectName : $scope.sObjectName,
                Id : recordId,
            });
        }
        
    $scope.IsVisible = true;
    $scope.ShowHide = function(){
        if($scope.IsVisible == true){
            $scope.IsVisible = false;
        }
        else{
            $scope.IsVisible = true;
        }
    }
    }
    directive.template = 
    `
        <div ng-repeat = "field in fields">
        	{{field.label}}<input type = "checkbox" ng-model = "field.record" />
    	</div>
    	<input type = "checkbox"/>
     	<table class="my-list-border">
        	<tr>
            	<th ng-repeat = "field in fields" class="my-list-border" ng-hide = "field.record">
                {{field.label}}
            	</th>
        	</tr>
        	<tr ng-repeat = "record in records">
            	<td ng-repeat="field in record" class="my-list-border"  ng-hide = "record.field">{{field}}</td>
            	<td><button ng-click="delete(record.Id)">Delete</button></td>
        	</tr>   
     	</table>
    `;
    return directive;
});
