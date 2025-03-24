trigger LeadAfterInsert on Lead(after insert, after update) {
  ContactTriggerHandler handler = new ContactTriggerHandler();
  handler.run();

  // for (Lead lead : Trigger.new) {
  //     if (lead != null && lead.isConverted == false) {
  //         LeadConversionHelper.convertLead(lead.Id);
  //     }
  // }

}
