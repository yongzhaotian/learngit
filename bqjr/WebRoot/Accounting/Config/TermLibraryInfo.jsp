<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "ҵ�������ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>//20100803 ltma
%>


<%
	String termID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	if(termID == null)
	{
		termID = "";
	}
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType == null)
	{
		objectType = "Term";
	}
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo == null)
	{
		objectNo = termID;
	}
	String termType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermType"));
	if(termType == null)
	{
		termType = "";
	}
	
	String parameterCount = Sqlca.getString("select count(*) from PRODUCT_TERM_PARA "
	                               +" where ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"' and TermID = '"+termID+"'");
	
	String sTempletNo = "TermLibraryInfo";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(sTempletNo,sTempletFilter,Sqlca));
	if(termID.length()>0) dwTemp.DataObject.setReadOnly("TermID,TermType", true);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(termID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
	};
%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>
	function saveRecord(){
	    var termID = getItemValue(0,getRow(),"TermID");
	    if(typeof(termID)=="undefined" || termID.length==0)return;
	    setItemValue(0,0,"ObjectNo",termID);
		var existsFlag = RunMethod("PublicMethod","GetColValue","1,PRODUCT_TERM_LIBRARY,String@ObjectType@Term~String@TermID@"+termID);
		if(existsFlag =="1")
		{
			alert("�������ظ�����ȷ�ϣ�");
			return;
		}
		if(confirm('ȷ��������')){//20100806 ltma:�������ݿⱣ��ʱ�����޸���ȷ��
			
			//���·������������ 20121126 dxu1
			var TermName = getItemValue(0,getRow(),"TermName");
			if(typeof(TermName) !="undefined" && TermName.length !=0)
		    {
				RunMethod("ProductManage","UpdateTermName",termID+","+TermName);
		    }
			as_save("myiframe0","open_self();");
		}
	}
	
	function open_self(){
		var termID = getItemValue(0,getRow(),"TermID");
		AsControl.OpenView("/Accounting/Config/TermLibraryInfo.jsp","ObjectNo="+termID+"&ObjectType=Term&TermID="+termID,"_self",OpenStyle);
	}

	function OpenSubPage(){
		var setFlag = getItemValue(0,getRow(),"SetFlag");
		if(typeof(setFlag)=="undefined" || setFlag.length==0) return;
		AsControl.OpenView("/Accounting/Config/TermItemList.jsp","TermID=<%=termID%>&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","ParameterList","");
		if("<%=termID%>".length>0){
			if(<%=Integer.parseInt(parameterCount)%> > 0){
				if(setFlag=="BAS"||setFlag=="SEG"){
					frames['myiframe0'].document.getElementById('ContentFrame_TermParaView').style.display="";
					AsControl.OpenView("/Accounting/Config/TermParaView.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&TermID=<%=termID%>","TermParaView","");
				}
			}
		}
		AsControl.OpenView("/Accounting/Config/TermRelativeView.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&TermID=<%=termID%>","TermRelativeView","");
	}

function initRow(){
		if (getRowCount(0)==0) {//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"TermType","<%=termType%>");
			setItemValue(0,0,"ObjectType","<%=objectType%>");
			setItemValue(0,0,"ObjectNo","<%=objectNo%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
		else{
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");	
		}
		OpenSubPage();
    }
</script>

<script language=javascript>
		AsOne.AsInit();
		init();
		var bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
