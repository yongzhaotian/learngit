<%@page import="org.apache.tomcat.util.digester.SetPropertiesRule"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content: 客户信息检查
		Input Param:
			CustomerType：客户类型
					01：公司客户；
					0201：一类集团客户；
					0202：二类集团客户（系统暂时不用）；
					03：个人客户；
			CustomerName:客户名称
			CertType:客户证件类型
			CertID:客户证件号码
		Output param:
  			ReturnStatus:返回状态
				01为无该客户
				02为当前用户以与该客户建立关联
				04为当前用户没有与该客户建立关联,且没有和任何客户建立主办权.
				05为当前用户没有与该客户建立关联,且有和其他客户建立主办权.
	 */
	//定义变量：Sql语句、返回信息、客户代码、主办权
	String sSql = "",sReturnStatus = "",sCustomerID = "",sBelongAttribute = "";
	String sCustomerType = "",sStatus = "",sUserID = "";
	//定义变量：计数器
	int iCount = 0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获取页面参数：客户类型、客户名称、证件类型、证件编号
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));	
	String sCertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));	
	String sRelativeSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeSerialNo"));
	//将空值转化为空字符串
	if(sCustomerName == null) sCustomerName = "";
	if(sRelativeSerialNo == null) sRelativeSerialNo = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";	
		
	sSql = " select CustomerID,CustomerType,Status "+
			" from CUSTOMER_INFO "+
			" where CertType = :CertType and CertID = :CertID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID));
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sCustomerType = rs.getString("CustomerType");
		sStatus = rs.getString("Status");
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";
	if(sStatus == null) sStatus = "";
	
	if(sCustomerID.equals("")){
		//系统中无该客户，请确认录入的机构代码是否正确
		sReturnStatus = "01";
	}else{
		//得到当前用户与该客户之间主办权的关系
		sSql = 	" select UserID "+
				" from CUSTOMER_BELONG "+
				" where CustomerID = :CustomerID "+
				" and BelongAttribute = '1'";
		sUserID = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		if(sUserID == null) sUserID = "";
		if(sUserID.equals(CurUser.getUserID()) || sUserID.equals("")){
			if(!sCustomerType.equals("0120")){
				sReturnStatus = "02";//该客户类型不是中小企业类型。
			}else{
				//1代表已认定的中小企业，8代表个人经营户企业
				if(sStatus.equals("1")){
					sReturnStatus = "03";//引入中小企业类型
				}else if(sStatus.equals("8")){
					if(sUserID.equals(CurUser.getUserID()))
						sReturnStatus = "04";//该个人经营户已存在
					if(sUserID.equals(""))
						sReturnStatus = "05";//取得该客户的管户权即可
				}else{
					sReturnStatus = "06";//该中小企业类型未经认定
				}
			}
		}else{
			sReturnStatus = "07";//该客户与当前用户没有主办权关系
		}		
	}
	
	//针对状态"03"、"05"进行引入操作
	if(sReturnStatus.equals("03")){
		//计算未终结申请业务数
		sSql = " select count(SerialNo) from BUSINESS_APPLY "+
			   " where CustomerID = :CustomerID "+
		       " and PigeonholeDate is null "+
		       " and OperateUserID = :OperateUserID " ;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
		if(rs.next()) iCount = rs.getInt(1);
		rs.getStatement().close(); 		
		if (iCount == 0){	//申请业务全部终结
			//计算未终结最终审批意见业务数
			sSql = " select count(*) from BUSINESS_APPROVE "+
			   " where CustomerID = :CustomerID "+
		       " and PigeonholeDate is null "+
		       " and OperateUserID = :OperateUserID " ;
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
			if(rs.next()) iCount = rs.getInt(1);
			rs.getStatement().close();
			if(iCount == 0){	//最终审批意见业务全部终结
				//计算未终结合同业务数
				sSql = " select count(*) from BUSINESS_CONTRACT "+
					   " where CustomerID = :CustomerID "+
				       " and FinishDate is null "+
				       " and ManageUserID = :ManageUserID " ;
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("ManageUserID",sUserID));
				if(rs.next()) iCount = rs.getInt(1);
				rs.getStatement().close();
				if (iCount == 0){	//合同业务全部终结
					if(sUserID.equals("")){
						//增加管户权
						String sNewSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
										 " BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
										 " values(:CustomerID,:OrgID,:UserID,'1','1','1','1','1',:InputOrgID, "+
										 " :InputUserID,:InputDate,:UpdateDate)";
						SqlObject so = new SqlObject(sNewSql);
						so.setParameter("CustomerID",sCustomerID);
						so.setParameter("OrgID",CurOrg.getOrgID());
						so.setParameter("UserID",CurUser.getUserID());
						so.setParameter("InputOrgID",CurOrg.getOrgID());
						so.setParameter("InputUserID",CurUser.getUserID());
						so.setParameter("InputDate",StringFunction.getToday());
						so.setParameter("UpdateDate",StringFunction.getToday());
						Sqlca.executeSQL(so);
					}
					if(sUserID.equals(CurUser.getUserID())){
						//更新中小企业标志号
						sSql = " update CUSTOMER_INFO set Status = '8' where CustomerID = :CustomerID";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));						
					}
					//删除该客户与其他的关联，保证唯一
					sSql = "delete from SME_CUSTRELA where CustomerID=:CustomerID";
					Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
					//增加关联
					sSql = 	" insert into SME_CUSTRELA(CustomerID,RelativeSerialNo,ObjectType) "+
							" values(:CustomerID,:RelativeSerialNo,'Customer')";
					Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("RelativeSerialNo",sRelativeSerialNo));
					//更新成功
					sReturnStatus = "09";
				}else{
					sReturnStatus = "10";//该客户存在未终结的合同信息
				}
			}else{
				sReturnStatus = "11";//该客户存在未完成的最终审批意见
			}
		}else{
			sReturnStatus = "12";//该客户存在未完成的业务申请
		}
	}
	if(sReturnStatus.equals("05")){
		//增加管户权
		sSql = 	" insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				" values(:CustomerID,:OrgID,:UserID,'1','1','1','1','1',:InputOrgID, "+
				" :InputUserID,:InputDate,:UpdateDate)";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("OrgID",CurOrg.getOrgID());
		so.setParameter("UserID",CurUser.getUserID());
		so.setParameter("InputOrgID",CurOrg.getOrgID());
		so.setParameter("InputUserID",CurUser.getUserID());
		so.setParameter("InputDate",StringFunction.getToday());
		so.setParameter("UpdateDate",StringFunction.getToday());
		Sqlca.executeSQL(so);
		//删除该客户与其他的关联，保证唯一
		sSql = "delete from SME_CUSTRELA where CustomerID=:CustomerID";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		//增加关联
				/*" values('"+sCustomerID+"','"+sRelativeSerialNo+"','Customer')";*/
		sSql = 	" insert into SME_CUSTRELA(CustomerID,RelativeSerialNo,ObjectType) "+
				" values(:CustomerID,:RelativeSerialNo,'Customer')";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("RelativeSerialNo",sRelativeSerialNo));
		sReturnStatus = "09";//更新成功
	}
	out.println(sReturnStatus);//返回检查状态值和客户号
%><%@ include file="/IncludeEndAJAX.jsp"%>