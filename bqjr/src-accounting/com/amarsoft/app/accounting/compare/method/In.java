package com.amarsoft.app.accounting.compare.method;

/**
 * in 反包含  判断
 * @author xjzhao@amarsoft.com
 */
public class In implements ICompare {
	public boolean compare(Object a, Object b) throws Exception {
		if(a instanceof String && b instanceof String)
		{
			return (","+(String)b).indexOf(","+(String)a+",") >= 0;
		}
		else
			throw new Exception("不支持的数据类型【"+a.toString()+"】，请检查！");
	}
}
