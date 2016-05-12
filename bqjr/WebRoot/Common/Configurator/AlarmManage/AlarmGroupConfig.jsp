<%@page import="com.amarsoft.are.jbo.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sScenarioID = CurPage.getParameter("ScenarioID");
	String sGroupID = CurPage.getParameter("GroupID");
    if(sScenarioID == null) sScenarioID = "";
    if(sGroupID == null) sGroupID = "";
%>
<script type="text/javascript">
	var availableItemCaptionList = new Array;
	var availableItemNameList = new Array;
	var selectedItemCaptionList = new Array;
	var selectedItemNameList = new Array;
<%
	StringBuilder sb = new StringBuilder();
	String queryStr = " select ModelID,ModelName from O where STATUS = '1' and ScenarioID = :ScenarioID "+
			" and ModelID not in (select sr.ModelID from jbo.sys.SCENARIO_RELATIVE sr where sr.ScenarioID = :ScenarioID and sr.GroupID = :GroupID) order by ModelID ";
	BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.sys.SCENARIO_MODEL", queryStr).setParameter("ScenarioID", sScenarioID).setParameter("GroupID", sGroupID);
	List<BizObject> list = bq.getResultList(false);
	for(int num = 0;num < list.size();num++){
		BizObject bo = (BizObject)list.get(num);
		String modelID = bo.getAttribute("ModelID").getString();
		String modelName = bo.getAttribute("ModelName").getString();
		String displayName = modelID +"   "+modelName;
		sb.append("availableItemCaptionList[" + num + "] = '" + displayName + "';\r");
		sb.append("availableItemNameList[" + num + "] = '" + modelID + "';\r");
	}
	
	queryStr = " select sm.ModelID,sm.ModelName from jbo.sys.SCENARIO_MODEL sm,O where sm.ScenarioID = O.ScenarioID and sm.ModelID = O.ModelID and O.ScenarioID = :ScenarioID and O.GroupID = :GroupID";
	bq = JBOFactory.createBizObjectQuery("jbo.sys.SCENARIO_RELATIVE", queryStr).setParameter("ScenarioID", sScenarioID).setParameter("GroupID", sGroupID);
	list = bq.getResultList(false);
	for(int num = 0;num < list.size();num++){
		BizObject bo = (BizObject)list.get(num);
		String modelID = bo.getAttribute("ModelID").getString();
		String modelName = bo.getAttribute("ModelName").getString();
		String displayName = modelID +"   "+modelName;
		sb.append("selectedItemCaptionList[" + num + "] = '" + displayName + "';\r");
		sb.append("selectedItemNameList[" + num + "] = '" + modelID + "';\r");
	}
	out.println(sb.toString());
%>
</script>
<head>
	<title>配置分组检查项</title>
