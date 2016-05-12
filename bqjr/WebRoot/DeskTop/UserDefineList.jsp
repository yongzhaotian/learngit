<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe:加入重点信息链接
		Input Param:
      		ObjectType:                对象类别
           		Customer:          客户
           		BusinessContract:  合同
	 */
	String PG_TITLE = "重点信息链接@WindowTitle"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量                     
   	String sSql="";   	
	String sObjectNo="";
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	String sHeaders[][]= { 
                         {"ObjectType","对象类型"},
                         {"CustomerID","客户编号"},	           
							 {"CustomerName","客户名称"},
							 {"CertType","证件类型"},
                         {"CertID","证件号码"},
							 {"ArtificialNo","合同文本编号"},
							 {"BusinessTypeName","业务品种"},
							 {"BusinessCCYName","币种"},
							 {"Balance","合同余额"},
							 {"ClassifyResult","风险分类"}
						     };  
	
	//重点案件
	String sHeaders1[][] = { 							
				{"ObjectType","对象类型"},
				{"SerialNo","内部案号"},
				{"LawCaseName","案件名称"},
				{"LawCaseTypeName","案件类型"},				
				{"LawsuitStatusName","我行的诉讼地位"},
				{"CaseBriefName","案由"},				
				{"CaseStatusName","当前诉讼进程"},
				{"CognizanceResultName","受理结果"},
				{"CurrencyName","诉讼币种"},
				{"AimSum","诉讼总标的(元)"},				
				{"ManageUserName","案件管理人"},
				{"ManageOrgName","案件管理机构"},
				{"InputDate","登记日期"}				
			}; 
	
	//重点抵债资产		
	String sHeaders2[][] = { 							
				{"SerialNo","资产编号"},
				{"AssetNo","资产编号"},
				{"AssetName","资产名称"},
				{"Flag","抵入表内/表外"},
				{"FlagName","抵入表内/表外"},
				{"AssetType","资产类别"},	
				{"AssetTypeName","资产类别"},	
				{"AssetSum","抵债金额(元)"},
				{"AssetBalance","资产余额(元)"},
				{"ManageUserID","管理人"},
				{"ManageOrgID","管理机构"}
			}; 
			
					              				   		
	if(sObjectType.equals("Customer")){
		sSql = 	" select UD.ObjectType,UD.UserID,UD.ObjectNo,UD.ObjectNo as CustomerID,CI.CustomerName,getItemName('CertType',CI.CertType) as CertType,CI.CertID "+
	       		" from USER_DEFINEINFO UD,CUSTOMER_INFO CI"+
	       		" where UD.UserID ='"+CurUser.getUserID()+"' and UD.ObjectType='Customer' and CI.CustomerID=UD.ObjectNo";
	}else if(sObjectType.equals("BusinessContract")){
		sSql = 	" select UD.ObjectType,UD.UserID,UD.ObjectNo,BC.CustomerID,getCustomerName(BC.CustomerID) as CustomerName, "+
	       		" BC.ArtificialNo,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCCYName,"+
	       		" BC.Balance,BC.ClassifyResult"+
	       		" from USER_DEFINEINFO UD,BUSINESS_CONTRACT BC"+
	       		" where UD.UserID ='"+CurUser.getUserID()+"' and UD.ObjectType='BusinessContract' and BC.SerialNo=UD.ObjectNo"; 
  	}else if(sObjectType.equals("LawCase")){
		sSql = 	"  select  UD.ObjectType,UD.UserID,UD.ObjectNo,LI.SerialNo,LI.LawCaseName,"+
			"  LI.LawCaseType,getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		  
			"  LI.LawsuitStatus,getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
			"  LI.CaseBrief,getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName," +
			"  LI.CaseStatus,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName," +
			"  LI.CognizanceResult,getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName," +
			"  LI.Currency,getItemName('Currency',LI.Currency) as CurrencyName," +
			"  LI.AimSum,"+
			"  LI.ManageUserID,getUserName(LI.ManageUserID) as ManageUserName, " +
			"  LI.ManageOrgID,getOrgName(LI.ManageOrgID) as ManageOrgName," +
			"  LI.InputDate"+
			"  from USER_DEFINEINFO UD,LAWCASE_INFO LI " +
			"  where UD.UserID ='"+CurUser.getUserID()+"' "+
			" and UD.ObjectType='LawCase' "+
			" and LI.SerialNo=UD.ObjectNo order by  LI.InputDate desc,LI.LawCaseName ";	//当前用户
	}else if(sObjectType.equals("PDAAsset")){
		sSql = "  select UD.ObjectType,UD.UserID,UD.ObjectNo,AI.SerialNo,AI.AssetNo,"+
				" AI.AssetName,AI.AssetType,"+
				" getItemName('PDAType',rtrim(ltrim(AI.AssetType))) as AssetTypeName,"+
				" AI.AssetSum, " +	
				" AI.AssetBalance, " +	
				" getUserName(AI.ManageUserID) as ManageUserID, " +	
				" getOrgName(AI.ManageOrgID) as ManageOrgID"+			
	      		" from USER_DEFINEINFO UD,ASSET_INFO AI " +
	      		" where UD.UserID ='"+CurUser.getUserID()+"' "+
				" and UD.ObjectType='PDAAsset' "+
				" and AI.SerialNo=UD.ObjectNo order by  AI.InputDate desc,AssetTypeName ";	//当前用户
	}
    
	if(sObjectType.equals("MyCommission")){	//重点客户
		return;
	}else if(sObjectType.equals("MySalary")){	//重点合同
		return;
	}
	
	ASDataObject doTemp = new ASDataObject(sSql);
   	if(sObjectType.equals("Customer")){	//重点客户
		doTemp.setHeader(sHeaders);
	}else if(sObjectType.equals("BusinessContract")){	//重点合同
	 	doTemp.setHeader(sHeaders);
	}else if(sObjectType.equals("LawCase")){ 	//重点案件
   	 	doTemp.setHeader(sHeaders1);
	}else if(sObjectType.equals("PDAAsset")){ 	//重点案件
   	 	doTemp.setHeader(sHeaders2);
	}
    	 
    //设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("AssetSum,AimSum,AssetBalance,Balance","2");
	
	//设置金额为三位一逗数字
	doTemp.setType("AssetSum,AimSum,AssetBalance,Balance","Number");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("AssetSum,AimSum,AssetBalance,Balance","3");
	doTemp.setAlign("CertType","2");
	
	doTemp.UpdateTable = "USER_DEFINEINFO";
	doTemp.setKey("ObjectType,UserID,ObjectNo",true);
	
	doTemp.setVisible("UserID,ObjectType,ObjectNo,BusinessType,BusinessCurrency,ClassifyResult",false);
	doTemp.setVisible("SerialNo,LawCaseType,LawsuitStatus,CaseBrief,CaseStatus,CognizanceResult,Currency",false);
	doTemp.setVisible("ManageUserID,ManageOrgID,AssetType",false);
	
	doTemp.setHTMLStyle("ArtificialNo","style={width:150px} ");
	doTemp.setHTMLStyle("CustomerName","style={width:300px} ");
	//doTemp.setHTMLStyle("CertType","style={width:90px} ");
    doTemp.setUpdateable("BusinessCCYName,BusinessTypeName",false);
	doTemp.setHTMLStyle("BusinessCCYName,ClassifyResult","style={width:80px} ");
	
	//设置案件行宽
	doTemp.setHTMLStyle("LawCaseName"," style={width:120px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");
	
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	
	//设置抵债资产行宽
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,FlagName","style={width:85px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID,AssetSum,AssetBalance,AssetNo"," style={width:100px} ");
	doTemp.setUpdateable("AssetTypeName",false); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","详情","查看详细信息","view()",sResourcesPath},
		{"true","","Button","删除","删除一条用户自定义链接","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function deleteRecord(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function view(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}else{
			sObjectType=getItemValue(0,getRow(),"ObjectType");
	    	if(sObjectType=="Customer"){ //重点客户
       		openObject("Customer",sObjectNo,"001");
          	}else if(sObjectType=="BusinessContract"){ //重点合同
               	//获得业务品种
				var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
				if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030"){
					OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=列表&ComponentType=MainWindow&SerialNo="+sObjectNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
				}else{
				  	openObject("BusinessContract",sObjectNo,"002");
				}
			}else if(sObjectType=="LawCase"){ //重点案件
	       		//获得案件流水号、案件类型
				var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
				if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
					alert(getHtmlMessage(1));  //请选择一条记录！
					return;
				}
				openObject("LawCase",sSerialNo,"002");
			}else if(sObjectType=="PDAAsset"){ //重点抵债资产
		       	//获得抵债资产流水号、抵债资产类型
				sSerialNo=getItemValue(0,getRow(),"SerialNo");	
				if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
					alert(getHtmlMessage(1));  //请选择一条记录！
					return;
				}
				OpenComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
				reloadSelf();
			}  
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>