<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "内部账户详情"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得页面参数	
	String sAccountNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CoreAccountNo")));
	String sOrgID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID")));
	String sCurrency = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency")));
	String sAccountType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountType")));
	if(sAccountNo==null||sAccountNo.length()==0)sAccountNo="";
	if(sOrgID==null||sOrgID.length()==0)sOrgID="";
	if(sCurrency==null||sCurrency.length()==0)sCurrency="";
	if(sAccountType==null||sAccountType.length()==0)sAccountType="";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "InnerAccountInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";//设置DW风格
	dwTemp.ReadOnly = "0";//设置是否只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountNo+","+sOrgID+","+sCurrency+","+sAccountType);
	for (int i = 0; i < vTemp.size(); i++)
	out.print((String) vTemp.get(i));

	String sButtons[][] = { 
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath },
	};
	%> 


	<%@include file="/Resources/CodeParts/Info05.jsp"%>


<script language=javascript>
	var bIsInsert = false;	//判断是否为点击	< 新增 >

	/*~[Describe=保存信息;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents) {
	
		if( !vI_all("myiframe0") ) return;
		
		if(bIsInsert ) {
			if( isExist() ) return;
			bIsInsert = false;
		}
		as_save("myiframe0","self.close();");
		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	</script>

<script language=javascript>

	/*~[Describe=加载页面时初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow() {
		//如果没有找到对应记录，则新增一条，并设置字段默认值
		if (getRowCount(0)==0) {
			as_add("myiframe0");//新增记录
			bIsInsert = true ;
		}
    }
    
   	/*~[Describe=选择机构;InputParam=无;OutPutParam=无;]~*/
	function selectAllOrg() {
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=判断帐号是否已存在;InputParam=无;OutPutParam=无;]~*/
	function isExist(){
		var sAccountNo = getItemValue(0,getRow(),"CoreAccountNo");
		var sCurrency = getItemValue(0,getRow(),"Currency");
		var sReturn = RunMethod("PublicMethod","GetColValue","Count(*),acct_core_account,String@CoreAccountNo@"+sAccountNo+"@String@Currency@"+sCurrency);
    	if(sReturn.split("@")[1]!="0")
        {
    		alert("该机账号已经存在!");
    		return true;
    	}
	}
		 
</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	//var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
