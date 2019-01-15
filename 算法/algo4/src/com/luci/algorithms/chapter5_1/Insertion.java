package com.luci.algorithms.chapter5_1;

public class Insertion {
	public static void sort(String[] a, int lo, int hi, int d) {
		// �ӵ�d���ַ���ʼ��a[lo]��a[hi]����
		for (int i = lo; i < hi; i++) {
			for (int j = i; j > lo && less(a[j], a[j - 1], d); j++) {
				exch(a, j, j - 1);
			}
		}
	}

	private static boolean less(String v, String w, int d) {
		return v.substring(d).compareTo(w.substring(d)) < 0;
	}

	private static void exch(String[] a, int i, int j) {
		String temp = a[i];
		a[i] = a[j];
		a[j] = temp;
	}
}
