<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		页面说明: 国家标准行业选择
	 */
	String sIndustryTypeValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryTypeValue"));
	String sIndustryType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	String sOpen = "";
	String sDefaultItem = "";
	//增加判断，防止出现 null错误 add by jbye 2009/03/30
	if(sIndustryType.length()>3) sDefaultItem = sIndustryType.substring(0,3);
	if(sIndustryType!=null&&sIndustryType.length()>3) sOpen = "YES";
%>
<html>
<head>
<title>请选择行业类型</title>
<style>
.black9pt {font-size: 11pt; font-weight: bolder; color: #000000; text-decoration: none;}
</style>
</head>
<script type="text/javascript">
	//获取用户选择的行业种类
	function TreeViewOnClick(){
		var sIndustryType=getCurTVItem().id;
		var sIndustryTypeName=getCurTVItem().name;
		buff.IndustryType.value=sIndustryType+"@"+sIndustryTypeName;
		//选择国标行业大类时可以自动触发右边节目
	<%	if(sIndustryTypeValue == null){	%>
			newBusiness();
	<%	}%>
	}
	
	//modify by hwang,修改双击相应函数。function TreeViewOnDBClick()修改为function TreeViewOnDBLClick() 
	function TreeViewOnDBLClick(){
		newBusiness();
	}

	//新选一个行业种类
	function newBusiness(){
	//选择国标行业大类时可以自动触发右边节目
	<%	if(sIndustryTypeValue == null){	%>
			if(buff.IndustryType.value!=""){
				sReturnValue = buff.IndustryType.value;
				parent.OpenPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+getCurTVItem().id,"frameright","");
			}else{
				alert(getBusinessMessage('247'));//请选择行业种类细项！
			}
	<%	}else{ %>
			var s,sValue,sName;
			var sReturnValue = "";
			s=buff.IndustryType.value;
			s = s.split('@');
			sValue = s[0];
			sName = s[1];
			if((sValue=="C371")||(sValue=="C372")||(sValue=="C375")||(sValue=="C376")||(sValue=="F553")||(sValue=="L741")){
				alert(getBusinessMessage('248'));//您选择的行业需要细分到小类！
			}else{
				if(buff.IndustryType.value.length<3){
					alert(getBusinessMessage('247'));//请选择行业种类细项！
				}else{
					if(sValue.length==5){
						top.returnValue = buff.IndustryType.value;
						top.close();
					}else{
						alert(getBusinessMessage('247'));//请选择行业种类细项！
					}
				}
			}
	<%	}%>
	}
	//清空功能的实现
	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function goBack(){
		top.close();
	}
	//将查询出的行业类型按照TreeView展示
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("行业类型列表","right");
		tviTemp.TriggerClickEvent=true;
		//选择行业类型一
		if(sIndustryTypeValue == null)
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and length(ItemNo) <= 3",Sqlca);
		else
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and ItemNo like '"+sIndustryTypeValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
</script>

<body bgcolor="#DCDCDC">
<center>
<form  name="buff">
<input type="hidden" name="IndustryType" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
	<td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<%
		if(sIndustryTypeValue == null){
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">行业类型大类</p>
	<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ></td>
	<%
		}else{
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">行业类型子类</p>
	<td nowrap align="center" valign="baseline">
		<table>
	        <tr>
		       <td><%=HTMLControls.generateButton("确定","确定","javascript:newBusiness()",sResourcesPath)%></td>
		       <td><%=HTMLControls.generateButton("取消","取消","javascript:goBack()",sResourcesPath)%></td>
		       <td><%=HTMLControls.generateButton("清空","清空","javascript:clearAll()",sResourcesPath)%></td>
	        </tr>
	    </table>
	</td>
	<%}%>
</tr>
</table>
</form>
</center>
</body>
</html>
<script type="text/javascript">
	startMenu();
	// Ctrl + F，最后一个参数为调用的方法，前面的参数均为按键值
	setQuick(17, 70, showTVSearch);
	expandNode('root');
	selectItem('<%=sDefaultItem%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	selectItem('<%=sIndustryType%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	expandNode('<%=sIndustryTypeValue%>');
</script>
<%@ include file="/IncludeEnd.jsp"%>