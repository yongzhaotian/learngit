<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
    Author:  cbsu 2009-10-13
    Tester:
    Content: �弶�����϶�ǩ�����
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "�弶�����϶�ǩ�����";
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sSql="";
    ASResultSet rs=null;
    String sObjectNo="",sBusinessType="",sBusinessCurrency="";
    String sAccountMonth="",sModeClassifyResult="",sCustomerName="",sCustomerID=""; 
    double dBalance = 0.0;
    //BC�����BD��
    String sTableName = "";
    //"�����ˮ��"����"��ͬ��ˮ��"
    String sHeadType = "";
    //"������"����"��ͬ���"
    String sBalanceType="";
    
    //��ȡ�������
    //FLOW_TASK���¼��ˮ��
    String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
    //�弶����������ˮ��
    String sClassifyRecordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    //�弶��������:Classify
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    //�弶�����ǽ�ݻ��ͬ
    String sResultType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ResultType"));

    //����ֵת��Ϊ���ַ���
    if(sSerialNo == null) sSerialNo = "";
    if(sClassifyRecordNo == null) sClassifyRecordNo = "";
    if(sObjectType == null) sObjectType = "";
    if(sResultType == null) sResultType = "";
    
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
    <%
 
    //����sResultType��ȷ���Ƕ�BUSINESS_DUEBILL(���)��BUSINESS_CONTRACT(��ͬ)����в���    
   if ("BusinessDueBill".equals(sResultType)) {
        sTableName = "BUSINESS_DUEBILL";
        sHeadType = "�����ˮ��";
        sBalanceType = "������";
    }
    if ("BusinessContract".equals(sResultType)) {
        sTableName = "BUSINESS_CONTRACT";
        sHeadType = "��ͬ��ˮ��";
        sBalanceType = "��ͬ���";
    } 
    

    //ȡ��ҳ����Ҫչ�ֵ�������Ϣ:���/��ͬ��ˮ�ţ�ҵ��Ʒ�֣����֣�������·ݣ�ģ���������
    sSql = " select CR.ObjectNo,BT.BusinessType,BT.BusinessCurrency," +
           " BT.Balance,CR.AccountMonth,CR.SecondResult," +
           " BT.CustomerID,BT.CustomerName" + 
           " from CLASSIFY_RECORD CR," + sTableName + " BT" + 
           " where CR.ObjectType =:ObjectType" +
           " and CR.SerialNo =:SerialNo and CR.ObjectNo=BT.SerialNo";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sResultType).setParameter("SerialNo",sClassifyRecordNo));
    if(rs.next()){
        sObjectNo = rs.getString("ObjectNo");
        sBusinessType = rs.getString("BusinessType");
        sBusinessCurrency = rs.getString("BusinessCurrency");
        //�弶����ģ�������������
        sModeClassifyResult = rs.getString("SecondResult");
        dBalance = rs.getDouble("Balance");
        sAccountMonth = rs.getString("AccountMonth");
        sCustomerName = rs.getString("CustomerName");
        sCustomerID = rs.getString("CustomerID");
         
         if (sObjectNo==null)sObjectNo="";
         if (sBusinessType==null)sBusinessType="";
         if (sBusinessCurrency==null)sBusinessCurrency="";
         if (sModeClassifyResult==null)sModeClassifyResult="";
         if (sAccountMonth==null)sAccountMonth="";
         if (sCustomerName==null)sCustomerName="";
         if (sCustomerID==null)sCustomerID="";
    }
    rs.getStatement().close();
  
               
    ASDataObject doTemp = null;
    if ("BusinessDueBill".equals(sResultType)) {
    	 String sTempletNo = "SignClassifyOpinionInfo1";
    	 doTemp = new ASDataObject(sTempletNo,Sqlca);
          }
     //ģ�ͱ�ţ�2013-5-9����
     
     
   
 	//����ASDataWindow���� 
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    //freeform��ʽ
    dwTemp.Style="2";
    Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//����������2013-5-9
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
        sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
        if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
        {
            initOpinionNo();
        }
      	//������ǩ������Ϊ�հ��ַ�
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion2"))){
			alert("��ǩ���϶����ɣ�");
			setItemValue(0,0,"PhaseOpinion2","");
			return;
		}
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
        var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);*/
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
            //������¼
            as_add("myiframe0");
            setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
            setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
            setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
            setItemValue(0,getRow(),"ObjectNo","<%=sClassifyRecordNo%>");
            setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
            setItemValue(0,getRow(),"BusinessCurrency","<%=sBusinessCurrency%>");
            setItemValue(0,getRow(),"SecondResult","<%=sModeClassifyResult%>");
            setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
            setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
            setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
            setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
        }
        setItemValue(0,getRow(),"PhaseChoice","<%=sObjectNo%>");
        setItemValue(0,getRow(),"BusinessTypeName","<%=sBusinessType%>");
        setItemValue(0,getRow(),"Balance","<%=DataConvert.toMoney(dBalance)%>");
        setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
        setItemValue(0,getRow(),"SecondResult","<%=sModeClassifyResult%>");
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