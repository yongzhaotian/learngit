package com.amarsoft.app.accounting.compare.method;

/**
 * > 大于 判断
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
			throw new Exception("不支持的数据类型【"+a.toString()+"】，请检查！");
	}
}
