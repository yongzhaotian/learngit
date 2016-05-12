package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * ���¿ͻ�����
 * @author syang 2009/10/28
 *
 */
public class ChangeCustomerType extends Bizlet {
	/** �ͻ�ID */
	private String sCustomerID = "";
	/** �ͻ����� */
	private String sCustomerType = "";
	/** �û�ID */
	private String sUserID = "";
	/** ������ */
	private String sOrgID = "";
	/** ��ǰ���� */
	private String sToday = "";
	
	/** ���ݿ����� */
	private Transaction Sqlca = null;

	/**
	 * @param ����˵��
	 *		<p>CustomerType���ͻ�����
	 *			<li>01    ��˾�ͻ�</li>
	 *			<li>0110  ������ҵ</li>  
	 *			<li>0120  ��С��ҵ</li>
	 *			<li>02    ���ſͻ�</li>  
	 *			<li>0210  ʵ�弯��</li>  
	 *			<li>0220  ���⼯��</li>
	 *			<li>03    ���˿ͻ�</li>  
	 *			<li>0310  ���˿ͻ�</li>  
	 *			<li>0320  ���徭Ӫ��</li>
	 *		</p>
	 * 		<p>CustomerName	:�ͻ�����</p>
	 * 		<p>CertType		:֤������</p>
	 * 		<p>CertID			:֤����</p>
	 * 		<p>Status			:��ǰ�ͻ�״̬
	 * 			<li>01 �޸ÿͻ�</li>
	 * 			<li>02 ��ǰ�û�����ÿͻ���������</li>
	 * 			<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li>
	 * 			<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li>
	 *		</p>
	 * 		<p>UserID			:�û�ID</p>
	 * 		<p>CustomerID		:�ͻ�ID</p>
	 * 		<p>OrgID			:����ID</p>
	 * @return ����ֵ˵��
	 * 		����״̬ 1 �ɹ�,0 ʧ��
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/**
		 * ��ȡ����
		 */
		sCustomerID = (String)this.getAttribute("CustomerID");	
		sCustomerType = (String)this.getAttribute("CustomerType");	
		sUserID = (String)this.getAttribute("UserID");	
		sOrgID = (String)this.getAttribute("OrgID");
		
		sToday = StringFunction.getToday();
		this.Sqlca = Sqlca;
 
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerType == null) sCustomerType = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		
		
		/**
		 * ��������
		 */
		String sReturn = "";
		
		/**
		 *	�����߼� 
		 */
		
		try{
			//�����ת���Ŀͻ������Ǵ�����ҵ����������϶�״̬
			if(sCustomerType.equals("0110")){
				updateCustomerInfo("");
				updateEntInfo(sCustomerID, sCustomerType,null);
			}
			//�����ת���Ŀͻ���������С����ҵ����������϶�״̬
			if(sCustomerType.equals("0120")){
				updateCustomerInfo("0");
				updateEntInfo(sCustomerID, sCustomerType,null);
			}
			//�����ת���Ŀͻ������Ǹ��˿ͻ�����ͻ�����
			if(sCustomerType.equals("0310")){
				updateCustomerInfo("");
				/**
				 * ����Ǹ��˿ͻ�����Ӧ��ɾ����С��ҵ������Ϣ		  
				 */
				  Sqlca.executeSQL(new SqlObject("Delete from SME_CUSTRELA where RelativeSerialno=:RelativeSerialno").setParameter("RelativeSerialno", sCustomerID));
			}
			//�����ת���Ŀͻ������Ǹ��˾�Ӫ������ͻ�����
			if(sCustomerType.equals("0320")){
				updateCustomerInfo("");
			}
			
			//������ҵ��Ϣ��ENT_INFO,���ͻ���ģScope�ֶθ��� add by cbsu 2009-11-2
			sReturn = "1";
		}catch(Exception e){
			sReturn = "0";
		}
		return sReturn;
	}
	
	/**
	 * ���¿ͻ���Ϣ��
	 * @param status
	 * @throws Exception
	 */
	private void updateCustomerInfo(String status) throws Exception{
		String sSql = 	" update CUSTOMER_INFO set"
			+" CustomerType =:CustomerType,"
			+" status =:status,"
			+" InputDate =:InputDate,"
			+" InputOrgID =:InputOrgID,"
			+" InputUserID =:InputUserID"
		    +" where CustomerID =:CustomerID ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("CustomerType", sCustomerType).setParameter("status", status).setParameter("InputDate", sToday);
		so.setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	}
	
	/**
	 * ������ҵ��Ϣ��ENT_INFO,���ͻ���ģScope�ֶκ�CreditBelong�ֶθ��¡�
	 * �������С��ҵת������ҵ����Scope����Ϊ"2"��
	 * ���ʱ������ҵת��С��ҵ����Scope����Ϊ�ա���Ϊ����������ҵ��С����ҵ��������޷��趨Scope����Ϊ��һ����
	 *  add by cbsu 2009-11-02
	 * ��ҵ��ģת��ʱ���轫�洢���õȼ�����ģ��CreditBelong�ֶ��ÿա�
	 *  add by cbsu 2009-11-06
	 * @param sCustomerID �ͻ����
	 * @param sTargetCustomerType ת����Ŀ���ģ
	 * @param sEmployeeNumber ת����Ա�����������Ϊ�գ���ת����
	 * @throws Exception
	 */
	private void updateEntInfo(String sCustomerID, String sTargetCustomerType,String sEmployeeNumber) throws Exception{
		SqlObject so = null;//��������
        String sScope = "";
        String sSourceCustomerType = "";
        String sSql = " Select CustomerType from CUSTOMER_INFO Where CustomerID = :CustomerID";
        sSourceCustomerType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
        //ת���ͻ���ģ��Դ�ͻ���������ҵ���ܸ���ENT_INFO��
        if ("01".equals(sSourceCustomerType.substring(0, 2))) {
            //����Ŀ���ģ������Scope�ֶε�ֵ
            if ("0110".equals(sTargetCustomerType)) {
                sScope = "2";
            }
            //��CreditBelong�ֶ��ÿ�  add by cbsu 2009-11-06
            /*if(sEmployeeNumber == null){
            	sSql = " Update ENT_INFO set Scope =:Scope, CreditBelong = '' Where CustomerID =:CustomerID ";
            	so = new SqlObject(sSql).setParameter("Scope", sScope).setParameter("CustomerID", sCustomerID);
            	Sqlca.executeSQL(so);
            }else{*/
            	 sSql = " Update ENT_INFO set Scope =:Scope , CreditBelong = '',EmployeeNumber =:EmployeeNumber  Where CustomerID =:CustomerID ";
            	 so = new SqlObject(sSql).setParameter("Scope", sScope).setParameter("EmployeeNumber", sEmployeeNumber).setParameter("CustomerID", sCustomerID);
            	 Sqlca.executeSQL(so);
//            }
        }
    }
}
