trigger ContactTrigger on Contact(before insert, after insert, 
before update, after update, 
before delete, after delete, 
after undelete) {
       
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.run();
     

}