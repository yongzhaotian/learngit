package com.amarsoft.app.als.image;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/*Ȩ��λ���壺jqcao��2013.11.25
 * 1��Ȩ���ַ��� ����3λ�ַ� ��000�������С�1����ʾ�и�Ȩ�ޣ���0����ʾ�޸�Ȩ��
 * 2����һλ ��ʾ�� �鿴Ȩ
 * 3���ڶ�λ ��ʾ�� ����Ȩ
 * 4������λ ��ʾ�� ɾ��Ȩ
 * */

public class ImageAuthManage {
	public String objectNo = "";
	public String objectType = "";
	public String userID = "";
	
	public static String getAuthCode( String sObjectType, String sObjectNo, String sUserID ) throws JBOException{
		String sAuthCode = "";
		BizObjectManager bm = null;
		/*Ĭ�����пͻ����в鿴Ȩ*/
		sAuthCode += "1";
		//===============Ӱ��������ڿͻ�====================
		if( sObjectType.equals( "Customer" ) ){
			String sBelongAttribute[] = new String[4];
			
			/*��������Ȩ��ӵ������Ȩ�޵��û���������Ȩ������Ȩ��ά��Ȩ*/
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
			BizObject bo = bm.createQuery("CustomerID=:CustomerID and UserID=:UserID")
					.setParameter("CustomerID",sObjectNo).setParameter("UserID",sUserID).getSingleResult( false );
			if( bo != null  ){
				sBelongAttribute[0] = bo.getAttribute( "BelongAttribute" ).toString(); if( sBelongAttribute[0] ==null ) sBelongAttribute[0] = "";
				sBelongAttribute[2] = bo.getAttribute( "BelongAttribute2" ).toString(); if( sBelongAttribute[2] ==null ) sBelongAttribute[2] = "";
			}
			if( ("1").equals(sBelongAttribute[0]) && ("1").equals(sBelongAttribute[2])) sAuthCode += "1";
			else sAuthCode += "0";
			
			/*����ɾ��Ȩ����ͬ����Ȩ*/
			sAuthCode += sAuthCode.charAt(1);
		//===============Ӱ���������ҵ��====================
		}else if( sObjectType.equals( "Business" ) ){
			/*��������Ȩ��ֻ��ҵ����δ�ύ�׶Σ����Խ���������*/
			bm =JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
			BizObjectQuery boq = bm.createQuery("Select O.PhaseNo From O, jbo.app.BUSINESS_APPLY BA, jbo.sys.FLOW_CATALOG FC" +
					" Where O.ObjectNo=:ObjectNo and O.ApplyType= BA.ApplyType and BA.SerialNo = O.ObjectNo" +
					" and O.FlowNo=FC.FlowNo and FC.InitPhase=O.PhaseNo").setParameter("ObjectNo",sObjectNo);
			if( boq.getTotalCount()  == 1 ){
				sAuthCode += "1";
			}else{
				sAuthCode += "0";
			}
		
			/*����ɾ��Ȩ��ͬ����Ȩ*/
			sAuthCode += sAuthCode.charAt( 1 );
		}
		return sAuthCode;
	}
	
	
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	} 
}
