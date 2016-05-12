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
	if(CurConfig ==null) throw new Exception("��ȡ�����ļ��������������ļ�");
	
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
			throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource:"+sDataSource);
       	}

        SqlcaRepository.commit();
        Sqlca = SqlcaRepository;
       %>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/jquery-1.9.1.min.js" ></script>

<%/*~BEGIN~�ɱ༭~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ҵ�����������ĵ�����Ϣ����Ӧ�ĵ�Ѻ�������Ϣ����;
		Input Param:
			ObjectType����������
			ObjectNo: ������
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ӻ�ͬ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%
		//ҵ����ˮ��
		String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		if (null == sObjectNo) sObjectNo = "";
		//ҵ������
		String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
		if (null == sObjectType) sObjectType = "";
		
		//ѡ�� ���� ����   010 Ӱ��ɨ��   020 �������ӡ
		String sFunctionType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FunctionType"));
		if (null == sFunctionType) sFunctionType = "010";
		
		
		//if ("AfterLoan".equals(sObjectType)||"ContractApply".equals(sObjectType)) sObjectType = "BusinessContract";
		
		//�����ҳ�� 
		String sUrl = CodeCache.getItem("XTMSUrl","0010").getItemAttribute();//CCS-857�����е��õ��Ӻ�ͬ��ַ�豣�浽�����ļ���ʹ��
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
			throw new Exception("����ȷ���õ��Ӻ�ͬ�����ļ�!");
		}
		
		//���崫�Ͳ���
		//��½�û��� 
		String sUID = CurConfig.getConfigure("EDocUID");
		//��½����
		String sPWD = CurConfig.getConfigure("EDocPWD");
		//ҵ��Ӧ�ú�
		String sAppId = CurConfig.getConfigure("EDocAppId");
		//�Ŵ�ϵͳ�û���
		String sUserID = CurUser.getUserID();
		//�Ŵ�ϵͳ����ID
		String sOrgID = CurUser.getOrgID();
		//����Ȩ��
		//0-1][0-1][0-1][0-1][0-1][0-1][0-1]����Ȩ�ޡ��鿴Ȩ�ޡ�ɾ��Ȩ�ޡ��޸�Ȩ�ޡ���ӡȨ�ޡ���עȨ�ޡ�����ԱȨ�ޡ� 
		String sRight = "";//Ĭ��ֻ�в鿴Ȩ��
		
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