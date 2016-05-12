package com.amarsoft.app.accounting.compare.method;

/**
 * NoContain 不包含 判断
 * @author xjzhao@amarsoft.com
 */
public class NoContain implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return ((String)a).indexOf((String)b) < 0;
		}
		else
			throw new Exception("不支持的数据类型【"+a.toString()+"】，请检查！");
	}
}
