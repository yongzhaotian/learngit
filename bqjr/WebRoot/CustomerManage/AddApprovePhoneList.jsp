<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: �绰����LISTҳ��
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�绰�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

    System.out.println("----------------------------------"+sCustomerID);
    //��绰�ؼ�ҳ��beging=============
    out.println("<div>");
    out.println("��ϯ��:<input id='txtAgentID' style='width: 60px' type='text' value='' />");
    out.println("<input id='btnInit' style='width: 84px' type='button' value='��ʼ��' /><input id='btnUnInit' style='width: 84px' type='button' value='����' /></div>");
    out.println("<input id='btnQuery' style='width: 84px' type='button' value='��ѯ' /></div>");
    out.println("<div>");
    out.println("<OBJECT id = 'objSp' style='Z-INDEX: 101; LEFT: 24px; WIDTH: 1300px; HEIGHT: 145px' classid=clsid:5E57CDEB-8FBB-4AB5-9050-3A307E5BCFBD></OBJECT>");
    out.println("</div>");
    //��绰�ؼ�ҳ��end================
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AddPhoneList"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//������ʾģ�����
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","����","addCommon()",sResourcesPath},
			{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	var sp;
    var ICC;
    var btn_Init;
    var btn_UnInit;
    var txt_AgentID;
    var txt_StationNo;
    var txt_CtiServerIp;
    var CookieAgtValue;
    var CookieStaValue;
    var txt_CallInNum;
    document.body.onload = function()
    {
        sp = document.getElementById("objSp");
        
	      txt_AgentID = document.getElementById("txtAgentID");
	           
        
        sp.attachEvent('OnError',Error);
        sp.attachEvent('OnInService',InService);
        sp.attachEvent('OnInBoundCall',inBoundCall);
        sp.attachEvent('OnCallInfoChange',CallInfoChange);
	      sp.attachEvent('OnTransferMessage',TransfMessage);
    	  sp.attachEvent('OnAnswerCall',AnswerCall)
        btn_Init = document.getElementById("btnInit");
        btn_Init.onclick = btnInit_Click;
        btn_btnUnInit = document.getElementById("btnUnInit");
        btn_btnUnInit.onclick = btnUnInit_Click;
        btn_btnQuery = document.getElementById("btnQuery");
        btn_btnQuery.onclick = btnQuery_Click;
        
     
        CookieAgtValue = getCookie('AgtID');
        document.all.txtAgentID.value = CookieAgtValue;
        
                    
    }

     //��ѯ
    function btnQuery_Click()
    {
        txt_CallInNum = sp.QueryData("RtStatusSt_Business", "Curr_Call_Cnt,2", "Business_ID,1,bu0001");
    }
    
    //��ʼ������
    function btnInit_Click()
    {
        //alert("123");
        sp.StartService();
	    
    }
    
  
    //��ʼ�������¼�
   function InService()
    {
       sp.style.visibility="visible";    
       sp.SetLoginAgentState(1103);
       sp.SetIVRNo("4855")
       //sp.SetReadConfig();
       //sp.CallBarVisible(0);
       //sp.CaptionVisible(0);
       //sp.StatusBarVisible(0);
       var retCode = sp.SPInit(txt_AgentID.value, 1);
       //�򿪻�ȡʵʱ���ݿ���
       sp.MonDataStart();
       if (retCode > 1)
       {
       	  alert(retCode);
       }
    }
    
    
    //����ʼ��
    function btnUnInit_Click()
    {
        //sp.SubscribeStop(subDD);
        sp.MonDataStop();
        var ret = sp.SPUnInit();
        sp.style.visibility="hidden";     
    }
    
    //AgentReadyClick
    function agentReady()
    {
 //     sp.SetOperationCancel();
    }
    
    //SubScribeDataEvent
     function subScribeDataEvent(data)
    {
     // alert("ScribeDataEvent:" + data);
    }
    function But(AgtStateButtonsFlag,NotReadySubStateButtonsFlag, StationStateButtonsFlag)
    {
      //alert(AgtStateButtonsFlag);
     // alert(NotReadySubStateButtonsFlag);
      //alert(StationStateButtonsFlag);
    }
    //InBoundCallEvent  //���絯���¼�
    function inBoundCall(customercallid, callid, MediaType, customercallno, serviceno, currqueue, trunkno)      
    {
    //  alert(MediaType);
    //  sp.SetCustomerCallData(customercallid, "Cust_Add_Field1,1,401");
    //    var getCCD = sp.GetCustomerCallData(customercallid, "Cust_Add_Field2,1");
    //    var queryDD = sp.QueryData("RtStatusData_AgentState", "Agent_Name,1","Agent_ID,1,1005");
        //var transDD = sp.TransferMessage("1005","ת������");
        //var subDD = sp.SubscribeStart("RtStatusSt_AgentGroup", "A00001", 0, 0,"Agt_Sub_State_Cnt2,0;Agt_Sub_State_Cnt3,0");
        //alert(MediaType+'|=='+customercallid+'|=='+customercallno+'|=='+serviceno+'|=='+currqueue+'|=='+trunkno); 
       
    }
    
    
    function AnswerCall()      
    {
    //	 alert(1111);
       //sp.AnswerCall();
    //   sp.ConsultantCall("41159", "");
    //   sp.ConferenceCall();
	      
    }

    
    
    //CallInfoChange //���б仯
    function CallInfoChange(CallType,CustomerCallID,callid,MediaType,EventReason)      
    {
    	//alert(CallType+'|==|'+CustomerCallID+'|==|'+callid+'|==|'+MediaType);
    
    }
    
    //AgentStateChangeEvent
    function agentStateChangeEvent(id, stateid, statename, substateid, substatename, oldstateid, oldstatename, oldsubstateid, oldsubstatename)
    {
     	//alert(stateid + '|' +substateid);
    }
    
    //StationStateChangeEvent
    function stationStateChangeEvent(stateid, statename, oldstateid, oldstatename, eventid)
    {
         //alert(stateid);
     	//alert(sp.QueryData("RtStatusData_Agent", "Agent_ID,1;Agt_Sub_State_Str,1;Station_State,0", "Agent_ID,1,1001"));
    }
    function Error(ErrorCode, ErrorStr)
    {
    	if (ErrorCode > 100)
    	{
     //  	   alert('�������Ӵ���,�����µ�½,������:'+ ErrorCode);
       }
    }
    
    function TransfMessage(MessageData)
    {
	   // alert('�յ���Ϣ��'+MessageData);
    }
    
    //дcookies���� 
    function SetCookie(name,value)//����������һ����cookie�����ӣ�һ����ֵ
    {
    	alert("111");
    var Days = 720; //�� cookie �������� 720 ��
    var exp  = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
    }
    function getCookie(name)//ȡcookies����        
    {
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
    if(arr != null) return unescape(arr[2]); return null;

    }
    function delCookie(name)//ɾ��cookie
    {
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
    }
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/

	function addCommon()
	{ 	 
	    OpenPage("/CustomerManage/AddPhoneInfo.jsp","_self","");
	}	

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/CustomerManage/AddPhoneInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	
	/*~[Describe=ȷ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
      doReturn();
	}
	
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sZipCode     = getItemValue(0,getRow(),"ZipCode");//����
		sPhoneCode   = getItemValue(0,getRow(),"PhoneCode");//�绰����
		sExtensionNo    = getItemValue(0,getRow(),"ExtensionNo");//�ֻ�����
		sPhoneType    = getItemValue(0,getRow(),"PhoneType");//�绰����
		
        
		//alert("-----"+sZipCode+"--------"+sPhoneCode+"-----"+sExtensionNo);
		top.returnValue = sZipCode+"@"+sPhoneCode+"@"+sExtensionNo+"@"+sPhoneType;
		top.close();
	}
	
	/*~[Describe=������绰;InputParam=��;OutPutParam=�绰����;]~*/
	function openphone(){
		var sPhoneType = getItemValue(0,getRow(),"PhoneCode");
		alert(sPhoneType);
	}
	

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
