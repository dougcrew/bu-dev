trigger EventTrigger on Event(before insert, after insert) {
  EventTriggerHandler handler = new EventTriggerHandler();
  handler.run();

}
