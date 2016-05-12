<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		快递签收			
	 */
	%>
<title>快递签收</title>

<%
	/**
	 * 初始化加载快递签收类型
	 */
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select itemno,itemname from code_library t where t.codeno='ExpressType' and t.isinuse='1' order by itemno asc"));
	List<Map<String, Object>> rsList = new ArrayList<Map<String, Object>>();
	while(rs.next()){
		Map<String, Object> rsMap = new HashMap<String, Object>();
		rsMap.put("itemno", rs.getString("itemno"));
		rsMap.put("itemname", rs.getString("itemname"));
		rsList.add(rsMap);
	}
	rs.getStatement().close();
%>

<body>
<div id="ButtonsDiv" style="margin-left: 0%; margin-right:0%; margin-top : 10px;">
<form name="CityForm" style="margin-bottom:0px;" action="" method="post">
<div id="postBillDiv" style="width:100%;">
	<div class="one_package_div">
		<table align="center">
			<tr>
				<td  width="60px">
					快递单号：
				</td>
				<td  width="75px">
					<input type="text" name="expressNo" class="expressNo">
				</td>
				<td>
					合同号：
				</td>
				<td>
					<input type="text" name="contractNo" class="contractNo" onkeyup="checkContractNo(this,event)">
				</td>
				<td width="30px">
					<label>1</label>
				</td>
				<td>
					类型：
				</td>
				<td>
					<select class="expressType" name="expressType">
						<%
							for (Map<String, Object> map : rsList) {							
						%>
						   <option value="<%=map.get("itemno")%>"><%=map.get("itemname")%></option>
						<%
							}
						%>
						
					</select>
				</td>
				<td width="35px">
				</td>
			</tr>
		</table>
	</div>
</div>
<div style="text-align:center;margin-top:15px;">
	<input type="button" value="新增快递" onclick="addPackageTarget()">
	<input type="button" value="确定" onclick="doSubmit()">
	<input type="button" value="取消" onclick="doCancle()">
</div>
<div id="targetId" style="display:none;">
	<table align="center">
		<tr>
			<td width="95px">
				
			</td>
			<td width="98px">
				
			</td>
			<td>
				合同号：
			</td>
			<td>
				<input type="text" name="contractNo" class="contractNo" onkeyup="checkContractNo(this,event)">
			</td>
			<td width="30px">
				<label></label>
			</td>
			<td>
				类型：
			</td>
			<td>
				<select class="expressType" name="expressType">
					<%
						for (Map<String, Object> map : rsList) {							
					%>
					   <option value="<%=map.get("itemno")%>"><%=map.get("itemname")%></option>
					<%
						}
					%>
				</select>
			</td>
			<td width="35px">
				<input type="button" value="删除" onclick="delTable(this)">
			</td>
		</tr>
	</table>
</div>

<div id="one_pack_target" style="display:none;">
	<div class="one_package_div">
		<p style="margin-top:8px; border-bottom-color: #e2e2e2; border-bottom-style: dashed; border-bottom-width: 1px;"></p>
		<table align="center">
			<tr>
				<td  width="60px">
					快递单号：
				</td>
				<td  width="75px">
					<input type="text" name="expressNo" class="expressNo">
				</td>
				<td>
					合同号：
				</td>
				<td>
					<input type="text" name="contractNo" class="contractNo" onkeyup="checkContractNo(this,event)">
				</td>
				<td width="30px">
					<label>1</label>
				</td>
				<td>
					类型：
				</td>
				<td>
					<select class="expressType" name="expressType">
						<%
							for (Map<String, Object> map : rsList) {							
						%>
						   <option value="<%=map.get("itemno")%>"><%=map.get("itemname")%></option>
						<%
							}
						%>
						
					</select>
				</td>
				<td width="35px">
					<input type="button" value="删除" onclick="delPackageTable(this)">
				</td>
			</tr>
		</table>
	</div>
</div>
</form>
</div>
</body>

