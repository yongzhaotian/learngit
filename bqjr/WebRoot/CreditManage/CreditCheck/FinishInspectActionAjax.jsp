<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat" %>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: ������ɲ���
		Input Param:
			                sSerialNo: ��ˮ��
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<%
	String sSql;
	boolean bFinishFlag=false;
	String sFinishType="";
	ASResultSet rs = null;
	SqlObject so = null;
	String sReturnValue="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));

	//����Ǵ�����;����
	if(sObjectType.equals("BusinessContract"))
	{
		//���ñ�����������¼
		sSql= "select count(*) as c from INSPECT_DETAIL where itemtype='01' and SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
		rs = Sqlca.getResultSet(so);
		int count1=0,count2=0;
		if(rs.next())
		{
			count1=rs.getInt("c");
		}
		rs.getStatement().close();
		
		//���ñ��������ÿ��¼
		sSql= "select count(*) as c from INSPECT_DETAIL where itemtype='02' and SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
		rs = Sqlca.getResultSet(so);
		if(rs.next())
		{
			count2=rs.getInt("c");
		}
		rs.getStatement().close();
		
		//����������ֶ��м�¼�������ɸñ���
		if(count1>0 && count2>0)
			bFinishFlag=true;
		else
			bFinishFlag=false;

		if(bFinishFlag)
		{
			sSql = "update INSPECT_INFO set finishdate=:finishdate,UpdateDate=:UpdateDate"+
			" where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
			so = new SqlObject(sSql).setParameter("finishdate",StringFunction.getToday())
			.setParameter("UpdateDate",StringFunction.getToday()).setParameter("SerialNo",sSerialNo)
			.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
			Sqlca.executeSQL(so);
		}
		sFinishType="Purpose";
	}
	//�����鱨�棬
	else if(sObjectType.equals("Customer"))
	{
		String sBeforDay="";
		String sToday="";
		sToday=StringFunction.getToday();
		sBeforDay=StringFunction.getRelativeDate(sToday,-10);//���10��ǰ������
		
		//��10�����������շ����Ĳ�����ɼ�鱨��
		sSql="select count(*) as ClassifyCount from CLASSIFY_RECORD where FinishDate > :FinishDate and FinishDate <= :FinishDate and UserId=:UserId and ObjectNo in(select serialno from business_contract where customerid=:customerid)";
		//out.println(sSql);
		so = new SqlObject(sSql).setParameter("FinishDate",sBeforDay).setParameter("FinishDate",sToday)
		.setParameter("UserId",CurUser.getUserID()).setParameter("customerid",sObjectNo);
		rs = Sqlca.getResultSet(so);
		if(rs.next())
		{
			int count=rs.getInt("ClassifyCount");
			//out.println(count);
			if(count>0)
				bFinishFlag=true;
			else
				bFinishFlag=false;
		}
		rs.getStatement().close();
		
		//������ɼ���������ڲ��Թ������ȥ��
		bFinishFlag=true;
		//----------------end---------------

		if(bFinishFlag)
		{
			if(sObjectType.equals("BusinessContract")){
				sSql = "update INSPECT_INFO set finishdate=:finishdate,UpdateDate=:UpdateDate,InspectType = '010020'"+
			   			" where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
				so = new SqlObject(sSql).setParameter("finishdate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday())
		   		.setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
			}else if(sObjectType.equals("Customer")){
				sSql = "update INSPECT_INFO set finishdate=:finishdate,UpdateDate=:UpdateDate,InspectType = '020020'"+
	   			" where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
				so = new SqlObject(sSql).setParameter("finishdate",StringFunction.getToday())
				.setParameter("UpdateDate",StringFunction.getToday()).setParameter("SerialNo",sSerialNo)
		   		.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
			}
			Sqlca.executeSQL(so);
		}
		sFinishType="Inspect";
	}
	
	if(bFinishFlag){
		sReturnValue="finished";
	}else{
		if("Purpose".equals(sFinishType))
			sReturnValue="Purposeunfinish";
		if("Inspect".equals(sFinishType))
			sReturnValue="Inspectunfinish";
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