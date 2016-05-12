package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * У��ͻ��Ƿ��пͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
 * @author syang 2009/10/27
 *
 */
public class CheckRolesAction extends Bizlet {

	
	/**
	 * @param ����˵��<br/>
	 * 		CustomerID	:�ͻ�ID<br/>
	 * 		UserID		:�û�ID
	 * @return ����ֵ˵��
	 * 		<p>����Ȩ@��Ϣ�鿴Ȩ@��Ϣά��Ȩ@ҵ�����Ȩ</p>
	 * 		<li>����Ȩֵ�򡡡���Y/N</li>
	 * 		<li>��Ϣ�鿴Ȩֵ��Y1/N1</li>
	 * 		<li>��Ϣά��Ȩֵ��Y2/N2</li>
	 * 		<li>ҵ�����Ȩֵ��Y3/N3</li>
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/**
		 * ��ȡ����
		 */
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sUserID = (String)this.getAttribute("UserID");
		
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		
		/**
		 * �������
		 */
		String sReturn = "";			//���ؽ��
	    ASResultSet rs = null;			//��Ž����    
	    String sBelongAttribute = "";	//�ͻ�����Ȩ    
	    String sBelongAttribute1 = "";	//��Ϣ�鿴Ȩ
	    String sBelongAttribute2 = "";	//��Ϣά��Ȩ
	    String sBelongAttribute3 = "";	//ҵ�����Ȩ    
	    String sReturnValue = "";		//����Ȩ��־   
	    String sReturnValue1 = "";		//��Ϣ�鿴Ȩ��־
	    String sReturnValue2 = "";		//��Ϣά��Ȩ��־
	    String sReturnValue3 = "";		//ҵ�����Ȩ��־
	    
	    /**
	     * �����߼�
	     */
	    
	    String sSql = " select BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3 "+
        " from CUSTOMER_BELONG "+
        " where CustomerID =:CustomerID "+
        " and UserID =:UserID  ";
	    SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("UserID", sUserID);
		rs = Sqlca.getResultSet(so);
	    
		if(rs.next()){
			sBelongAttribute = rs.getString("BelongAttribute");
			sBelongAttribute1 = rs.getString("BelongAttribute1");
			sBelongAttribute2 = rs.getString("BelongAttribute2");
			sBelongAttribute3 = rs.getString("BelongAttribute3");	   
		}
		rs.getStatement().close();
		rs = null;
		if(sBelongAttribute == null) sBelongAttribute = "";
		if(sBelongAttribute1 == null) sBelongAttribute1 = "";
		if(sBelongAttribute2 == null) sBelongAttribute2 = "";
		if(sBelongAttribute3 == null) sBelongAttribute3 = "";
		
		
		
		//����пͻ�����Ȩ����Y�����򷵻�N	
	    if(sBelongAttribute.equals("1")){
	        sReturnValue = "Y";
	    }else{ 
	    	sReturnValue = "N";
	    }
	        
	    //�������Ϣ�鿴Ȩ����Y1�����򷵻�N1	
	    if(sBelongAttribute1.equals("1")){
	        sReturnValue1 = "Y1";
	    }else{ 
	    	sReturnValue1 = "N1";
	    }
	    
	    //�������Ϣά��Ȩ����Y2�����򷵻�N2	
	    if(sBelongAttribute2.equals("1")){
	        sReturnValue2 = "Y2";
	    }else{ 
	    	sReturnValue2 = "N2";
	    }
	    
	    //�����ҵ�����Ȩ����Y3�����򷵻�N3	
	    if(sBelongAttribute3.equals("1")){
	        sReturnValue3 = "Y3";
	    }else{ 
	    	sReturnValue3 = "N3";
	    }
	        
	    sReturn = sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3;
		return sReturn;
	
  	}
}
