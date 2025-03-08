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
      String startDateTimeAssigneeTZ = Evt.StartDateTime.format( 'yyyy-MM-dd HH:mm:ss', assignedUser.TimeZoneSidKey );
    }
}