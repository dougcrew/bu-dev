trigger LeadAfterInsert on Lead (after insert) {
    for (Lead lead : Trigger.new) {
        if (lead != null && lead.isConverted == false) {
            LeadConversionHelper.convertLead(lead.Id);
        }
    }
}