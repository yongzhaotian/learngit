package com.amarsoft.app.accounting.compare.method;

/**
 * != ������ �ж�
 * @author xjzhao@amarsoft.com
 */
public class NoEquals implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		return !a.equals(b);
	}
}
