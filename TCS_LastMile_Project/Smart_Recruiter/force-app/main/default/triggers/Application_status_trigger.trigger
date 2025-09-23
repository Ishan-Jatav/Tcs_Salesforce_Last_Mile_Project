trigger Application_status_trigger on Application__c (after update) {

    // Call handler method, pass Trigger.new and Trigger.oldMap
   Application_Status_Trigger_Hander.createTaskOnStatusChange(Trigger.new, Trigger.oldMap);
}