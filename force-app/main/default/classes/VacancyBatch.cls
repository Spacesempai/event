/**
 * Created by OlexandrKrykun on 04.04.2021.
 */

public with sharing class VacancyBatch implements Database.Batchable<SObject> ,
Database.Stateful {
  private String batchQuery;
  private String standardQuery = 'Select id from Vacancy__c where status__c = \'closed\' ';
  Exception[] errors = new Exception[0];  
  private List<CustomException> customExceptions = new List<CustomException>();

  public VacancyBatch(String query) {
    this.batchQuery = query; 
  }
  public VacancyBatch() {
    this.batchQuery = standardQuery;
  }

  public Database.QueryLocator start(Database.BatchableContext context) {
    return Database.getQueryLocator(this.batchQuery);
  }
  public void execute(    
    Database.BatchableContext context,
    List<Vacancy__c> vacancies
  ) {   
      List<CronTrigger> CronTrigger = [
              SELECT
                      CreatedById,
                      CreatedDate,
                      CronExpression,
                      CronJobDetail.Name,
                      CronJobDetail.JobType,
                      EndTime,
                      Id,
                      LastModifiedById,
                      NextFireTime,
                      OwnerId,
                      PreviousFireTime,
                      StartTime,
                      State,
                      TimesTriggered,
                      TimeZoneSidKey
              FROM CronTrigger
      ];
      List<AsyncApexJob> apexJobs = [
              SELECT
                      ApexClassId,
                      CompletedDate,
                      CreatedById,
                      CreatedDate,
                      ExtendedStatus,
                      Id,
                      JobItemsProcessed,
                      JobType,
                      LastProcessed,
                      LastProcessedOffset,
                      MethodName,
                      NumberOfErrors,
                      ParentJobId,
                      Status,
                      TotalJobItems
              FROM AsyncApexJob];
      for(CronTrigger cron:CronTrigger){
        System.debug('CronTriggerName->'+ cron.CronJobDetail.Name);
        System.debug('CronTriggerJobType->'+ cron.CronJobDetail.JobType);
      }
      for(AsyncApexJob j:apexJobs){
        System.debug('AsyncApexJob->'+j);
      }
      try {
      delete vacancies;     
      delete vacancies;     
      delete vacancies;     
      delete vacancies;     


    } catch(Exception e) {
      CustomException customException = new CustomException();
      customException.rec = vacancies;
      customException.msg = e.getMessage();
      customExceptions.add(customException);
      throw e;
  }
    }
  
  public void finish(Database.BatchableContext context) {
    Logger logging = new Logger();
    if(!customExceptions.isEmpty()) {   //System.debug('trace '+ customExceptions[0].getStackTraceString());  
      // System.debug('ERRORS '+ customExceptions);   
      // System.debug('ERRORS '+ customExceptions[0].getMsg());   
      // System.debug('ERRORS '+ customExceptions[0].getRec());   
      //  System.debug('batch '+ context.getJobId());   
      //Add for!!!
   
      logging.log(context,customExceptions[0].getMsg(),customExceptions[0].getRec(),'ERROR');
      }        
        else {
          System.debug('All good');
          logging.log('batch finished successfully','INFO ');
        }
  }
  public class CustomException extends Exception{
    public String msg;      
    public List<Vacancy__c> rec;
    public  String getMsg(){
      return this.msg;
    }
    public   String getRec(){
      List<String> lstNames  = new List<String>();
      for(Vacancy__c ac: rec){
      lstNames.add(ac.Id);
}
String names = string.join(lstNames,',');
return names;
    }
  } 
}