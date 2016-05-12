<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户信息录入界面
		Input Param:
			  CustomerType：客户类型				
				01：公司客户；
				0110：大型企业客户；
				0120：中小型企业客户；
				02：集团客户；
				0210：实体集团客户；
				0220：虚拟集团客户；
				03：个人客户
				0310：个人客户；
				0320：个体经营户；
		Output param:
			 CustomerType：客户类型				
				01：公司客户；
				0110：大型企业客户；
				0120：中小型企业客户；
				02：集团客户；
				0210：实体集团客户；
				0220：虚拟集团客户；
				03：个人客户
				0310：个人客户；
				0320：个体经营户；
			 CustomerOrgType:客户机构类型	
					0101：法人企业；
					0102：非法人企业；
					0103：事业单位；
					0104：社会团体；
					0105：党政机关；
					0106：金融机构；
					0199：其他；			
			CustomerName：客户名称
			CertType：证件类型
			CertID：证件号码
		History Log: zywei 2005/09/10 重检代码
		             pwang 2009/10/12 修改客户机构类型选择代码为CustomerOrgType。
	 */
	%>
<%/*~END~*/%>
 

<html>
<head> 
<title>请输入客户信息</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sCustomerOrgType ="";
	//获得组件参数	

	//获得页面参数	：客户类型
	String sCustomerType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
	%>
<%/*~END~*/%>


<script type="text/javascript">

	function newCustomer(){
		var sCustomerType = "";
		var sCustomerName = trim(document.all("CustomerName").value);
		
		//非关联集团客户需取得证件类型、证件号码
		if("<%=sCustomerType.substring(0,2)%>" != '02'){
			var sCertType = document.all("CertType").value;
			var sCertID = trim(document.all("CertID").value);
			var sCertID1 = trim(document.all("CertID1").value);
		}else{
			var sCertType = "";
			var sCertID = "";
			var sCertID1 = "";
		}
		
		//获取客户类型（小类）
		var sCustomerOrgType = document.all("CustomerType").value;	
		//检查客户类型是否选择
		if (sCustomerOrgType == ''){
			alert(getBusinessMessage('147'));//请选择客户类型！
			document.all("CustomerType").focus();
			return;
		}
		
		//非关联集团客户需检查证件类型、证件号码
		if("<%=sCustomerType.substring(0,2)%>" != '02'){
			//检查证件类型是否选择
			if (sCertType == ''){
				alert(getBusinessMessage('148'));//请选择证件类型！
				document.all("CertType").focus();
				return;
			}
			//检查证件号码是否输入
			if (sCertID == ''){
				alert(getBusinessMessage('149'));//证件号码未输入！
				document.all("CertID").focus();
				return;
			}
			//检查证件号码是否输入一致
			if (sCertID != sCertID1){
				alert(getBusinessMessage('152'));//证件号码输入不一致！
				document.all("CertID1").focus();
				return;
			}
		}
		
		//判断组织机构代码合法性
		if(sCertType =='Ent01'){
			if(!CheckORG(sCertID)){
				alert(getBusinessMessage('102'));//组织机构代码有误！
				document.all("CertID").focus();
				return;
			}
		}
			
		//判断身份证合法性,个人身份证号码应该是15或18位！
		if(sCertType == 'Ind01' || sCertType =='Ind08'){
			if (!CheckLicense(sCertID)){
				alert(getBusinessMessage('156'));//身份证号码有误！
				document.all("CertID").focus();
				return;
			}
		}		
		
		//检查客户名称是否输入
		if (sCustomerName == ''){
			alert(getBusinessMessage('104'));//客户名称不能为空！
			document.all("CustomerName").focus();
			return;
		}
		
		//返回变量：细化的客户类型、客户名称、客户证件类型、证件号
		self.returnValue=sCustomerOrgType+"@"+sCustomerName+"@"+sCertType+"@"+sCertID;
		self.close();
	}
	
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body class="pagebackground">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <%	    
	    if(sCustomerType.substring(0,2).equals("01")){ //公司客户需要选择小类
	 %>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择机构类型&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="CustomerType">
        	<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerOrgType' and ItemNo <> '01' and ItemNo like '01%' and IsInUse = '1' order by SortNo ",1,2,"")%> 
        </select>
      </td>
    </tr> 
     <%
		}else{
	 %>
  	<tr>
	  <td>  
       <input name="CustomerType" value='<%=sCustomerType%>' type=hidden>  
      </td>
    </tr> 	    
	 <%	
		}
		//非关联集团客户需选择证件类型
	    if(!sCustomerType.substring(0,2).equals("02")){
     %>
     <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择证件类型&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="CertType"">
	    <%
	    //选择证件类型
	    if(sCustomerType.substring(0,2).equals("01")){ //选择公司客户的证件类型
	    %>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and SortNo like 'Ent%' order by SortNo ",1,2,"")%> 
	    <%
		}else if(sCustomerType.substring(0,2).equals("03")){ //选择个人客户的证件类型
	    %>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo like 'Ind%' order by SortNo ",1,2,"")%> 
	    <%
		}
	    %>
        </select>
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >证件号码&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CertID" value="">
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >证件号码确认&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CertID1" value="">
      </td>
    </tr>
    <%
    }
    %>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC"  >客户名称&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CustomerName" value="" <%=(sCustomerType.equals("04")?"style='width:100px'":"style='width:200px'")%> >
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>