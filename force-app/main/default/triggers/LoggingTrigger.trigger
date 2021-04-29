trigger LoggingTrigger on Logging__e (after insert) {
List<Log__c> logs = new List<Log__c>();  
    
    for (Logging__e event : Trigger.New) {              
            Log__c log = new Log__c();
            log.Logging_level__c = event.LogLevel__c;
            log.Message__c = event.Message__c;
            //log.Context_Id__c = event.Record__c;
            log.Context_Id__c = event.Context_Id__c;
            log.User_Name__c = event.User_name__c;
            log.Stack_trace_String__c = event.Stack_trace_String__c;
            log.Context_Name__c = event.Context_Name__c;
            logs.add(log);
        }
   insert logs;
    
}