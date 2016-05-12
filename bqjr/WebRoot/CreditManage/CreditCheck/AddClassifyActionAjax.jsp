<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   zywei 2005/09/09
 * Tester:
 *
 * Content:   �����ʲ����շ�����Ϣ
 * Input Param:
 *		AccountMonth������·�
 *		ObjectType����������
 *		ObjectNo��������
 *		ModelNo��ģ�ͺ�
 * Output param:
 * History Log:  
 *	      
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	//���������Sql���
	String sSql = "";
	//���������������ˮ��
	String sSerialNo = "";
	//������������
	double dBalance = 0.0;
	//�����������ѯ�����
	ASResultSet rs = null;
	SqlObject so = null;
	String sReturnValue="";
	
	//��ȡҳ�����������·ݡ��������͡������š����͡�ģ�ͺ�
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo")); 
	
	//����ֵת��Ϊ���ַ���
	if(sAccountMonth == null) sAccountMonth = ""; 
	if(sObjectType == null) sObjectType = ""; 
	if(sObjectNo == null) sObjectNo = ""; 
	if(sType == null) sType = ""; 
	if(sModelNo == null) sModelNo = ""; 
	
	//���ݶ����������������
	String sTableName = "";
	if(sObjectType.equals("BusinessContract"))
	{
		sTableName = "BUSINESS_CONTRACT";
	}			
	if(sObjectType.equals("BusinessDueBill"))
	{
		sTableName = "BUSINESS_DUEBILL";
	}
	
	try
	{	
		//�������������
		if(sType.equals("Batch"))
		{
			String sObjectNo1 = sTableName+".SerialNo";
			sSql = 	" select SerialNo,nvl(Balance,0) as Balance "+
					" from "+sTableName+" "+
					" where not exists (select 1 "+
					" from CLASSIFY_RECORD "+
					" where ObjectType =:ObjectType "+
					" and AccountMonth =:AccountMonth and ObjectNo=:ObjectNo) "+
					" and Balance > 0 ";
			so = new SqlObject(sSql);
			so.setParameter("ObjectType",sObjectType).setParameter("AccountMonth",sAccountMonth).setParameter("ObjectNo",sObjectNo1);
			rs = Sqlca.getASResultSet(so);
			while(rs.next())
			{
				sObjectNo = rs.getString("SerialNo");
				dBalance = rs.getDouble("Balance");
				//����ʲ����շ�����ˮ��
				sSerialNo = DBKeyHelp.getSerialNo("CLASSIFY_RECORD","SerialNo",Sqlca);
				//�����ʲ����շ�����Ϣ	
				sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
					   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate)"+		
					   	" values(:SerialNo,:ObjectType,:ObjectNo,:AccountMonth,:ModelNo,:BusinessBalance,"+
					   	" :Sum1,:Sum2,:Sum3,:Sum4,:Sum5,:UserID,:OrgID,:InputDate,:ClassifyDate,"+
					   	" :UpdateDate) ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo",sSerialNo).setParameter("ObjectType",sObjectType)
				.setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth)
				.setParameter("ModelNo",sModelNo).setParameter("BusinessBalance",dBalance)
				.setParameter("Sum1",0.00).setParameter("Sum2",0.00).setParameter("Sum3",0.00).setParameter("Sum4",0.00)
				.setParameter("Sum5",0.00).setParameter("UserID",CurUser.getUserID()).setParameter("OrgID",CurOrg.getOrgID()).setParameter("InputDate",StringFunction.getToday())
				.setParameter("ClassifyDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());			
				Sqlca.executeSQL(so);		    	
				    				
				sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
						" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
		        		" ItemNo from EVALUATE_MODEL where ModelNo =:ModelNo ";
				so = new SqlObject(sSql);
				so.setParameter("ModelNo",sModelNo);
				Sqlca.executeSQL(so);
			}
			rs.getStatement().close();			
		}else
		{
			//��ѯ��ͬ/��ݵ����
			sSql = 	" select Balance "+
					" from "+sTableName+" "+
					" where SerialNo =:SerialNo ";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo",sObjectNo);
			rs = Sqlca.getASResultSet(so);
			if(rs.next())
				dBalance = rs.getDouble("Balance");
	
			rs.getStatement().close();
			
			//����ʲ����շ�����ˮ��
			sSerialNo = DBKeyHelp.getSerialNo("CLASSIFY_RECORD","SerialNo",Sqlca);
			//�����ʲ����շ�����Ϣ	
			sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
				   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate)"+		
				   	" values(:SerialNo,:ObjectType,:ObjectNo,:AccountMonth,:ModelNo,:BusinessBalance,"+
				   	" :Sum1,:Sum2,:Sum3,:Sum4,:Sum5,:UserID,:OrgID,:InputDate,:ClassifyDate,"+
				   	" :UpdateDate) ";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo",sSerialNo).setParameter("ObjectType",sObjectType)
				.setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth)
				.setParameter("ModelNo",sModelNo).setParameter("BusinessBalance",dBalance)
				.setParameter("Sum1",0.00).setParameter("Sum2",0.00).setParameter("Sum3",0.00).setParameter("Sum4",0.00)
				.setParameter("Sum5",0.00).setParameter("UserID",CurUser.getUserID()).setParameter("OrgID",CurOrg.getOrgID()).setParameter("InputDate",StringFunction.getToday())
				.setParameter("ClassifyDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());			
			Sqlca.executeSQL(so);	    	
			    				
			sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
			" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
    		" ItemNo from EVALUATE_MODEL where ModelNo =:ModelNo ";
			so = new SqlObject(sSql);
			so.setParameter("ModelNo",sModelNo);
			Sqlca.executeSQL(so);
		}
	}catch(Exception e)
	{
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}    	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sSerialNo);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>
