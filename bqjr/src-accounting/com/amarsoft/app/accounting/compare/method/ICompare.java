package com.amarsoft.app.accounting.compare.method;


/**
 * 
 *实现两个数据对象的比较，比较匹配则返回true否则false
 *  
 *比较方式如下：
 * = 等于
 * != 不等于
 * > 大于
 * >= 大于等于
 * < 小于
 * <= 小于等于
 * Start 开头是
 * NoStart 开头不是
 * End 结尾是
 * NoEnd 结尾不是
 * Contain 包含
 * NoContain 不包含
 * in 反包含
 * not in 不反包含
 *  
 * @author xjzhao@amarsoft.com
 * @since 1.0
 * @since JDK1.6
 */

public interface ICompare{
 
 /**
  * 匹配两个数据对象
  * @param a
  * @param b
  * @return 匹配结果
  * @throws Exception
  */
 public boolean compare(Object a,Object b) throws Exception;
 
}