</head>
<body bgcolor="#E4E4E4">
<form name="configform">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5'>
				<tr>
					<td><span class='dialog-label'>可引入的检查项</span></td>
					<td></td>
					<td><span class='dialog-label'>已引入的检查项</span></td>
					<td></td>
				</tr>
				<tr>
					<td align='center' style="width: 48%">
						<select name='item_available' onchange='selectionChanged(document.forms["configform"].elements["item_available"],document.forms["configform"].elements["item_chosen"]);' size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
					<td width='32' align='center' valign='middle'>
	                    <img name='movefrom_item_available' onmousedown='pushButton("movefrom_item_available",true);' onmouseup='pushButton("movefrom_item_available",false);' onmouseout='pushButton("movefrom_item_available",false);' onclick='moveSelected(document.forms["configform"].elements["item_available"],document.forms["configform"].elements["item_chosen"]);updateHiddenChooserField(document.forms["configform"].elements["item_chosen"],document.forms["configform"].elements["configItem"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif' alt='Add selected items' />
						<br><br>
						<img name='movefrom_item_chosen' onmousedown='pushButton("movefrom_item_chosen",true);' onmouseup='pushButton("movefrom_item_chosen",false);' onmouseout='pushButton("movefrom_item_chosen",false);' onclick='moveSelected(document.forms["configform"].elements["item_chosen"],document.forms["configform"].elements["item_available"]);updateHiddenChooserField(document.forms["configform"].elements["item_chosen"],document.forms["configform"].elements["configItem"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif' alt='Remove selected items' />
					</td>
					<td align='center' style="width: 48%">
						<select name='item_chosen' onchange='selectionChanged(document.forms["configform"].elements["item_chosen"],document.forms["configform"].elements["item_available"]);' size='12' style='width:100%;' multiple='true'>
						</select>
						<input type='hidden' name='configItem' value=''>
					</td>
					<td width='32' align='center' valign='middle'>
                    	<img name='shiftup_item_chosen' onmousedown='pushButton("shiftup_item_chosen",true);' onmouseup='pushButton("shiftup_item_chosen",false);' onmouseout='pushButton("shiftup_item_chosen",false);' onclick='shiftSelected(document.forms["configform"].elements["item_chosen"],-1);updateHiddenChooserField(document.forms["configform"].elements["item_chosen"],document.forms["configform"].elements["configItem"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_item_chosen' onmousedown='pushButton("shiftdown_item_chosen",true);' onmouseup='pushButton("shiftdown_item_chosen",false);' onmouseout='pushButton("shiftdown_item_chosen",false);' onclick='shiftSelected(document.forms["configform"].elements["item_chosen"],1);updateHiddenChooserField(document.forms["configform"].elements["item_chosen"],document.forms["configform"].elements["configItem"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' />
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	<tr height=1>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=4>
			<table width="100%">
				<tr>
				    <td width="45%" align="right">
				         <%=HTMLControls.generateButton("&nbsp;恢&nbsp;复&nbsp;","恢复","javascript:doDefault();",sResourcesPath)%>
					</td>
					<td width="5%" align="center"></td>
                    <td width="50%" align="left">
                         <%=HTMLControls.generateButton("&nbsp;确&nbsp;定&nbsp;","确定","javascript:doQuery();",sResourcesPath)%>
					</td>
                    <!-- <td width="30%" align="left">
                         <%=HTMLControls.generateButton("&nbsp;取&nbsp;消&nbsp;","取消","javascript:self.returnValue='_none_';self.close();",sResourcesPath)%>
					</td> -->
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
<script type="text/javascript">
	function cloneOption(option){
		var out = new Option(option.text,option.value);
		out.selected = option.selected;
		out.defaultSelected = option.defaultSelected;
		return out;
	}
	
	function shiftSelected(chosen,howFar){
		var opts = chosen.options;
		var newopts = new Array(opts.length);
		var start, end, incr;
		if(howFar > 0){
			start = 0;
			end = newopts.length;
			incr = 1; 
		}else{
			start = newopts.length - 1;
			end = -1;
			incr = -1; 
		}
		for(var sel = start; sel != end; sel += incr){
			if (opts[sel].selected){
				setAtFirstAvailable(newopts, cloneOption(opts[sel]), sel + howFar, -incr);
			}
		}
		for(var uns = start; uns != end; uns += incr){
			if (!opts[uns].selected) {
				setAtFirstAvailable(newopts, cloneOption(opts[uns]), start, incr);
			}
		}
		opts.length = 0;
		for(i=0; i<newopts.length; i++){
			opts[opts.length] = newopts[i]; 
		}
	}
	
	function setAtFirstAvailable(array,obj,startIndex,incr){
		if (startIndex < 0) startIndex = 0;
		if (startIndex >= array.length) startIndex = array.length -1;
		for(var xxx=startIndex; xxx>= 0 && xxx<array.length; xxx += incr){
			if (array[xxx] == null) {
				array[xxx] = obj; 
				return; 
			}
		}
	}
	
	function moveSelected(from,to){
		newTo = new Array();
		for(i=0; i<to.options.length; i++){
			newTo[newTo.length] = cloneOption(to.options[i]);
			newTo[newTo.length-1].selected = false;
		}
		
		for(i=0; i<from.options.length; i++){
			if (from.options[i].selected) {
				newTo[newTo.length] = cloneOption(from.options[i]);
				from.options[i] = null;
				i--;
			}
		}
		to.options.length = 0;
		for(i=0; i<newTo.length; i++){
			to.options[to.options.length] = newTo[i];
		}
		selectionChanged(to,from);
	}
   
	function updateHiddenChooserField(chosen,hidden){
		hidden.value='';
		var opts = chosen.options;
		for(var i=0; i<opts.length; i++){
			hidden.value = hidden.value + opts[i].value+'\n';
		}
	}
   
	function selectionChanged(selectedElement,unselectedElement){
		for(i=0; i<unselectedElement.options.length; i++){
			unselectedElement.options[i].selected=false;
		}
		form = selectedElement.form;
		enableButton("movefrom_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("movefrom_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
		enableButton("shiftdown_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("shiftup_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("shiftdown_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
		enableButton("shiftup_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
	}
   
   function enableButton(buttonName,enable){
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1){
			if(enable) img.src = src.substring(0,und)+".gif"; 
		}else{
			if(!enable){
				var gif = src.lastIndexOf("_clicked.gif"); 
				if (gif == -1) gif = src.lastIndexOf(".gif"); 
				img.src = src.substring(0,gif)+"_disabled.gif";
			}
		}
	}
   
   function pushButton(buttonName,push){
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1) return false; 
		und = src.lastIndexOf("_clicked.gif"); 
		if (und == -1){
			var gif = src.lastIndexOf(".gif");
			if (push) img.src = src.substring(0,gif)+"_clicked.gif"; 
		}else{
			if (!push) img.src = src.substring(0,und)+".gif"; 
		}
	}
	
	function doQuery(){
		if(configform.item_chosen.length == 0){
			alert("请选择要引入的检查项！");
			return;
		}
		
		var vReturn = "";
		var vConfigItemCount = configform.item_chosen.length;
		
		for(var i=0; i<vConfigItemCount;i++ ){
			var vTemp = configform.item_chosen.options[i].value;
            vReturn = vReturn+vTemp+"@";
		}
		var sReturnMessage = RunJavaMethodTrans("com.amarsoft.app.alarm.action.AlarmConfigAction","addGroupItems","ScenarioID=<%=sScenarioID%>,GroupID=<%=sGroupID%>,ModelIDs="+vReturn);
		if(sReturnMessage == "SUCCEEDED") alert("配置成功！");
		else alert("配置失败！");
		//self.close();
	}
	
	function doDefault(){
		configform.item_available.options.length = 0;
		configform.item_chosen.length = 0;
		
		var j = 0;
		for(var i = 0; i < availableItemNameList.length; i++){
			eval("configform.item_available.options[" + j + "] = new Option(availableItemCaptionList[" + i + "], availableItemNameList[" + i + "])");
			j++;
		}
		
		j = 0;
		for(var i = 0; i < selectedItemNameList.length; i++){
			eval("configform.item_chosen.options[" + j + "] = new Option(selectedItemCaptionList[" + i + "], selectedItemNameList[" + i + "])");
			j++;
		}
	}
	
	doDefault();
</script>
<%@ include file="/IncludeEnd.jsp"%>