public with sharing class CalculateTimeOffsets {
  public static void updateTimeOffsetFields(List<Contact> contactsToProcess) {
    List<Contact> contactsToUpdate = new List<Contact>();
    System.debug(
      'Number of contacts received for processing: ' + contactsToProcess.size()
    );
    for (Contact cont : contactsToProcess) {
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
      }

      if (cont.Timezone_Identifier__c != null) {
        cont.Update_Offset_Fields_Now__c = false;
        contactsToUpdate.add(cont);
      }
    }

    if (!contactsToUpdate.isEmpty()) {
      update contactsToUpdate;
    }
  }

  public static TimeZone getUserTimezone() {
    TimeZone userTimeZone = UserInfo.getTimeZone();
    return userTimeZone;
  }

  // public static void calculateEventTime() {

  // }
  // This is what I am attempting to use to find out if the scheduled event date is in dst or not
  public static Date stdTimezoneOffset(Datetime datetime) {
    Date jan = new Date(Year(DATEVALUE(this.datetime)));
    Date jul = new Date(Year(DATEVALUE(this.datetime)));
    return Math.max(jan.getOffset(), jul.getOffset());
  }

  public static Boolean isDstObserved() {
    return this.getOffset() < this.stdTimezoneOffset();
  }

  public static Datetime getTimezonOffset() {
    // This is a JavaScript function I got from Stack Overflow
    // Date.prototype.stdTimezoneOffset = function () {
    //     var jan = new Date(this.getFullYear(), 0, 1);
    //     var jul = new Date(this.getFullYear(), 6, 1);
    //     Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
    // }

    // Date.prototype.isDstObserved = function () {
    //     return this.getTimezoneOffset() < this.stdTimezoneOffset();
    // }

    // var today = new Date();
    // if (today.isDstObserved()) {
    //     alert ("Daylight saving time!");
    // }
  }
}
