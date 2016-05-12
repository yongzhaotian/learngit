<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "NPAPawnList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {			
			{"true","","Button","详情","查看抵质押物信息详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","价值变更","抵质押物价值变更","valueChange()",sResourcesPath},
			{"true","","Button","其他信息变更","抵质押物其他信息变更","otherChange()",sResourcesPath},
			{"true","","Button","资产监管信息","资产监管信息","assetWard()",sResourcesPath}
		};
	
%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

//---------------------定义按钮事件------------------------------------
/*~[Describe=资产监管信息;InputParam=无;OutPutParam=无;]~*/
function assetWard()
{
//担保物编号
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sObjectType = "GuarantyInfo";

if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
{
	alert(getHtmlMessage('1'));//请选择一条信息！
	return;
}
else 
{
	OpenComp("AssetWardList","/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","ObjectNo="+sGuarantyID+"&ObjectType="+sObjectType,"_blank",OpenStyle);
}
}

/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
function viewAndEdit()
{
//担保物编号、担保合同号
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sGuarantyType = getItemValue(0,getRow(),"GuarantyType");		
if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
{
	alert(getHtmlMessage('1'));//请选择一条信息！
}else 
{		
	OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAPawnInfo.jsp?GuarantyID="+sGuarantyID+"&PawnType="+sGuarantyType,"_self");
}
}



/*~[Describe=抵质押物价值变更;InputParam=无;OutPutParam=无;]~*/
function valueChange()
{
//担保物编号、担保合同号
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sObjectNo = getItemValue(0,getRow(),"ObjectNo");
sGuarantyType="050";
if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
{
	alert(getHtmlMessage('1'));//请选择一条信息！
}else 
{
	OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=010&GuarantyID="+sGuarantyID+"&GuarantyType="+sGuarantyType,"_blank",OpenStyle);
	reloadSelf();
}
														
													
}

/*~[Describe=抵质押物其他信息变更;InputParam=无;OutPutParam=无;]~*/
function otherChange()
{
//担保物编号、担保合同号
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sObjectNo = getItemValue(0,getRow(),"ObjectNo");
sGuarantyType="050";
if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
{
	alert(getHtmlMessage('1'));//请选择一条信息！
}else 
{
	OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=020&GuarantyID="+sGuarantyID+"&GuarantyType="+sGuarantyType,"_blank",OpenStyle);
	reloadSelf();
}
}

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
AsOne.AsInit();
init();
my_load(2,0,'myiframe0');
showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
