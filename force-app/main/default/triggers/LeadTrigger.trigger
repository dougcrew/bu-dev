trigger LeadTrigger on Lead(
  before insert,
  after insert,
  before update,
  after update
) {
  System.debug('Lead Trigger: ' + Trigger.operationType);
  LeadTriggerHandler handler = new LeadTriggerHandler();
  handler.run();

  // If (trigger.isUpdate && Lead.IsConverted && !trigger.oldmap.get(lead.id).IsConverted){
  //   LeadTriggerHandler.afterUpdate(Trigger.new);

  // if (Trigger.isAfter && Trigger.isInsert) {
  //   for (Lead lead : Trigger.new) {
  //     if (lead != null && lead.isConverted == false) {
  //       LeadConversionHelper.convertLead(lead.Id);
  //     }
  //   }
  // }

  // if (Trigger.isAfter && Trigger.isUpdate) {
  //   LeadTriggerHandler.getAccsForTimezoneUpdates(Trigger.new);
  // }

}
