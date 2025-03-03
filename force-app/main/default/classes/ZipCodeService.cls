public with sharing class ZipCodeService {
    
    public static final String API_KEY = 'OFjhte9Q89UxyHg9DSsqaRjyGGRoGZtmGE2Uic2KEPBOwUXRD8xIsUou0OVBhMwj';
    public static final String BASE_ENDPOINT = 'https://www.zipcodeapi.com/rest/OFjhte9Q89UxyHg9DSsqaRjyGGRoGZtmGE2Uic2KEPBOwUXRD8xIsUou0OVBhMwj/info.json/29566/radians';
    
    
    public static ZipCodeResponse getTerritoryDetail(string zipCode) {
            String responseBody = get(zipCode);
             if (responseBody != null) {
                return (ZipCodeResponse) JSON.deserialize(responseBody, ZipCodeResponse.class);
             }          
        return null;  
    }

    private static String get(String zipdCode) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        // endpoint = endpoint.replace('{apiKey}', apikey).replace('{zipCode}', zipCode);
        String formattedEndpoint = String.format(
            BASE_ENDPOINT,
            new List<String>{API_KEY, zipdCode}
        );

        request.setEndPoint(BASE_ENDPOINT);
        request.setMethod('GET');
        request.setTimeout(120000);

        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            System.debug('API Error: ' + response.getStatusCode() + ' - ' + response.getBody());
            return null;
        }
    }

    
    public static ZipCodeResponse updateContactTimezone (Map<Id, String> ContactZipMap) {
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Id contactId : ContactZipMap.keySet()) {
            String zipCode = contactZipMap.get(contactId);
            ZipCodeResponse zipInfo = (ZipCodeResponse)JSON.deserialize(get(zipCode), ZipCodeResponse.class); 
            return zipInfo; 
    
            if (zipInfo != null && zipInfo.timezone != null) {
                Contact currentContact = new Contact(Id = contactId);
                currentContact.Timezone_Abbr__c = zipInfo.timezone.timezone_abbr;
                currentContact.Timezone_Identifier__c = zipInfo.timezone.timezone_identifier;
                currentContact.UTC_Offset_seconds__c = zipInfo.timezone.utc_offset_sec;
                currentContact.Is_Daylight_Saving__c = zipInfo.timezone.is_dst;

                contactsToUpdate.add(currentContact); 
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    
    }
}