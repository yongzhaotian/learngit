<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "资产转让协议列表页面";
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;资产转让筛选&nbsp;&nbsp;";
 %>
 <% 
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TrustCompaniesInfo",Sqlca);
	doTemp.setKey("SERIALNO", true);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			//{"true","","Button","保存并返回","保存并返回","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","返回","返回","goBack()",sResourcesPath},
		};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	var bIsInsert = false;
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		if(!bIsInsert){
			beforeUpdate();
		}
		if(!validCheck())return;
		as_save("myiframe0");
	}
	
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	
	function saveRecordAndReturn()
	{
		if(!validCheck())return;
		as_save("myiframe0");
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealClientList.jsp","","_self","");
	}
	
	function validCheck(){
		var companyName = getItemValue(0,getRow(),"SERVICEPROVIDERSNAME");
		var accoutNo = getItemValue(0,getRow(),"TURNACCOUNTNUMBER");
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(companyName)=="undefined"||companyName==""){
			alert("请输入公司名称！");
			return false;
		}
		if(typeof(accoutNo)=="undefined"||accoutNo==""){
			alert("请输入帐号");
			return false;
		}
		var reg = new RegExp("^[0-9]*$");
		if(!reg.test(accoutNo)){
			alert("帐号输入不正确，请输入数字类型帐号");
			return false;
		}

		var sReturn = RunMethod("公用方法","GetColValue","SERVICE_PROVIDERS,Count(*),SERVICEPROVIDERSNAME='"+companyName+"' and serialNo<>'"+serialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			alert("公司名称不能重复");
			return false;
		}
		return true;
	}
	
	// 返回交易列表
	function goBack()
	
	{
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealClientList.jsp","","_self","");
	}

	/*~[Describe=初始化部分参数;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UPDATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			initSerialNo();
			bIsInsert = true;
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "SERVICE_PROVIDERS";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);//获取流水号
		
		setItemValue(0,getRow(),sColumnName,sSerialNo);//将流水号置入对应字段
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
		
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>