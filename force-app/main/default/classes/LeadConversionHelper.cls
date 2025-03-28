public without sharing class LeadConversionHelper {
  public static void convertLead(Id leadId) {
    // Fetch the lead to convert, including fields required for Opportunity Name customization
    List<Lead> leadsToConvert = [
      SELECT
        Id,
        FirstName,
        LastName,
        Campus_of_Interest__c,
        Program_of_Interest__c
      FROM Lead
      WHERE Id = :leadId AND ConvertedContactId = NULL
    ];

    if (leadsToConvert.size() > 0) {
      Lead leadToConvert = leadsToConvert[0];

      try {
        // populateLookupFields(new List<Lead>{leadToConvert});
        update LeadToConvert;
      } catch (Exception e) {
        System.debug(
          'Warning: Errorr udpating lead with lookup values: ' + e.getMessage()
        );
      }
      // Prepare LeadConvert object for the conversion
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadToConvert.Id);
      lc.setDoNotCreateOpportunity(false); // Ensure an Opportunity is created

      /* Generate the custom Opportunity Name
        String opportunityName = leadToConvert.FirstName +' '+ leadToConvert.LastName + ' | ' + leadToConvert.Program_of_Interest__c;
        lc.setOpportunityName(opportunityName); // Set the custom Opportunity Name */

      // Set the converted status (adjust based on your organization’s settings)
      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      // Perform the lead conversion
      try {
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        if (lcr.isSuccess()) {
          System.debug('Lead conversion succeeded');
        }
      } catch (Exception e) {
        System.debug('Lead conversion failed: ' + e.getMessage());
      }
    } else {
      System.debug('Lead already converted or does not exist.');
    }
  }

  // private static void populateLookupFields(List<Lead> leads) {
  //     // get picklist values by looping and adding to Set
  //     Set<String>campusValues = new Set<String>();
  //     Set<String>programValues = new Set<String>();

  //     for (Lead lead : leads) {
  //         if(String.isNotBlank(lead.Campus_of_Interest__c)){
  //             campusValues.add(lead.Campus_of_Interest__c);
  //         }

  //         if(String.isNotBlank(lead.Program_of_Interest__c)){
  //             programValues.add(lead.Program_of_Interest__c);
  //         }

  //     }
  //     // create Map to for lookup fields
  //     // query Program and Campus that match picklist values
  //     Map<String, Id>campusToId = new Map<String, Id>();
  //     for (Account campus : [SELECT Name, Id
  //                             FROM Account
  //                             WHERE Name IN : campusValues
  //                             AND RecordType.Name = 'Campus']) {
  //         campusToId.put(campus.Name, campus.Id);
  //         }

  //     Map<String, Id>programToId = new Map<String, Id>();
  //     for (Program__c prog : [SELECT Name, Id
  //                         FROM Program__c
  //                         WHERE Name IN :programValues]) {
  //         programToId.put(prog.Name, prog.Id);
  //         }

  //      // Update lookup fields
  //      for (Lead lead : leads) {
  //         if(String.isNotBlank(lead.Campus_of_Interest__c) && campusToId.containsKey(lead.Campus_of_Interest__c)) {
  //             lead.Campus__c = campusToId.get(lead.Campus_of_Interest__c);
  //         }

  //         if(String.isNotBlank(lead.Program_of_Interest__c) && campusToId.containsKey(lead.Program_of_Interest__c)) {
  //             lead.Program__c = programToId.get(lead.Program_Of_Interest__c);
  //         }
  //     }
  // }
}
