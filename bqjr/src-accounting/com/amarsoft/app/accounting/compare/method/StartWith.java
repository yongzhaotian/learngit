package com.amarsoft.app.accounting.compare.method;

/**
 * Start ��ͷ��  �ж�
 * @author xjzhao@amarsoft.com
 */
public class StartWith implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).startsWith((String)b);
		}
		else
			throw new Exception("��֧�ֵ��������͡�"+a.toString()+"�������飡");
	}
}
