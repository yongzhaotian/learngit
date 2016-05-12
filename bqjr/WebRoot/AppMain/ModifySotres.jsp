<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		选择门店与展厅			
	 */
	%>
<%
    String sSql = ""; //存放SQL语句
    String sMobileTel="";
    String sSalesManager="";
    String sIdenttype = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("identtype"));
    ASResultSet rs=null;
   
    //销售代表电话
    sSql="select MobileTel from user_info where UserID=:UserID";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
    if(rs.next()){
    	sMobileTel=rs.getString("MobileTel");
    	if(sMobileTel==null){
    		sMobileTel="";
    	}
    }

    
	if(sIdenttype.equals("01")){//门店
	    rs = Sqlca.getResultSet(new SqlObject("select SNo,SNo|| ' ' || SName as SName from store_info where identtype='01' and status='05' and sno in (Select sno from STORERELATIVESALESMAN where ( Stype is null or Stype='' ) and SalesManNo='"+CurUser.getUserID()+"')"));
	
	}
	if(sIdenttype.equals("02")){//展厅
		rs = Sqlca.getResultSet(new SqlObject("select SNo,SName from store_info where identtype='02' and status='05'  and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"+CurUser.getUserID()+"')"));
	}
 
	String[][] sButtons = {
			{"true","All","Button","确定","","selectCity()","","","",""},
			{"false","","Button","重置","","resetCity()","","","",""},
			{"false","All","Button","删除","","delRecord()","","","",""},
	};
%>
<body style="overflow:hidden;">
<div id="ButtonsDiv" style="margin-left: 8%; margin-right:8%; margin-top : 10px;">
<form name="CityForm" style="margin-bottom:0px;" enctype="multipart/form-data" action="" method="post">
<table align=center><tr>
<% if(sIdenttype.equals("01")){%>
<td>请选择做单门店：</td>
<%}else{ %>
<td>请选择做单展厅：</td>
<%} %>
	<td>
		<%-- <select id="CityIDSelected" name="CityIDSelected" onKeyPress="javascript:pressEnter(0, event);" class="select_class"  onChange="javascript:chooseOption()"  style="width:auto"> 
		   <OPTION value="" selected="selected"></OPTION>
		<%while (rs.next()){%> 
			<OPTION value="<%=rs.getString("SNo") %>" ><%=rs.getString("SName") %>&nbsp;</OPTION>
		<%} 
		   rs.getStatement().close();
		%>
		</select> --%>
		<input type="text" name="CityIDSelected" id="CityIDSelected"  class="select_class" disabled="disabled"  style="width:200px;"/><input type="button" id="button" name="选择门店" value="门店选择" onclick="javascript:chooseOption()"/> 
		<input type="text" name="sNo" id="sNo" style="display: none"/><br/>
	
	</td>
	<tr align="center">
	<tr>
	<td>销售经理：</td>
	<td>
	    <div id="mydiv"></div>
	</td>
</tr>
<tr>
    <td>是否移动POS点：</td>
    <td><input type="radio" name="m2"  value="1" onclick="javascript:hidePos()" checked>否
            <input type="radio" name="m2" id="isPos"  value="0" onclick="javascript:showPos()">是
    </td>
</tr>
<tr>
	<td>请选择移动POS点：</td>
	<td>
				<select id="POSSelected" name="POSSelected" onKeyPress="javascript:pressEnter(0, event);" class="select_class" disabled="disabled"  style="width:200px;"> 
		
				</select>
	</td>
</tr>
<tr>
    <td>销售经理是否有误：</td>
    <td><input type="radio" name="m1"  value="无误" onclick="javascript:hideTips()" checked>无误
            <input type="radio" name="m1"  value="有误" onclick="javascript:showTips()">有误
    </td>
</tr>
<tr>
     <td colspan="2" align="center" ><div id="seconddiv" style="display:none"><font color="red">如确认销售经理有误请联系管理员修改</font></div></td>
</tr>
<tr>
<td>电话号码：</td>
<td><input id="myinput"  onChange="javascript:checkMobile()" /><!-- update CCS-594 PRM-262 销售登陆时填报自己的手机号码(1、系统设置联系手机号码为必录项。) by rqiao 20150326 --></td>
</tr>

