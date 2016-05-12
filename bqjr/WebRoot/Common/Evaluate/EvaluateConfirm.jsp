<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �����˹��϶�
		Input Param:
			              --ObjectType:  ��������
			              --ObjectNo  :  ������
			              --ModelType :  ����ģ������ 010--���õȼ�����   030--���ն�����  080--�����޶� 018--���ô�������  ������'EvaluateModelType'����˵��
			              --CustomerID��  �ͻ�����        ��        
	 */
	String PG_TITLE = "�����˹��϶�"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������������������͡������š�������¼��ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));

	String sHeaders[][] = { {"AccountMonth","����·�"},
	                        {"ModelName","����ģ��"},
	                        {"EvaluateDate","ϵͳ��������"},
	                        {"EvaluateScore","ϵͳ�����÷�"},
	                        {"EvaluateResult","ϵͳ�������"},
					          	{"CognScore","�˹������÷�"},
								{"CognResult","�˹��������"},
								{"FinishDate","�˹������������"},
								{"CognOrgName","������λ"},
								{"CognUserName","������"},
	                        {"Evaluatelevel","��������"},
	                        {"Remark","����˵��"}
	};
	
	String sSql = " select R.SerialNo,R.AccountMonth,C.ModelName,C.ModelNo,R.EvaluateDate,R.EvaluateScore,R.EvaluateResult,R.CognScore,R.CognResult,R.FinishDate,R.Remark,"+
	       " R.CognOrgID,getOrgName(CognOrgID) as CognOrgName,R.CognUserID,getUserName(CognUserID) as CognUserName,Evaluatelevel"+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType='"+sObjectType + "' and SerialNo ='"+sSerialNo+"'and ObjectNo='"+ sObjectNo + "' order by AccountMonth DESC";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);

	doTemp.setVisible("SerialNo,ModelNo,CognUserID,CognOrgID,Evaluatelevel",false);
	doTemp.setUpdateable("ModelName,CognOrgName,CognUserName",false);
	//���ÿ��
	doTemp.setHTMLStyle("ModelName","style={width:300px} ");
	doTemp.setHTMLStyle("FinishDate,AccountMonth,EvaluateDate","  style={width:70px}  ");
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	doTemp.setCheckFormat("EvaluateScore,CognScore","2");
	doTemp.setType("EvaluateScore,CognScore","Number");
	doTemp.setDDDWSql("CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' and IsInUse='1' order by SortNo ");
	doTemp.setReadOnly("AccountMonth,ModelName,EvaluateDate,EvaluateScore,EvaluateResult,CognOrgName,CognUserName,FinishDate",true);
	
	doTemp.setHTMLStyle("Remark","style={width:300px;height:70px}");
	doTemp.setRequired("R.Remark",true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="0";      //����Ϊfree���

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����","my_save()",sResourcesPath},
		{"true","","Button","�ύ","�ύ","my_Finished()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function my_save(){
		var sFinishDate  = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sFinishDate)!="undefined" && sFinishDate.length>0){
			alert("������¼���ύ���޷��޸��˹��϶���Ϣ��");
			return;
		}
		setItemValue(0,0,"CognUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"CognOrgID","<%=CurOrg.getOrgID()%>");
		as_save('myiframe0');
	}
	
	function my_Finished(){
		var sFinishDate  = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sFinishDate)!="undefined" && sFinishDate.length>0){
			alert("������¼���ύ����ȷ�ϣ�");
			return;
		}
		if(confirm("��ȷ��Ҫ�ύ�϶���")){
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			my_save(); 
		}
	}

	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>