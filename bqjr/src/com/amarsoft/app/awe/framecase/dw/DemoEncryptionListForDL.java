package com.amarsoft.app.awe.framecase.dw;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.htmlfactory.ListHtmlWithASDataObjectGenerator;

public class DemoEncryptionListForDL extends ListHtmlWithASDataObjectGenerator {
	

	public void calPageCount(BusinessProcessData bpData) throws Exception {
		//���ﲻ������
		//rowCount = 58;
		//pageCount = (rowCount + this.pageSize -1 ) / this.pageSize;
	}

	public void run(BusinessProcessData bpData) throws Exception {
		String sManager = this.asObj.getCustomProperties().getProperty("manager");
		//���������ļ�ת��Ϊ��
		FileInputStream inStream = new FileInputStream(new File("c:\\test.zip"));
		//����������ת��Ϊ����
		DemoImpExpEncryption d = new DemoImpExpEncryption();
		//��������
		HashMap<String,int[]> counts = new HashMap<String,int[]>();
		counts.put(sManager, new int[]{curPage*pageSize,pageSize});
		HashMap<String,List<BizObject>> result = d.importData(inStream,counts);
		searchedDataList = result.get(sManager);
		rowCount = d.getRowCount(sManager);
		if(pageSize>rowCount)pageSize=rowCount;
		pageCount = (rowCount + this.pageSize -1 ) / this.pageSize;
	}
}
