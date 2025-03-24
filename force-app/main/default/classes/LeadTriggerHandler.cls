public with sharing class LeadTriggerHandler extends TriggerHandler {
  private List<Lead> newLeadList;
  private List<Lead> oldLeadList;
  private Map<Id, Lead> newLeadMap;
  private Map<Id, Lead> oldLeadMap;

  public LeadTriggerHandler() {
    this.newLeadList = (List<Lead>) Trigger.new;
    this.newLeadMap = (Map<Id, Lead>) Trigger.newMap;
    this.oldLeadList = (List<Lead>) Trigger.old;
    this.oldLeadMap = (Map<Id, Lead>) Trigger.oldMap;
  }

  public override void afterInsert() {
    for (Lead lead : newLeadList) {
      if (lead != null && lead.isConverted == false) {
        LeadConversionHelper.convertLead(lead.Id);
      }
    }
  }

  public override void afterUpdate() {
    Set<Id> convertedAccountIds = new Set<Id>();

    for (Lead l : newLeadList) {
      if (l.convertedAccountId != null) {
        convertedAccountIds.add(l.convertedAccountId);
      }
    }

    List<Account> accounts = [
      SELECT Id, Name
      FROM Account
      WHERE Id IN :convertedAccountIds
    ];
    Map<Id, Account> accountMap = new Map<Id, Account>(accounts);

    List<Account> updateAccounts = new List<Account>();

    for (Lead newLead : newLeadList) {
      Lead oldLead = oldLeadMap.get(newLead.Id);
      if (!oldLead.IsConverted && newLead.isConverted) {
        Account account = accountMap.get(newLead.convertedAccountId);
        updateAccounts.add(account);
      }
    }
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    List<Contact> contactsToUpdate = new List<Contact>();
    for (Account acc : updateAccounts) {
      Contact contId = acc.PersonContactId;

      contactMap.put(contId);
    }
    if (!contactsToUpdate.isEmpty()) {
      CalculateTimeOffsets.updateTimeOffsetFields(contactsToUpdate);
    }
  }
}
