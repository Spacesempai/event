public class yourClassName {

  @future
  public static void massDeleteJobs(List<ID> paramIDsToAbort) {
    Integer i = 0;
    while (i < 150 && paramIDsToAbort.size() > 0) {
      System.abortJob(paramIdsToAbort.remove(0));
      i++;
    }
    if (paramIDsToAbort.size() > 0) {
      yourClassName.massDeleteJobs(paramIDsToAbort);
    }
  }
}