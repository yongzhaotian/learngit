<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		页面说明: 选择行政区划
	 */
	String sAreaCodeValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCodeValue"));//在该页面打开后打开二级分类时传值。
	String sAreaCode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCode"));//已有值时，做初始化传入。
	String sOpen = "";
	String sDefaultItem = "";
	String sDefaultItem2 = "";
	
	if(sAreaCode.length()>3) sDefaultItem = sAreaCode.substring(0,4);
	if(sAreaCode!=null&&sAreaCode.length()>4){
		sOpen = "YES";//暂不作控制。
		sDefaultItem2 =sAreaCode;
	}
%>
<html>
<head>
<title>请选择行政区划 </title>
<style>
.black9pt {font-size: 11pt; font-weight: bolder; color: #000000; text-decoration: none;}
</style>
</head>
<script type="text/javascript">
	//获取用户选择的行业种类
	function TreeViewOnClick(){
		var sAreaCode=getCurTVItem().value;
		var sAreaCodeName=getCurTVItem().name;
		var sAreaCodeID=getCurTVItem().id;
		buff.AreaCode.value=sAreaCode+"@"+sAreaCodeName+"@"+sAreaCodeID;

		//选择国标行业大类时可以自动触发右边节目
	<%	if(sAreaCodeValue == null){	%>
			newBusiness();
	<%	}%>
	}
	
	//modify by hwang,修改双击相应函数。function TreeViewOnDBClick()修改为function TreeViewOnDBLClick() 
	function TreeViewOnDBLClick(){
		newBusiness();
	}
	
	//新选一个行政区划
	function newBusiness(){
		//选择行政规划大类时可以自动触发右边节目
	<%	if(sAreaCodeValue == null){	%>
			if(buff.AreaCode.value!=""){
				sReturnValue = buff.AreaCode.value;			
				parent.OpenPage("/SystemManage/CustomerFinanceManage/AreaCodeSelect.jsp?AreaCodeValue="+getCurTVItem().id,"frameright","");
			}else{
				alert("请选择行政区划细项！");//请选择行政规划细项！
			}
	<%	}else{	%>
			var s,sValue,sName;
			var sReturnValue = "";
			s=buff.AreaCode.value;

			s = s.split('@');
			sValue = s[0];
			sName = s[1];
			sID = s[2];
			if(typeof(sID)=="undefined" || sID.length<5){
				alert("请选择行政区划细项！");//请选择行政区划细项！
			}else{
				if(sID.length==6){				
					top.returnValue = sValue+"@"+sName;
					top.close();
				}
				else{
					alert("请选择行政区划细项！");//请选择行政区划细项！
				}
			}
	<%	}%>	
	}
	
	//清空
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
		HTMLTreeView tviTemp = new HTMLTreeView("行政区划列表","right");
		tviTemp.TriggerClickEvent=true;
		//选择行业类型一
		if(sAreaCodeValue == null)
			tviTemp.initWithSql("SortNo","ItemName","ItemNo","","from Code_Library where CodeNO='AreaCode' and length(SortNo) <= 4",Sqlca);
		else
			tviTemp.initWithSql("SortNo","ItemName","ItemNo","","from Code_Library where CodeNO='AreaCode' and SortNo like '"+sAreaCodeValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
</script>
<body bgcolor="#DCDCDC">
<center>
<form  name="buff">
<input type="hidden" name="AreaCode" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
	<td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<%
		if(sAreaCodeValue == null){
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">行政区划大类</p>
	<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ></td>
	<%
		}else{
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">行政区划子类</p>
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
	expandNode('root');		
	selectItem('<%=sDefaultItem%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	selectItem('<%=sDefaultItem2%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
</script>
<%@ include file="/IncludeEnd.jsp"%>