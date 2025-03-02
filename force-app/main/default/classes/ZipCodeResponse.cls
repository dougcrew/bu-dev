public with sharing class ZipCodeResponse {
    public String state { get; set; }
    public String city { get; set; }
    public TimeZone timezone { get; set; }
    public Decimal lng { get; set; }
    public List<acceptable_city_names> acceptable_city_names { get; set; }
    public Decimal lat { get; set; }
    public List<String> area_codes { get; set; }
    public String zip_code { get; set; }
    
    public class TimeZone {
        public String timezone_abbr { get; set; }
        public String timezone_identifier { get; set; }
        public Integer utc_offset_sec { get; set; }
        public String is_dst { get; set; }
    }
    
    public class acceptable_city_names {
        public String city { get; set; }
        public String state { get; set; }
    }
}