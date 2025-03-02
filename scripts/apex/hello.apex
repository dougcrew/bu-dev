public class TimeZoneWrapper {
    public TimeZoneData timezone;
}
public with sharing class TimeZoneData {
    public String timezone_identifier;
}

String jsonResponse = '{"zip_code": "29566",' +
    '"lat": 33.873381,' +
    '"lng": -78.667107,' +
    '"city": "Little River",' +
    '"state": "SC",' +
    '"timezone": {' +
        '"timezone_identifier": "America/New_York",' +
        '"timezone_abbr": "EST",' +
        '"utc_offset_sec": -18000,' +
        '"is_dst": "F"' +
    '},' +
    '"acceptable_city_names": [],' +
    '"area_codes": [843]' +
'}';

// ZipCodeWrapper wrapper = ZipCodeWrapper.deserializeFromJson(jsonInput);
// String timezoneId = wrapper.getTimezoneId();
// Assuming your callout response is stored in a String variable called jsonResponse
TimeZoneWrapper wrapper = (TimeZoneWrapper)JSON.deserialize(jsonResponse, TimeZoneWrapper.class);
String timezoneId = wrapper.timezone.timezone_identifier;
System.debug('Timezone Id::: ' + timezoneId);