var myList = angular.module("myList", []);

/*function ShowHide(){
    var checkBox = document.getElementById("field.label");
    var val = checkBox.value;
    if (checkBox.checked == true){
    alert(val);
    }
}*/
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
        $scope.delete = function(recordId) {
            $scope.deleteAction({
                sObjectName : $scope.sObjectName,
                Id : recordId,
            });
        }
        
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
        	{{field.label}}<input type = "checkbox" ng-model = "field.apiname"/>
    	</div>
        <input type = "button" ng-click = "ShowHide()" value = "click"/>
     <table class="my-list-border">
        <tr>
            <th ng-repeat = "field in fields" class="my-list-border" ng-hide = "field.apiname">
                {{field.label}}
            </th>
        </tr>
        <tr ng-repeat = "record in records">
            <td ng-repeat="field in record" class="my-list-border">
                 <p ng-show = IsVisible>{{field}}<p>
            </td>
            <td><button ng-click="delete(record.Id)">Delete</button></td>
        </tr>   
     </table>
     
    `;
    return directive;
});
