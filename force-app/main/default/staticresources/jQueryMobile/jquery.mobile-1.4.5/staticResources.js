function check(){
                    var First_Name__c=document.getElementById('{!$Component.First_Name__c}').value;
                    var Last_Name__c=document.getElementById('{!$Component.Last_Name__c}').value;
                    var Application_Date__c=document.getElementById('{!$Component.Application_Date__c}').value;
                    var Country__c=document.getElementById('{!$Component.Country__c}').value;
                    var DOB__c=document.getElementById('{!$Component.DOB__c}').value;
                    var Email__c=document.getElementById('{!$Component.Email__c}').value;
                    var Expected_Salary__c=document.getElementById('{!$Component.Expected_Salary__c}').value;
                    var Job_Rasika__c=document.getElementById('{!$Component.Job_Rasika__c}').value;
                    var Salutation__c=document.getElementById('{!$Component.Salutation__c}').value;
                    var State__c=document.getElementById('{!$Component.State__c}').value;
                    var Status__c=document.getElementById('{!$Component.Status__c}').value;
                    if(First_Name__c == "" || Last_Name__c == "" || Application_Date__c == "" || Country__c == "" || DOB__c == "" || 
                      Email__c == "" || Expected_Salary__c == "" || Job_Rasika__c == "" || Salutation__c == "" || State__c == "" || 
                      Status__c == "")
                    {
                        alert('Please fill all the fields');
                        //document.getElementById('{!$Component.theButton}').disabled = true;
                    }
                    else{
                        //document.getElementById('{!$Component.theButton}').disabled = false;
                    }
                }