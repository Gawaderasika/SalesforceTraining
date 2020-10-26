public with sharing class Utility {

    public static String generateCardId(){
        String CharList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_';
        Integer position;
        Integer LengthRequired = 30;
        String Res = '';
        for(Integer i = 0; i <= LengthRequired; i++) {
            position = Integer.valueof(String.valueof(Math.roundToLong(CharList.length()*Math.random()))) -1;
            Res += CharList.substring(position,position+1);
        }
        
        return Res;
    }
}