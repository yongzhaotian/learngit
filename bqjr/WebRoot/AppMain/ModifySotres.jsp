<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		ѡ���ŵ���չ��			
	 */
	%>
<%
    String sSql = ""; //���SQL���
    String sMobileTel="";
    String sSalesManager="";
    String sIdenttype = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("identtype"));
    ASResultSet rs=null;
   
    //���۴���绰
    sSql="select MobileTel from user_info where UserID=:UserID";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
    if(rs.next()){
    	sMobileTel=rs.getString("MobileTel");
    	if(sMobileTel==null){
    		sMobileTel="";
    	}
    }

    
	if(sIdenttype.equals("01")){//�ŵ�
	    rs = Sqlca.getResultSet(new SqlObject("select SNo,SNo|| ' ' || SName as SName from store_info where identtype='01' and status='05' and sno in (Select sno from STORERELATIVESALESMAN where ( Stype is null or Stype='' ) and SalesManNo='"+CurUser.getUserID()+"')"));
	
	}
	if(sIdenttype.equals("02")){//չ��
		rs = Sqlca.getResultSet(new SqlObject("select SNo,SName from store_info where identtype='02' and status='05'  and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"+CurUser.getUserID()+"')"));
	}
 
	String[][] sButtons = {
			{"true","All","Button","ȷ��","","selectCity()","","","",""},
			{"false","","Button","����","","resetCity()","","","",""},
			{"false","All","Button","ɾ��","","delRecord()","","","",""},
	};
%>
<body style="overflow:hidden;">
<div id="ButtonsDiv" style="margin-left: 8%; margin-right:8%; margin-top : 10px;">
<form name="CityForm" style="margin-bottom:0px;" enctype="multipart/form-data" action="" method="post">
<table align=center><tr>
<% if(sIdenttype.equals("01")){%>
<td>��ѡ�������ŵ꣺</td>
<%}else{ %>
<td>��ѡ������չ����</td>
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
		<input type="text" name="CityIDSelected" id="CityIDSelected"  class="select_class" disabled="disabled"  style="width:200px;"/><input type="button" id="button" name="ѡ���ŵ�" value="�ŵ�ѡ��" onclick="javascript:chooseOption()"/> 
		<input type="text" name="sNo" id="sNo" style="display: none"/><br/>
	
	</td>
	<tr align="center">
	<tr>
	<td>���۾���</td>
	<td>
	    <div id="mydiv"></div>
	</td>
</tr>
<tr>
    <td>�Ƿ��ƶ�POS�㣺</td>
    <td><input type="radio" name="m2"  value="1" onclick="javascript:hidePos()" checked>��
            <input type="radio" name="m2" id="isPos"  value="0" onclick="javascript:showPos()">��
    </td>
</tr>
<tr>
	<td>��ѡ���ƶ�POS�㣺</td>
	<td>
				<select id="POSSelected" name="POSSelected" onKeyPress="javascript:pressEnter(0, event);" class="select_class" disabled="disabled"  style="width:200px;"> 
		
				</select>
	</td>
</tr>
<tr>
    <td>���۾����Ƿ�����</td>
    <td><input type="radio" name="m1"  value="����" onclick="javascript:hideTips()" checked>����
            <input type="radio" name="m1"  value="����" onclick="javascript:showTips()">����
    </td>
</tr>
<tr>
     <td colspan="2" align="center" ><div id="seconddiv" style="display:none"><font color="red">��ȷ�����۾�����������ϵ����Ա�޸�</font></div></td>
</tr>
<tr>
<td>�绰���룺</td>
<td><input id="myinput"  onChange="javascript:checkMobile()" /><!-- update CCS-594 PRM-262 ���۵�½ʱ��Լ����ֻ�����(1��ϵͳ������ϵ�ֻ�����Ϊ��¼�) by rqiao 20150326 --></td>
</tr>

<tr>
	<td colspan="2" align="center" ><input type="button" name="submit" value="ȷ��" onclick="javascript:selectCity()"/>
	<!--<input type="reset" value="����"  onclick="javascript:resetCity()"/>--><!-- update CCS-594 PRM-262 ���۵�½ʱ��Լ����ֻ����루2��ɾ�����ð�ť�� by rqiao 20150326 --></td></tr>
</tr></table>
</form>
</div>
</body>

<script type="text/javascript">
        

     document.getElementById("myinput").value="<%=sMobileTel%>";
     
     function checkMobile(){
    	 var sMobile = document.getElementById("myinput").value;
 	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
 	    	alert("�ֻ����벻�ܿ�");
 	    	return false;
 	    }
 	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
 	        alert("�ֻ�����������������������"); 
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
			 alert("����ѡ���ŵ꣡");
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
			 alert("����ѡ���ŵ꣡");
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
			 alert("����ѡ���ŵ꣡");
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
 			alert("��ѡ���ŵ꣡");
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
    	 //���۴����޷�ά�����۾���ֻ����ϵ����Ա
    	 document.getElementById("mydiv").innerHTML="<font color=\"red\">���۾���Ϊ�գ�����ϵ����Աά��</font>";
    	 document.getElementById("submit").disabled=true;
    	 document.getElementById("submit").style.display = "none";
    	 alert("����ϵ������ŵ����۾���֪ͨ������Ӫ��ϵͳ�н����ŵ���Ϣ��������!");
    	 //document.getElementById("mydiv").innerText="���۾���Ϊ�գ�����ϵ����Աά��";
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
		var sResetMobileTel=document.getElementById("myinput").value;//��ǰ¼���ֻ�����
		if(isPos==true){
			if(sPosNo==""||sPosNo==null){
				alert("��ѡ����ӦPOS�㣡");
	 	    	return;
			}
		}
		//end clhuang 2015/05/28
		<%-- update CCS-594 PRM-262 ���۵�½ʱ��Լ����ֻ�����(1��ϵͳ������ϵ�ֻ�����Ϊ��¼�3�������޸ĺ���ʱ��ϵͳ�����޸��û���Ϣ�е��ֻ����롣4�����۴���¼��绰���룬ϵͳ��¼���۴���ÿһ�β�ͬ���޸ġ�) by rqiao 20150326 --%>
		if(typeof(sResetMobileTel) == "undefined" || sResetMobileTel.length==0){
 	    	alert("�ֻ����벻�ܿ�");
 	    	return;
 	    }
		if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sResetMobileTel))){ 
 	        alert("�ֻ�����������������������"); 
 	        return; 
 	    } 
		//����ֻ���Ϊ�գ����ֻ��Ų����䶯
		if(typeof(sResetMobileTel)!="undefined" && sResetMobileTel.length!=0){
			<%--RunMethod("UserManage","UpdateMobileTel",sMobileTel+",<%=CurUser.getUserID()%>");--%>
			RunMethod("UserManage","ModifySaleInfoRecord","<%=CurUser.getUserID()%>,"+sResetMobileTel);<%--4�����۴���¼��绰���룬ϵͳ��¼���۴���ÿһ�β�ͬ���޸ġ�--%>
		}
		<%-- end --%>
		
		<%-- var ReturnValue = RunMethod("PublicMethod", "UpdateColValue", "String@attribute8@"+sSNo+",user_info,String@UserID@"+'<%=CurUser.getUserID()%>');
		if(ReturnValue != "TRUE"){
			alert("������ѡ��");
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
			alert("������ѡ��");
		}
	}

	function resetCity() {
		document.getElementById("mydiv").innerText="";
		document.getElementById("submit").disabled=false;
		 document.getElementById("myinput").value="<%=sMobileTel%>";
	}
	
</script>
<%@ include file="/IncludeEnd.jsp"%>
