<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "ʾ������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	
	//����������
	
	//���ҳ�����	
	String sBookType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType")); 
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));   
	if(sItemNo==null) sItemNo="";
	if(sBookType==null) sBookType="";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountCodeConfigInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sItemNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};

	%>

	<%@include file="/Resources/CodeParts/Info05.jsp"%>




	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		AsControl.OpenView("/Accounting/Config/AccountCodeConfigList.jsp","BookType=<%=sBookType%>", "_self","");
	}


	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=SystemConfig.getBusinessTime()%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
		setItemValue(0,0,"UpdateDate","<%=SystemConfig.getBusinessDate()%>");
	}

	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg(sOrgID,sOrgName)
	{
		setObjectValue("SelectAllOrg","","@"+sOrgID+"@0@"+sOrgName+"@1",0,0,"");		
	}
	
	
	function selectAllBookType(){
		//setMultiObjectTreeValue("SelectOIKOrgID","","@ItemAttribute@0@ItemAttributeName@1",0,0,"");
		setMultiObjectTreeValue("SelectAllBookType","","@BookType@0@BookTypeName@1",0,0,"");	
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"CodeNo","AccountCodeConfig");
		}
    }

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





<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	


<%@ include file="/IncludeEnd.jsp"%>
