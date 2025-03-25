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

  //   public override void afterInsert() {
  //     for (Lead lead : newLeadList) {
  //       if (lead != null && lead.isConverted == false) {
  //         LeadConversionHelper.convertLead(lead.Id);
  //       }
  //     }
  //   }

  public override void afterUpdate() {
    Set<Id> convertedAccountIds = new Set<Id>();

    for (Lead l : newLeadList) {
      if (l.convertedAccountId != null) {
        convertedAccountIds.add(l.convertedAccountId);
      }
    }

    if (convertedAccountIds.isEmpty()) {
      return;
    }

    List<Account> accounts = [
      SELECT Id, Name, Zip_Code__pc
      FROM Account
      WHERE Id IN :convertedAccountIds
    ];

    List<Account> accountsToUpdate = new List<Account>();

    for (Account acc : accounts) {
      if (acc.Zip_Code__pc != null) {
        ZipCodeService.getTimezoneDetail(acc.Zip_Code__pc);
      }
    }
  }
}
