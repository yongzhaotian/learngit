<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
%>

<script language=javascript>
	function setMultiObjectTreeValue(sObjectType,sParaString,sValueString,iArgDW,iArgRow,sStyle)
	{
		if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var iDW = iArgDW;
		if(iDW == null) iDW=0;
		var iRow = iArgRow;
		if(iRow == null) iRow=0;
	
		var sValues = sValueString.split("@");
	
		var i=sValues.length;
	 	i=i-1;
	 	if (i%2!=0)
	 	{
	 		alert("setObjectValue()���ز����趨����!\r\n��ʽΪ:@ID����@ID�ڷ��ش��е�λ��...");
		return;
	 	}else
		{	
			var treeValueList="";
			var j=i/2,m,sColumn,iID;	
			for(m=1;m<=j;m++)
			{
				sColumn = sValues[2*m-1];
				iID = parseInt(sValues[2*m],10);
				
				if(sColumn!="")
					treeValueList+=","+getItemValue(iDW,iRow,sColumn);
			}
			
			sObjectNoString =  selectMultipleTree(sObjectType,sParaString,sStyle,treeValueList);
			
			if(typeof(sObjectNoString)=="undefined" )
			{
				return;	
			}else if(sObjectNoString=="_CANCEL_"  )
			{
				return;
			}else if(sObjectNoString=="_CLEAR_")
			{
				for(m=1;m<=j;m++)
				{
					sColumn = sValues[2*m-1];
					if(sColumn!="")
						setItemValue(iDW,iRow,sColumn,"");
				}	
			}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined")
			{
				sObjectNos = sObjectNoString.split("@");
				for(m=1;m<=j;m++)
				{
					sColumn = sValues[2*m-1];
					iID = parseInt(sValues[2*m],10);
					
					if(sColumn!="")
						setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
				}	
			}else
			{
				//alert("ѡȡ������ʧ�ܣ��������ͣ�"+sObjectType);
				return;
			}
			return sObjectNoString;
		}	
	}

	function selectMultipleTree(sObjectType,sParaString,sStyle,sValue)
	{
		if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		if(typeof(sValue)=="undefined" || sValue=="") sValue = "";
		sObjectNoString = AsControl.PopView("/Accounting/Config/MultiSelectTreeViewDialog.jsp","SelectedValue="+sValue+"&SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
		return sObjectNoString;
	}
</script>


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
		objectNo = "";
	}
	
	ASDataWindow dwTemp=com.amarsoft.app.accounting.web.ProductTermView.createTermDataWindow(objectType, objectNo, termID, Sqlca, CurPage);
	ASDataObject doTemp = dwTemp.DataObject;
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","����","updateParaValues()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0","updateParaValues();");
	}

	function updateParaValues(){
		var paraList="ObjectType=<%=objectType%>&VersionID=<%=objectNo%>&TermID=<%=termID%>";
<%
		for(int i=0;i<doTemp.Columns.size();i++){
			String paraname = doTemp.getColumnAttribute(i, "Name");
%>
			var s=getItemValue(0,getRow(),"<%=paraname%>");
			
			if(typeof(s) != "undefined" ){
				s=real2Amarsoft(s);
				paraList = paraList+"&<%=paraname%>="+s;
			}
<%
		}
%>		
		//modify end
		var result =PopPage("/Accounting/Config/TermParaSaveAction.jsp?"+paraList,"","dialogWidth=60;dialogheight=25;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		alert(result);//parent.reloadSelf(1);
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	
	var obj = parent.document.getElementById('TermParaView');
	if(typeof(obj) != "undefined" && obj != null)
	{
		obj.style.height = ((DZ[0][1].length/2)*18+25)+"%";
	}
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
