<%@ page language="java" import="com.amarsoft.are.*,com.amarsoft.awe.control.model.*,com.amarsoft.awe.dw.ui.util.PublicFuns,com.amarsoft.awe.dw.ui.util.Request,com.amarsoft.awe.dw.ASDataObject,com.amarsoft.awe.dw.ui.util.ConvertXmlAndJava,com.amarsoft.awe.dw.ui.value.*,java.util.*,com.amarsoft.awe.dw.ui.util.*,com.amarsoft.awe.dw.ui.htmlfactory.*,com.amarsoft.are.jbo.*,com.amarsoft.are.jbo.impl.*" pageEncoding="GBK"%><%
/*
本页面，被AJax调用
功能：实现数据删除操作
参数说明：自动根据request.getQueryString()来获得dono,events[返回处理事件],以及关键字信息
注意：修改本页面不要产生html级别的代码[就是说最终运行结果界面不应有空行，js脚本，css样式等，避免返回到js时出现错误]
*/
try{
	String sASD = request.getParameter("asd").toString();
	//对象转换
	ASDataObject asObj = Component.getDataObject(sASD);//(ASDataObject)com.amarsoft.awe.util.ObjectConverts.getObject(sASD);
	String sBusinessProcess = asObj.getBusinessProcess();
	if(sBusinessProcess==null || sBusinessProcess.equals(""))
		sBusinessProcess = ARE.getProperty("Jbo_BusinessProcess");
	String sJbo = asObj.getJboClass();
	String xml =request.getParameter("para").toString();
	xml = java.net.URLDecoder.decode(xml,"UTF-8");
	//System.out.println("xml=" + xml);
	//String sBpData = Request.GBKSingleRequest("bpdata",request);
	//String sSelectedRows = Request.GBKSingleRequest("SelectedRows",request);
	//if(sBpData.equals("undefined"))
	//	sBpData = "";
	//com.amarsoft.cbm.datamodel.BusinessProcessData bpData = new com.amarsoft.cbm.datamodel.BusinessProcessData();
	//bpData.SelectedRows = PublicFuns.getIntArrays(sSelectedRows);
	com.amarsoft.awe.dw.ui.list.DeleteAction deleteAction = new com.amarsoft.awe.dw.ui.list.DeleteAction(sJbo,asObj,request,sBusinessProcess);
	boolean result = deleteAction.deleteObjects(xml);
	if(result){
		out.println("{status:'success',resultInfo:'"+ WordConvertor.convertJava2Js(deleteAction.getResultInfo()) +"'}");
	}
	else{
		out.println("{status:'fail',errors:'"+ WordConvertor.convertJava2Js(deleteAction.toString()) +"'}");
	}
}
catch(Exception e){
	e.printStackTrace();
	out.println("{status:'fail',errors:'"+ WordConvertor.convertJava2Js(e.toString()) +"'}");
	ARE.getLog().error("系统错误" + e.toString());
}
%>