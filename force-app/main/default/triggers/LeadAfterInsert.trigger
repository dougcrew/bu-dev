trigger LeadAfterInsert on Lead(after insert, after update) {
  LeadTriggerHandler handler = new LeadTriggerHandler();
  handler.run();
  System.debug('Lead Trigger fired');
  // for (Lead lead : Trigger.new) {
  //     if (lead != null && lead.isConverted == false) {
  //         LeadConversionHelper.convertLead(lead.Id);
  //     }
  // }
}
