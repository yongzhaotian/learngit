package com.amarsoft.app.als.flow.cfg;

import org.jdom.Document;

import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;

public interface WFConverter {

	//将BusinessProcess转换为XML Doc
	public Document convertProcessToXML(BusinessProcess bp);
	
	//将XML Doc转换为BusinessProcess
	public BusinessProcess convertXMLToProcess(Document doc);
}
