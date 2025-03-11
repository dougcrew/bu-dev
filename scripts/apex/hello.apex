List<Contact> contactsToProcess = [SELECT Id, LastName, Zip_Code__c, Standard_Time_Offset__c, DST_Offset__c, Timezone_Identifier__c FROM Contact WHERE LastName = 'Morrison'];
System.debug('List of Contacts::::' + contactsToProcess);

CalculateTimeOffsets.updateTimeOffsetFields(contactsToProcess);

Contact updatedCont = [SELECT Id, Zip_Code__c, Standard_Time_Offset__c, DST_Offset__c, Timezone_Identifier__c FROM Contact WHERE LastName = 'triggertest'];

System.debug('Updated Fields:::: ' + updatedCont.Standard_Time_Offset__c + ' & ' + updatedCont.DST_Offset__c);