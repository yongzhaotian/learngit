package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
/**
 * ���ڶ�������������ָ��Ŀ��ơ�
 * @author yzhan
 * @since 2011-11-21
 *
 */
public class SpecialAdjData {


	 
	/**
	 *�жϸÿͻ���ע���ʽ��Ƿ�С��100��
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static boolean getRegisterCapitalFlag(String customerID)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("customerID=:customerID");
		BizObject bo = bq.setParameter("customerID",customerID).getSingleResult();
		Double registerCapital = bo.getAttribute("REGISTERCAPITAL").getDouble();
		if(registerCapital < 100.00)return true;//��Ԫ
		else return false;
	}
	
	/**
	 * �жϸÿͻ������ʲ��Ƿ�С��1��
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static boolean getTotalAssetsFlag(String customerID)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("customerID=:customerID");
		BizObject bo = bq.setParameter("customerID",customerID).getSingleResult();
		Double totalAssets = bo.getAttribute("TOTALASSETS").getDouble();
		if(totalAssets < 10000.00)return true;//��Ԫ
		else return false;
	}
}
