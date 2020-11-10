@isTest  
private class MetadataServiceTest
{    
 
	@IsTest
    private static void coverGeneratedCodeTypes()
    {    	       
        // Reference types
        Test.startTest();
        new MetadataService();
         
        new MetadataService.WebLink();
        new MetadataService.CallOptions_element();
        new MetadataService.RecordTypePicklistValue();
        new MetadataService.ListViewFilter();
        new MetadataService.CustomField();
        new MetadataService.ListView();
        new MetadataService.FieldSet();
        new MetadataService.ValidationRule();
        new MetadataService.MetadataWithContent();
        new MetadataService.Metadata();
        new MetadataService.SessionHeader_element();
        new MetadataService.ActionOverride();
        new MetadataService.CustomObject();
        new MetadataService.PicklistValue();
        new MetadataService.ArticleTypeTemplate();
        new MetadataService.SharingRecalculation();
        new MetadataService.SharingReason();
        new MetadataService.FieldSetItem();
        new MetadataService.DebuggingInfo_element();
        new MetadataService.SearchLayouts();
        new MetadataService.StaticResource();	
        new MetadataService.deleteMetadataResponse_element();
        new MetadataService.Error();
        new MetadataService.SaveResult();
        new MetadataService.deleteMetadata_element();
        new MetadataService.createMetadata_element();
        new MetadataService.CompactLayout();
        new MetadataService.DeleteResult();
        new MetadataService.upsertMetadata_element();
        new MetadataService.upsertMetadataResponse_element();
        new MetadataService.GlobalPicklistValue();
        new MetadataService.PicklistValue();
        new MetadataService.ValueSetValuesDefinition();
        new MetadataService.ValueSet();
        new MetadataService.ValueSettings();
      
        Test.stopTest();
        
      String JobId =  MetadataService.checkTestrunning();
        System.assert(JobId !=null);
    }


  
}