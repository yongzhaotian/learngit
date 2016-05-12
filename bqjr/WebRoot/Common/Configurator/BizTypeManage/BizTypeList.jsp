<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 产品管理列表
	 */
	String PG_TITLE = "产品管理列表";
	String[][] sHeaders = {
				{"TypeNo","类型编号（永久）"},
				{"SortNo","排序编号"},
				{"TypeName","类型名称"},
				{"IsInUse","是否有效"},
				{"TypesortNo","类型序号"},
				{"SubtypeCode","分类编号"},
				{"InfoSet","信息设置"},
				{"ApplyDetailNo","申请显示模板"},	
				{"ApproveDetailNo","最终审批意见显示模板"},	
				{"ContractDetailNo","合同显示模板"},
				{"DisplayTemplet","出帐显示模板"},	
				{"Attribute1","属性1"},
				{"Attribute2","属性2"},
				{"Attribute3","属性3"},
				{"Attribute4","属性4"},
				{"Attribute5","属性5"},
				{"Attribute6","属性6"},
				{"Attribute7","属性7"},
				{"Attribute8","属性8"},
				{"Attribute9","属性9"},
				{"Attribute10","属性10"},
				{"Remark","备注"},
				{"InputUserName","登记人"},
				{"InputUser","登记人"},
				{"InputORGName","登记机构"},
				{"InputORG","登记机构"},
				{"InputTime","登记时间"},
				{"UpdateUserName","更新人"},
				{"UpdateUser","更新人"},
				{"UpdateTime","更新时间"},
				};
	String sSql = "select "+
			"TypeNo,SortNo,TypeName,getItemName('IsInUse',IsInUse) as IsInUse,TypesortNo,SubtypeCode,InfoSet,"+
			"ApplyDetailNo,ApproveDetailNo,ContractDetailNo,DisplayTemplet,"+
			"Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,"+
			"Attribute6,Attribute7,Attribute8,Attribute9,Attribute10,Remark,"+
			"getUserName(InputUser) as InputUserName,InputUser,"+
			"getOrgName(InputORG) as InputORGName,InputORG,InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,UpdateUser,UpdateTime "+
			"from BUSINESS_TYPE where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_TYPE";
	doTemp.setKey("TypeNo",true);
	doTemp.setHeader(sHeaders);
	//查询
 	doTemp.setColumnAttribute("TypeNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
 
 	doTemp.setHTMLStyle("InputORG"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUser,UpdateUser,InputORG,InputUserName,UpdateUserName,InputORGName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputORG,UpdateUser",false);    	

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","","");
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
              if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/BizTypeManage/BizTypeList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
       if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn=popComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","TypeNo="+sTypeNo,"");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/BizTypeManage/BizTypeList.jsp","_self","");    
                }
            }
        }
	}

	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>