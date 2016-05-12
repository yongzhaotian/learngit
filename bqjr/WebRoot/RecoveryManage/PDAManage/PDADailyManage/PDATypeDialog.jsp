<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004.12.08
 * Tester:
 *
 * Content:      选择抵债资产类型
 * Input Param:
 *			    
 * Output param:
 *	AssetType：抵债资产类型	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择抵债资产类型</title>
<%
	//抵债资产类型
	String sAssetType="";
%>
<script type="text/javascript">

	function Get_AssetType()
	{
		var sAssetType ;
		
		//抵债资产类型
		sAssetType = document.all("AssetType").value;
		
		if(sAssetType == "")
		{
			alert(getBusinessMessage("783"));//请选择抵债资产类型！
			return;
		}
		  		
		//获取流水号
		var sSerialNo = initSerialNo();
		//插入刚刚产生的序列号记录，补充缺省值。
		PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAInsertActionAjax.jsp?SerialNo="+sSerialNo+"&AssetType="+sAssetType,"","");

		//返回资产类型和序列号
		self.returnValue=sAssetType+"@"+sSerialNo;
		self.close();
	}
	
	function initSerialNo()
	{
		 //生成一个新的记录插入Asset_Info：序列号。
		var sTableName = "ASSET_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		var  sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		return sSerialNo;
	}
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
  <table align="center" width="240" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
    </tr>
	<tr> 
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >选择抵债资产分类：</td>
	<td nowarp bgcolor="#F0F1DE" > 
		<select name="AssetType" >
			<%=HTMLControls.generateDropDownSelect(Sqlca,"PDAType",sAssetType)%> 
		</select>
	</td>
	</tr>
    </table>
  <table align="center" width="240" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
	<td> </td>
	</tr>
    <tr>
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("确认","","javascript:Get_AssetType()",sResourcesPath)%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>     
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>