<script type="text/javascript">

	/**[@desctiption=新增一条  @param=null @return=null]**/
	function addTable(obj){
		var count = 0;
		$(obj).parent().parent().parent().parent().parent().find('.contractNo').each(function(){
			if(!$(this).val())
			count = count + 1;
		})
		if(count < 1){
			$(obj).parent().parent().parent().parent().parent().append($('#targetId').html());
			//对签收文件重新进行计数
			$('#postBillDiv label').each(function(index,element){
				$(this).text(index+1);
			})
		}
	}
	
	/**[@desctiption=删除一条  @param=null @return=null]**/
	function delTable(obj){
		$(obj).parent().parent().parent().parent().remove();
		//对签收文件重新进行计数
		$('#postBillDiv label').each(function(index,element){
			$(this).text(index+1);
		})
	}
	
	/**[@desctiption=新增包裹  @param=null @return=null]**/
	function addPackageTarget(){
		$('#postBillDiv').append($('#one_pack_target').html());
		//对签收文件重新进行计数
		$('#postBillDiv label').each(function(index, element){
			$(this).text(index+1);
		})
	}
	
	/**[@desctiption=检查快递单号  @param=null @return=boolean]**/
	function checkPostBillNo(){
		var flag = true;
		$('#postBillDiv').find('.expressNo').each(function(index, element){
			if(!$(element).val()){
				flag = false;
				return;
			}
		})
		return flag;
	}
	
	/**[@desctiption=验证合同编号  @param=null @return=null]**/
	function checkContractNo(obj, event){
		//如果是回车键
		if (event.keyCode == "13") {
			var contractNo = $(obj).val();
			if(!contractNo){
				//alert("请输入合同编号！");
				return false;
			}
			//查找合同号是否在我们平台存在
			var count = RunMethod("Unique","uniques","business_contract,count(1),serialNo='"+contractNo+"'");
			if(count < 1){
				alert('你输入的合同编号不正确，请重新输入！');
				$(obj).val('');
				return false;
			}
			//自动添加一行
			addTable(obj);
			//将光标移到下一行
			$(obj).parent().parent().parent().parent().next().find('.contractNo').focus();
	    }
		
	}
	
	/**[@desctiption=取消  @param=null @return=null]**/
	function doCancle(){
		if(confirm("您确定要取消快递签收吗？")){
			window.close();
		}
	}
	
	/**[@desctiption=删除快递单号 @param=null @return=null]**/
	function delPackageTable(obj){
		$(obj).parent().parent().parent().parent().parent().remove();
		//对签收文件重新进行计数
		$('#postBillDiv label').each(function(index,element){
			$(this).text(index+1);
		})
	}
	
	/**[@desctiption=合同号不能为空  @param=null @return=boolean]**/
	function contractNoisNotNull(){
		var flag = true;
		$('#postBillDiv table').each(function(index,item){
			//合同号
			var contractNo = $(item).find('.contractNo').val();
			if(!contractNo){
				flag = false;
				return;
			}
		});
		return flag;
	}
	
	function ExpressUnpacking(expressNo,contractNo,expressType,serialNo,sortNo){
		this.expressNo = expressNo;
		this.contractNo = contractNo;
		this.expressType = expressType;
		this.serialNo = serialNo;
		this.sortNo = sortNo;
	}
	
	function doSubmit(){
		
		//检查快递单号
		var flag = checkPostBillNo();
		if(!flag){
			alert('快递单号没填完整，请输入合同号');
			return false;
		}
		
		//检查合同号是否为空
		flag = contractNoisNotNull();
		if(!flag){
			alert('合同号没填完整，请输入合同号');
			return false;
		}
		
		var arr = new Array();
		var flag = true;
		
		$('#postBillDiv table').each(function(index, item){
			//快递单号
			var expressNo = $(item).parent().find('.expressNo').val();
			//合同号
			var contractNoObj = $(item).find('.contractNo');
			var contractNo = contractNoObj.val();
			if(!contractNo){
				alert("合同号不能为空");
				contractNoObj.focus();
				flag = false;
				return;
			}
			//查找合同号是否在我们平台存在
			var count = RunMethod("Unique","uniques","business_contract,count(1),serialNo='"+contractNo+"'");
			if(count < 1){
				alert('你输入的合同编号'+contractNo+'不正确，请重新输入！');
				contractNoObj.val('');
				contractNoObj.focus();
				flag = false;
				return;
			}
			//快递类型
			var expressType = $(item).find('.expressType').val();
			//获取流水号
			var serialNo = '<%=DBKeyUtils.getSerialNo("ex")%>';
			//编号
			var sortNo = index+1;
			//根据快递签收类型更改地标
			var obj = new ExpressUnpacking(expressNo,contractNo,expressType,serialNo,sortNo);
			arr.push(obj);
		});
		
		if(!flag){
			return;
		}
		
		var str = "param="+JSON.stringify(arr);
		
		$.ajax({
			type:"post",
			url: sWebRootPath+"/servlet/expressUnpacking",
			data: str,
			async: false,
			success: function(msg){
				if(msg == "success"){
					alert( "快递拆包成功");
				}else{
					alert("快递拆包失败-"+msg);
				}
			     
			   }

		})
		
		window.close();
	}
	
	/**[@desctiption=确定签收  @param=null @return=null]**/
	function doSubmit_back(){
		
		var obj1 = new testObj("zty","man");
		var obj2 = new testObj("wmf","woman");
		var arr = new Array();
		arr.push(obj1);
		arr.push(obj2);
		var str = "param="+JSON.stringify(arr);
		
		$.ajax({
			type:"post",
			url: sWebRootPath+"/servlet/expressUnpacking",
			data: str,
			async: false,
			success: function(msg){
			     alert( "Data Saved: " + msg );
			   }

		})
		
		return;
		//检查快递单号
		var flag = checkPostBillNo();
		if(!flag){
			alert('快递单号没填完整，请输入合同号');
			return false;
		}
		
		//检查合同号是否为空
		flag = contractNoisNotNull();
		if(!flag){
			alert('合同号没填完整，请输入合同号');
			return false;
		}
		//录入人
		var inputUser = "<%=CurUser.getUserID()%>";
		//录入人部门
		var inputOrg = "<%=CurUser.getOrgID()%>";
		//录入时间
		var inputTime = "<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		//jQuery foreach
		$('#postBillDiv table').each(function(index, item){
			//快递单号
			var expressNo = $(item).parent().find('.expressNo').val();
			//合同号
			var contractNo = $(item).find('.contractNo').val();
			//快递类型
			var expressType = $(item).find('.expressType').val();
			//获取流水号
			var serialNo = '<%=DBKeyUtils.getSerialNo("ex")%>';
			//编号
			var sortNo = index+1;
			//根据快递签收类型更改地标
			var landMarkStatus = RunMethod("Unique","uniques","code_library, itemattribute, codeno='ExpressType' and itemno='"+expressType+"' ");
			//如果确认后的地标状态不为空，则执行update操作
			if(null != landMarkStatus && landMarkStatus != '' && landMarkStatus.toUpperCase() != 'NULL'){
				RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateLandMarkStatus", "updateLanMarkStatus", "contractNo=" + contractNo + ",landMarkStatus=" + parseInt(landMarkStatus));
			}
			//参数拼接
			var args = "serialNo="+serialNo+",expressNo="+expressNo+",contractNo="+contractNo+",expressType="+expressType+",inputUser="+inputUser+",inputOrg="+inputOrg+",inputTime="+inputTime+",sortNo="+sortNo;
			//录入快递信息
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateLandMarkStatus", "inserPostBill",args);
			
		});
		
		window.close();
		
	}
	
	
</script>

<%@ include file="/IncludeEnd.jsp"%>
