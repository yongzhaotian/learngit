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
		//这里不做导出
		//rowCount = 58;
		//pageCount = (rowCount + this.pageSize -1 ) / this.pageSize;
	}

	public void run(BusinessProcessData bpData) throws Exception {
		String sManager = this.asObj.getCustomProperties().getProperty("manager");
		//将导出的文件转化为流
		FileInputStream inStream = new FileInputStream(new File("c:\\test.zip"));
		//将二进制流转化为对象
		DemoImpExpEncryption d = new DemoImpExpEncryption();
		//设置条数
		HashMap<String,int[]> counts = new HashMap<String,int[]>();
		counts.put(sManager, new int[]{curPage*pageSize,pageSize});
		HashMap<String,List<BizObject>> result = d.importData(inStream,counts);
		searchedDataList = result.get(sManager);
		rowCount = d.getRowCount(sManager);
		if(pageSize>rowCount)pageSize=rowCount;
		pageCount = (rowCount + this.pageSize -1 ) / this.pageSize;
	}
}
