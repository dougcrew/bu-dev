public with sharing class ContactTriggerHandler extends TriggerHandler {
  private List<Contact> newContList;
  private List<Contact> oldContList;
  private Map<Id, Contact> newContMap;
  private Map<Id, Contact> oldContMap;

  public ContactTriggerHandler() {
    this.newContList = (List<Contact>) Trigger.new;
    this.newContMap = (Map<Id, Contact>) Trigger.newMap;
    this.oldContList = (List<Contact>) Trigger.old;
    this.oldContMap = (Map<Id, Contact>) Trigger.oldMap;
  }

  public override void afterUpdate() {
    List<Contact> contactsToProcess = new List<Contact>();

    for (Contact cont : newContList) {
      Contact oldCont = oldContMap.get(cont.Id);
      if (
        oldCont != null &&
        oldCont.Update_Offset_Fields_Now__c != cont.Update_Offset_Fields_Now__c
      ) {
        contactsToProcess.add(cont);
      }
    }
    if (!contactsToProcess.isEmpty()) {
      CalculateTimeOffsets.updateTimeOffsetFields(contactsToProcess);
    }
  }
}
