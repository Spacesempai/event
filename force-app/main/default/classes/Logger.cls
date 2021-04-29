public with sharing class Logger {
    public  Logger() {

    }
    public void  log(String msg, String LogLevel) {
        Logging__e  logEvent = new Logging__e(
            LogLevel__c=LogLevel,
            Message__c= msg);
            Database.SaveResult sr = EventBus.publish(logEvent);
                 
    }
    public  void log(Database.BatchableContext context, VacancyBatch.CustomException ex, String LogLevel) {
        Logging__e  logEvent = new Logging__e(
            LogLevel__c =LogLevel,
            Message__c = ex.getMsg(),
            Record__c = ex.getRec(),
            User_Name__c = userinfo.getName(),
            Context_Id__c = context.getJobId(),
            Context_Name__c = ex.getAC(), 
            Stack_trace_String__c = ex.getStackTraceString());
            Database.SaveResult sr = EventBus.publish(logEvent);
            // System.debug('batch '+ context.getJobId());   

            // System.debug('Event' + sr.isSuccess());
            // System.debug('Event' + sr.isSuccess());
            //  System.debug('users '+ userinfo.getName());       

    }
}