trigger ContactTrigger on Contact(before insert, after insert, 
before update, after update, 
before delete, after delete, 
after undelete) {
        // switch on Trigger.operationType {
        //         when BEFORE_INSERT, BEFORE_UPDATE {
        //             // call your before handler
        //         }
        //         when AFTER_INSERT {
        //             ContactTriggerHandler.afterInsert();
        //         }
        //         when else {
        //             // this shouldn't happen
        //         }
        //     }
       
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.run();
     

}