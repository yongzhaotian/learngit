<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<div style="width:690px; height:330px; overflow:scroll;">
	<table border="0" ; font-size:15px ;cellpadding="3" cellspacing="1" width="100%" align="center" id="serialnoconTable">   
	<tr style="text-align: center; COLOR: #0076C8; BACKGROUND-COLOR: #F4FAFF; font-weight: bold" >
		<td width="100px"   border="1">快递单号</td>
		<td width="180px"  border="1">合同号</td>
		<td width="180px"  border="1">包裹关联合同号</td>
		<td width="180px"  border="1">包裹是否存在合同号</td>
		<td width="150px"  border="1">类型</td>
	  </tr>
	<tr  style="background-color: #b9d8f3;">
	    <td><input style="width: 100px" id="expressno"   type="text" onchange="onclick12()" onblur="onclick12()" onkeydown="if(event.keyCode==13){expressnoOnclick()}"></td>
	    <td><input style="width: 180px" id="serialno"   type="text"  onchange="onclick11()"   onblur="onclick11()"  onkeydown="if(event.keyCode==13){searchIsexist()}"></td>
	    <td><input style="width: 180px" id="serialnocon" readonly="readonly"></td>
	    <td><input style="width: 120px;color: red" id="isexist" readonly="readonly" ></td>
	     <td>
	     		<select id="filetype"  style="150px" onchange="onchangeSercon(this)">
	    	 			<option value="1">合同</option>
	    	 			<option value="2">补件</option>
	    	 			<option value="3">退货</option>
	    	 			<option value="4">银行代扣</option>    	 			
	    	 </select>
	     </td>
	  </tr>
	</table>
</div>
<div style="height: 20px;"></div>
<div  style="width: 300px;position:relative; left:150px"align="center">
	<table style="width: 150px;">
	  <tr align="center">
	    <td align="center"><input type="button" value="确认" onclick="commit('Y')"></td>
	    <td align="center"><input type="button" value="不接收" onclick="commit('N')"></td> 
	  </tr>
	</table>
