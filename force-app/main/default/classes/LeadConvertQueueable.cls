public class LeadConvertQueueable implements Queueable, Database.AllowsCallouts {

    private Id vLeadId;

    public leadConvertQueueable(Id leadId) {

        this.vLeadId = leadId;

    }

    public void execute(QueueableContext context) {
        
        try {

            Lead vLeadToConvert = [SELECT Id FROM Lead WHERE Id = :vLeadId AND IsConverted = false LIMIT 1];

            LeadStatus vConvertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

            Database.LeadConvert lc = new Database.LeadConvert();

            lc.setLeadId(vLeadToConvert.Id);

            lc.setConvertedStatus(vConvertStatus.MasterLabel);

            lc.setDoNotCreateOpportunity(false); // Set to false if Opportunity creation is needed

            Database.LeadConvertResult result = Database.convertLead(lc);

            if (!result.isSuccess()) {

                System.debug('Lead conversion failed: ' + result.getErrors()[0].getMessage());

            }

        } catch (Exception e) {

            System.debug('Lead conversion error: ' + e.getMessage());

        }

    }

}