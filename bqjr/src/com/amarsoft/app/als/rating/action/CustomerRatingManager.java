package com.amarsoft.app.als.rating.action;

import com.amarsoft.app.als.rating.model.CustomerRatingInfo;
import com.amarsoft.app.als.rating.model.CustomerRatingLoader;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 客户相关处理类
 * @author hwang
 * @since 2011/03/09
 * 成长型小企业授信额度测算调用此类
 *
 */
public class CustomerRatingManager {
	
	private String customerId = "";//客户编号
	private String accountMonth = "";//最近一次评级日期减去12个月的月份
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
	 * 最近一年是否有评级
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
	 * 获取指定条件评级记录
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
	 * 获取客户的有效评价信息记录对象
	 * @return
	 * @throws Exception
	 */
	public static CustomerRatingInfo getCusRatingObj(String CustomerID) throws Exception {

		return CustomerRatingLoader.getCusRatingInfo(CustomerID);
	}
	
	/**
	 * 获取客户的已保存有效评价信息记录对象
	 * @return
	 * @throws Exception
	 */
	public static CustomerRatingInfo getCusRatingObjSaved(String CustomerID) throws Exception {

		return CustomerRatingLoader.getCusRatingInfoSaved(CustomerID);
	}
	
	/**
	 * 更新客户的评价信息
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
	 * 获取客户的评价模型名称
	 * @return
	 * @throws Exception
	 */
	public static String getCusRatingModelName(String ModelID) throws Exception {

		return CustomerRatingLoader.getRuleModelName(ModelID);
	}
	
	/**
	 * 获取客户的最新有效评级结果
	 * @return
	 * @throws Exception
	 */
	public static String getCusRatingResult(String CustomerID) throws Exception {

		return CustomerRatingLoader.getCusRatingResult(CustomerID);
	}
	
}