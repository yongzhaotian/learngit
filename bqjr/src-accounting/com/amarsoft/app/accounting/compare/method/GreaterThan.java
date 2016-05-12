package com.amarsoft.app.accounting.compare.method;

/**
 * > ���� �ж�
 * @author xjzhao@amarsoft.com
 */
public class GreaterThan implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).compareTo((String)b) > 0;
		}
		else if(a instanceof Double && b instanceof Double)
		{
			return ((Double)a) > ((Double)b);
		}
		else if(a instanceof Integer && b instanceof Integer)
		{
			return ((Integer)a) > ((Integer)b);
		}
		else
			throw new Exception("��֧�ֵ��������͡�"+a.toString()+"�������飡");
	}
}
