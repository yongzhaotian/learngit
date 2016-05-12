package com.amarsoft.app.accounting.compare.method;

/**
 * != ²»µÈÓÚ ÅÐ¶Ï
 * @author xjzhao@amarsoft.com
 */
public class NoEquals implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		return !a.equals(b);
	}
}
