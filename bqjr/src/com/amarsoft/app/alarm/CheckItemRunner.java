package com.amarsoft.app.alarm;

import java.io.Serializable;

import com.amarsoft.awe.util.Transaction;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 探测模型运行器。把运行器拆分出来，方便于未来遇上更多的扩展
 */
public abstract class CheckItemRunner implements Serializable{
	private static final long serialVersionUID = 4213339734225087052L;
	ScenarioContext context = null;		//场景上下文容器
	/**
	 * 设置场景上下文容器
	 * @param context
	 */
	public void setScenarioContext(ScenarioContext context){
		this.context = context;
	}
	/**
	 * 获取场景上下文容器
	 * @return 场景上下文容器
	 */
	public ScenarioContext getScenarioContext(){
		return context;
	}
	/**
	 * 抽象方法，运行模型
	 * @param sqlca 运行模型引用
	 * @param checkItem 运行模型引用
	 * @return
	 */
	public abstract Object run(Transaction sqlca,CheckItem checkItem) throws Exception;
}

