public with sharing class ContactTriggerHandler extends TriggerHandler{

    private List<Contact> newContList;
    private List<Contact> oldContList;
    private Map<Id, Contact> newContMap;
    private Map<Id, Contact> oldContMap;

    public OpportunityTriggerHandler(){
        this.newContList = (List<Contact>) Trigger.new;
        this.newContMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldContList = (List<Contact>) Trigger.old;
        this.oldContMap = (Map<Id, Contact>) Trigger.oldMap;
    }

    public override void afterInsert(){
        List<Contact> contacts = new List<Contact>();

        for (Contact cont : this.newContList) {
            if(cont.Zip_Code__c != null){
                System.enqueueJob(new GetContactTimeZoneQueueable(cont.Id, cont.Zip_Code__c));
            }
        }
    }
}