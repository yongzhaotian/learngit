package com.amarsoft.app.accounting.compare.method;

/**
 * NoEnd ��β����  �ж�
 * @author xjzhao@amarsoft.com
 */
public class NoEndWith implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return !((String)a).endsWith((String)b);
		}
		else
			throw new Exception("��֧�ֵ��������͡�"+a.toString()+"�������飡");
	}
}
