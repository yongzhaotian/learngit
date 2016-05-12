<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Resources/Include/IncludeBeginDWAJAX.jspf"%>
<%@page import="com.amarsoft.app.util.TemplateExport"%>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));

	ASResultSet rs = null;
	if(sDWName!=null && !sDWName.equals("")){
		ASDataWindow dwTemp = Component.getDW(sSessionID);
	
		Vector columns = dwTemp.DataObject.Columns;
		Vector tempElements = new Vector();
		for(int i=0;i<columns.size();i++){
			String tmp = "";
			//0  名称
			//1  输入方式
			//2  数据来源
			//3  显示格式
			//4  必输项
			//5  征信说明
			//6 备注
			String[] elem = new String[7];
			ASColumn col = (ASColumn)columns.get(i);
			boolean isDDW = false;
			String sVisiable = col.getAttribute("Visible");
			//如果为不显示的，则不用显示了
			if(sVisiable == null) sVisiable = "";
			if(!sVisiable.equals("1")){
				continue;
			}
			//0 名称
			elem[0] = col.getAttribute("Header");
			//1 输入方式
			elem[1] = (String)col.getAttribute("EditStyle");
			if(elem[1]== null) elem[1] = "";
			if(elem[1].equals("1")){
				elem[1] = "文本框";
				//如果为文本框，再检查是否后面带了个按钮，如果带了按钮，则为选择框
				String sExts = (String)col.getAttribute("Unit");
				if(sExts == null) sExts = "";
				if(sExts.indexOf("<input") >= 0&&sExts.indexOf("type=button") >= 0){
					elem[1] = "选择框";
				}
			}else if(elem[1].equals("2")){
				elem[1] = "下拉列表";
				isDDW = true;
			}else if(elem[1].equals("3")){
				elem[1] = "文本区";
			}else{
				elem[1] = "**不正常**";
			}
			//2 数据来源
			elem[2] = (String)col.getAttribute("ReadOnly");
			if(elem[2]== null) elem[2] = "";
			if(elem[2].equals("1")){
				elem[2] = "自动显示";
			}else if(elem[2].equals("0")){
				elem[2] = "手工输入";
			}else{
				elem[2] = "**不正常**";
			}
			//3 显示格式
			elem[3] = (String)col.getAttribute("CheckFormat");
			if(elem[3]== null) elem[3] = "";
			if(elem[3].equals("1")){
				elem[3] = "字符串";
			}else if(elem[3].equals("2")){
				elem[3] = "数字";
			}else if(elem[3].equals("3")){
				elem[3] = "日期";
			}else if(elem[3].equals("4")){
				elem[3] = "时间";
			}else if(elem[3].equals("5")){
				elem[3] = "整数";
			}else{
				if(Integer.parseInt(elem[3])>=10){
					elem[3] = "数字";
				}else{
					elem[3] = "**不正常**";
				}
			}
			//4 必输项
			elem[4] = (String)col.getAttribute("Required");
			if(elem[4]== null) elem[4] = "";
			if(elem[4].equals("1")){
				elem[4] = "是";
			}else if(elem[4].equals("0")){
				elem[4] = "否";
			}else{
				elem[4] = "**不正常**"; 
			}
			//5 征信说明
			elem[5] = (String)col.getAttribute("Unit");
			if(elem[5]== null) elem[5] = "";
			if(elem[5].indexOf("(征信 M)")>0){
				elem[5] = "必输项(M)";
			}else if(elem[5].indexOf("(征信 C)")>0){
				elem[5] = "有条件选择(C)";
			}else if(elem[5].indexOf("(征信 O)")>0){
				elem[5] = "可选(O)";
			}else{
				elem[5] = "";
			}
			//备注字段处理
			//1.如果配置了下拉框，则备注显示下拉框信息
			//2.如果没有配置下拉框，则看是否配置了相关单位（如：元，月，万等）
			//a.先检查是否为下拉框
			String sRemark = "";
			if(isDDW){
				//如果 为下拉框，则检查下拉框来源
				String s = (String)col.getAttribute("EditSource");
				String sSourceType = s.split(":")[0];
				String sSource = s.split(":")[1];
				
				if(sSourceType == null) sSourceType = "";
				if(sSource == null) sSource = "";
				//如果为代码，则取代码值
				if(sSourceType.equalsIgnoreCase("Code")){
					sRemark = "列表包括：";
					rs = Sqlca.getASResultSet("select ItemName from CODE_LIBRARY where CodeNo='"+sSource+"' order by sortno asc");
					boolean f = true;
					int count=0;
					while(rs.next()){
						if(f)sRemark += "<br/>&nbsp;&nbsp;"+rs.getString("ItemName");
						else sRemark += "<br/>&nbsp;&nbsp;"+rs.getString("ItemName");
						f = false;
						count++;
					}
					rs.getStatement().close();
					rs = null;
					if(count>5){
						sRemark = "参考代码表："+sSource;
					}
				}else if(sSourceType.equalsIgnoreCase("CodeTable")){
					sRemark = "列表包括：&nbsp;&nbsp;"+sSource;
				}else if(sSourceType.equalsIgnoreCase("SQL")){
					sRemark = "列表包括：&nbsp;&nbsp;";
					rs = Sqlca.getASResultSet(sSource);
					boolean f = true;
					int count=0;
					while(rs.next()){
						if(f)sRemark += "<br/>&nbsp;&nbsp;"+rs.getString(2);
						else sRemark += "<br/>&nbsp;&nbsp;"+rs.getString(2);
						f = false;
						count++;
					}
					rs.getStatement().close();
					rs = null;
					if(count>5){
						sRemark = "参考代码表："+sSource;
					}
				}
			}else{
				String sUnit = (String)col.getAttribute("Unit");
				if(sUnit == null) sUnit = "";
				if(sUnit.indexOf("年")>=0 ||sUnit.indexOf("月")>=0 ||sUnit.indexOf("日")>=0
						||sUnit.indexOf("元")>=0 ||sUnit.indexOf("万")>=0 ||sUnit.indexOf("股")>=0
						||sUnit.indexOf("平方米")>=0 ||sUnit.indexOf("里")>=0){
					sRemark = "单位："+sUnit;
				}else if(sUnit.indexOf("%")>=0 ||sUnit.indexOf("﹪")>=0 ||sUnit.indexOf("‰")>=0){
					sRemark = "后缀："+sUnit;
				}
			}
			elem[6] = sRemark;
			tempElements.add(elem);
		}
		//sPhyRealPath = request.getSession(true).getServletContext().getRealPath("/DownLoad");
		Configure curConfig = Configure.getInstance(application);
		if(curConfig ==null) throw new Exception("读取配置文件错误！请检查对应xml文件");
		String sPhyRealPath = curConfig.getConfigure("DWDownloadFilePath");
    	if(sPhyRealPath ==null) sPhyRealPath = "/tmp/DownLoad";
    	sPhyRealPath += "/Template";
		
		//生成文件
		TemplateExport te = new TemplateExport(sPhyRealPath);
		String sFile = te.genFile(tempElements,".xls");
%>
<html>
<head><title>请稍候...</title></head>
<body>
<div align=center>
<br>
<font style="font-size:9pt;color:red">正在从服务器获取数据,请稍候...</font>
</div>
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"正在下载，请稍候...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
<form name=form1 method=post action=<%=sWebRootPath%>/servlet/view/file target=MyAtt>
	<div style="display:none">
		<input name=filename value="<%=sFile%>">
		<input name=contenttype value="application/x-zip-compressed">
		<input name=viewtype value="download">
	</div>
</form>
<%
	}
%>
</body>
</html>
<script type="text/javascript">
	form1.submit();
	
	setTimeout('closeTop();',2000);	
	function closeTop(){
		top.close();
	}
</script>
<%@ include file="/Resources/Include/IncludeTail.jspf"%>