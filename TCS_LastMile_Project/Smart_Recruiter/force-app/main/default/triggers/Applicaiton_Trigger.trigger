trigger Applicaiton_Trigger on Application__c (before insert) {
      if (Trigger.isBefore && Trigger.isInsert) {
        Application_Trigger_Handler.preventDuplicateApplications(Trigger.new);
    }
}