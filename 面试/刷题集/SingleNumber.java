import java.io.*; 
import java.util.*; 

/*
Given an array of integers, every element appears twice except for one.
 Find that single one.
 这道题运用位运算的异或。异或是相同为0，不同为1。所以对所有数进行异或，得出的那个数就是single number。
 初始时先让一个数与0异或，然后再对剩下读数挨个进行异或。
 这里运用到异或的性质：对于任何数x，都有x^x=0，x^0=x

 同时异或还有性质：

 交换律 A XOR B = B XOR A

 结合律 A XOR B XOR C = A XOR (B XOR C) = (A XOR B) XOR C

 自反性 A XOR B XOR B = A XOR 0 = A
*/
class SingleNumber {
    public int singleNumber(int[] A) {
        int result = 0;
        for (int i = 0; i < A.length; i++) {
            result = result ^ A[i];
        }
        return result;
    }

    public static void main(String[] args) {
        int[] A = {4, 5, 5, 4, 2};
        SingleNumber st = new SingleNumber();
        int result = st.singleNumber(A);
        System.out.print(result);
    }
}