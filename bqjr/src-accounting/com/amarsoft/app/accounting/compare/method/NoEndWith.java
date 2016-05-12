package com.amarsoft.app.accounting.compare.method;

/**
 * NoEnd 结尾不是  判断
 * @author xjzhao@amarsoft.com
 */
public class NoEndWith implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return !((String)a).endsWith((String)b);
		}
		else
			throw new Exception("不支持的数据类型【"+a.toString()+"】，请检查！");
	}
}
