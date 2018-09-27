


public class Ex07 {
	public static void main(String[] args) {
		double t = 9.0;
		while (Math.abs(t - 9.0/t) > .001){
			System.out.printf("befor: %f   %f 	%f 	%b 	%f \n", t,  9.0/t, Math.abs(t - 9.0/t), (Math.abs(t - 9.0/t) > .001), t);
		    t = (9.0/t + t) / 2.0;	
			System.out.printf("after: %f   %f 	%f 	%b 	%f \n", t,  9.0/t, Math.abs(t - 9.0/t), (Math.abs(t - 9.0/t) > .001), t);
		}
	}
  }