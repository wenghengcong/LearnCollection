import java.io.*; 
import java.util.*; 

/*
Evaluate the value of an arithmetic expression in Reverse Polish Notation.

Valid operators are+,-,*,/. Each operand may be an integer or another expression.

Some examples:

  ["2", "1", "+", "3", "*"] -> ((2 + 1) * 3) -> 9
  ["4", "13", "5", "/", "+"] -> (4 + (13 / 5)) -> 6
*/
class EvaluateReversePolishNotation {
    public int evalRPN(String[] tokens) {
        if(tokens == null)
        {
            return 0;
        }
        //操作数栈
       Stack<Integer> oprandStack = new Stack<Integer>();
       Integer result = 0;
       for(int i=0; i<tokens.length;i++) {
           String token = tokens[i];
           if(token.equals("+")) {
               int v1 = oprandStack.pop();
               int v2 = oprandStack.pop();
               int sigleResutl = new Integer(v1+v2);
               oprandStack.push(sigleResutl);
           } else if(token.equals("-")) {
               int v1 = oprandStack.pop();
               int v2 = oprandStack.pop();
               int sigleResutl = new Integer(v2-v1);
               oprandStack.push(sigleResutl);
           } else if(token.equals("*")) {
               int v1 = oprandStack.pop();
               int v2 = oprandStack.pop();
               int sigleResutl = new Integer(v1*v2);
               oprandStack.push(sigleResutl);
           } else if(token.equals("/")) {
               int v1 = oprandStack.pop();
               int v2 = oprandStack.pop();
               int sigleResutl = new Integer(v2/v1);
               oprandStack.push(sigleResutl);
           } else {
               int opr = Integer.parseInt(token);
               oprandStack.push(opr);
           }
       }
        result = oprandStack.pop();
        return result.intValue();
    }

    public static void main(String[] args) {
        String[] st = {"2","1","+","3","*"};
        EvaluateReversePolishNotation solu = new EvaluateReversePolishNotation();
        int re = solu.evalRPN(st);
		System.out.print(re);
	}
}