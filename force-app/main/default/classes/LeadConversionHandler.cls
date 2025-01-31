public class LeadConversionHandler {

    public static void enqueueLeadConversion(Id leadId) {

        leadConvertQueueable vLeadConvertJob = new leadConvertQueueable(leadId);

        System.enqueueJob(vLeadConvertJob);

    }

}