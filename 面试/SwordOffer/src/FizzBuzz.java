import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FizzBuzz {
    public static List<String> fizzBuzz(int n) {
        List<String> result = new ArrayList();
        Map fizzMap = new HashMap();
        Map buzzMap = new HashMap();
        fizzMap.put(3, "fizz ");
        buzzMap.put(5, " buzz");
        for (int i=0; i<=n;i++) {
            String mapFizz = (String) fizzMap.get(i%3+3);
            String mapBuzz = (String) buzzMap.get(i%5+5);
            String nStr = mapFizz + " " + mapBuzz;
            // 1.fizz为空，即null_buzz
            // 2.buzz为空，即fizz_null
            // 3.fizz__buzz
            nStr = nStr.replaceFirst(" ", "");
            nStr = nStr.replaceAll("null ", "");
            if (nStr.length() == 0) {
                nStr = String.valueOf(i);
            }
            result.add(nStr);
        }
        return result;
    }
}
