<%@page import="com.amarsoft.app.alarm.*"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.awe.Configure"%>
<%@page import="com.amarsoft.awe.RuntimeContext"%>
<%@page import="com.amarsoft.awe.util.Transaction"%>
<%@page import="com.amarsoft.awe.util.ObjectConverts"%>
<%@ page contentType="text/html; charset=GBK"%>
<%
/* Copyright 2001-2010 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: syang  2009/09/11
 * Tester:
 *
 * Content: 
 *          ����ÿ������� 
 *           
 * Input Param:
 *      ModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue: JSON���ݣ�����ͻ��˲���
 *					����ֵ��ʽ��
 *						{
 *						"status":"true/false",
 *						"message":"message1[~`~]message2[~`~]message3
 *						}
 * History Log:
 *			syang 2011/06/28 �����������л����ݣ�����ʹ��session����
 */
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
if(CurARC == null) throw new Exception("------Timeout------");

Configure CurConfig = Configure.getInstance(application);
if(CurConfig ==null) throw new Exception("��ȡ�����ļ��������������ļ�");
Transaction Sqlca = null;
com.amarsoft.are.jbo.JBOTransaction tx = null;
String sDataSource = CurConfig.getConfigure("DataSource");

try{
	Sqlca = new Transaction(sDataSource);
	tx = com.amarsoft.are.jbo.JBOFactory.createJBOTransaction();
	tx.join(Sqlca);
	String sGroupID = (String)request.getParameter("GroupID");
	String sItemID = (String)request.getParameter("ItemID");
	String serializableScenario = (String)request.getParameter("SerializableScenario");
	
	if(serializableScenario==null)serializableScenario="";
	
	if(serializableScenario.length()==0)throw new Exception("���������ȡ����");

	try{
		
		ScenarioContext context = (ScenarioContext)ObjectConverts.getObject(serializableScenario);
		
		CheckItem chItem = context.getScenario().getCheckItem(sGroupID, sItemID);
		
		String sPassMessage = chItem.getPassMessage();
		String sNoPassMessage = chItem.getNoPassMessage();
		if(sPassMessage == null) sPassMessage = "";
		if(sNoPassMessage == null) sNoPassMessage = "";
		
		AlarmMessage am = (AlarmMessage)context.getCheckItemRunner().run(Sqlca, chItem);
		StringBuffer  sbMessage = new StringBuffer();
		String sMessage = "";
		for(int j=0;j<am.size();j++){
			sbMessage.append(am.getMessage(j)+"[~`~]");
		}
		if(sbMessage.length() > 5){
			sMessage = sbMessage.substring(0,sbMessage.length()-5);
		}else{
			sMessage = "";
		}
		
		//���ִ�к󣬷��ص���ϢΪ��
		//	1.���ͨ��������Ϣȡ���õ�ͨ������ʾ��Ϣ
		//	2.���δͨ������ȡ���õ�δͨ������ʾ��Ϣ
		if(sMessage.equals("")){
			if(am.isPass()){
				sMessage = sPassMessage;
			}else{
				sMessage = sNoPassMessage;
			}
		}
		//Thread.sleep(200);
		//����JSON
		out.println("{");
		out.println("\"status\":\""+am.isPass()+"\",");
		out.println("\"message\":\""+sMessage+"\"");
		out.println("}");
		ARE.getLog().debug("status:"+am.isPass()+"|message:"+sMessage);
	}catch(Exception ea){
		ea.printStackTrace();
	}
}catch(Exception e){
	if(Sqlca!=null) Sqlca.getConnection().rollback();
	if(tx!=null)
	{
		tx.rollback();
		tx = null;
	}
    e.printStackTrace();
    ARE.getLog().error(e.getMessage(),e);
    throw e;
}finally{
    if(Sqlca!=null){
        Sqlca.getConnection().commit();
        Sqlca.disConnect();
        Sqlca = null;
    }
    if(tx!=null)
	{
		tx.commit();
		tx = null;
	}
}%>