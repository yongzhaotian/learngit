package com.amarsoft.app.als.flow.cfg;

import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;
import com.amarsoft.are.jbo.JBOException;

public interface WFLoader {

	//加载工作流
	public BusinessProcess loadWorkFlow(String flowNo) throws JBOException;
	
	//持久化工作流
	public void persistWorkFlow(BusinessProcess bp) throws JBOException;
}
