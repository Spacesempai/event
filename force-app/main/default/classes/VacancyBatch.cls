/**
 * Created by OlexandrKrykun on 04.04.2021.
 */

public with sharing class VacancyBatch implements Database.Batchable<SObject> ,
Database.Stateful {
  private String batchQuery;
  private String standardQuery = 'Select id from Vacancy__c where status__c = \'closed\' ';
  Exception[] errors = new Exception[0];  
  private List<CustomException> customExceptions = new List<CustomException>();
  private String stackTraceString;


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
      // delete vacancies;     
      // delete vacancies;     
      // delete vacancies;     


    } catch(Exception e) {
      AsyncapexJob aJ = [SELECT Id, ApexClassID FROM AsyncapexJob WHERE Id =: context.getJobId()];
      ApexClass aC = [SELECT Id, Name FROM ApexClass WHERE Id =: aJ.ApexClassID];
      CustomException customException = new CustomException();
      customException.rec = vacancies;
      customException.msg = e.getMessage();
      customException.createStackTraceString();
      customException.apexClass = aC.Name;
      customExceptions.add(customException);      
      System.debug('Stack Trace'+ customException.getStackTraceString());   

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
      for( CustomException ex:customExceptions){
      logging.log(context,ex,'ERROR');
  }
  
      }        
        else {
          System.debug('All good');
          logging.log('batch finished successfully','INFO ');
        }
  }
  public class CustomException extends Exception{
    public String stackTrackString;
    public String msg;      
    public List<Vacancy__c> rec;
    public String apexClass;
    public  String getMsg(){
      return this.msg;
    }
    public String getAC(){
      return this.apexClass;
    }
    public   String getRec(){
      List<String> lstNames  = new List<String>();
      for(Vacancy__c ac: rec){
      lstNames.add(ac.Id);
}
String names = string.join(lstNames,',');
return names;
    }
    private void createStackTraceString() {
      stackTrackString = new DmlException().getStackTraceString();
      // stackTrackString = stackTrackString.replaceFirst('(?m)(.*\\n){3}?', '');
  }

  public override String getStackTraceString() {
      return stackTrackString;
  }
  } 
}