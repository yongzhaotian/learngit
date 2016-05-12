package com.amarsoft.app.als.flow.cfg;

import org.jdom.Document;

import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;

public interface WFConverter {

	//��BusinessProcessת��ΪXML Doc
	public Document convertProcessToXML(BusinessProcess bp);
	
	//��XML Docת��ΪBusinessProcess
	public BusinessProcess convertXMLToProcess(Document doc);
}
