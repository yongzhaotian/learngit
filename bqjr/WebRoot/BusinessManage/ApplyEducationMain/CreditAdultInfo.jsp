<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ������Ϣ����
	 */
	String PG_TITLE = "������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ContractInfo300028";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
	
	//doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()",sResourcesPath},
		     {"true","","Button","����","���ص��б����","doReturn()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
			/*****************�������ܶ�==����ÿ���ṩ�����+��������*********/
		    var monthly_income_total=0;
			var monthly_income_payments=getItemValue(0,getRow(),"monthly_income_payments");
			var monthly_income_Other=getItemValue(0,getRow(),"monthly_income_Other");
			monthly_income_total=parseInt(monthly_income_payments)+parseInt(monthly_income_payments)
   			if(monthly_income_total){
	   			 if(!isNaN(monthly_income_total)){ 
					setItemValue(0,0,"monthly_income_total",monthly_income_total);
	   			 }
   			}

       		as_save("myiframe0","");
	}
	
	function checkOrgSortNo(){
		var sSortNo=getItemValue(0,getRow(),"SortNo");
		if(!(typeof(sSortNo) == "undefined" || sSortNo.length==0)){
			var Return=RunMethod("BusinessManage","checkOrgUnique",sSortNo);
			if(Return!=0){
				alert("������Ѵ��ڣ����������룡");
				setItemValue(0,0,"SortNo","");
			}
			
		}
		
	}
    
	function doReturn(){
		if(parent.reloadView){
			parent.reloadView();
		}else{
			OpenPage("/AppConfig/OrgUserManage/OrgList.jsp","_self","");
		}
	}

	<%/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;]~*/%>
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"updateby","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"createby","<%=CurUser.getUserID()%>");
	       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	       setItemValue(0,0,"createDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}else{
			   setItemValue(0,0,"createby","<%=CurUser.getUserID()%>");
		       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"Putoutno",<%=sObjectNo%>);
		
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>