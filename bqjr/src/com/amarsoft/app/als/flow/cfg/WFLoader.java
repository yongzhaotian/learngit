package com.amarsoft.app.als.flow.cfg;

import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;
import com.amarsoft.are.jbo.JBOException;

public interface WFLoader {

	//���ع�����
	public BusinessProcess loadWorkFlow(String flowNo) throws JBOException;
	
	//�־û�������
	public void persistWorkFlow(BusinessProcess bp) throws JBOException;
}
