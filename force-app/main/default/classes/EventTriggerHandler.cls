public with sharing class EventTriggerHandler extends TriggerHandler {
  private List<Event> newEventList;
  private List<Event> oldEventList;
  private Map<Id, Event> newEventMap;
  private Map<Id, Event> oldEventMap;

  public EventTriggerHandler() {
    this.newEventList = (List<Event>) Trigger.new;
    this.newEventMap = (Map<Id, Event>) Trigger.newMap;
    this.oldEventList = (List<Event>) Trigger.old;
    this.oldEventMap = (Map<Id, Event>) Trigger.oldMap;
  }

  //   public override void afterUpdate() {
  //     Map<DateTime, Boolean> dstStatusMap = new Map<DateTime, Boolean>();
  //     Set<DateTime> uniqueStartTimes = new Set<DateTime>();

  //     // Collect all unique start times
  //     for (Event ev : newEventList) {
  //         if (ev.WhoId != null && ev.StartDateTime != null) {
  //             uniqueStartTimes.add(ev.StartDateTime);
  //         }
  //     }

  //     // Calculate DST status once per unique datetime
  //     for (DateTime dt : uniqueStartTimes) {
  //         dstStatusMap.put(dt, CalculateTimeOffsets.isDstObserved(dt));
  //     }

  //     // Process events using the pre-calculated map
  //     for (Event ev : newEventList) {
  //         if (ev.WhoId != null && ev.StartDateTime != null) {
  //             Boolean isDuringDst = dstStatusMap.get(ev.StartDateTime);

  //             // Use the isDuringDst value for your timezone calculations
  //             // ...
  //             }
  //         }
  //     }
}
