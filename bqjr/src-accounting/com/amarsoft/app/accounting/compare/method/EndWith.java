package com.amarsoft.app.accounting.compare.method;

/**
 * End 结尾是  判断
 * @author xjzhao@amarsoft.com
 */
public class EndWith implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).endsWith((String)b);
		}
		else
			throw new Exception("不支持的数据类型【"+a.toString()+"】，请检查！");
	}
}
