@IsTest
public class ATS_TestClass {

    // Utility method to create a Contact
    private static Contact createContact() {
        Contact c = new Contact(
            LastName = 'Test Candidate',
            Email = 'testcandidate@example.com'
        );
        insert c;
        return c;
    }

    // Utility method to create a Job Posting
    private static Job_Opening__c createJobPosting() {
        Job_Opening__c job = new Job_Opening__c(
            Name = 'Software Engineer'
        );
        insert job;
        return job;
    }

    // Utility method to create an Application
    private static Application__c createApplication(Id contactId, Id jobId, String statusVal) {
        Application__c app = new Application__c(
            Contact__c = contactId,
            Job__c = jobId,
           Applicant_Status__c = statusVal
        );
        insert app;
        return app;
    }

    // Utility method to create Applicant Info + Interview
    private static Interview__c createInterview(Id appInfoId, Datetime slotTime) {
        Interview__c interview = new Interview__c(
            Applicant_Information__c = appInfoId,
            Interview_Date_Time__c = slotTime
        );
        insert interview;
        return interview;
    }

    // ----------------------------
    // TEST CASES
    // ----------------------------

    @IsTest
    static void testDuplicateApplicationPrevention() {
        Contact c = createContact();
        Job_Opening__c job = createJobPosting();

        // Insert first application
        Application__c app1 = createApplication(c.Id, job.Id, 'Applied');

        // Try inserting duplicate application
        Application__c app2 = new Application__c(
            Contact__c = c.Id,
            Job__c = job.Id,
           Applicant_Status__c= 'Applied'
        );

        Test.startTest();
        try {
            insert app2;
            System.assert(false, 'Duplicate should not be inserted');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('duplicate'), 'Should block duplicate application');
        }
        Test.stopTest();
    }

    @IsTest
    static void testTaskCreationOnApprovedApplication() {
        Contact c = createContact();
        Job_Opening__c job = createJobPosting();

        Application__c app = createApplication(c.Id, job.Id, 'Applied');

        Test.startTest();
        app.Applicant_Status__c = 'Approved';
        update app;
        Test.stopTest();

        // Check Task created
        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :app.Id];
        System.assertEquals(1, tasks.size(), 'Task should be created when Application is Approved');
        System.assertEquals('Application Approved Notification', tasks[0].Subject, 'Task subject should match');
    }

    @IsTest
    static void testInterviewValidation_NoOverlap() {
        Contact c = createContact();
        Job_Opening__c job = createJobPosting();
        Application__c app = createApplication(c.Id, job.Id, 'Applied');

        // First interview slot
        Interview__c int1 = createInterview(app.Id, Datetime.now().addDays(1));

        // Overlapping interview slot
        Interview__c int2 = new Interview__c(
            Applicant_Information__c = app.Id,
            Interview_Date_Time__c = int1.Interview_Date_Time__c // same time
        );

        Test.startTest();
        try {
            insert int2;
            System.assert(false, 'Should not allow overlapping interviews');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('overlap'), 'Should block overlapping interview creation');
        }
        Test.stopTest();
    }
}