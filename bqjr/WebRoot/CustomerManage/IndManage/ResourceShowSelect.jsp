<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-12
		Tester:
		Describe: ���������������Ӧ�������ĵ�����Ϣ�б�һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
				ObjectType���������ͣ�ApproveApply��
				ObjectNo: �����ţ��������������ˮ�ţ�
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ˮ����Ϣ����ͼ��չ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	ASResultSet rs =null;
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	
	String hValue1 ="",vValue1 ="",sAddValue1 = "",hValue2 ="",vValue2 ="",sAddValue2 = "",sResourceType = "";
	sSql = "select ResourceType,ConsumeAmount,AccountMonth from SME_CONSINFO "+
		" where ObjectType=:ObjectType and ObjectNo=:ObjectNo and ResourceType in('010','020') order by ResourceType,AccountMonth";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo));
	while(rs.next()){
		sResourceType = rs.getString("ResourceType");
		if(sResourceType.equals("010")){	//ˮ��
			hValue1 += rs.getString("AccountMonth")+"@";
			vValue1 += rs.getDouble("ConsumeAmount")+"@";
		}
		else if(sResourceType.equals("020")){//���
			hValue2 += rs.getString("AccountMonth")+"@";
			vValue2 += rs.getDouble("ConsumeAmount")+"@";
		}
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>


<HEAD>
	<title><%=PG_TITLE%></title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onload="" style="overflow:auto" oncontextmenu="return true">
<form name="form0">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr height="1%" valign=top id=mytop >
		<td>
			<table width="100%" >
			<tr>
				<td align=left>
						ѡȡͼ��չ�ַ�ʽ��
						<select name="GraphType">
							<option value=0 >��״ͼ</option>
							<option value=6 >����ͼ</option>
						</select>
				</td>
				<td align=left>
						չ�����ݣ�
					<select name="ResourceType">
						<%=HTMLControls.generateDropDownSelect(Sqlca," select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ResourceType' and ItemNo in('010','020') and IsInUse = '1' order by SortNo ",1,2,"")%> 
				    </select>
				</td>
				<td align=left>
					<%=HTMLControls.generateButton("ͼ��չ��","ͼ��չ��","javascript:graphShow();",sResourcesPath)%>
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr id=mydown> 
	    <td> 
		<div id=divDrag title='չ����Ϣ' ondrag="dragFrame(event);"><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
			<iframe name="rightdown" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=��ѡ���������Ϣ" width=100% height=100% frameborder=0></iframe> 
	    </td>
	</tr>
</table>
</form>
</body>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	mytop.height=1;
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function dragFrame(event) {
		if(event.y>100 && event.y<800) { 
			mytop.height=event.y-10;
		}
		if(event.y<100) {
			window.event.returnValue = false;
		}
	}
    /*~[Describe=��ͼ����ʾ;InputParam=�����¼�;OutPutParam=��;]~*/
    function graphShow()
    {
		sGraphType = form0.GraphType.value;
		sResourceType = form0.ResourceType.value;
		if(sResourceType=="010")
		{
			sItemName = "ˮ��";
			sCaption = "��";
			hValue = "<%=hValue1%>";
			vValue = "<%=vValue1%>";
		}else if(sResourceType=="020")
		{
			sItemName = "���";
			sCaption = "ǧ��ʱ/��";
			hValue = "<%=hValue2%>";
			vValue = "<%=vValue2%>";
		}
		if (typeof(hValue)=="undefined" || hValue.length==0) 
		{
			alert("���ݲ��������޷�չ�֣�");
			return;
		}
		hValue = hValue.substr(0,hValue.length-1);
		vValue = vValue.substr(0,vValue.length-1);
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-120;
		//alert("sItemName:"+sItemName+"  hValue:"+hValue+"  vValue:"+vValue+"  sGraphType:"+sGraphType);
    	OpenPage("/CustomerManage/IndManage/ResourceGraph.jsp?GraphType="+sGraphType+"&ItemName="+sItemName+"&Caption="+sCaption+"&vValue="+vValue+"&hValue="+hValue+"&ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&rand="+randomNumber(),"rightdown","");
    }
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>