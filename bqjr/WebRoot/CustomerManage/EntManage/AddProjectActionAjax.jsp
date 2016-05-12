<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* 
  Tester:
  Content:  ������Ŀ����
  Input Param:
			ObjectType  ����������
			ObjectNo:   : ������
			ProjectType : ��Ŀ����
			ProjectName : ��Ŀ����
  Output param:
 			sProjectNo  :��Ŀ���
 
  History Log:     
      DATE	  CHANGER		CONTENT
      2005-7-25 fbkang     ����ע��
       2005/09/13 zywei ����������         
 */
 %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>

<%     	
    //�������
   	String sSql = "",sReturnValue="";
    //���ҳ�����
	String sObjectType     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo       =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sProjectType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectType"));
	String sProjectName    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectName"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sProjectType == null) sProjectType = "";
	if(sProjectName == null) sProjectName = "";
   //����������

	//��ʼ����Ŀ���
    String sProjectNo  = DBKeyHelp.getSerialNo("PROJECT_INFO","ProjectNo",Sqlca);
 %>
<%/*~END~*/%>	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=ִ��sql����*/%>    
<%
	try {
	   	//������Ŀ���Ͽ�
	    sSql = " insert into PROJECT_INFO(ProjectNo,InputUserID,InputOrgID,InputDate,UpdateDate,ProjectType,ProjectName) " +
 	   " values(:ProjectNo,:InputUserID,:InputOrgID,:InputDate,:UpdateDate,:ProjectType,:ProjectName)" ;
	    SqlObject so = new SqlObject(sSql);
	    so.setParameter("ProjectNo",sProjectNo);
	    so.setParameter("InputUserID",CurUser.getUserID());
	    so.setParameter("InputOrgID",CurOrg.getOrgID());
	    so.setParameter("InputDate",StringFunction.getToday());
	    so.setParameter("UpdateDate",StringFunction.getToday());
	    so.setParameter("ProjectType",sProjectType);
	    so.setParameter("ProjectName",sProjectName);
	    Sqlca.executeSQL(so);    
   
	   	//������Ŀ���������
	    sSql = " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) " +
 	  		   " values(:ProjectNo,:ObjectType,:ObjectNo)";
	    so = new SqlObject(sSql);
	    so.setParameter("ProjectNo",sProjectNo);
	    so.setParameter("ObjectType",sObjectType);
	    so.setParameter("ObjectNo",sObjectNo);
	    Sqlca.executeSQL(so);
	}catch(Exception e)
	{
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}
%>
<%/*~END~*/%>	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main04;Describe=���ز���*/%>  

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sProjectNo);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>