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
		String modelCondition = "";//ģ����Ϣ
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String scope = "";//��ҵ��ģ
		String setupDate = "";//��ҵ����ʱ��
		String industryType = "";//������ҵ����
		
		//��øÿͻ��Ĺ�����ҵ���ࡢ��ҵ��ģ����ҵ��������
		bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		bq = bm.createQuery("select Scope, Setupdate,IndustryType from O where CustomerID=:CustomerID");
		bo = bq.setParameter("CustomerID",customerID).getSingleResult();
		if(bo == null)modelCondition = "NOCUSTOMER";//�ͻ������ڣ�
		else{
			//��ÿͻ���Ϣ
			scope = bo.getAttribute("Scope").getString();
			setupDate = bo.getAttribute("SetupDate").getString();
			industryType = bo.getAttribute("IndustryType").getString();
			//����ͻ���Ϣ
			if("".equals(scope)|| scope == null)scope ="NONE";

			String today = StringFunction.getToday();
			String setupFlag = "";//��ҵ�Ƿ��������һ�·�֮ǰ��������:Y �� :N
			today = today.substring(0,4);
			today = (Integer.parseInt(today)-1)+"/01/01";//��ǰ����ǰһ��
			
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
