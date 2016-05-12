<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "���������߼�����";

	//���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BatchWithholdLogicInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setReadOnly("withholdDate", true);
	doTemp.setReadOnly("withholdWay", true);
	
	String sSql="";
	String sWithholdWay="";
	ASResultSet rs=null;
	sSql="select withholdWay from Batch_withhold where SerialNo=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	 if(rs.next()){
		 sWithholdWay=rs.getString("withholdWay");
	    	if(sWithholdWay==null){
	    		sWithholdWay="";
	    	}
	    }
	 rs.getStatement().close();
	 
	
	 if("1".equals(sWithholdWay)){
		doTemp.setRequired("withholdPercent", true);
		doTemp.setReadOnly("withholdSum", true);
	}
	if("2".equals(sWithholdWay)){
		doTemp.setReadOnly("withholdPercent", true);
		doTemp.setRequired("withholdSum", true);
	} 
	doTemp.WhereClause+=" and serialno="+sSerialNo;
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	<%/*~[Describe=���������Ƿ����;]~*/%>
	function checkIsExists() {
		var sWithholdDate = getItemValue(0, 0, "withholdDate");
		var Serialno = getItemValue(0, 0, "serialno");
		if (typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
			return;
		}
		if(sWithholdDate<4){
			alert("������������С��4��");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		
		if(sWithholdDate%10 != 0){
			alert("��������������10��������,���������룡");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		
		var sSerialno = RunMethod("BusinessManage", "SelectWithholdInfo", sWithholdDate);
		if (sSerialno!="Null" && sSerialno.length>0 && Serialno!="<%=sSerialNo%>") {
			alert("�������Ѿ����ڣ����������룡");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
	}
	
	<%/*~[Describe=���ðٷֱ��Ƿ�Ϸ�;]~*/%>
	function checkWithholdPercent() {
		var sWithholdPercent = getItemValue(0, 0, "withholdPercent");
		if (typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0) {
			return;
		}
		/* if(sWithholdPercent<=0 || sWithholdPercent>100){
			alert("������0~100֮������֣�����0��С�ڵ���100");
			setItemValue(0, 0, "withholdPercent", "");
			return;
		} */
		if(sWithholdPercent<=0 ){
			alert("���������0������");
			setItemValue(0, 0, "withholdPercent", "");
			return;
		}
	}
	
	 <%/*~[Describe=������۰ٷֱȼ���;]~*/%>
	 function countWithholdPercentTotal(){
		 var sWithholdDate = getItemValue(0, 0, "withholdDate");
		 if (typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
				return;
		 }
		 
		 var sWithholdPercent=getItemValue(0,0,"withholdPercent");
		 if (typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0) {
			 return;
		 }
		 var sWithholdPercentTotal=RunMethod("BusinessManage", "SelectWithholdPercentTotal", sWithholdDate+",<%=sSerialNo%>");
		 if (typeof(sWithholdPercentTotal)=='undefined' || sWithholdPercentTotal.length==0||sWithholdPercentTotal=="Null") {
			 sWithholdPercentTotal="0";
		 }
		 var sPercentTotal=parseFloat(sWithholdPercentTotal);
		 
		 var sPercent=parseFloat(sWithholdPercent);
		 var sWithholdPercentTotalNow=sPercentTotal+sPercent;
		 setItemValue(0,0,"withholdPercentTotal",sWithholdPercentTotalNow);
	 }
	
	function saveRecord(sPostEvents){
		var sWithholdPercentTotal = getItemValue(0, 0, "withholdPercentTotal");
		if(sWithholdPercentTotal>100){
			alert("ͬһ���������Ĵ��۰ٷֱȼ��ܲ��ܳ����ٷְ٣����������ô��۰ٷֱ�");
			return;
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	function goBack(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BatchWithholdLogic.jsp","","_self");
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		
		setItemValue(0, 0, "updateorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"updateuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"updatedate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		
	}
	 
	
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		var sWithholdDate=getItemValue(0,0,"withholdDate");
		var sWithholdPercentTotal=RunMethod("BusinessManage","CountWithholdPercent",sWithholdDate);
		if(sWithholdPercentTotal=="Null") sWithholdPercentTotal="";
		setItemValue(0,0,"withholdPercentTotal",sWithholdPercentTotal);
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
