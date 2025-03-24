public with sharing class ContactTriggerHandler extends TriggerHandler {
  private List<Contact> newConList;
  private List<Contact> oldConList;
  private Map<Id, Contact> newConMap;
  private Map<Id, Contact> oldConMap;

  public ContactTriggerHandler() {
    this.newConList = (List<Contact>) Trigger.new;
    this.newConMap = (Map<Id, Contact>) Trigger.newMap;
    this.oldConList = (List<Contact>) Trigger.old;
    this.oldConMap = (Map<Id, Contact>) Trigger.oldMap;
  }

  public override void afterInsert() {
    Set<Id> newContactIds = new Set<Id>();
    for (Contact con : newConList) {
      newContactIds.add(con.Id);
    }

    Map<Id, Lead> leadsByContactId = new Map<Id, Lead>();
    for (Lead ld : [
      SELECT Id, ConvertedContactId
      FROM Lead
      WHERE ConvertedContactId IN :newContactIds
    ]) {
      leadsByContactId.put(ld.ConvertedContactId, ld);
    }

    List<Contact> contactsToProcess = new List<Contact>();
    for (Contact con : newConList) {
      if (leadsByContactId.containsKey(con.Id)) {
        Lead sourceLead = leadsByContactId.get(con.Id);
        contactsToProcess.add(con);
      }
    }
    if (!contactsToProcess.isEmpty()) {
      CalculateTimeOffsets.updateTimeOffsetFields(contactsToProcess);
    }
  }
}
