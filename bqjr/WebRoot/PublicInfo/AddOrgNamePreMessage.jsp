<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: �ͻ�ѡ��;
		Input Param:
			CustomerType: �ͻ�����
			CustomerBelong:�ͻ�����
				User:��ǰ�ͻ��ܻ�
				Org:��ǰ�����ܻ�
				OrgBelong:������Ͻ
				All:ȫ��
		Output Param:
			CustomerID: �ͻ����
			CustomerName: �ͻ�����

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ѡ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow_open
	//��ȡ��������
	String sOrgID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgID"));
	String sOrgFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgFlag"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag"));        
    String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));    
    String sSql = "",sOrgproperty="";
    String sOrgClass = "";
    if(sType==null) sType="00";
    if(sFlag==null)
     sFlag = "3";
    if(sOrgFlag==null){
      sOrgFlag = "";
    }
    sSql="select orgproperty from org_info where orgid=:orgid";
    ASResultSet rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("orgid",sOrgID));
    if (rs1.next()){
           sOrgproperty = DataConvert.toString(rs1.getString("orgproperty"));
    }
    rs1.getStatement().close();
    
    if(sOrgproperty==null) sOrgproperty="";
    
    if(sOrgID == null){
		if(sOrgFlag.equals ("1")){
		  	sSql = "select OrgID,OrgName,OrgClass from ORG_INFO where length(OrgID)!=4 order by OrgID ";
		}else{ 
		  	sSql = "select OrgID,OrgName,OrgClass from ORG_INFO order by OrgID ";
		}    
    }else if(sOrgID.equals("5")){
       sSql = "select OrgID,OrgName,OrgClass from ORG_INFO where (OrgID like '1%' or BelongArea='1') and length(OrgID)=7 order by OrgID ";
    }else{
        if((sOrgproperty.equals("01")||sOrgproperty.equals("02")||sOrgproperty.equals("03")||sOrgproperty.equals("04"))&&(sOrgID.length()<=4)&&(sFlag.equals("1")))
           sSql = "select OrgID,OrgName,OrgClass from ORG_INFO  order by OrgID ";
        else if((sOrgproperty.equals("01")||sOrgproperty.equals("02")||sOrgproperty.equals("03")||sOrgproperty.equals("04"))&&(sFlag.equals("1")))
           sSql = "select OrgID,OrgName,OrgClass from ORG_INFO where OrgID like '"+sOrgID.substring(0,7)+"%'  order by OrgID ";
        else
           sSql = "select OrgID,OrgName,OrgClass from ORG_INFO where OrgID like '"+sOrgID+"%' or BelongArea='"+sOrgID+"' order by OrgID ";
    }
    if(sType.equals("01")&&sOrgID.length()>=7){
      sSql = "select distinct OrgID,OrgName,OrgClass from ORG_INFO where ( orglevel='2' and  OrgID  like '"+sOrgID.substring(0,7)+"') or orglevel='0' order by OrgID ";
    }else if(sType.equals("01")){
      sSql = "select distinct OrgID,OrgName,OrgClass from ORG_INFO where  orglevel='0' order by OrgID ";
    }

    ASDataObject doTemp = new ASDataObject(sSql);
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);


	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>



<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	function doSearch(){
		document.forms["form1"].submit();
	}
	function mySelectRow(){
		try{
			sOrgID = getItemValue(0,getRow(),"OrgID");
			sOrgName = getItemValue(0,getRow(),"OrgName");
			//sCertType = getItemValue(0,getRow(),"CertType");
			//sCertID = getItemValue(0,getRow(),"CertID");
			if (typeof(sOrgID)=="undefined" || sOrgID.length==0)	return;
        }catch(e){
			return;
		}
		parent.sObjectInfo =sOrgID+"@"+sOrgName; 
	}

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>