<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 汽车贷后催收任务详情页面-- */
	String PG_TITLE = "汽车贷后催收任务详情页面";

	// 获得页面参数
	String sColSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColectionSerialNo"));//催收任务编号
	String sBcSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo"));//合同号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//跟进登记结果编号
	//out.println("sColSerialNo:"+sColSerialNo+"sBcSerialNo:"+sBcSerialNo);
	if(sColSerialNo==null)sColSerialNo="";
	if(sBcSerialNo==null)sBcSerialNo="";
	if(sSerialNo==null)sSerialNo="";
	
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CARCOLLECTIONREGISTINFO";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.setVisible("SERIALNO,PHASETYPE1,PHASETYPE2", false);//是否可见
	doTemp.setReadOnly("SERIALNO,INPUTUSERID,INPUTUSERNAME,INPUTORGID,INPUTORGNAME,INPUTDATE,UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", true);//是否只读
	if(sSerialNo.equals("")){
		doTemp.setVisible("SERIALNO,PHASETYPE1,PHASETYPE2,UPDATEUSERNAME,UPDATEUSERID,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", false);//是否可见
	}else{
		doTemp.setReadOnly("REGISTTYPE,REMARK,SERIALNO,INPUTUSERID,INPUTUSERNAME,INPUTORGID,INPUTORGNAME,INPUTDATE,UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", true);//是否只读
	}
		
	doTemp.setRequired("REGISTTYPE", true);
	
	doTemp.setDDDWSql("PHASETYPE1", "select itemno,itemname from code_library where codeno='PhaseType1'");
	doTemp.setDDDWSql("PHASETYPE2", "select itemno,itemname from code_library where codeno='PhaseType2'");
	doTemp.setDDDWSql("REGISTTYPE", "select itemno,itemname from code_library where codeno='RegistType'");

	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}else{
			beforeUpdate();
		}
		as_save("myiframe0",sPostEvents);
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		//alert("保存:ContractSerialNo=<%=sBcSerialNo%>&ColectionSerialNo=<%=sColSerialNo%>");
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","updateCarColectionRegist","RegistSerialNo="+sSerialNo);
		if(sReturn != "Success"){
			alert("催收跟进登记结果状态更新失败!");
			return;
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenPage("/BusinessManage/CollectionManage/ColectionRegistList.jsp","ContractSerialNo=<%=sBcSerialNo%>&ColectionSerialNo=<%=sColSerialNo%>","_self","");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var sSerialNo = getSerialNo("CAR_COLLECTIONREGIST_INFO","SerialNo","");// 获取流水号
		setItemValue(0,0,"SERIALNO",sSerialNo);
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UPDATEORGNAME","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"UPDATEORGID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
			if(bIsInsert){
				var sSerialNo = getSerialNo("CAR_COLLECTIONREGIST_INFO","SerialNo","");// 获取流水号
				setItemValue(0,0,"SERIALNO",sSerialNo);
				setItemValue(0,0,"CONTRACTSERIALNO","<%=sBcSerialNo%>");
				setItemValue(0,0,"COLECTIONSERIALNO","<%=sColSerialNo%>");
				setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
				setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
				setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
				setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			}
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
