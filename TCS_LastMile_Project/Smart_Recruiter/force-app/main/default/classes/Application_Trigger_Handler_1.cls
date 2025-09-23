public class Application_Trigger_Handler_1 {
      
   

    // Method to create Applications from Contacts who applied
    public static void createApplicationsFromContacts(List<Contact> newContacts) {

        List<Application__c> appsToCreate = new List<Application__c>();

        //: Loop through Contacts
        for (Contact c : newContacts) {
            // Only create Application if Job_Posting__c is filled
            if (c.Job_Opening__c != null) {

                // : Prevent duplicate Application for same Contact + Job
                List<Application__c> existingApps = [
                    SELECT Id FROM Application__c 
                    WHERE Contact__c = :c.Id 
                    AND	Job__c = :c.Job_Opening__c
                ];
                if (existingApps.isEmpty()) {
                    Application__c app = new Application__c();
                    app.Contact__c = c.Id;
                    app.Job__c = c.Job_Opening__c;
                    app.Applicant_Status__c = 'Applied'; 
                    appsToCreate.add(app);
                }
            }
        }

        //  Insert Applications
        if (!appsToCreate.isEmpty()) {
            insert appsToCreate;
        }
    }
}