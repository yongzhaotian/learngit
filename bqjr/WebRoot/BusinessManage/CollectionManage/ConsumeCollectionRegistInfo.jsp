<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "催收任务登记结果详情界面";

	// 获得页面参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));//客户编号
	String sCollectionSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CollectionSerialNo"));//催收流水号
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));

	if(sCustomerID==null) sCustomerID="";
	if(sCollectionSerialNo==null) sCollectionSerialNo="";
	if(sPhaseType1==null) sPhaseType1="";

	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeCollectionRegistInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setVisible("UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", false);
	doTemp.setReadOnly("SERIALNO,CUSTOMERID,COLLECTIONSERIALNO,CUSTOMERNAME,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEORGID,UPDATEUSERNAME,UPDATEDATE,INPUTUSERNAME,INPUTORGNAME,UPDATEORGNAME,UPDATEORGNAME", true);
	//add    wlq   增加复核时间的校验  20141016
	doTemp.setHTMLStyle("RECHECKDATE", "onChange=\"javascript:parent.getDoChange()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//<input class=\"inputdate\" value=\"...\" type=button onclick=parent.getRegionCode(\"\")>
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	var dates;
	
	//获取行动代码
	function getExecutorCode(){
		sPhaseType1="sPhaseType1,<%=sPhaseType1%>";
		setObjectValue("SelectExecutorCode",sPhaseType1,"@EXECUTORCODE@0@SUBEXECUTORCODE@1@PROMISREPAYMENTDATE@2",0,0,"");
		var sPROMISREPAYMENTDATE = getItemValue(0,getRow(),"PROMISREPAYMENTDATE");//获取重排天数
		var date="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//获取系统当前日期
		//计算
		dates=AddDays(date,sPROMISREPAYMENTDATE);
		setItemValue(0,0,"RECHECKDATE",dates);
	}
	
	//日期加上天数后的新日期.
	function AddDays(date,days){
		var nd = new Date(date);
		   nd = nd.valueOf();
		   nd = nd + days * 24 * 60 * 60 * 1000;
		   nd = new Date(nd);
		   //alert(nd.getFullYear() + "年" + (nd.getMonth() + 1) + "月" + nd.getDate() + "日");
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
	
	//2个日期的差值
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
		//校验重排日期不能超过7天
		var d1 = getItemValue(0,getRow(),"RECHECKDATE");//获取复合日期
		var d2="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//获取系统当前日期
		
		//复合日期不能为空(modified by qizhong.chi)
		if(!d1){
			alert("复合日期不能为空!");
			return false;
		}
		
        //四舍五入
		var s=DateDiff(d1,d2).toFixed(0);
		
		if(s>7){
			alert("复合日期不能超过七天！");
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

        //拼接时间串
	    var sTime=hour+":"+minute+":"+second;
	
		setItemValue(0,0,"RECHECKDATE",d1+" "+sTime);
		as_save("myiframe0",sPostEvents);
		window.close();
	}
	
	function getDoChange(){
		var sRecheckDate=getItemValue(0, getRow(), "RECHECKDATE");
		if(DateDiff("<%=StringFunction.getToday()%>" ,sRecheckDate)>0){
			alert("复核日期不能小于当前时间！");
			return "error";
		}
		if(DateDiff(dates ,sRecheckDate)<0){
			alert("复核日期不能大于重排天数！");
			return "error";
		}
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		
	}
	
	function initSerialNo(){
		var sSerialNo = getSerialNo("CONSUME_COLLECTIONREGIST_INFO","SERIALNO");// 获取流水号
		setItemValue(0,getRow(),"SERIALNO",sSerialNo);
	}
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
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
