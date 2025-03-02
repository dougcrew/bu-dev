public with sharing class GetContactTimeZoneQueueable implements Queueable, Database.AllowCallouts {
    private List<Contact> contactsToProcess;
    private Integer currentIndex = 0;
    private List<Contact> contactsToUpdate = new List<Contact>();
    
    public GetContactTimeZoneQueueable(List<Contact> contacts) {
        this.contactsToProcess = contacts;
    }

    public GetContactTimeZoneQueueable(List<Contact> contacts, Integer startIndex, List<Contact> updatedContacts) {
        this.contactId = contId;
        this.zipCode = zipCode;
        this.remainingContacts = contactsToProcess;
    }

    public static void enqueueJob(){
        List<Contact> contactList = new List<Contact>([SELECT Id, Zip_Code__c 
                                                        FROM Contact 
                                                        WHERE Timezone_Identifier__c = null 
                                                        AND Zip_Code__c != null
                                                        LIMIT 100]);
        if ( !contactList.isEmpty()) {
            System.enqueueJob(new GetContactTimeZoneQueueable(conatctList));

            List<Contact> remainingContacts = contactList.isEmpty() ? null : contactList;

        }
    }

    public void execute(QueueableContext context) {

        Integer maxCallouts = 10;
        Integer endIndex = Math.min(currentIndex + maxCallouts, contactsToProcess.size());

            try {
                for (Integer i = currentIndex; i < endIndex; i++) {
                    Contact currentContact = contactsToProcess[i];
                    try {

                        ZipCodeResponse zipInfo = ZipCodeService.getTerritoryDetail(currentContact.Zip_Code__c);
                    }
                }
                ZipCodeService.updateContactTimezone(contactId, zipCode);

                if (zipInfo != null && zipInfor.timezone != null) {
                    currentContact.Timezone_Abbr__c = zipInfo.timezone.timezone_abbr;
                        currentContact.Timezone_Identifier__c = zipInfo.timezone.timezone_identifier;
                        currentContact.UTC_Offset_seconds__c = zipInfo.timezone.utc_offset_sec;
                        currentContact.Is_Daylight_Saving__c = zipInfo.timezone.is_dst;

                        contactsToUpdate.add(currentContact);
                }

            } catch (Exception e) {

                System.debug('Error processing contact: ' + currentContact.Id + ': ' + e.getMessage());

                // proceed with process even if this one fails
                if (!remainingContacts.isEmpty()) {
                    update contactsToUpdate;
                }

                if (endIndex < contactsToProcess.size()) {
                    System.enqueueJob(new GetContactTimeZoneQueueable(
                        contactsToProcess,
                        endIndex,
                        new List<Contact>()
                    ));
                }
            } catch (Exception e) {
                System.debug('General error in execute: ' + e.getMessage());

                if(!contactsToUpdate.isEmpty()) {
                    try {
                        update contactsToUpdate;
                    } catch (Exception updateEx) {
                        System.debug('Error updating contacts: ' + updateEx.getMessage());
                    }
                    
                }
            }
        } 
    }