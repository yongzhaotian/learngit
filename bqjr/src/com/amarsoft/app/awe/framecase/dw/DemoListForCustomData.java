package com.amarsoft.app.awe.framecase.dw;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.htmlfactory.ListHtmlWithASDataObjectGenerator;
import com.amarsoft.awe.dw.ui.htmlfactory.QueryParamObject;

public class DemoListForCustomData extends ListHtmlWithASDataObjectGenerator {
	

	public void calPageCount(BusinessProcessData bpData) throws Exception {
		rowCount = 100;
		pageCount = (rowCount + this.pageSize -1 ) / this.pageSize;
	}

	public void run(BusinessProcessData bpData) throws Exception {
		//System.out.println("paramstr="+this.paramstr);
		//获得查询条件
		List<QueryParamObject> queryParams = this.getQeuryParmObjects();
		for(QueryParamObject queryParam : queryParams){
			System.out.println("查询条件：[colname="+ queryParam.getColName() +",option="+queryParam.getOption()+",value0="+queryParam.getValue0()+",value1="+queryParam.getValue1()+"]");
		}
		this.searchedDataList = new ArrayList<BizObject>();
		rowCount = 100;
		if(pageSize>rowCount)pageSize=rowCount;
		pageCount = (rowCount + this.pageSize -1 ) / this.pageSize;
		BizObjectManager manager = getBizObjectManager();
		for(int i=0;i<pageSize;i++){
			int iIndex = (this.curPage * this.pageSize);			
			iIndex += i;
			HashMap attributes = new HashMap();
			attributes.put("SERIALNO", (100000 + iIndex) +"");
			attributes.put("CUSTOMERNAME", "name" + iIndex);
			attributes.put("TELEPHONE", "135649");
			attributes.put("ISINUSE", (i % 2+1)+"");
			attributes.put("ADDRESS", "2011");
			
			BizObject obj = createBizObject(manager, attributes);
			searchedDataList.add(obj);
			
		}
		
	}

	
	

}
