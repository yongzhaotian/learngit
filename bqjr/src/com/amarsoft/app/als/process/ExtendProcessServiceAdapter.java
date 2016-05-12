package com.amarsoft.app.als.process;

/**
 * 扩展流程服务接口适配器<br>
 * 提供扩展流程服务的默认实现,真正的实现须在具体的引擎服务实现类中定义
 * @author zszhang
 *
 */
public class ExtendProcessServiceAdapter extends DefaultContext implements ExtendProcessService {

	/**
	 * 示例扩展方法的简单实现,真正的实现需在具体的引擎服务实现类中定义
	 */
	public String sampleExtendMethod(){
		return null;
	}
}
