trigger Contact_Trigger_1 on Contact (after insert, after update) {

    List<Contact> contactsWithJob = new List<Contact>();

    // Step 1: Loop through inserted/updated contacts
    for (Contact c : Trigger.new) {
        if (c.Job_Opening__c != null) { // replace with your actual field API name
            contactsWithJob.add(c);
        }
    }

    // Step 2: Call handler to create Applications
    if (!contactsWithJob.isEmpty()) {
        Application_Trigger_Handler_1.createApplicationsFromContacts(contactsWithJob);
    }
}