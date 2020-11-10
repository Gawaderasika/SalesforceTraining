public class exampleCon {
	Integer count = 0;
                        
    public PageReference incrementCounter() {
            count++;
            return null;
    }
                        
    public Integer getCount() {
        return count;
    }
    /**********************************************************************/
    Integer count1 = 0;
                        
    public PageReference incrementCounter1() {
            count1++;
            return null;
    }
                    
    public Integer getCount1() {
        return count1;
    }
}