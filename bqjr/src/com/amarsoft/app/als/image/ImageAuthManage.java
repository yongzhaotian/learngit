package com.amarsoft.app.als.image;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/*权限位定义：jqcao，2013.11.25
 * 1、权限字符串 包含3位字符 “000”，其中“1”表示有该权限，“0”表示无该权限
 * 2、第一位 表示： 查看权
 * 3、第二位 表示： 新增权
 * 4、第三位 表示： 删除权
 * */

public class ImageAuthManage {
	public String objectNo = "";
	public String objectType = "";
	public String userID = "";
	
	public static String getAuthCode( String sObjectType, String sObjectNo, String sUserID ) throws JBOException{
		String sAuthCode = "";
		BizObjectManager bm = null;
		/*默认所有客户都有查看权*/
		sAuthCode += "1";
		//===============影像对象属于客户====================
		if( sObjectType.equals( "Customer" ) ){
			String sBelongAttribute[] = new String[4];
			
			/*处理新增权：拥有以下权限的用户具有新增权：主办权、维护权*/
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
			BizObject bo = bm.createQuery("CustomerID=:CustomerID and UserID=:UserID")
					.setParameter("CustomerID",sObjectNo).setParameter("UserID",sUserID).getSingleResult( false );
			if( bo != null  ){
				sBelongAttribute[0] = bo.getAttribute( "BelongAttribute" ).toString(); if( sBelongAttribute[0] ==null ) sBelongAttribute[0] = "";
				sBelongAttribute[2] = bo.getAttribute( "BelongAttribute2" ).toString(); if( sBelongAttribute[2] ==null ) sBelongAttribute[2] = "";
			}
			if( ("1").equals(sBelongAttribute[0]) && ("1").equals(sBelongAttribute[2])) sAuthCode += "1";
			else sAuthCode += "0";
			
			/*处理删除权：暂同新增权*/
			sAuthCode += sAuthCode.charAt(1);
		//===============影像对象属于业务====================
		}else if( sObjectType.equals( "Business" ) ){
			/*处理新增权：只有业务处于未提交阶段，可以进行新增。*/
			bm =JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
			BizObjectQuery boq = bm.createQuery("Select O.PhaseNo From O, jbo.app.BUSINESS_APPLY BA, jbo.sys.FLOW_CATALOG FC" +
					" Where O.ObjectNo=:ObjectNo and O.ApplyType= BA.ApplyType and BA.SerialNo = O.ObjectNo" +
					" and O.FlowNo=FC.FlowNo and FC.InitPhase=O.PhaseNo").setParameter("ObjectNo",sObjectNo);
			if( boq.getTotalCount()  == 1 ){
				sAuthCode += "1";
			}else{
				sAuthCode += "0";
			}
		
			/*处理删除权：同新增权*/
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
