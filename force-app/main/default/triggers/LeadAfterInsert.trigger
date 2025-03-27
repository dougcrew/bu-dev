trigger LeadAfterInsert on Lead(
  before insert,
  after insert,
  before update,
  after update
) {
  // LeadTriggerHandler handler = new LeadTriggerHandler();
  // handler.run();

  // If (trigger.isUpdate && Lead.IsConverted && !trigger.oldmap.get(lead.id).IsConverted){
  //   LeadTriggerHandler.afterUpdate(Trigger.new);

  if (Trigger.isAfter && Trigger.isInsert) {
    for (Lead lead : Trigger.new) {
      if (lead != null && lead.isConverted == false) {
        LeadConversionHelper.convertLead(lead.Id);
      }
    }
  }

  if (Trigger.isAfter && Trigger.isUpdate) {
    LeadTriggerHandler.getAccsForTimezoneUpdates(Trigger.new);
  }

}
