<%@ page language="java" import="java.util.*,com.amarsoft.awe.control.model.*,com.amarsoft.are.jbo.*,com.amarsoft.awe.dw.ui.util.*,com.amarsoft.awe.dw.ui.validator.client.*,com.amarsoft.awe.dw.ui.util.ConvertXmlAndJava,com.amarsoft.awe.util.ObjectConverts,com.amarsoft.awe.dw.ASDataObject,com.amarsoft.awe.dw.ui.util.Request,com.amarsoft.awe.dw.ui.actions.IDataAction,com.amarsoft.awe.dw.ui.info.DefaultAction,com.amarsoft.awe.dw.ui.htmlfactory.*,com.amarsoft.awe.dw.ui.htmlfactory.imp.*" pageEncoding="GBK"%>
<!-- 
��ҳ�棬ΪIFrame����ҳ�棬��̨��������
���ܣ�ʵ��������ӱ������
����˵��������form���������ʵ����Ҫ�Ĳ�����Ϣ
ע�⣺ǰ��ҳ��form.target��������Ϊһ��iframe
 -->
<script>
function setParentInputValue(inputName,value){
	//alert(opener);
	//alert(parent.document);
	var els = parent.document.getElementsByName(inputName);
	for(var i=0;i<els.length;i++){
		els[i].value = value;
	}
}
</script>
<%
String sJbo = Request.GBKSingleRequest("SERIALIZED_JBO",request);
String sASD = Request.GBKSingleRequest("SERIALIZED_ASD",request);
//sASD = Component.getDataObject(sASD);
String sPostEvents = Request.GBKSingleRequest("POST_EVENTS",request);//ǰִ̨�нű�
String sFormId = Request.GBKSingleRequest("SYS_FORMID",request);//���formid,Ŀ��Ϊ������ˢ�¾ֲ�ҳ��
String sAction = Request.GBKSingleRequest("SYS_ACTION",request);//��ö�������
String sBpData = Request.GBKSingleRequest("SYS_BPDATA",request);//��ö�������
String sUpdatedFields = Request.GBKSingleRequest("UPDATED_FIELD",request);//��ñ�������ֶ�
if(sBpData.equals("undefined"))
	sBpData = "";
IDataAction action = new DefaultAction(request,sUpdatedFields);
boolean result = action.run(sJbo,sASD,sAction,ConvertXmlAndJava.xml2java(sBpData));
if(result){
	ASDataObject asd = action.getAsObj();//���»��asdataobject����
	//����������֤����
	//asd.setValidateRules(com.amarsoft.awe.dw.ui.validator.ValidateRule.getRules(asd,"EDIT",""));
	BizObject bizOjb = action.getBizObjects()[0];//���»��jbo����
	sJbo = ObjectConverts.getString(bizOjb);//����µ����л�����ַ���
	//���¸�ֵ
	out.println("<script>");
	out.println("var dwindex = "+sFormId.substring(8)+";");
	if(!sAction.equalsIgnoreCase("delete")){
		for(int i=0;i<bizOjb.getAttributeNumber();i++){
			com.amarsoft.are.lang.DataElement attribute = bizOjb.getAttribute(i);
			if(com.amarsoft.awe.dw.ui.util.PublicFuns.strInArr2(asd.getVirtualFields(),attribute.getName())>-1)continue;
			if(attribute==null)continue;
			if(asd.getColumn(attribute.getName())==null ) continue;
			String sValue = "";
			if(attribute.getValue()!=null && attribute.getString()!=null && !attribute.getString().equals("") ){
				if("7".equals(asd.getColumn(attribute.getName()).getAttribute("COLCHECKFORMAT")) && attribute.getString()!=null ){
					sValue = new java.text.DecimalFormat("###,##0.00").format(Double.parseDouble(attribute.getString().replaceAll(",", ""))/10000);
					sValue = com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(sValue);
				}
				else if("6".equals(asd.getColumn(attribute.getName()).getAttribute("COLCHECKFORMAT")) && attribute.getString()!=null ){
					sValue = new java.text.DecimalFormat("###,##0").format(Double.parseDouble(attribute.getString().replaceAll(",", ""))/10000);
					sValue = com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(sValue);
				}
				else
					sValue = com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(attribute.getString());
			}
				
			out.println("if(parent.getObj(dwindex,'"+ attribute.getName().toUpperCase() +"')){");
			out.println("parent.setItemValue(dwindex,0,'"+ attribute.getName().toUpperCase() +"','"+ sValue +"');");
			out.println("var iOldFieldIndex = parent.getDisplayFieldIndex(dwindex,'"+attribute.getName().toUpperCase()+"');");
			out.println("parent.ARRAY_OLD[dwindex][iOldFieldIndex] = '"+sValue+"'");
			out.println("}");
		}
		//���л���hidden
		out.println("parent.getObj(dwindex,'SERIALIZED_JBO').value='"+sJbo+"';");
		out.println("parent.getObj(dwindex,'SERIALIZED_ASD').value='"+sASD+"';");
	}
	//ˢ����֤����
	JQueryForm validCode = new JQueryForm(action.getAsObj().getDONO(),asd.getValidateTagList());
	validCode.setJsPreObjectName("parent.");
	String sValidCode = "parent._user_validator["+ sFormId.substring(8) +"] = " + validCode.generate(request.getContextPath(),sFormId,asd.getValidateRules()).replaceAll("\n","") ; 
	out.println(sValidCode);
	//out.println("alert(parent0._user_validator[0]);");
	//System.out.println("sValidCode = " + sValidCode);
	//����з��ؽ�������������
	//System.out.println("action.getResultInfo()=" +action.getResultInfo());
	out.println("parent.aDWResultError[dwindex]='';");
	if(action.getResultInfo()!=null)
		out.println("parent.aDWResultInfo[dwindex]='"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(action.getResultInfo()) +"';");
	//�����ʾ����ɹ���ֱ��event�¼�
	out.println("parent.updateSuccess('����ɹ�','"+ sPostEvents.replaceAll("'","\\\\'") +"');");
	out.println("parent.document.getElementById('UPDATED_FIELD').value='';");
	//System.out.println("parent.updateSuccess('����ɹ�','"+ sPostEvents.replaceAll("'","\\\\'") +"');");
	out.println("</script>");
}
else{
	//out.println("<script>var dwindex = "+sFormId.substring(8)+";parent.aDWResultInfo[dwindex]='';parent.aDWResultError[dwindex]='"+action.getErrors().replaceAll("'","&acute;")+"';parent.updateSuccess('"+ action.getErrors().replaceAll("'","&acute;") +"');</script>");
	out.println("<script>var dwindex = "+sFormId.substring(8)+";parent.aDWResultInfo[dwindex]='';parent.aDWResultError[dwindex]='"+WordConvertor.convertJava2Js(action.getErrors())+"';parent.updateSuccess('"+ WordConvertor.convertJava2Js(action.getErrors()) +"');</script>");

}
%>
