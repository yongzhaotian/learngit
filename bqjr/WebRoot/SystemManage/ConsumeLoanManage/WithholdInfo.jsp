<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "�������������߼�";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BatchWithholdLogicInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause+=" and 1=2";
	
	
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
	<%/*~[Describe=���ݴ�������ȷ��������;]~*/%>
	function changeRequired(){
		//��������
		var sWithholdWay=getItemValue(0,0,"withholdWay");
		   if (typeof(sWithholdWay)=='undefined' || sWithholdWay.length==0) {
					return;
		   }

		if(sWithholdWay=="1"){
			setItemRequired(0, 0, "withholdPercent", true);
			setItemRequired(0,0,"withholdSum",false);
			setItemReadOnly(0, 0, "withholdSum", true);
			setItemReadOnly(0, 0, "withholdPercent", false);
			setItemValue(0,0,"withholdSum","");
		}else{
			setItemRequired(0, 0, "withholdPercent", false);
			setItemRequired(0,0,"withholdSum",true);
			setItemReadOnly(0, 0, "withholdPercent", true);
			setItemReadOnly(0, 0, "withholdSum", false);
			setItemValue(0,0,"withholdPercent","");
			setItemValue(0,0,"withholdPercentTotal","");
		}
		return;
	}
	<%/*~[Describe=���������Ƿ����;]~*/%>
	function checkIsExists() {
		var sWithholdDate = getItemValue(0, 0, "withholdDate");
		if (typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
			return;
		}
		
		if(!(/^[\d-]+$/.test(sWithholdDate))){
			alert("������������Ϊ����");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		sWithholdDateInt=parseInt(sWithholdDate);
		if(sWithholdDate<=0){
			alert("���������������0");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		
		
       	var sSerialno = RunMethod("BusinessManage", "SelectWithholdInfo", sWithholdDate);
		if (sSerialno!="Null" && sSerialno.length>0) {
			//��ѯ��һ�����۵������Ǵ��۰ٷֱȻ��Ǵ��۽��
			 var sWithholdPercent=RunMethod("BusinessManage", "SelectWithholdPercent", sSerialno);
			 if(typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0){
				 //����Ǵ��۽��
				 setItemDisabled(0, 0, "withholdWay", true);
				 setItemValue(0,0,"withholdWay","2");
				 setItemReadOnly(0, 0, "withholdWay", true);
				 setItemRequired(0, 0, "withholdPercent", false);
				 setItemRequired(0,0,"withholdSum",true);
				 setItemReadOnly(0, 0, "withholdPercent", true);
				 setItemReadOnly(0, 0, "withholdSum", false);
				 setItemValue(0,0,"withholdPercent","");
				 //���۽���ʾ���۰ٷֱȼ���
				 setItemValue(0,0,"withholdPercentTotal","");
				 return;
				 
			 }else{
				 //����Ǵ��۰ٷֱ�
				 setItemDisabled(0, 0, "withholdWay", true);
				 setItemValue(0,0,"withholdWay","1");
				 setItemReadOnly(0, 0, "withholdWay", true);
				 setItemRequired(0, 0, "withholdPercent", true);
				 setItemRequired(0,0,"withholdSum",false);
				 setItemReadOnly(0, 0, "withholdSum", true);
				 setItemReadOnly(0, 0, "withholdPercent", false);
				 setItemValue(0,0,"withholdSum","");
				 //���۰ٷֱ���ʾ���۰ٷֱȼ���
				 var sWithholdPercentTotal=RunMethod("BusinessManage", "CountWithholdPercent", sWithholdDate);
				 setItemValue(0,0,"withholdPercentTotal",sWithholdPercentTotal);
				 return;
			 }
			
		}
		
		setItemDisabled(0, 0, "withholdWay", false);
		setItemValue(0,0,"withholdPercentTotal","");
	}
	<%/*~[Describe=ֻҪ���������ı䣬�ͽ����������ÿ�;]~*/%>
	function changeWithholdWay(){
		setItemValue(0,0,"withholdWay","");
	}
	<%/*~[Describe=���ðٷֱ��Ƿ�Ϸ�;]~*/%>
	function checkWithholdPercent() {
		var sWithholdPercent = getItemValue(0, 0, "withholdPercent");
		if (typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0) {
			return;
		}
		
		if(sWithholdPercent<=0 ){
			alert("���������0������");
			setItemValue(0, 0, "withholdPercent", "");
			return;
		}
	}
	
	<%/*~[Describe=�����۽��;]~*/%>
	 function checkWithholdSum(){
		var sWithholdSum=getItemValue(0, 0, "withholdSum");
		if (typeof(sWithholdSum)=='undefined' || sWithholdSum.length==0) {
			return;
		}
		if(sWithholdSum<=0 ){
			alert("���������0������");
			setItemValue(0, 0, "withholdSum", "");
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
		 
		 var sWithholdPercentTotal = "";
		 var sSerialNo = getItemValue(0, 0, "serialno");
		 if(!bIsInsert) sWithholdPercentTotal=RunMethod("BusinessManage", "SelectWithholdPercentTotal", sWithholdDate+","+sSerialNo);
		 else sWithholdPercentTotal=RunMethod("BusinessManage", "CountWithholdPercent", sWithholdDate);

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
		
		if(!bIsInsert){
			var withholdWay = getItemValue(0,0,"withholdWay");
			var sWithholdDate = getItemValue(0, 0, "withholdDate");
			var sSerialNo = getItemValue(0, 0, "serialno");
		    if (typeof(withholdWay)=='undefined' || withholdWay.length==0 || typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
					return;
		    }
		    
		    if(withholdWay=="2"){
			    var withholdReturn = RunMethod("BusinessManage", "WithholdWayCheck", sWithholdDate+",1,"+sSerialNo);
			    if(withholdReturn>0){
				    alert("�����������Ѵ��ڴ������͵�ֵΪ���۰ٷֱȵļ�¼���������͵�ֵ������ѡ���۽��");
				    return;
			    }
		    }else{
		    	var withholdReturn = RunMethod("BusinessManage", "WithholdWayCheck", sWithholdDate+",2,"+sSerialNo);
			    if(withholdReturn>0){
				    alert("�����������Ѵ��ڴ������͵�ֵΪ���۽��ļ�¼���������͵�ֵ������ѡ���۰ٷֱ�");
				    return;
			    }
		    }
		    
	    }
		
		if(bIsInsert){
			beforeInsert();
		}
		
		as_save("myiframe0",sPostEvents);
		var sWithholdWay=getItemValue(0,0,"withholdWay");
	    if (typeof(sWithholdWay)=='undefined' || sWithholdWay.length==0) {
				return;
	    }
		

		if(sWithholdWay=="1"){
			setItemReadOnly(0, 0, "withholdSum", true);
			setItemReadOnly(0, 0, "withholdPercent", false);
		}else{
			setItemReadOnly(0, 0, "withholdPercent", true);
			setItemReadOnly(0, 0, "withholdSum", false);
		}
		return;
	}

	function goBack(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BatchWithholdLogic.jsp","","_self");
	}


	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputtime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			
			var sSerialNo = getSerialNo("BATCH_WITHHOLD", "SERIALNO", "");
			setItemValue(0, 0, "serialno", sSerialNo);
			setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputtime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

			bIsInsert = true;
		}
    } 
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
