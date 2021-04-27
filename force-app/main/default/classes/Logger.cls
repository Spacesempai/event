public with sharing class Logger {
    public  Logger() {

    }
    public void  log(String msg, String LogLevel) {
        Logging__e  logEvent = new Logging__e(
            LogLevel__c=LogLevel,
            Message__c= msg);
            Database.SaveResult sr = EventBus.publish(logEvent);
                 
    }
    public  void log(Database.BatchableContext context, String msg, String rec , String LogLevel) {
        Logging__e  logEvent = new Logging__e(
            LogLevel__c =LogLevel,
            Message__c = msg,
            Record__c = rec,
            User_Name__c = userinfo.getName(),
            Context_Id__c = context.getJobId());
            Database.SaveResult sr = EventBus.publish(logEvent);
            // System.debug('batch '+ context.getJobId());   

            // System.debug('Event' + sr.isSuccess());
            // System.debug('Event' + sr.isSuccess());
            //  System.debug('users '+ userinfo.getName());       

    }
}