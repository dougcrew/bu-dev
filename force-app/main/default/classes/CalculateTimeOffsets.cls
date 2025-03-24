public with sharing class CalculateTimeOffsets {
  public static void updateTimeOffsetFields(List<Contact> contactsToProcess) {
    List<Contact> contactsToUpdate = new List<Contact>();
    System.debug(
      'Number of contacts received for processing: ' + contactsToupdate.size()
    );

    for (Contact cont : contactsToProcess) {
      // if (cont.Timezone_Identifier__c = timeOffsets ) {

      switch on cont.Timezone_Identifier__c {
        when 'America/New_York' {
          cont.DST_Offset__c = 3;
          cont.Standard_Time_Offset__c = 2;
        }
        when 'America/Chicago' {
          cont.DST_Offset__c = 2;
          cont.Standard_Time_Offset__c = 1;
        }
        when 'America/Denver' {
          cont.DST_Offset__c = 1;
          cont.Standard_Time_Offset__c = 0;
        }
        when 'America/Phoenix' {
          cont.DST_Offset__c = 0;
          cont.Standard_Time_Offset__c = 0;
        }
        when 'America/Los_Angeles' {
          cont.DST_Offset__c = 0;
          cont.Standard_Time_Offset__c = -1;
        }
        when 'America/Anchorage' {
          cont.DST_Offset__c = -1;
          cont.Standard_Time_Offset__c = -2;
        }
        when 'Pacific/Honolulu' {
          cont.DST_Offset__c = -2;
          cont.Standard_Time_Offset__c = -3;
        }
        when else {
          System.debug(
            'Unknown timezone identifier: ' + cont.Timezone_Identifier__c
          );
        }
      }

      contactsToUpdate.add(cont);
    }

    if (!contactsToUpdate.isEmpty()) {
      try {
        update contactsToUpdate;
        System.debug(
          'Successfully updated ' + contactsToUpdate.size() + ' contacts'
        );
      } catch (Exception e) {
        System.debug('Error updating contacts: ' + e.getMessage());
      }
    } else {
      System.debug('No contacts to update');
    }
  }

  public static TimeZone getUserTimezone() {
    TimeZone userTimeZone = UserInfo.getTimeZone();
    return userTimeZone;
  }

  // public static void calculateEventTime() {

  // }
  // This is what I am attempting to use to find out if the scheduled event date is in dst or not
  public static Integer stdTimezoneOffset(Datetime dt) {
    // Get offset for January (winter) and July (summer) of the same year
    Integer year = dt.year();
    Datetime jan = Datetime.newInstance(year, 1, 1);
    Datetime jul = Datetime.newInstance(year, 7, 1);

    // Return the maximum offset (standard time)
    return Math.max(getTimezoneOffset(jan), getTimezoneOffset(jul));
  }

  public static Boolean isDstObserved(Datetime dt) {
    // If current offset is less than standard offset, we're in DST
    return getTimezoneOffset(dt) < stdTimezoneOffset(dt);
  }

  @InvocableMethod(
    label='Check If DST Is Observed'
    description='Determines if Daylight Saving Time is observed for the given datetime'
  )
  public static List<Boolean> isDstObservedInvocable(List<Datetime> datetimes) {
    List<Boolean> results = new List<Boolean>();
    for (Datetime dt : datetimes) {
      results.add(isDstObserved(dt));
    }
    return results;
  }

  private static Integer getTimezoneOffset(Datetime dt) {
    // Get timezone offset in milliseconds and cast to Integer
    Long offsetLong =
      dt.getTime() -
      DateTime.newInstanceGmt(
          dt.year(),
          dt.month(),
          dt.day(),
          dt.hour(),
          dt.minute(),
          dt.second()
        )
        .getTime();

    return Integer.valueOf(offsetLong);
  }
}
