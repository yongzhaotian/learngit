package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.bizobject.customer.GroupCustomer;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

public class OperCustomer {
	private String customerID;	//客户编号
	private String userID;
	
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public static void updateEntCustomer(String sAttribute,GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
	   BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
	   tx.join(m);
	   BizObjectQuery bq = m.createQuery("update O set GroupFlag=:GroupFlag where CustomerID=:CustomerID");
	   bq.setParameter("GroupFlag",sAttribute).setParameter("CustomerID", groupCustomer.getKeyMemberCustomerID());
	   bq.executeUpdate();	
		
	}

	public static void updateCustomerInfo(GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		tx.join(m);
		BizObjectQuery bq  = m.createQuery("update O set BelongGroupID=:BelongGroupID where CustomerID=:CustomerID");
		bq.setParameter("CustomerID", groupCustomer.getKeyMemberCustomerID()).setParameter("BelongGroupID",groupCustomer.getGroupID());
	    bq.executeUpdate();	
	}
	
	
	public String compareToUserID() throws Exception{
		String sReturn = "";
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = m.createQuery("CustomerID=:CustomerID and InputUserID=:InputUserID").setParameter("CustomerID", customerID).setParameter("InputUserID",userID).getSingleResult();
		if(bo != null){
			sReturn = "Y";
		}
		return sReturn;
	}
	//获取客户的法人代表
	public static String getCustomerKeyman(String sCustomerID) throws JBOException{
		String sReturn = "";
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID).getSingleResult();
		if(bo != null){
			sReturn = bo.getAttribute("FICTITIOUSPERSON").getString();
		}
		if(StringX.isEmpty(sReturn)){
			sReturn = "";
		}
		return sReturn;
	}
	
	//联保体客户授信成员不能少于3个
	public String judgeCustomerCount() throws JBOException{
		String customerType = "";
		int count = 0;
		try {
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			BizObject bo = bm.createQuery("Select CustomerType from O where CustomerID = :CustomerID").setParameter("CustomerID", customerID).getSingleResult();
			if(bo != null){
				customerType = bo.getAttribute("CustomerType").getString();
			}
			//客户类型为联保体
			if("0240".equals(customerType)){
				bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_MEMBER_RELATIVE");
				count = bm.createQuery("GroupID=:CustomerID").setParameter("CustomerID",customerID).getTotalCount();
				if(count < 3){
					return "No";
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
			return "Yes";
		}
		return "Yes";
	}
	
}