</div>

	<script type="text/javascript">
	
	
	var serialnoconList=null;// 根据快递单号查询出的所以合同
	var serialnoRow;// 当前输入的合同 对于的位置
	var isexist="";//默认合同部存在
	var  expressno="";
	var expressnoCount =0;
	function onclick11(){//如果输入11位 ，则触发
	var	express=	document.getElementById("serialno").value; 
		if(express.length==11){
			searchIsexist();
		}
	}
	function onclick12(){//如果输入11位 ，则触发
		var	express=	document.getElementById("expressno").value; 
			if(express.length==12){
				expressnoOnclick();
			}
	}	
	function expressnoOnclick(){
	 expressno=	document.getElementById("expressno").value; 
	if(!expressno){
		return;
	}
	expressnoCount++;
	if(expressnoCount >1){
		if(serialnoconList){
			if("F" != serialnoconList){
				for (var y = 0; y < serialnoconList.length; y++) {
					document.getElementById('tr_'+y).removeNode()
				}
			}
		}
		
	}
	var updateBy = "<%=CurUser.getUserID()%>";
	var list=	RunJavaMethodSqlca("com.amarsoft.app.billions.SelectMangeReceiveNo", "selctReceiveNo","expressno="+expressno+",updateBy="+updateBy);
	if(list !=null){
		serialnoconList = list.split(","); 
		 if(serialnoconList&&serialnoconList!="F"){
				 for (var i=0 ; i< serialnoconList.length ; i++){   
							if(serialnoconList[i]){
					 			addRow(serialnoconList[i],i);
							}
					 }
			}
		}

	}
    function addRow(serialnocon,row) {
        var newTR = document.getElementById("serialnoconTable").insertRow(document.getElementById("serialnoconTable").rows.length);
       			 newTR.id="tr_"+row;
        var newNameTD = newTR.insertCell(0);
        newNameTD.innerHTML = "";
        var newNameTD = newTR.insertCell(1);
        newNameTD.innerHTML = "";
        var newNameTD = newTR.insertCell(2);
        newNameTD.innerHTML = "<input style='width: 180px;background-color: #b9d8f3;' readonly='readonly'  id='serialnocon_"+row+"' name='array["+row+"].serialnocon' value='"+serialnocon+"'>";
        var newNameTD = newTR.insertCell(3);
        newNameTD.innerHTML = "<input style='width: 120px;background-color: #b9d8f3;' name='array["+row+"].isexist readonly='readonly'  id='isexist_"+row+"'>";
        var newNameTD = newTR.insertCell(4);  
        newNameTD.innerHTML = "<input  style='width: 80px ;background-color: #b9d8f3;' id='filetype_html_"+row+"' value='合同'  > "+
        										  "<input  type='hidden' id='filetype_"+row+"' value='1' >";
    /*    newNameTD.innerHTML = "<select style='150px' name='array["+row+"].filetype' id='filetype_"+row+"' >"+
			"<option value='1'>合同</option>"+
 			"<option value='2'>补件</option>"+
 			"<option value='3'>退货</option>"+
 			"<option value='4'>银行代扣</option>"+    	 			
 			"</select>";       */
    }

    /**
    *根据手输入合同号与查询出的所以合同匹配
    *
    */
    function searchIsexist(){
    	var data=document.getElementById("serialno");
    	if(!data){
    		return;
    	}
	    var  serialno=	data.value; 
    	if(serialnoconList&&serialno){
	    	for (var y = 0; y < serialnoconList.length; y++) {
	    		if( serialno.trim()==serialnoconList[y].trim()){
	    			isexist="有";serialnoRow=y;
	    			break ;
	    		}else{
	    			isexist="";serialnoRow=null;
	    		}
			}
    	}else{
    		return;
    	}
    	document.getElementById("serialnocon").value=serialno;
    	document.getElementById("isexist").value=isexist;
		if(serialnoRow||serialnoRow==0){
	    	document.getElementById("isexist_"+serialnoRow).value=isexist;
		}
 	}

    var count =0;// 第二次点击确认，是否存在合同如果有空指则为退回
    function commit(data){
    	 var filetypelist="";
    	 var isexistlist="";
    	 var serialnoconlist ="";
    	 var serialnoconurl ="";
    	   if(serialnoconList||"F"==serialnoconList){
    		   window.location.href=window.location.href;//刷新本页面
    		   return ;
    	   }
    	 count++;
	        for(var i=0;i<serialnoconList.length;i++) {
		        	filetypelist = document.getElementById("filetype_"+i).value;
		        	isexistlist = document.getElementById("isexist_"+i).value;
		        	serialnoconlist = document.getElementById("serialnocon_"+i).value;
			        	if(data !="N"){// 如果退回不用验证
				        	if(count <2){
						        	if(!isexistlist){
						        		alert("包裹内合同数量与实际不符，请核对后再提交！");
						        		return ;
						        	}
					        	}
				        	if(!isexistlist){
				        		data="N";
				        	}
			        	}
				if(i==0){
		        	serialnoconurl=filetypelist+"@"+isexistlist+"@"+serialnoconlist;
				}else{
					serialnoconurl=filetypelist+"@"+isexistlist+"@"+serialnoconlist+"_"+serialnoconurl;
				}	        	
	        }
		commitCan(data,serialnoconurl);
        window.location.href=window.location.href;//刷新本页面
    }
    
	function     commitCan(data,serialnoconurl){
		if(serialnoconurl==null||""==serialnoconurl){
			return;
		}
		var updateBy = "<%=CurUser.getUserID()%>";
		var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.SelectMangeReceiveNo", "updateReceive","serialnoconurl="+serialnoconurl+",updateBy="+updateBy+",receivestauts="+data+",expressno="+expressno);
   		if(str=="S"){
			if(data=="N"){
				alert("快递包裹退回");
			}else{
				alert("快递包裹接收成功");
			}
   		}
	}
    
    /**
    *选择类型
    */
    function onchangeSercon(type){
    	if(serialnoRow||serialnoRow==0){
    		document.getElementById("filetype_html_"+serialnoRow).value=onchangeData(type.value);
    		document.getElementById("filetype_"+serialnoRow).value=type.value;
    		document.getElementById("filetype_"+serialnoRow).value=onchangeData(type.value);
    	}
    }   
    
   function onchangeData(data){
	   if(data){
		   if(data=="1"){
			  return  "合同";
		   } else if(data=="2"){
			   return  "补件";
		   }else if(data=="3"){
			   return  "退货";
		   }else{
			   return  "银行代扣";
		   }
	   }
   } 
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>

	

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	//my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>