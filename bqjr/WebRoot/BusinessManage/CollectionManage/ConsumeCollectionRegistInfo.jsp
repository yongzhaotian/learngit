<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "��������Ǽǽ���������";

	// ���ҳ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));//�ͻ����
	String sCollectionSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CollectionSerialNo"));//������ˮ��
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));

	if(sCustomerID==null) sCustomerID="";
	if(sCollectionSerialNo==null) sCollectionSerialNo="";
	if(sPhaseType1==null) sPhaseType1="";

	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeCollectionRegistInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setVisible("UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", false);
	doTemp.setReadOnly("SERIALNO,CUSTOMERID,COLLECTIONSERIALNO,CUSTOMERNAME,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEORGID,UPDATEUSERNAME,UPDATEDATE,INPUTUSERNAME,INPUTORGNAME,UPDATEORGNAME,UPDATEORGNAME", true);
	//add    wlq   ���Ӹ���ʱ���У��  20141016
	doTemp.setHTMLStyle("RECHECKDATE", "onChange=\"javascript:parent.getDoChange()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//<input class=\"inputdate\" value=\"...\" type=button onclick=parent.getRegionCode(\"\")>
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	var dates;
	
	//��ȡ�ж�����
	function getExecutorCode(){
		sPhaseType1="sPhaseType1,<%=sPhaseType1%>";
		setObjectValue("SelectExecutorCode",sPhaseType1,"@EXECUTORCODE@0@SUBEXECUTORCODE@1@PROMISREPAYMENTDATE@2",0,0,"");
		var sPROMISREPAYMENTDATE = getItemValue(0,getRow(),"PROMISREPAYMENTDATE");//��ȡ��������
		var date="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//��ȡϵͳ��ǰ����
		//����
		dates=AddDays(date,sPROMISREPAYMENTDATE);
		setItemValue(0,0,"RECHECKDATE",dates);
	}
	
	//���ڼ����������������.
	function AddDays(date,days){
		var nd = new Date(date);
		   nd = nd.valueOf();
		   nd = nd + days * 24 * 60 * 60 * 1000;
		   nd = new Date(nd);
		   //alert(nd.getFullYear() + "��" + (nd.getMonth() + 1) + "��" + nd.getDate() + "��");
		var y = nd.getFullYear();
		var m = nd.getMonth()+1;
		var d = nd.getDate();
       
	   /* var hour = nd.getHours();
	    if (hour < 10) {
	        hour = "0" + hour.toString();
	    }
	    var minute = nd.getMinutes();
	    if (minute < 10) {
	        minute = "0" + minute.toString();
	    }
	    var second = nd.getSeconds();
	    if (second < 10) {
	        second = "0" + second.toString();
	    }
        */
		if(m <= 9) m = "0"+m;
		if(d <= 9) d = "0"+d; 
		var cdate = y+"/"+m+"/"+d;

		return cdate;
	}
	
	//2�����ڵĲ�ֵ
	function DateDiff(d1,d2){ 
	    var day = 24 * 60 * 60 *1000; 
	try{     
	   var dateArr = d1.split("/"); 
	   var checkDate = new Date(); 
	       checkDate.setFullYear(dateArr[0], dateArr[1]-1, dateArr[2]); 
	   var checkTime = checkDate.getTime(); 

	   var dateArr2 = d2.split("/"); 
	   var checkDate2 = new Date(); 
	       checkDate2.setFullYear(dateArr2[0], dateArr2[1]-1, dateArr2[2]); 
	   var checkTime2 = checkDate2.getTime(); 

	   var cha = (checkTime - checkTime2)/day;
	        return cha; 
	    }catch(e){ 
	      return false; 
	   } 
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		//У���������ڲ��ܳ���7��
		var d1 = getItemValue(0,getRow(),"RECHECKDATE");//��ȡ��������
		var d2="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//��ȡϵͳ��ǰ����
		
		//�������ڲ���Ϊ��(modified by qizhong.chi)
		if(!d1){
			alert("�������ڲ���Ϊ��!");
			return false;
		}
		
        //��������
		var s=DateDiff(d1,d2).toFixed(0);
		
		if(s>7){
			alert("�������ڲ��ܳ������죡");
			return false;
		}
		var returnValue=getDoChange();
		if(returnValue=="error"){
			return;
		}
		var nd = new Date();
		var hour = nd.getHours();
	    var minute = nd.getMinutes();
	    var second = nd.getSeconds();

        //ƴ��ʱ�䴮
	    var sTime=hour+":"+minute+":"+second;
	
		setItemValue(0,0,"RECHECKDATE",d1+" "+sTime);
		as_save("myiframe0",sPostEvents);
		window.close();
	}
	
	function getDoChange(){
		var sRecheckDate=getItemValue(0, getRow(), "RECHECKDATE");
		if(DateDiff("<%=StringFunction.getToday()%>" ,sRecheckDate)>0){
			alert("�������ڲ���С�ڵ�ǰʱ�䣡");
			return "error";
		}
		if(DateDiff(dates ,sRecheckDate)<0){
			alert("�������ڲ��ܴ�������������");
			return "error";
		}
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		
	}
	
	function initSerialNo(){
		var sSerialNo = getSerialNo("CONSUME_COLLECTIONREGIST_INFO","SERIALNO");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"SERIALNO",sSerialNo);
	}
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			initSerialNo();
			
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			setItemValue(0,0,"COLLECTIONSERIALNO","<%=sCollectionSerialNo%>");
			setItemValue(0,0,"CUSTOMERID","<%=sCustomerID%>");
			setItemValue(0,0,"CUSTOMERNAME","<%=Sqlca.getString("SELECT CUSTOMERNAME FROM ind_info WHERE CUSTOMERID='"+sCustomerID+"'")%>");
			bIsInsert = true;
		}else{
			setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATEORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
