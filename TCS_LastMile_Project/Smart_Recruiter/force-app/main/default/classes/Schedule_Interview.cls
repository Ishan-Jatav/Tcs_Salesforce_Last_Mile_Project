public with sharing class Schedule_Interview {
    @AuraEnabled
    public static void scheduleInterview(Id candidateId, Id jobId, Datetime interviewDate) {
        Interview__c interview = new Interview__c(
            Applicant_Information__c = candidateId,
            Applied_Job_Info__c = jobId,
            Interview_Date_Time__c = interviewDate
        );
        insert interview;
    }

    @AuraEnabled(cacheable=true)
    public static List<Job_Opening__c> getOpenJobs() {
        return [SELECT Id, Name FROM  Job_Opening__c WHERE Job_Posting_status__c = 'Active'];
    }

    @AuraEnabled(cacheable=true)
    public static List<Application__c> getCandidates() {
        return [SELECT Id, Name FROM Application__c];
    }
}