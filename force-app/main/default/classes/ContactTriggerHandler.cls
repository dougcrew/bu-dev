public with sharing class ContactTriggerHandler extends TriggerHandler{

    private List<Contact> newContList;
    private List<Contact> oldContList;
    private Map<Id, Contact> newContMap;
    private Map<Id, Contact> oldContMap;

    public ContactTriggerHandler(){
        this.newContList = (List<Contact>) Trigger.new;
        this.newContMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldContList = (List<Contact>) Trigger.old;
        this.oldContMap = (Map<Id, Contact>) Trigger.oldMap;
    }

    public override void afterUpdate(){
        /* System.debug('ContactTriggerHandler.afterInsert called');
        System.debug('Contact Count: ' + this.newContList.size());*/
        Map<Id, String> contactZipMap = new Map<Id, String>();

        for (Contact cont : this.newContList) {
                if(Trigger.isUpdate && cont.Zip_Code__c != ((Contact)Trigger.oldMap.get(cont.Id)).Zip_Code__c) {
                    contactZipMap.put(cont.Id, cont.Zip_Code__c);
                }                   
            }
        if(!contactZipMap.isEmpty()) {
            ZipCodeService.updateContactTimezone(contactZipMap);
        }
    }
}