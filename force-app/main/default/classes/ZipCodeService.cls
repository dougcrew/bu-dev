public with sharing class ZipCodeService {
    
    public static final String API_KEY = 'OFjhte9Q89UxyHg9DSsqaRjyGGRoGZtmGE2Uic2KEPBOwUXRD8xIsUou0OVBhMwj';
    public static final String BASE_ENDPOINT = 'https://www.zipcodeapi.com/rest/{0}/info.json/{1}/radians';
    
    
    public static ZipCodeResponse getTerritoryDetail(string zipCode) {
        String responseBody = get(zipCode);
        if (responseBody != null) {
            // Replace "T" and "F" with true and false before deserializing
            responseBody = responseBody.replace('"is_dst":"T"', '"is_dst":true')
                                     .replace('"is_dst":"F"', '"is_dst":false');
            
            try {
                return (ZipCodeResponse) JSON.deserialize(responseBody, ZipCodeResponse.class);
            } catch(Exception e) {
                System.debug('Deserialization error: ' + e.getMessage());
                return null;
            }
        }          
        return null;  
    }

    private static String get(String zipCode) {
        System.debug('get method called with zipCode: ' + zipCode);
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String formattedEndpoint = String.format(
                BASE_ENDPOINT,
                new List<String>{API_KEY, zipCode}
            );
            
            System.debug('Calling API with endpoint: ' + formattedEndpoint);
            
            request.setEndPoint(formattedEndpoint);
            request.setMethod('GET');
            request.setTimeout(120000);
            
            System.debug('Sending HTTP request');
            HttpResponse response = http.send(request);
            System.debug('Response received with status code: ' + response.getStatusCode());
            
            if(response.getStatusCode() == 200) {
                String body = response.getBody();
                System.debug('Response body (first 200 chars): ' + body.substring(0, Math.min(body.length(), 200)));
                return body;
            } else {
                System.debug('API Error Status: ' + response.getStatusCode());
                System.debug('API Error Body: ' + response.getBody());
                return null;
            }
        } catch(Exception e) {
            System.debug('Exception in get method: ' + e.getMessage());
            System.debug('Exception Stack: ' + e.getStackTraceString());
            return null;
        }
    }

    // public static void updateContactTimezone (Map<Id, String> contactZipMap) {
    //     System.debug('updateContactTimezone called with ' + contactZipMap.size() + ' contacts');
    //     List<Contact> contactsToUpdate = new List<Contact>();

    //     for (Id contactId : contactZipMap.keySet()) {
    //         System.debug('Processing contact ID: ' + contactId);
    //         String zipCode = contactZipMap.get(contactId);
    //         System.debug('Contact zipCode: ' + zipCode);
    //         ZipCodeResponse zipInfo = getTerritoryDetail(zipCode);
    //         System.debug('zipInfo returned: ' + zipInfo);
    

    //         if (zipInfo != null && zipInfo.timezone != null) {
    //             Contact currentContact = new Contact(Id = contactId);
    //             currentContact.Timezone_Abbr__c = zipInfo.timezone.timezone_abbr;
    //             currentContact.Timezone_Identifier__c = zipInfo.timezone.timezone_identifier;
    //             currentContact.UTC_Offset_seconds__c = zipInfo.timezone.utc_offset_sec;
    //             currentContact.Is_Daylight_Saving__c = Boolean.valueOf(zipInfo.timezone.is_dst);
    //             // String isDstStr = (String)zipInfo.timezone.is_dst;
    //             // currentContact.Is_Daylight_Saving__c = isDstStr.equalsIgnoreCase('T');
                
    //             System.debug('contact to update: ' + currentContact.Timezone_Identifier__c);
    //             System.debug('Timezone values set: ' + 
    //                             'Abbr=' + currentContact.Timezone_Abbr__c + 
    //                             ', Identifier=' + currentContact.Timezone_Identifier__c + 
    //                             ', UTC Offset=' + currentContact.UTC_Offset_seconds__c + 
    //                             ', DST=' + currentContact.Is_Daylight_Saving__c);

    //             contactsToUpdate.add(currentContact);
    //         } 
    // }   if(!contactsToUpdate.isEmpty()) {
    //         update contactsToUpdate;
    //     }
    // }

    public static void updatePersonAccountTimezone(Map<Id, String> accountZipMap) {
        System.debug('updatePersonAccountTimezone called with ' + accountZipMap.size() + ' person accounts');
        
        Map<Id, Id> accountToContactMap = new Map<Id, Id>();
        for (Account acc : [SELECT Id, PersonContactId 
                            FROM Account 
                            WHERE Id IN :accountZipMap.keySet() 
                            AND IsPersonAccount = TRUE]) {
            if (acc.PersonContactId != null) {
                accountToContactMap.put(acc.Id, acc.PersonContactId);
            }
        }
        
        Map<Id, String> contactZipMap = new Map<Id, String>();
        for (Id accountId : accountZipMap.keySet()) {
            Id contactId = accountToContactMap.get(accountId);
            if (contactId != null) {
                contactZipMap.put(contactId, accountZipMap.get(accountId));
            }
        
        String zipCode = contactZipMap.get(contactId);
        ZipCodeResponse zipInfo = getTerritoryDetail(zipCode);
        
        if (!contactZipMap.isEmpty()) {
            if (zipInfo != null && zipInfo.timezone != null) {
                Contact currentContact = new Contact(Id = contactId);
                currentContact.Timezone_Abbr__c = zipInfo.timezone.timezone_abbr;
                currentContact.Timezone_Identifier__c = zipInfo.timezone.timezone_identifier;
                currentContact.UTC_Offset_seconds__c = zipInfo.timezone.utc_offset_sec;
                currentContact.Is_Daylight_Saving__c = Boolean.valueOf(zipInfo.timezone.is_dst);
            }
        }
    }
}

    @InvocableMethod(label='Update Contact Timezone from Zip Code'
                    description='Updates contact timezone field based zip code')
    public static void updateContactTimeZoneFromFlow(List<FlowInput> inputs) {
        System.debug('Invocable method called with inputs: ' + inputs.size());
        Map<Id, String> contactZipMap = new Map<Id, String>();
        Map<Id, String> personAccountMap = new Map<Id, String>();

        for (FlowInput input : inputs) {
            if (input.zipCode != null) {
                if (input.contactId != null) {
                contactZipMap.put(input.contactId, input.zipCode);
            } else if (input.accountId != null) {
                personAccountMap.put(input.accountId, input.zipCode);
                }
            }
        }

        if (!personAccountMap.isEmpty()) {
            updatePersonAccountTimeZone(personAccountMap);
        }
    }

    public class FlowInput {
        // @InvocableVariable(label='Contact ID' required=false)
        // public Id contactId;

        @InvocableVariable(label='Account ID (for Person Accounts)' required=false)
    public Id accountId;

        @InvocableVariable(label='Zip Code' required=true)
        public String zipCode;
    }


}