<tr>
	<td colspan="2" align="center" ><input type="button" name="submit" value="确定" onclick="javascript:selectCity()"/>
	<!--<input type="reset" value="重置"  onclick="javascript:resetCity()"/>--><!-- update CCS-594 PRM-262 销售登陆时填报自己的手机号码（2、删除重置按钮） by rqiao 20150326 --></td></tr>
</tr></table>
</form>
</div>
</body>

<script type="text/javascript">
        

     document.getElementById("myinput").value="<%=sMobileTel%>";
     
     function checkMobile(){
    	 var sMobile = document.getElementById("myinput").value;
 	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
 	    	alert("手机号码不能空");
 	    	return false;
 	    }
 	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
 	        alert("手机号码输入有误，请重新输入"); 
 	        //obj.focus();
 		    //setItemValue(0,0,"MobileTelephone","");
 	        return false; 
 	    } 
     }
     //by clhuang 2015/05/28
     function choosePOSOption(){
         var myselect=document.getElementById("POSSelected");
         var sSNo = document.getElementById("sNo").value;
         if(sSNo==""||sSNo==null){
			 alert("请先选择门店！");
			 var childs = myselect.childNodes;  
		     for(var i = 0; i <childs.length; i++) {    
		    	 myselect.removeChild(childs[i]);  
		     } 
		     myselect.options[0] = new Option("","");
			 return;
		 }
         var sReturn = RunMethod("BusinessManage", "selectPosNo", sSNo+",<%=CurUser.getUserID()%>");
         var sReturnName = RunMethod("BusinessManage", "selectPosName", sSNo+",<%=CurUser.getUserID()%>");
        
         var sReturnArr = null;
         var sReturnNameArr = null;
         if(!(sReturn==""||sReturn=="Null" || sReturnName==""||sReturnName=="Null" )){
     
       		sReturnArr = ((sReturn.replace("{","")).replace("}","")).split(",");
       		sReturnNameArr = ((sReturnName.replace("{","")).replace("}","")).split(",");
       	} else {
       		sReturnArr = "";
       		sReturnNameArr = "";
       	}
         
         myselect.options[0] = new Option("","");
         for(var i=0;i<sReturnArr.length;i++){
        	 
        	 myselect.options[i+1] = new Option(sReturnNameArr[i],sReturnArr[i]);
        	
         }
         
       }
	 function hidePos(){ 
		 var sSNo = document.getElementById("CityIDSelected").value;
		 var myselect=document.getElementById("POSSelected");
		 myselect.disabled=true;
		 if(sSNo==""||sSNo==null){
			 alert("请先选择门店！");
			 var childs = myselect.childNodes;  
		     for(var i = 0; i < childs.length; i++) {    
		    	 myselect.removeChild(childs[i]);  
		     } 
		     myselect.options[0] = new Option("","");
			 return;
		 }
		 
	     var childs = myselect.childNodes;  
	     for(var i = 0; i < childs.length; i++) {    
	    	 myselect.removeChild(childs[i]);  
	     } 
	     myselect.options[0] = new Option("","");
	 }
	 function showPos(){
		 var sSNo = document.getElementById("CityIDSelected").value;
		 var myselect=document.getElementById("POSSelected");
		 myselect.disabled=false;
		 if(sSNo==""||sSNo==null){
			 alert("请先选择门店！");
			 var childs = myselect.childNodes;
		     for(var i = 0; i < childs.length; i++) {    
		    	 myselect.removeChild(childs[i]);  
		     } 
		     myselect.options[0] = new Option("","");
			 return;
		 }
		
		 choosePOSOption();
	 }
	//end  clhuang 2015/05/28
	
     function chooseOption(){
    	 
    var sReturn = setObjectValue("selectStore", "UserID,<%=CurUser.getUserID()%>", "","","","dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
 		if (typeof(sReturn)=='undefined' || sReturn.length==0) {
 			alert("请选择门店！");
 			return;
 		}
 	var sReturnArr = sReturn.split("@");
    var sStore=sReturnArr[0];
    var sSalesManager="";
    document.getElementById("CityIDSelected").innerText=sReturnArr[2];
    document.getElementById("sNo").innerText=sReturnArr[0];
    if(typeof(sStore)=="undefined" || sStore.length==0){
    }else{
       sSalesManager=RunMethod("StoreManage","SelectManager",sStore);
    }
     if(sSalesManager=="Null"){
    	 //销售代表无法维护销售经理，只能联系管理员
    	 document.getElementById("mydiv").innerHTML="<font color=\"red\">销售经理为空，请联系管理员维护</font>";
    	 document.getElementById("submit").disabled=true;
    	 document.getElementById("submit").style.display = "none";
    	 alert("请联系管理该门店销售经理，通知销售运营在系统中将该门店信息补充完整!");
    	 //document.getElementById("mydiv").innerText="销售经理为空，请联系管理员维护";
     }else{
	 document.getElementById("mydiv").innerText=sSalesManager;
	 document.getElementById("submit").disabled=false;
	 document.getElementById("submit").style.display = "block";
	 
     }
   //by clhuang 2015/05/28
     var myselect=document.getElementById("POSSelected");
     var childs = myselect.childNodes;  
     for(var i = 0; i < childs.length; i++) {    
    	 myselect.removeChild(childs[i]);  
     } 
     choosePOSOption();
   //end clhuang 2015/05/28
   }
    function hideTips(){
    	document.getElementById("seconddiv").style.display="none";
    	document.getElementById("submit").disabled=false;

    }
    function showTips(){
    	document.getElementById("seconddiv").style.display="block";
    	document.getElementById("submit").disabled=true;
    	
    }
	function selectCity(){
		var sSNo = document.getElementById("sNo").value;
		//by clhuang 2015/05/28
		var sPosNo = document.getElementById("POSSelected").value;
		var isPos = document.getElementById("isPos").checked;
		var sResetMobileTel=document.getElementById("myinput").value;//当前录入手机号码
		if(isPos==true){
			if(sPosNo==""||sPosNo==null){
				alert("请选择相应POS点！");
	 	    	return;
			}
		}
		//end clhuang 2015/05/28
		<%-- update CCS-594 PRM-262 销售登陆时填报自己的手机号码(1、系统设置联系手机号码为必录项。3、销售修改号码时，系统不能修改用户信息中的手机号码。4、销售代表录入电话号码，系统记录销售代表每一次不同的修改。) by rqiao 20150326 --%>
		if(typeof(sResetMobileTel) == "undefined" || sResetMobileTel.length==0){
 	    	alert("手机号码不能空");
 	    	return;
 	    }
		if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sResetMobileTel))){ 
 	        alert("手机号码输入有误，请重新输入"); 
 	        return; 
 	    } 
		//如果手机号为空，则手机号不做变动
		if(typeof(sResetMobileTel)!="undefined" && sResetMobileTel.length!=0){
			<%--RunMethod("UserManage","UpdateMobileTel",sMobileTel+",<%=CurUser.getUserID()%>");--%>
			RunMethod("UserManage","ModifySaleInfoRecord","<%=CurUser.getUserID()%>,"+sResetMobileTel);<%--4、销售代表录入电话号码，系统记录销售代表每一次不同的修改。--%>
		}
		<%-- end --%>
		
		<%-- var ReturnValue = RunMethod("PublicMethod", "UpdateColValue", "String@attribute8@"+sSNo+",user_info,String@UserID@"+'<%=CurUser.getUserID()%>');
		if(ReturnValue != "TRUE"){
			alert("请重新选择");
		}else{
			RunJspAjax("/AppMain/reloadASUseAjax.jsp?sno="+sSNo);
			self.returnValue = sSNo;
			self.close();
		} --%>
		var	sReturnValue = RunJspAjax("/AppMain/reloadASUseAjax.jsp?sno="+sSNo+"&PosNo="+sPosNo);
		if("success"==sReturnValue){
			self.returnValue = sSNo;
			self.close();
		}else{
			alert("请重新选择");
		}
	}

	function resetCity() {
		document.getElementById("mydiv").innerText="";
		document.getElementById("submit").disabled=false;
		 document.getElementById("myinput").value="<%=sMobileTel%>";
	}
	
</script>
<%@ include file="/IncludeEnd.jsp"%>
