package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
/**
 * 用于对特殊调整项个别指标的控制。
 * @author yzhan
 * @since 2011-11-21
 *
 */
public class SpecialAdjData {


	 
	/**
	 *判断该客户的注册资金是否小于100万
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static boolean getRegisterCapitalFlag(String customerID)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("customerID=:customerID");
		BizObject bo = bq.setParameter("customerID",customerID).getSingleResult();
		Double registerCapital = bo.getAttribute("REGISTERCAPITAL").getDouble();
		if(registerCapital < 100.00)return true;//万元
		else return false;
	}
	
	/**
	 * 判断该客户的总资产是否小于1亿
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static boolean getTotalAssetsFlag(String customerID)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("customerID=:customerID");
		BizObject bo = bq.setParameter("customerID",customerID).getSingleResult();
		Double totalAssets = bo.getAttribute("TOTALASSETS").getDouble();
		if(totalAssets < 10000.00)return true;//万元
		else return false;
	}
}
