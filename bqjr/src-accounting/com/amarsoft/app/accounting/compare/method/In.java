package com.amarsoft.app.accounting.compare.method;

/**
 * in ������  �ж�
 * @author xjzhao@amarsoft.com
 */
public class In implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return (","+(String)b).indexOf(","+(String)a+",") >= 0;
		}
		else
			throw new Exception("��֧�ֵ��������͡�"+a.toString()+"�������飡");
	}
}
