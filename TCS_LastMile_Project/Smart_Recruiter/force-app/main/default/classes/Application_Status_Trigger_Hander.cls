public class Application_Status_Trigger_Hander {

    // Method to create Task when Application status changes
    public static void createTaskOnStatusChange(List<Application__c> newApps, Map<Id, Application__c> oldMap) {

        List<Task> tasksToCreate = new List<Task>();

        for (Application__c app : newApps) {

            // Compare old vs new status to detect change
            Application__c oldApp = oldMap.get(app.Id);

            if (oldApp.Applicant_Status__c!= app.Applicant_Status__c && app.Applicant_Status__c== 'shortlisted'  && app.Assigned_User__c != null) {

                Task t = new Task();
                t.Subject = 'Follow up on shortlisted Application';
                t.WhatId = app.Id; // Related to Application
                t.OwnerId = app.Assigned_User__c; // Assign to recruiter (replace with your field API name)
                t.Status = 'Not Started';
                t.Priority = 'High';
                t.Description = 'The application has been approved. Follow up with the candidate.';
                tasksToCreate.add(t);
            }
        }

        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}