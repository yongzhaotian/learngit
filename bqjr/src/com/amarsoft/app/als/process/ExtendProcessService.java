package com.amarsoft.app.als.process;

/**
 * 扩展流程服务接口<br>
 * 某些流程引擎如果有特殊服务需事先,则可在本接口中添加
 * @author zszhang
 *
 */
public interface ExtendProcessService extends Context {

	/**
	 * 示例扩展方法
	 * @return
	 */
	public String sampleExtendMethod();
}
