public class Application_Validation_Handler {

    public static void preventDuplicateApplications(List<Application__c> newApps) {

        // Collect Contact Ids and Job Ids from new applications
        Set<Id> contactIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        for (Application__c app : newApps) {
            if (app.Contact__c != null && app.Job__c != null) {
                contactIds.add(app.Contact__c);
                jobIds.add(app.Job__c);
            }
        }

        // Query existing Applications with Pending Interviews
        List<Application__c> existingApps = [
            SELECT Id, Contact__c, Job__c
            FROM Application__c
            WHERE Contact__c IN :contactIds
            AND Job__c IN :jobIds
            AND Applicant_Status__c != 'Rejected'  // pending or approved
        ];

        // Create a map for fast lookup
        Map<String, Application__c> comboMap = new Map<String, Application__c>();
        for (Application__c app : existingApps) {
            String key = app.Contact__c + '-' + app.Job__c;
            comboMap.put(key, app);
        }

        // Loop through new records and prevent insert
        for (Application__c app : newApps) {
            String key = app.Contact__c + '-' + app.Job__c;
            if (comboMap.containsKey(key)) {
                app.addError('Candidate already has an Application for this Job or has a pending interview.');
            }
        }
    }
}