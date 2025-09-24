public with sharing class AppicationInJobPosting {
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getApplicationsByJob(Id jobId) {
        return [
            SELECT Id, Name, Contact__r.Name, 	Applicant_Status__c s
            FROM Application__c 
            WHERE 	Job__c = :jobId
            ORDER BY CreatedDate DESC
        ];
    }
}