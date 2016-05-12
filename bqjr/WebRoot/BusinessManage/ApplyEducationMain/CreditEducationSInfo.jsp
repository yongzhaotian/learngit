<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 机构信息详情
	 */
	String PG_TITLE = "机构信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	String sNo= CurUser.getAttribute8();
	String sStoreCity = Sqlca.getString(new SqlObject("select City from Store_Info where SNo=:SNo").setParameter("SNo", sNo));
	if (sStoreCity == null) sStoreCity = "";
	String isInNearCity = Sqlca.getString(new SqlObject("select StoreCity from NearCity_Info where StoreCity=:StoreCity").setParameter("StoreCity", sStoreCity));
	if (isInNearCity == null) isInNearCity = "";
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ContractInfo300027";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
	
	//doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//定义后续事件
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
		
	var Family_other_telephone=		getvalus(getItemValue(0,getRow(),"Family_other_telephone"),'1');
	var Family_Parents_CompanyTel=		getvalus(getItemValue(0,getRow(),"Family_Parents_CompanyTel"),'2');
	var Family_Parents_telephone=		getvalus(getItemValue(0,getRow(),"Family_Parents_telephone"),'3');
	var school_counselor_telephone=		getvalus(getItemValue(0,getRow(),"school_counselor_telephone"),'4');
	var k=0;
	var list1 = new Array(); 
	list1[k++] = Family_other_telephone; 
	list1[k++] = Family_Parents_CompanyTel; 
	list1[k++] = Family_Parents_telephone; 
	list1[k++] = school_counselor_telephone; 

		var flag = "1";
		for(var i=0;i<list1.length;i++){
			for(var j=i+1;j<list1.length;j++){
				if(list1[i] == list1[j]){
					flag="0";
					break;
				}
			}
		}
		if(flag == "1"){
		}else{
			alert("所有关系的电话存在重复号码,请检测重复号码并修改!");
			return false;
		}
		    addPhoneInfo();
       		as_save("myiframe0","");
	}
	function getvalus(obj,rowid){
			if(obj){
				return obj;
			}else{
				return rowid;
			}
			
	}
	
	/*~[插入地址到地址库]~*/
	function addPhoneInfo(){
		//学校宿舍电话
	
		var school_dormitory_telephone = getItemValue(0,0,"school_dormitory_telephone");
		//学校辅导员电话
		var school_counselor_telephone = getItemValue(0,0,"school_counselor_telephone");
		//客户编号
		var sCustomerID = getItemValue(0,0,"SerialNo").substr(0, 8);
		//获取流水号
		for( var i=0;i<2;i++){
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sSerialNo = getSerialNo("Phone_Info","SerialNo","");*/
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("PI")%>';
		/** --end --*/
		
			if(i==0){//学校宿舍电话
					str=sSerialNo+","+sCustomerID+","+school_dormitory_telephone+",110";
			}
			if(i==1){//学校辅导员电话
					str=sSerialNo+","+sCustomerID+","+school_counselor_telephone+",120";
			}
			//插入电话到电话仓库
			RunMethod("BusinessManage","UpdatePhoneInfo",str);
		}
		
	}
	 function checkName(obj){
		    var sName = obj.value;
			if(typeof(sName) == "undefined" || sName.length==0 ){
				return false;
			}else{
			if(/\s+/.test(sName)){
				alert("姓名含有空格，请重新输入");
				//obj.focus();
				return false;
			}
			//姓名必须是中文或者字母
			if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
				    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)·([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
					alert("姓名输入非法");
					//obj.focus();
					return false;
				    }
				    
				}
			 }
			return true;
			}

	/*~[单位地址省市选择窗口]~*/
	function getWorkAdd(datatype){
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"school_address","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					if("s"==datatype){
						setItemValue(0,getRow(),"school_address",sAreaCodeName);
					}else{
						setItemValue(0,getRow(),"Family_Parents_City",sAreaCodeName);
					}
			}
		}
	 }
	
	
	function checkOrgSortNo(){
		var sSortNo=getItemValue(0,getRow(),"SortNo");
		if(!(typeof(sSortNo) == "undefined" || sSortNo.length==0)){
			var Return=RunMethod("BusinessManage","checkOrgUnique",sSortNo);
			if(Return!=0){
				alert("排序号已存在，请重新输入！");
				setItemValue(0,0,"SortNo","");
			}
			
		}
		
	}
	function checkForms(obj){
		var nameStr=obj.value;
	
        var iu, iuu, regArray=new Array("","◎","■","●","№","↑","→","↓","!","@","#","$","%","^","&","*","_","+","=","|","","[","]","？","~","`"+
        "!","<",">","‰","→","←","↑","↓","¤","§","＃","＆","＆","＼","≡","≠","?","、","/"+
        "≈","∈","∪","∏","∑","∧","∨","⊥","∥","∥","∠","⊙","≌","≌","√","∝","∞","∮","，","。","&","？","：","《","》","【","】","{","}","~","！","￥","…"+
        "∫","≯","≮","＞","≥","≤","≠","±","＋","÷","×","/","Ⅱ","Ⅰ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅹ","Ⅻ"+
        "╄","╅","╇","┻","┻","┇","┭","┷","┦","┣","┝","┤","┷","┷","┹","╉","╇","【","】"+
        "①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩","┌","├","┬","┼","┍","┕","┗","┏","┅","—"+
        "〖","〗","←","〓","☆","§","□","‰","◇","＾","＠","△","▲","＃","℃","※",".","≈","￠"); 
        iuu=regArray.length;
        for(iu=1;iu<=iuu;iu++){
               if (nameStr.indexOf(regArray[iu])!=-1){
            	   if(regArray[iu]){
                      alert("名称不能包含：【" + regArray[iu]+"】字符");
                      obj.focus();
                      return ;
            	   }
               }
        }
 return true;              
 }
	
	function checkMobile1(obj){
		var sSchCouTel=obj.value;
		//空格自动忽略
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){    //非手机号
						alert("手机号码格式填写错误"); 
						obj.focus();
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("固定电话格式填写错误"); 
						obj.focus();
				        return false; 
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}
	}

	function doReturn(){
		if(parent.reloadView){
			parent.reloadView();
		}else{
			OpenPage("/CreditManage/CreditApply/CreditInfo.jsp","_self","");
		}
	}

	<%/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;]~*/%>
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"updateby","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"createby","<%=CurUser.getUserID()%>");
	       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	       setItemValue(0,0,"createDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}else{
			   setItemValue(0,0,"createby","<%=CurUser.getUserID()%>");
		       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"Putoutno",<%=sObjectNo%>);
		
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>