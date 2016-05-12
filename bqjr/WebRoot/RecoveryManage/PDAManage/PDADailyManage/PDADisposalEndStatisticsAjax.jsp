<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-16
 * Tester:
 *
 * Content:  
 * Input Param:
 *		ObjectNo�������� 
 *		ObjectType: ��������
 * Output param	��ͳ�ƽ����
 *
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); //�ʲ���ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	//�������
	String sSql = "";
	String sReturnValue="";
	double  dSum1 = 0;//ͳ���ۼƳ�����ս��
	double  dSum2 = 0;//ͳ���ۼƳ��ۻ��ս��
	double  dSum3 = 0;//ͳ���ۼƷ���֧���ܶ�
	double  dSum4 = 0;//ͳ�ƴ�������
	ASResultSet rs = null;
	SqlObject so = null;

 	//ͳ���ۼƳ�����ս��:�����
	sSql = 	" select sum(RMBSum) as my_Sum  from RECLAIM_INFO "+
			" where  ObjectNo = :ObjectNo "+
			" and ObjectType = :ObjectType "+
			" and CashBackType = '01' ";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
	rs = Sqlca.getASResultSet(so);
	if (rs.next())
		dSum1=rs.getDouble(1);	
	rs.getStatement().close(); 
 	
 	//ͳ���ۼƳ��ۻ��ս��:�����
	sSql = 	" select sum(RMBSum) as my_Sum  from RECLAIM_INFO "+
			" where ObjectNo = :ObjectNo "+
			" and ObjectType = :ObjectType "+
			" and CashBackType in ('02','03','04','05') ";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
	rs = Sqlca.getASResultSet(so);
	if (rs.next())
		dSum2=rs.getDouble(1);
	rs.getStatement().close(); 
 	
 	//ͳ���ۼƷ���֧���ܶ�:�����
	sSql = 	" select sum(CostSum) as my_Sum from COST_INFO "+
			" where  ObjectNo = :ObjectNo "+
			" and ObjectType = :ObjectType "+
			" and AccountDesc <> '02' ";//��������ΪӪҵ��֧���ķ���.
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
	rs = Sqlca.getASResultSet(so);
	if (rs.next())
	  	dSum3=rs.getDouble(1);
	rs.getStatement().close(); 

   	//ͳ�ƴ�������
	dSum4=dSum1+dSum2-dSum3;	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(dSum1+"");
	args.addArg(dSum2+"");
	args.addArg(dSum3+"");
	args.addArg(dSum4+"");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>