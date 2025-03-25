public with sharing class CalculateTimeOffsets {
  public static void updateTimeOffsetFields(List<Account> accountsToProcess) {
    List<Account> accountsToUpdate = new List<Account>();
    System.debug(
      'Number of contacts received for processing: ' + accountsToupdate.size()
    );

    for (Account acc : AccountsToProcess) {
      switch on acc.Timezone_Identifier__pc {
        when 'America/New_York' {
          acc.DST_Offset__pc = 3;
          acc.Standard_Time_Offset__pc = 2;
        }
        when 'America/Chicago' {
          acc.DST_Offset__pc = 2;
          acc.Standard_Time_Offset__pc = 1;
        }
        when 'America/Denver' {
          acc.DST_Offset__pc = 1;
          acc.Standard_Time_Offset__pc = 0;
        }
        when 'America/Phoenix' {
          acc.DST_Offset__pc = 0;
          acc.Standard_Time_Offset__pc = 0;
        }
        when 'America/Los_Angeles' {
          acc.DST_Offset__pc = 0;
          acc.Standard_Time_Offset__pc = -1;
        }
        when 'America/Anchorage' {
          acc.DST_Offset__pc = -1;
          acc.Standard_Time_Offset__pc = -2;
        }
        when 'Pacific/Honolulu' {
          acc.DST_Offset__pc = -2;
          acc.Standard_Time_Offset__pc = -3;
        }
        when else {
          System.debug(
            'Unknown timezone identifier: ' + acc.Timezone_Identifier__pc
          );
        }
      }

      accountsToUpdate.add(acc);
    }

    if (!accountsToUpdate.isEmpty()) {
      try {
        update accountsToUpdate;
        System.debug(
          'Successfully updated ' + accountsToUpdate.size() + ' accounts'
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
