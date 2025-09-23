public class Application_Trigger_Handler {

  public static void preventDuplicateApplications(List<Application__c> newApps) {
        
        //  Collect all Contact and Job Ids from the incoming records
        Set<Id> contactIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();
        
        for (Application__c app : newApps) {
            if (app.Contact__c != null) {
                contactIds.add(app.Contact__c);
            }
            if (app.Job__c != null) {
                jobIds.add(app.Job__c);
            }
        }
        
        //  Query existing Applications with those with  Contact and Job combinations
        List<Application__c> existingApps = [
            SELECT Id, Contact__c, Job__c
            FROM Application__c
            WHERE Contact__c IN :contactIds
            AND Job__c IN :jobIds
        ];
        
        //  Build a set of existing keys (ContactId + JobId)
        Set<String> existingKeys = new Set<String>();
        for (Application__c app : existingApps) {
            existingKeys.add(app.Contact__c + '-' + app.Job__c);
        }
        
        //  Compare with new records → block duplicates
        for (Application__c app : newApps) {
            String key = app.Contact__c + '-' + app.Job__c;
            if (existingKeys.contains(key)) {
                app.addError('This candidate has already applied for this job posting.');
            }
        }
    }

}