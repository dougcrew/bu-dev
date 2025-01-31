public class LeadConversionInvocable {

    @InvocableMethod

    public static void convertLead(List<Id> vLeadIds) {

        for (Id vLeadId : vLeadIds) {

            leadConversionHandler.enqueueLeadConversion(vLeadId);

        }

    }

}