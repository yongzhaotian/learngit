<%@ page language="java" import="com.amarsoft.are.*,java.util.*,com.amarsoft.awe.dw.handler.BusinessProcessData,com.amarsoft.awe.dw.ui.util.PublicFuns,com.amarsoft.are.jbo.*,com.amarsoft.awe.dw.ASDataObjectFilter,com.amarsoft.awe.dw.ui.list.ListAction,com.amarsoft.awe.dw.ui.util.ConvertXmlAndJava,com.amarsoft.awe.dw.ASDataObject,com.amarsoft.awe.dw.ui.util.Request,com.amarsoft.awe.dw.ui.actions.IDataAction,com.amarsoft.awe.dw.ui.htmlfactory.*,com.amarsoft.awe.dw.ui.htmlfactory.imp.*" pageEncoding="GBK"%><%@page import="java.net.URLDecoder"%><%
String sJbo = Request.GBKSingleRequest("SERIALIZED_JBO",request);
String sASD = Request.GBKSingleRequest("SERIALIZED_ASD",request);
sASD = sASD.replace("%7C", "|");
//String sPostEvents = Request.GBKSingleRequest("POST_EVENTS",request);//ǰִ̨�нű�
String sCurPage = Request.GBKSingleRequest("curpage",request);
int iCurPage = 0;
if(sCurPage.matches("[0-9]+"))
	iCurPage = Integer.parseInt(sCurPage);
//String sTableIndex = Request.GBKSingleRequest("index",request);
String sAction = Request.GBKSingleRequest("SYS_ACTION",request);//��ö�������
String sSelectedRows = Request.GBKSingleRequest("SelectedRows",request);
//request.setCharacterEncoding("UTF-8");
String sUpdatedFields = request.getParameter("UPDATED_FIELD");//��ñ�������ֶ�
if(sUpdatedFields==null)sUpdatedFields = "";
//System.out.println("UPDATED_FIELD0 = " + sUpdatedFields);
sUpdatedFields= URLDecoder.decode(sUpdatedFields,"UTF-8");
//System.out.println("UPDATED_FIELD1 = " + sUpdatedFields);
if(sUpdatedFields.equals("<root></root>"))sUpdatedFields="";
//sUpdatedFields = new String(sUpdatedFields.getBytes("GBK"),"UTF-8");
//System.out.println("UPDATED_FIELD1 = " + sUpdatedFields);
BusinessProcessData bpData = new BusinessProcessData();
bpData.SelectedRows = PublicFuns.getIntArrays(sSelectedRows);
try{
	IDataAction action = new ListAction(request,sUpdatedFields);
	boolean result = action.run(sJbo,sASD,sAction,bpData);
	if(result){
		out.println("{status:'success',resultInfo:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(action.getResultInfo()) +"'}");
	}
	else{
		out.println("{status:'fail',errors:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(action.getErrors()) +"'}");
	}
}
catch(Exception e){
	e.printStackTrace();
	//out.println("<script>alert('ϵͳ����"+ e.toString() +"');</script>");
	out.println("{status:'fail',errors:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(e.toString()) +"'}");
	ARE.getLog().error("ϵͳ����" + e.toString());
}

%>
