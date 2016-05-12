<%@ page contentType="text/html;charset=GBK"%>
<%-- <%@ page import="com.amarsoft.app.image.OperateImage" %> --%>
<%@page buffer="64kb" errorPage="/Frame/page/control/ErrorPage.jsp"%><%@
page import="java.io.*"%><%@
page import="java.sql.*"%><%@
page import="java.text.*"%><%@
page import="java.util.*"%><%@
page import="com.amarsoft.are.ARE"%><%@
page import="com.amarsoft.are.lang.*"%><%@
page import="com.amarsoft.are.security.*"%><%@
page import="com.amarsoft.are.util.*"%><%@
page import="com.amarsoft.context.*"%><%@
page import="com.amarsoft.awe.Configure"%><%@
page import="com.amarsoft.awe.RuntimeContext"%><%@
page import="com.amarsoft.awe.control.model.*"%><%@
page import="com.amarsoft.awe.util.*"%><%@
page import="com.amarsoft.awe.ui.model.*"%><%@
page import="com.amarsoft.awe.ui.widget.*"%><%@
page import="com.amarsoft.amarscript.*"%><%@
page import="com.amarsoft.alert.*"%><%@
page import="com.amarsoft.web.dw.*"%><%@
page import="com.amarsoft.web.ui.*"%><%@
page import="org.apache.commons.lang.*"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	response.setCharacterEncoding("UTF-8");
	RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
	if(CurARC == null) throw new Exception("------Timeout------");

	Configure CurConfig = Configure.getInstance(application);
	if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查配置文件");
	
	String sDebugMode = CurConfig.getConfigure("DebugMode");
    String sRunTimeDebugMode = CurConfig.getConfigure("RunTimeDebugMode");
    String sCurRunMode=CurConfig.getConfigure("RunMode");

    String sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");
    ASUser CurUser = CurARC.getUser();
    ASOrg CurOrg = CurUser.getBelongOrg();
    String sCompClientID="";

    String sWebRootPath = request.getContextPath();
	String sServletURL = request.getServletPath();
	String sSkinPath = sWebRootPath + CurUser.getSkin().getPath();
    
    Transaction SqlcaRepository = null;
    Transaction Sqlca = null;

    try{
        int iPostChange = 1;

        sCompClientID = request.getParameter("CompClientID");
        if(sCompClientID==null) sCompClientID="";

        ComponentSession CurCompSession = CurARC.getCompSession();
        Component CurComp = CurCompSession.lookUp(sCompClientID);
        Page CurPage = new Page(CurComp);
        CurPage.setRequestAttribute((HttpServletRequest)request);
        
        ASPreference CurPref = CurARC.getPref();
        
		String sDataSource = CurConfig.getConfigure("DataSource");
      	try{
      		SqlcaRepository = new Transaction(sDataSource);
      	}catch(Exception ex) {
      		ex.printStackTrace();
			throw new Exception("连接数据库失败！连接参数：<br>DataSource:"+sDataSource);
       	}

        SqlcaRepository.commit();
        Sqlca = SqlcaRepository;
       %>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/jquery-1.9.1.min.js" ></script>

<%/*~BEGIN~可编辑~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: 业务申请新增的担保信息所对应的抵押物基本信息详情;
		Input Param:
			ObjectType：对象类型
			ObjectNo: 对象编号
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "电子合同调用"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%
		//业务流水号
		String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		if (null == sObjectNo) sObjectNo = "";
		//业务类型
		String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
		if (null == sObjectType) sObjectType = "";
		
		//选择 功能 类型   010 影像扫描   020 条形码打印
		String sFunctionType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FunctionType"));
		if (null == sFunctionType) sFunctionType = "010";
		
		
		//if ("AfterLoan".equals(sObjectType)||"ContractApply".equals(sObjectType)) sObjectType = "BusinessContract";
		
		//定义打开页面 
		String sUrl = CodeCache.getItem("XTMSUrl","0010").getItemAttribute();//CCS-857程序中调用电子合同地址需保存到配置文件中使用
/* 		String sAddr = request.getRemoteAddr();
		if (sUrl.equals("")){
			String sImageOACustomerIP = CurConfig.getConfigure("ImageOACustomerIP");
			String[] sImageOACustomerIPArr = sImageOACustomerIP.split(",");
			for(int i=0;i<sImageOACustomerIPArr.length;i++){
				if (sAddr.startsWith(sImageOACustomerIPArr[i])){
					if ("010".equals(sFunctionType)){
						sUrl = CurConfig.getConfigure("ImageOAURL");
					} else {
						sUrl = CurConfig.getConfigure("ImageOABarcodeURL");
					}
					break;
				}
			}
		}
		
		if (sUrl.equals("")){
			String sImagePCustomerIP = CurConfig.getConfigure("ImagePCustomerIP");
			String[] sImagePCustomerIPArr = sImagePCustomerIP.split(",");
			for(int i=0;i<sImagePCustomerIPArr.length;i++){
				if (sAddr.startsWith(sImagePCustomerIPArr[i])){
					if ("010".equals(sFunctionType)){
						sUrl = CurConfig.getConfigure("ImagePURL");
					} else {
						sUrl = CurConfig.getConfigure("ImagePBarcodeURL");
					}
					break;
				}
			}
		} */
		
		if(sUrl.equals("")){
			throw new Exception("请正确配置电子合同管理文件!");
		}
		
		//定义传送参数
		//登陆用户名 
		String sUID = CurConfig.getConfigure("EDocUID");
		//登陆密码
		String sPWD = CurConfig.getConfigure("EDocPWD");
		//业务应用号
		String sAppId = CurConfig.getConfigure("EDocAppId");
		//信贷系统用户号
		String sUserID = CurUser.getUserID();
		//信贷系统机构ID
		String sOrgID = CurUser.getOrgID();
		//操作权限
		//0-1][0-1][0-1][0-1][0-1][0-1][0-1]新增权限、查看权限、删除权限、修改权限、打印权限、批注权限、管理员权限。 
		String sRight = "";//默认只有查看权限
		
		String sRightType = CurComp.getAttribute("RightType");
		if("ReadOnly".equals(sRightType)){
			sRight = "0100000";
		} else {
			sRight = "1101000";
		}
		
%>

<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.validate.min-1.8.1.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.validate.extend.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_control.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_widget.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_webcalendar.js"></script>
<script type="text/javascript" src="<%=sResourcesPath%>/xls.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/expand.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/htmlcontrol.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/Support/as_dz.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/Support/as_dz_middle.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/Support/checkdatavalidity.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/common.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/message.js"> </script>
<script type="text/javascript" src="<%=sResourcesPath%>/menu.js"> </script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/chart/json2.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/resources/htmledit/as_htmleditor.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/as_formatdoc.js"></script>
<script type="text/javascript" >
var AsOne = {SetDefault:function(sURL) {document.write("<iframe name=myform999 src='"+sURL+"' frameborder=0 width=1 height=1 style='display:none'> </iframe>");},AsInit:function() {} };AsOne.SetDefault("");

var sUserID = "<%=sUserID%>";
//sUserID = "160001";
var sOrgID = "<%=sOrgID%>";
//sOrgID = "106";

var sUrl = "<%=sUrl%>?tasklist&userid="+sUserID+"&deptid="+sOrgID;

/*       $(document).ready(
   		 window.open(sUrl,"_self",""); 
 		 );    */ 
    
       window.open(sUrl,"_self","");   		 
</script>

<%
    }
    catch(Exception e)
    {
    	if(SqlcaRepository!=null) SqlcaRepository.rollback();
    	if(Sqlca!=null) Sqlca.rollback();
        e.printStackTrace();
        ARE.getLog().error(e.getMessage(),e);
        throw e;
    }
    finally
    {
        if(SqlcaRepository == Sqlca)
        {
            Sqlca.commit();
            Sqlca.disConnect();
            Sqlca = null;
            SqlcaRepository = null;
        }else
        {
            if(Sqlca!=null)
            {
                Sqlca.commit();
                Sqlca.disConnect();
                Sqlca = null;
            }
            if(SqlcaRepository!=null)
            {
                SqlcaRepository.commit();
                SqlcaRepository.disConnect();
                SqlcaRepository = null;
            }
        }
    }
%>