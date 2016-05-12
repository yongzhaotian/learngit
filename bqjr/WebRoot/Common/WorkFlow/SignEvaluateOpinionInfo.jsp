<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:  bwang 
	Tester:
	Content: ���õȼ��϶�ǩ�����
	Input Param:
		
	Output param:
	History Log: 
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ��϶�ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	String sSql="";
	ASResultSet rs=null;
	String sCognResult="",sCustomerName="",sModelName="";
	String sAccountMonth="",sEvaluateDate="",sSystemScore="",sSystemResult="",sCustomerID="";
	//��ȡ���������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sERSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ERSerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sERSerialNo == null) sERSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�õ�ǰ�׶ε��������
	sSql = " select ER.ObjectNo,getCustomerName(ER.ObjectNo) as CustomerName,"+
	   " CognResult,ER.AccountMonth ,"+
	   " EC.ModelName as ModelName,ER.EvaluateDate,ER.EvaluateScore,ER.EvaluateResult"+
	   " from EVALUATE_RECORD ER,EVALUATE_CATALOG EC" + 
       " where ER.ObjectType = :ObjectType"+
       " and ER.SerialNo = :SerialNo and ER.ModelNo=EC.ModelNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("SerialNo",sERSerialNo));
	if(rs.next()){
		sCognResult = rs.getString("CognResult");
		sModelName=rs.getString("ModelName");
		sAccountMonth=rs.getString("AccountMonth");
	 	sEvaluateDate=rs.getString("EvaluateDate");
 		sSystemScore=rs.getString("EvaluateScore");
	 	sSystemResult=rs.getString("EvaluateResult");
	 	sCustomerID=rs.getString("ObjectNo");
	 	sCustomerName=rs.getString("CustomerName");
	 	
	 	if (sModelName==null)sModelName="";
	 	if (sAccountMonth==null)sAccountMonth="";
	 	if (sEvaluateDate==null)sEvaluateDate="";
	 	if (sSystemScore==null)sSystemScore="";
	 	if (sSystemResult==null)sSystemResult="";
	 	if (sCustomerID==null)sCustomerID="";
	 	if (sCustomerName==null)sCustomerName="";
		if(sCognResult ==null) sCognResult=""; 
	 
	}
	
	rs.getStatement().close();
	String sHeaders[][] = { 
							{"AccountMonth","����·�"},
	                        {"ModelName","����ģ��"},
	                        {"SystemScore","ϵͳ�����÷�"},
	                        {"SystemResult","ϵͳ�������"},
	                        {"CustomerName","�ͻ�����"},
	                        {"CognScore","�˹������÷�"},
							{"CognResult","�˹��������"},
							{"PhaseOpinion","����ԭ��˵��"},
							{"InputTime","�˹���������"},
							{"InputOrgName","������λ"},
							{"InputUserName","������"}
			              };                 
		
	//����SQL���
	 sSql = 	" select SerialNo,'' as AccountMonth, PhaseChoice as ModelName,"+//����·�,����ģ��
	 			" PhaseOpinion3 as SystemScore,PhaseOpinion1 as SystemResult,"+//ϵͳ�����÷֣�ϵͳ�������
	 			" BailSum as CognScore,PhaseOpinion2 as CognResult,"+//�˹����֣��˹��������
	 			" OpinionNo,PhaseOpinion, CustomerId,CustomerName,"+//����ԭ��˵�����ͻ�����
				" InputOrg,getOrgName(InputOrg) as InputOrgName,ObjectType,ObjectNo, "+
				" InputUser,getUserName(InputUser) as InputUserName, "+
				" InputTime,UpdateUser,UpdateTime "+
				" from FLOW_OPINION " +
				" where SerialNo='"+sSerialNo+"' ";
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders); 
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	//�����ֶ��Ƿ�ɼ�  
	doTemp.setVisible("AccountMonth,SerialNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime,ObjectType,ObjectNo,CustomerId",false);		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("InputOrgName,InputUserName,AccountMonth",false);
	//���ñ�����
	doTemp.setRequired("CognScore,PhaseOpinion",true);
	doTemp.setAlign("SystemScore","3");
	doTemp.setType("CognScore","Number");
	doTemp.setCheckFormat("CognScore","2");
	//�˹��϶�����
	doTemp.setHTMLStyle("CognScore"," onChange=\"javascript:parent.setResult()\" ");
	doTemp.setHTMLStyle("CognScore"," onkeyup=\"javascript:parent.setResult()\" ");
	//doTemp.appendHTMLStyle("CognScore"," myvalid=\"parseFloat(myobj.value,10)>0.01 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�˹������÷ֵķ�ΧΪ(0,100]\" ");
	
	//����������
	doTemp.setDDDWSql("SystemResult,CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	//����ֻ������
	doTemp.setReadOnly("CustomerName,InputOrgName,InputUserName,InputTime,AccountMonth,ModelName,CognResult,SystemScore,SystemResult",true);
	//�༭��ʽΪ��ע��
	doTemp.setEditStyle("PhaseOpinion","3");
	//��html��ʽ
	doTemp.setHTMLStyle("ModelName"," style={width:50%}");
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:50%;overflow:auto;font-size:9pt;} ");
	//��������ԭ�����������
	doTemp.setLimit("PhaseOpinion",400);
	
	//����ASDataWindow����		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform��ʽ
	
	//���˹����������ͽ�����µ�EVALUATE_RECORD����
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.UpdateEvaluateManResult(#ObjectNo,#SerialNo)");
    dwTemp.setEvent("AfterUpdate","!WorkFlowEngine.UpdateEvaluateManResult(#ObjectNo,#SerialNo)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sObjectType = "<%=sObjectType%>";
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//������ǩ������Ϊ�հ��ַ�
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion"))){
			alert("��ǩ������ԭ��˵����");
			setItemValue(0,0,"PhaseOpinion","");
			return;
		}
		//�������˹�����Ϊ0
		if( getItemValue(0,0,"CognScore") == 0.0 || getItemValue(0,0,"CognScore") > 100.0 ){
			alert("����ȷ��д�˹����֣��˹������÷ֵķ�ΧΪ(0,100]");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0"); 
	}
	
	/*~[Describe=ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert("����û��ǩ�������������ɾ�����������");
	 	}
	 	else if(confirm("��ȷʵҪɾ�������"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("���ɾ���ɹ�!");
	  		}
	   		else
	   		{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
		}
		reloadSelf();
	} 
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
								
		//��ȡ��ˮ��
		var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sOpinionNo);*/
		//��ȡ��ˮ��
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		/** --end --*/
	}
	
	/*~[Describe=����һ���¼�¼;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ���������������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sERSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");	
			setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,getRow(),"ModelName","<%=sModelName%>");
			setItemValue(0,getRow(),"EvaluateDate","<%=sEvaluateDate%>");
			setItemValue(0,getRow(),"SystemScore","<%=DataConvert.toMoney(sSystemScore)%>");
			setItemValue(0,getRow(),"SystemResult","<%=sSystemResult%>");	
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");	
			setItemValue(0,getRow(),"CognResult","<%=sCognResult%>");
		}      
	}
	
		/*~[Describe=���ݷ�ֵ�����������;InputParam=��;OutPutParam=��;]~*/
	function setResult(){		
		//������ֵ�������
		//��Ҫ���ݾ���������е���
		var CognScore = getItemValue(0,getRow(),"CognScore");
	    var sObjectType = "<%=sObjectType%>";
	    var sObjectNo = "<%=sObjectNo%>";
	    var sERSerialNo = "<%=sERSerialNo%>";

	    //�����ж������õȼ�����ģ�壬��ÿ��ģ�����������������ͬ����˱�����ݲ�ͬ��ģ��������������ֵ�Ľ�����㹤����
	    //add by cbsu 2009-11-18
	    var sParaString = sObjectType + "," + sObjectNo + "," + sERSerialNo + "," + CognScore;
		var result = RunMethod("���õȼ�����","GetEvaluateResult",sParaString);
	    if(typeof(result)=="undefined" || result.length==0) {
	        result = "0";
		} else
		setItemValue(0,getRow(),"CognResult",result);
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>