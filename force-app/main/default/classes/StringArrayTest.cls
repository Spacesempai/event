public class StringArrayTest {
public static List<String> generateStringArray (Integer data) {
    List<String> test = new List<String>();
    for(Integer i=0;i<data;i++) {
    test.add('Test ' + (i));       
} 	
    System.debug(test);
    return test;
}
}