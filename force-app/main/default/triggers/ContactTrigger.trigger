trigger ContactTrigger on Contact(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  ContactTriggerHandler handler = new ContactTriggerHandler();
  handler.run();
  // if (trigger.isAfter) {
  //         if (trigger.isUpdate) {

  //         List<Contact> contactsToProcess = new List<Contact>();
  //         System.debug('Trigger fired - isAfter: ' + trigger.isAfter + ', isUpdate: ' + trigger.isUpdate);
  // System.debug('Number of contacts in trigger.new: ' + trigger.new.size());

  //       for(Contact cont : trigger.new) {
  //         if(cont.Update_Offset_Fields_Now__c){
  //           contactsToProcess.add(cont);
  //         }
  //         System.debug('Number of contacts to process: ' + contactsToProcess.size());
  //       } if(!contactsToProcess.isEmpty()) {
  //         CalculateTimeOffsets.updateTZOffsetFields(contactsToProcess);
  //     }
  //         }
  // }
}
