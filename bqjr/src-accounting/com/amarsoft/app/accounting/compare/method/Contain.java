package com.amarsoft.app.accounting.compare.method;

/**
 * Contain ����  �ж�
 * @author xjzhao@amarsoft.com
 */
public class Contain implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).indexOf((String)b) >= 0;
		}
		else
			throw new Exception("��֧�ֵ��������͡�"+a.toString()+"�������飡");
	}
}
