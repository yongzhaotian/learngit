package com.amarsoft.app.als.rating.bizlets;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetTempSaveFlag extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String customerID = (String) this.getAttribute("CustomerID");
		String tempSaveFlag = "1";//客户信息暂存标志
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID=:customerID").setParameter("customerID",customerID);
		BizObject bo = bq.getSingleResult();
		if(bo != null){
			tempSaveFlag = bo.getAttribute("tempSaveFlag").getString();
			if(tempSaveFlag==null ||"".equals(tempSaveFlag))tempSaveFlag="1";
		}
	return tempSaveFlag;	
	}

}
