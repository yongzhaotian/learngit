<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�û�����ʱ����־"; // ��������ڱ��� <title> PG_TITLE </title>

	//���ҳ��������û���
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	if(sUserID == null) sUserID = "";
                      
	String sHeaders[][] = {
								{"ListID","���"},
								{"UserID","�û���"},
								{"UserName","�û�����"},
								{"OrgID","������"},
								{"OrgName","��������"},
								{"BeginTime","��ʼ����ʱ��"},
								{"EndTime","�˳�ϵͳʱ��(��ֵ��ʾ���߻��쳣�˳�)"},
							}; 

 	String sSql = "select SessionID,UserID,UserName,OrgID,OrgName,BeginTime,EndTime from USER_LIST where UserId='"+sUserID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);	
	doTemp.UpdateTable = "USER_LIST";
	doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID",false);	
	
	doTemp.setHTMLStyle("UserName"," style={width:120px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("UserID,OrgID"," style={width:60px} ");
	
	//doTemp.setCheckFormat("BeginTime,EndTime","3");
	//���ɲ�ѯ��
	//doTemp.setColumnAttribute("UserName,OrgID,OrgName,BeginTime,EndTime","IsFilter","1");
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!doTemp.haveReceivedFilterCriteria()) 
	//    doTemp.WhereClause+=" and BeginTime like '"+StringFunction.getToday()+"%' and EndTime is null ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(40); //��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","PlainText","���ڱ�ҳ��������������ͨ����ѯ������ѯ","���ڱ�ҳ��������������ͨ����ѯ������ѯ","style={color:red}",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@include file="/IncludeEnd.jsp"%>