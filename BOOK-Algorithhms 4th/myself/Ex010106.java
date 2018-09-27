import edu.princeton.cs.algs4.StdOut;

public class Ex06 {
	public static void main(String[] args) {
		int f = 0;
		int g = 1;
		for (int i = 0; i <= 15; i++) {
			f = f + g;
			g = f - g;
			System.out.printf("%d, %d \n", f, g);
		}
		System.out.printf("last: %d, %d \n", f, g);
        StdOut.println("haha");
	}
}
