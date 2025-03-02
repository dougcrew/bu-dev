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

        request.setEndPoint(endpoint);
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

    
    public static void updateContactTimezone (Id contId, String zipCode) {
    ZipCodeResponse zipInfo = (ZipCodeResponse)JSON.deserialize(get(zipCode), ZipCodeResponse.class);
            
                    
    }
}