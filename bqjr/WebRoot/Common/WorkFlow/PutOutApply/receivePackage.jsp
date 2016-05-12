<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		���ǩ��			
	 */
	%>
<title>���ǩ��</title>

<%
	/**
	 * ��ʼ�����ؿ��ǩ������
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
					��ݵ��ţ�
				</td>
				<td  width="75px">
					<input type="text" name="expressNo" class="expressNo">
				</td>
				<td>
					��ͬ�ţ�
				</td>
				<td>
					<input type="text" name="contractNo" class="contractNo" onkeyup="checkContractNo(this,event)">
				</td>
				<td width="30px">
					<label>1</label>
				</td>
				<td>
					���ͣ�
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
	<input type="button" value="�������" onclick="addPackageTarget()">
	<input type="button" value="ȷ��" onclick="doSubmit()">
	<input type="button" value="ȡ��" onclick="doCancle()">
</div>
<div id="targetId" style="display:none;">
	<table align="center">
		<tr>
			<td width="95px">
				
			</td>
			<td width="98px">
				
			</td>
			<td>
				��ͬ�ţ�
			</td>
			<td>
				<input type="text" name="contractNo" class="contractNo" onkeyup="checkContractNo(this,event)">
			</td>
			<td width="30px">
				<label></label>
			</td>
			<td>
				���ͣ�
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
				<input type="button" value="ɾ��" onclick="delTable(this)">
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
					��ݵ��ţ�
				</td>
				<td  width="75px">
					<input type="text" name="expressNo" class="expressNo">
				</td>
				<td>
					��ͬ�ţ�
				</td>
				<td>
					<input type="text" name="contractNo" class="contractNo" onkeyup="checkContractNo(this,event)">
				</td>
				<td width="30px">
					<label>1</label>
				</td>
				<td>
					���ͣ�
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
					<input type="button" value="ɾ��" onclick="delPackageTable(this)">
				</td>
			</tr>
		</table>
	</div>
</div>
</form>
</div>
</body>

<script type="text/javascript">

	/**[@desctiption=����һ��  @param=null @return=null]**/
	function addTable(obj){
		var count = 0;
		$(obj).parent().parent().parent().parent().parent().find('.contractNo').each(function(){
			if(!$(this).val())
			count = count + 1;
		})
		if(count < 1){
			$(obj).parent().parent().parent().parent().parent().append($('#targetId').html());
			//��ǩ���ļ����½��м���
			$('#postBillDiv label').each(function(index,element){
				$(this).text(index+1);
			})
		}
	}
	
	/**[@desctiption=ɾ��һ��  @param=null @return=null]**/
	function delTable(obj){
		$(obj).parent().parent().parent().parent().remove();
		//��ǩ���ļ����½��м���
		$('#postBillDiv label').each(function(index,element){
			$(this).text(index+1);
		})
	}
	
	/**[@desctiption=��������  @param=null @return=null]**/
	function addPackageTarget(){
		$('#postBillDiv').append($('#one_pack_target').html());
		//��ǩ���ļ����½��м���
		$('#postBillDiv label').each(function(index, element){
			$(this).text(index+1);
		})
	}
	
	/**[@desctiption=����ݵ���  @param=null @return=boolean]**/
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
	
	/**[@desctiption=��֤��ͬ���  @param=null @return=null]**/
	function checkContractNo(obj, event){
		//����ǻس���
		if (event.keyCode == "13") {
			var contractNo = $(obj).val();
			if(!contractNo){
				//alert("�������ͬ��ţ�");
				return false;
			}
			//���Һ�ͬ���Ƿ�������ƽ̨����
			var count = RunMethod("Unique","uniques","business_contract,count(1),serialNo='"+contractNo+"'");
			if(count < 1){
				alert('������ĺ�ͬ��Ų���ȷ�����������룡');
				$(obj).val('');
				return false;
			}
			//�Զ����һ��
			addTable(obj);
			//������Ƶ���һ��
			$(obj).parent().parent().parent().parent().next().find('.contractNo').focus();
	    }
		
	}
	
	/**[@desctiption=ȡ��  @param=null @return=null]**/
	function doCancle(){
		if(confirm("��ȷ��Ҫȡ�����ǩ����")){
			window.close();
		}
	}
	
	/**[@desctiption=ɾ����ݵ��� @param=null @return=null]**/
	function delPackageTable(obj){
		$(obj).parent().parent().parent().parent().parent().remove();
		//��ǩ���ļ����½��м���
		$('#postBillDiv label').each(function(index,element){
			$(this).text(index+1);
		})
	}
	
	/**[@desctiption=��ͬ�Ų���Ϊ��  @param=null @return=boolean]**/
	function contractNoisNotNull(){
		var flag = true;
		$('#postBillDiv table').each(function(index,item){
			//��ͬ��
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
		
		//����ݵ���
		var flag = checkPostBillNo();
		if(!flag){
			alert('��ݵ���û���������������ͬ��');
			return false;
		}
		
		//����ͬ���Ƿ�Ϊ��
		flag = contractNoisNotNull();
		if(!flag){
			alert('��ͬ��û���������������ͬ��');
			return false;
		}
		
		var arr = new Array();
		var flag = true;
		
		$('#postBillDiv table').each(function(index, item){
			//��ݵ���
			var expressNo = $(item).parent().find('.expressNo').val();
			//��ͬ��
			var contractNoObj = $(item).find('.contractNo');
			var contractNo = contractNoObj.val();
			if(!contractNo){
				alert("��ͬ�Ų���Ϊ��");
				contractNoObj.focus();
				flag = false;
				return;
			}
			//���Һ�ͬ���Ƿ�������ƽ̨����
			var count = RunMethod("Unique","uniques","business_contract,count(1),serialNo='"+contractNo+"'");
			if(count < 1){
				alert('������ĺ�ͬ���'+contractNo+'����ȷ�����������룡');
				contractNoObj.val('');
				contractNoObj.focus();
				flag = false;
				return;
			}
			//�������
			var expressType = $(item).find('.expressType').val();
			//��ȡ��ˮ��
			var serialNo = '<%=DBKeyUtils.getSerialNo("ex")%>';
			//���
			var sortNo = index+1;
			//���ݿ��ǩ�����͸��ĵر�
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
					alert( "��ݲ���ɹ�");
				}else{
					alert("��ݲ��ʧ��-"+msg);
				}
			     
			   }

		})
		
		window.close();
	}
	
	/**[@desctiption=ȷ��ǩ��  @param=null @return=null]**/
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
		//����ݵ���
		var flag = checkPostBillNo();
		if(!flag){
			alert('��ݵ���û���������������ͬ��');
			return false;
		}
		
		//����ͬ���Ƿ�Ϊ��
		flag = contractNoisNotNull();
		if(!flag){
			alert('��ͬ��û���������������ͬ��');
			return false;
		}
		//¼����
		var inputUser = "<%=CurUser.getUserID()%>";
		//¼���˲���
		var inputOrg = "<%=CurUser.getOrgID()%>";
		//¼��ʱ��
		var inputTime = "<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		//jQuery foreach
		$('#postBillDiv table').each(function(index, item){
			//��ݵ���
			var expressNo = $(item).parent().find('.expressNo').val();
			//��ͬ��
			var contractNo = $(item).find('.contractNo').val();
			//�������
			var expressType = $(item).find('.expressType').val();
			//��ȡ��ˮ��
			var serialNo = '<%=DBKeyUtils.getSerialNo("ex")%>';
			//���
			var sortNo = index+1;
			//���ݿ��ǩ�����͸��ĵر�
			var landMarkStatus = RunMethod("Unique","uniques","code_library, itemattribute, codeno='ExpressType' and itemno='"+expressType+"' ");
			//���ȷ�Ϻ�ĵر�״̬��Ϊ�գ���ִ��update����
			if(null != landMarkStatus && landMarkStatus != '' && landMarkStatus.toUpperCase() != 'NULL'){
				RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateLandMarkStatus", "updateLanMarkStatus", "contractNo=" + contractNo + ",landMarkStatus=" + parseInt(landMarkStatus));
			}
			//����ƴ��
			var args = "serialNo="+serialNo+",expressNo="+expressNo+",contractNo="+contractNo+",expressType="+expressType+",inputUser="+inputUser+",inputOrg="+inputOrg+",inputTime="+inputTime+",sortNo="+sortNo;
			//¼������Ϣ
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateLandMarkStatus", "inserPostBill",args);
			
		});
		
		window.close();
		
	}
	
	
</script>

<%@ include file="/IncludeEnd.jsp"%>
