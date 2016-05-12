package com.amarsoft.app.als.rating.action;

import com.amarsoft.app.als.rating.model.CustomerRatingInfo;
import com.amarsoft.app.als.rating.model.CustomerRatingLoader;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * �ͻ���ش�����
 * @author hwang
 * @since 2011/03/09
 * �ɳ���С��ҵ���Ŷ�Ȳ�����ô���
 *
 */
public class CustomerRatingManager {
	
	private String customerId = "";//�ͻ����
	private String accountMonth = "";//���һ���������ڼ�ȥ12���µ��·�
	private String cusbomtextin = "";
	
	public CustomerRatingManager()
	{
		
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getAccountMonth() {
		return accountMonth;
	}

	public void setAccountMonth(String accountMonth) {
		this.accountMonth = accountMonth;
	}
	
	public String getCusBomTextIn() {
		return cusbomtextin;
	}

	public void setCusBomTextIn(String cusbomtextin) {
		this.cusbomtextin = cusbomtextin;
	}

	/**
	 * ���һ���Ƿ�������
	 * @return
	 * @throws Exception
	 */
	public String havaNewRating() throws Exception {
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
		BizObjectQuery q = m.createQuery("CustomerNO=:CustomerID and CONFIRMDATE>=:CONFIRMDATE");
		q.setParameter("CustomerID",customerId).setParameter("CONFIRMDATE",accountMonth);
		return q.getTotalCount()+"";
		
	}
	
	/**
	 * ��ȡָ������������¼
	 * @return
	 * @throws Exception
	 */
	public String findRatingResult() throws Exception {
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
		BizObjectQuery q = m.createQuery("CustomerNO=:CustomerID");
		q.setParameter("CustomerID",customerId);
		int iCount=q.getTotalCount();
		String sReturn="";
		if(iCount>0){
			sReturn+=iCount;
		}
		return sReturn;
	}
	
	/**
	 * ��ȡ�ͻ�����Ч������Ϣ��¼����
	 * @return
	 * @throws Exception
	 */
	public static CustomerRatingInfo getCusRatingObj(String CustomerID) throws Exception {

		return CustomerRatingLoader.getCusRatingInfo(CustomerID);
	}
	
	/**
	 * ��ȡ�ͻ����ѱ�����Ч������Ϣ��¼����
	 * @return
	 * @throws Exception
	 */
	public static CustomerRatingInfo getCusRatingObjSaved(String CustomerID) throws Exception {

		return CustomerRatingLoader.getCusRatingInfoSaved(CustomerID);
	}
	
	/**
	 * ���¿ͻ���������Ϣ
	 * @return
	 * @throws Exception
	 */
	public String updateCusRatingInfo() throws Exception {
		
		cusbomtextin = cusbomtextin.replace("@", ";");
		cusbomtextin = cusbomtextin.replace(":", "=");
		if (cusbomtextin.startsWith(";"))cusbomtextin = cusbomtextin.substring(1);
		
		return CustomerRatingLoader.updateCusRatingInfo(customerId, cusbomtextin);
	}
	
	/**
	 * ��ȡ�ͻ�������ģ������
	 * @return
	 * @throws Exception
	 */
	public static String getCusRatingModelName(String ModelID) throws Exception {

		return CustomerRatingLoader.getRuleModelName(ModelID);
	}
	
	/**
	 * ��ȡ�ͻ���������Ч�������
	 * @return
	 * @throws Exception
	 */
	public static String getCusRatingResult(String CustomerID) throws Exception {

		return CustomerRatingLoader.getCusRatingResult(CustomerID);
	}
	
}