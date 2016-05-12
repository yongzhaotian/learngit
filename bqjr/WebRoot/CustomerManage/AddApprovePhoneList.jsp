<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 电话号码LIST页面
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "电话列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
    String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

    System.out.println("----------------------------------"+sCustomerID);
    //软电话控件页面beging=============
    out.println("<div>");
    out.println("坐席号:<input id='txtAgentID' style='width: 60px' type='text' value='' />");
    out.println("<input id='btnInit' style='width: 84px' type='button' value='初始化' /><input id='btnUnInit' style='width: 84px' type='button' value='销毁' /></div>");
    out.println("<input id='btnQuery' style='width: 84px' type='button' value='查询' /></div>");
    out.println("<div>");
    out.println("<OBJECT id = 'objSp' style='Z-INDEX: 101; LEFT: 24px; WIDTH: 1300px; HEIGHT: 145px' classid=clsid:5E57CDEB-8FBB-4AB5-9050-3A307E5BCFBD></OBJECT>");
    out.println("</div>");
    //软电话控件页面end================
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AddPhoneList"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//传入显示模板参数
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
			{"true","","Button","新增","新增","addCommon()",sResourcesPath},
			{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","确定","确定","doCreation()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
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

     //查询
    function btnQuery_Click()
    {
        txt_CallInNum = sp.QueryData("RtStatusSt_Business", "Curr_Call_Cnt,2", "Business_ID,1,bu0001");
    }
    
    //初始化服务
    function btnInit_Click()
    {
        //alert("123");
        sp.StartService();
	    
    }
    
  
    //初始化服务事件
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
       //打开获取实时数据开关
       sp.MonDataStart();
       if (retCode > 1)
       {
       	  alert(retCode);
       }
    }
    
    
    //反初始化
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
    //InBoundCallEvent  //来电弹屏事件
    function inBoundCall(customercallid, callid, MediaType, customercallno, serviceno, currqueue, trunkno)      
    {
    //  alert(MediaType);
    //  sp.SetCustomerCallData(customercallid, "Cust_Add_Field1,1,401");
    //    var getCCD = sp.GetCustomerCallData(customercallid, "Cust_Add_Field2,1");
    //    var queryDD = sp.QueryData("RtStatusData_AgentState", "Agent_Name,1","Agent_ID,1,1005");
        //var transDD = sp.TransferMessage("1005","转发数据");
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

    
    
    //CallInfoChange //呼叫变化
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
     //  	   alert('网络连接错误,请重新登陆,错误码:'+ ErrorCode);
       }
    }
    
    function TransfMessage(MessageData)
    {
	   // alert('收到消息：'+MessageData);
    }
    
    //写cookies函数 
    function SetCookie(name,value)//两个参数，一个是cookie的名子，一个是值
    {
    	alert("111");
    var Days = 720; //此 cookie 将被保存 720 天
    var exp  = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
    }
    function getCookie(name)//取cookies函数        
    {
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
    if(arr != null) return unescape(arr[2]); return null;

    }
    function delCookie(name)//删除cookie
    {
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
    }
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/

	function addCommon()
	{ 	 
	    OpenPage("/CustomerManage/AddPhoneInfo.jsp","_self","");
	}	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}	

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/CustomerManage/AddPhoneInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	
	/*~[Describe=确定信息;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
      doReturn();
	}
	
	/*~[Describe=确认;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sZipCode     = getItemValue(0,getRow(),"ZipCode");//区号
		sPhoneCode   = getItemValue(0,getRow(),"PhoneCode");//电话号码
		sExtensionNo    = getItemValue(0,getRow(),"ExtensionNo");//分机号码
		sPhoneType    = getItemValue(0,getRow(),"PhoneType");//电话类型
		
        
		//alert("-----"+sZipCode+"--------"+sPhoneCode+"-----"+sExtensionNo);
		top.returnValue = sZipCode+"@"+sPhoneCode+"@"+sExtensionNo+"@"+sPhoneType;
		top.close();
	}
	
	/*~[Describe=拨打软电话;InputParam=无;OutPutParam=电话号码;]~*/
	function openphone(){
		var sPhoneType = getItemValue(0,getRow(),"PhoneCode");
		alert(sPhoneType);
	}
	

	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
