package com.amarsoft.app.als.rating.bizlets;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetRatingModelCondition extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String customerID = (String) this.getAttribute("CustomerID");
		String modelCondition = "";//模板信息
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String scope = "";//企业规模
		String setupDate = "";//企业成立时间
		String industryType = "";//国标行业分类
		
		//获得该客户的国标行业分类、企业规模、企业成立日期
		bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		bq = bm.createQuery("select Scope, Setupdate,IndustryType from O where CustomerID=:CustomerID");
		bo = bq.setParameter("CustomerID",customerID).getSingleResult();
		if(bo == null)modelCondition = "NOCUSTOMER";//客户不存在！
		else{
			//获得客户信息
			scope = bo.getAttribute("Scope").getString();
			setupDate = bo.getAttribute("SetupDate").getString();
			industryType = bo.getAttribute("IndustryType").getString();
			//处理客户信息
			if("".equals(scope)|| scope == null)scope ="NONE";

			String today = StringFunction.getToday();
			String setupFlag = "";//企业是否是上年度一月份之前成立，是:Y 否 :N
			today = today.substring(0,4);
			today = (Integer.parseInt(today)-1)+"/01/01";//当前日期前一年
			
			if("".equals(setupDate) || setupDate==null)
				setupFlag="NONE";
			else if(today.compareTo(setupDate)> 0)
				setupFlag="Y";
			else 
				setupFlag = "N";
			
			if("".equals(industryType)|| industryType==null)industryType="NONE";
			else industryType = industryType.substring(0,1);
			modelCondition= industryType+"@"+scope+"@"+setupFlag;
		}
		return modelCondition;
	}

}
