<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: kfb  2005.03.10
 * Tester:
 *
 * Content: �����ɫȨ�޲���
 * Input Param:
 * Output param:
 *
 * History Log:
 *			
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%

	//��ȡ��������ɫ��š�ת��ǰ�ͻ������š�������ֵ��ת����ͻ������š�ת��ǰ�������
	String sRoleID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));	
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));	
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));	
	String sValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Value"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));	
	String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));		
   	
   	//�������
   	ASResultSet rs = null;	
	if (sValue == null)  sValue = "";
	int iCount = 0;
	String sReturnValue = "";
	String sSql = "";
	String sRoleStr = "";
	SqlObject so = null;
	String sNewSql = "";	
	//ת����־��Ϣ
	String sChangeReason = "��ɫת�Ʋ�����Ա����:"+CurUser.getUserID()+"   ������"+CurUser.getUserName()+"   �������룺"+CurOrg.getOrgID()+"   �������ƣ�"+CurOrg.getOrgName();
	String sInputDate   = StringFunction.getToday();
	
	//��ɫ�����û�
	if(sAction!=null && sAction.equals("UserRole"))
	{
		String sRole[] = StringFunction.toStringArray(sValue,"|");
		try{
					
					sSql = " select RoleID from USER_ROLE where UserID =:UserID ";
					rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sUserID));
					while(rs.next())
						sRoleStr = sRoleStr + "'" + rs.getString("RoleID") + "',";
					rs.getStatement().close();
					if(sRoleStr.length() > 0)
					{
						sRoleStr = sRoleStr.substring(0,sRoleStr.length() - 1);						
						sSql = " delete from USER_ROLE where UserID = :UserID and "+
					       	   " RoleID in :RoleStr ";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("UserID",sUserID).setParameter("RoleStr",sRoleStr));
						if (!sValue.equals(""))
						{
							for(iCount=0;iCount<sRole.length;iCount++)
							{	
								if (sRole[iCount]!="" )
								{
								   sSql = "select count(RoleID) from USER_ROLE where RoleID =:RoleID and UserID =:UserID ";
								   rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sToUserID).setParameter("RoleID",sRole[iCount]));
	
								   int num=0;
								   while(rs.next())
								   {	
									   num = rs.getInt(1);
								   }
								   rs.getStatement().close();
								   if (num<=0)
								   {
									    String sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
										sSql = "insert into USER_ROLE(RoleID,UserID,Grantor,BeginTime,Status,Remark)"+
												" values(:RoleID,:UserID,:Grantor,:BeginTime,'1','1')";
										so = new SqlObject(sSql);
										so.setParameter("RoleID",sRole[iCount]);
										so.setParameter("UserID",sToUserID);
										so.setParameter("Grantor",CurUser.getUserID());
										so.setParameter("BeginTime",sBeginTime);
										Sqlca.executeSQL(so);
								   }
								}
							}
						}
						//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
				        String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
				        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
				                " VALUES('TransferRole',:ObjectNo,:SerialNo,:OldOrgID,'','', "+
				                " '',:OldUserID,'','','',:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
				        so = new SqlObject(sSql);
				        so.setParameter("ObjectNo",sRoleID);
						so.setParameter("SerialNo",sSerialNo1);
						so.setParameter("OldOrgID",sFromOrgID);
						so.setParameter("OldUserID",sUserID);
						so.setParameter("ChangeReason",sChangeReason);
						so.setParameter("ChangeOrgID",CurOrg.getOrgID());
						so.setParameter("ChangeUserID",CurUser.getUserID());
						so.setParameter("ChangeTime",sInputDate);
				        Sqlca.executeSQL(so);
						Sqlca.commit();	
						sReturnValue = "TRUE";
					}
		   }catch(Exception e)
		   {
			  sReturnValue = "FALSE";
			  throw new Exception("��ɫת��������ʧ�ܣ�"+e.getMessage());
		   }	
	}

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>