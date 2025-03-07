public with sharing class ZipCodeService {
    
    public static final String API_KEY = 'OFjhte9Q89UxyHg9DSsqaRjyGGRoGZtmGE2Uic2KEPBOwUXRD8xIsUou0OVBhMwj';
    public static final String BASE_ENDPOINT = 'https://www.zipcodeapi.com/rest/{0}/info.json/{1}/radians';
    
    public static ZipCodeResponse getTimezoneDetail(string zipCode) {
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
        
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String formattedEndpoint = String.format(
                BASE_ENDPOINT,
                new List<String>{API_KEY, zipCode}
            );
            
            request.setEndPoint(formattedEndpoint);
            request.setMethod('GET');
            request.setTimeout(120000);
            
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200) {
                String body = response.getBody();
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

    public static void updateContactTimezone(Map<Id, String> personAccZipMap) {
        System.debug('updatePersonAccountTimezone called with ' + personAccZipMap.size() + ' person accounts');
        
        Map<Id, String> contactZipMap = new Map<Id, String>();
        for (Contact cont : [SELECT Id, Zip_Code__c
                            FROM Contact 
                            WHERE Id IN :personAccZipMap.keySet()]) {
            if (cont.Id != null) {
                contactZipMap.put(cont.Id, cont.Zip_Code__c);
            } System.debug('contactZipMap: ' + contactZipMap);
        }
        
        for (Id contactId : contactZipMap.keySet()) {
            String zipCode = contactZipMap.get(contactId);
            ZipCodeResponse zipInfo = getTimezoneDetail(zipCode);
                
                if (zipInfo != null && zipInfo.timezone != null) {
                    Contact currentContact = new Contact(Id = contactId);
                    currentContact.Timezone_Abbr__c = zipInfo.timezone.timezone_abbr;
                    currentContact.Timezone_Identifier__c = zipInfo.timezone.timezone_identifier;
                    currentContact.UTC_Offset_seconds__c = zipInfo.timezone.utc_offset_sec;
                    currentContact.Is_Daylight_Saving__c = Boolean.valueOf(zipInfo.timezone.is_dst);
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
        if (!contactZipMap.isEmpty()) {
            updateContactTimeZone(personAccountMap);
        }

    }

    public class FlowInput {
        @InvocableVariable(label='Contact ID' required=false)
        public Id contactId;

        @InvocableVariable(label='Account ID (for Person Accounts)' required=false)
    public Id accountId;

        @InvocableVariable(label='Zip Code' required=true)
        public String zipCode;
    }
}

