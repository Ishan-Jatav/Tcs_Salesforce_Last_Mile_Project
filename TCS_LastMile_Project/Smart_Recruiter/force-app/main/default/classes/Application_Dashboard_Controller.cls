public with sharing class Application_Dashboard_Controller {
     @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getApplicationsByStatus() {
        Map<String, Integer> statusCount = new Map<String, Integer>();

        // Query applications and group by status
        for (AggregateResult ar : [
            SELECT Applicant_Status__c status, COUNT(Id) cnt
            FROM Application__c
            GROUP BY Applicant_Status__c
        ]) {
            statusCount.put((String)ar.get('status'), (Integer)ar.get('cnt'));
        }

        return statusCount;
    }
}