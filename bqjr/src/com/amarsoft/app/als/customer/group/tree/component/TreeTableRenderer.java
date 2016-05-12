package com.amarsoft.app.als.customer.group.tree.component;


import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.awe.util.ObjectConverts;

/**
 * @author syang
 * @date 2011-7-23
 * @describe TreeTable��Ⱦ����
 * 	���ڸ���Ŀǰ������Ӧ�ó�������������200���ҿ���ʹ�ã�
 *  ���������������Ҫд���࣬�������л����Context�����ˣ��������Ϊ�������󣬵���ҳ�淴Ӧ����
 * 			������Ҫ�Ľ�������
 * 							1.headerSetting���Լ�codeSetting���ø�ʽ��Ҫ��ϸ����
 * 							2.�־û���������������
 * 							3.����ToopTips����
 */
public class TreeTableRenderer<T extends TreeNode> implements HTMLRenderer<T> {
	private String headerSetting = "";
	private String codeSetting = "";
	private Map<String,Map<String,String>> codeMap = null;
	@SuppressWarnings("rawtypes")
	private Metadata[] metadata ;
	
	private StringBuilder html = new StringBuilder();
	
	@SuppressWarnings("rawtypes")
	private void initMetadata(){
		//Ԥ�������
		String formatErrMessage = "����headerSetting��ʽ������ʹ��{name1=label1,name2=label2}��ʽ";
		if(headerSetting==null)throw new FacesRunTimeException("����headerSettingû�����ã�����");
		if(!headerSetting.startsWith("{")||!headerSetting.endsWith("}"))throw new FacesRunTimeException(formatErrMessage);
		headerSetting = headerSetting.replaceAll("\\{","").replaceAll("\\}","");
		//�������
		String[] fs = headerSetting.split(",");
		metadata = new Metadata[fs.length];
		for(int i=0;i<fs.length;i++){
			String[] m = fs[i].split("=");
			if(m.length!=2)throw new FacesRunTimeException(formatErrMessage);
			metadata[i] = new Metadata();
			metadata[i].setName(m[0]);
			metadata[i].setHeader(m[1]);
		}
	}
	private void initCodeMap(){
		if(codeSetting==null||codeSetting.length()==0)return;
		String formatErrMessage = "�����codeSetting��ʽ����{{field1=key1:value1,key2:value2}{field2=key1:value1,key2:value2}}";
		codeSetting = codeSetting.replaceAll("\\s+","");
		if(!codeSetting.startsWith("{{")||!codeSetting.endsWith("}}"))throw new FacesRunTimeException(formatErrMessage);
		codeSetting = codeSetting.substring(2);
		codeSetting = codeSetting.substring(0,codeSetting.length()-2);
		String[] codeArray = codeSetting.split("\\}\\{");
		codeMap = new HashMap<String,Map<String,String>>();
		for(int i=0;i<codeArray.length;i++){	//ȡfield1=key1:value1,key2:value2
			if(codeArray[i]==null||codeArray[i].length()==0)throw new FacesRunTimeException(formatErrMessage);
			String[] r = codeArray[i].split("=");
			if(r.length!=2)throw new FacesRunTimeException(formatErrMessage);
			Map<String,String> itemMap = new HashMap<String,String>();//ÿ����Ĵ���ӳ���
			String[] mapData = r[1].split(",");//ȡkey1:value1,key2:value2
			if(mapData==null||mapData.length==0)throw new FacesRunTimeException(formatErrMessage);
			for(int j=0;j<mapData.length;j++){
				String[] row = mapData[j].split(":");
				if(row.length!=2)throw new FacesRunTimeException(formatErrMessage);
				itemMap.put(row[0],row[1]);
			}
			codeMap.put(r[0], itemMap);
		}
	}
	public void decode(FacesContext context, T component) {

	}	
	public void encodeBegin(FacesContext context, T node) {
		initMetadata();
		initCodeMap();
		String serialContext = "";
		try {
			serialContext = ObjectConverts.getString(context);
		} catch (IOException e) {
			e.printStackTrace();
			throw new FacesRunTimeException(TreeTableRenderer.class.getName()+"��ȡ���л�Context����IO�쳣");
		}
		html.append("<form id='backProcess' name='backProcess' style='display:none'>");
		html.append("<input type='hidden' name='contextSerial' id='contextSerial' value='").append(serialContext).append("'></input>");
		html.append("</form>");
		html.append("<fieldset class='fstreetable'>").append("\n");
		html.append("	<legend>").append((String)context.getAttribute("Header")).append("</legend>").append("\n");
		html.append("	<table class='treetable'>").append("\n");
		html.append("		<thead>").append("\n");
		html.append("			<tr>").append("\n");
		for(int i=0;i<metadata.length;i++){
			html.append("			<th name='").append(metadata[i].getName()).append("'>").append(metadata[i].getHeader()).append("</th>").append("\n");
		}
		html.append("			</tr>").append("\n");
		html.append("		</thead>").append("\n");
		html.append("		<tbody>").append("\n");
	}
	public void encodeEnd(FacesContext context, T node) {
		html.append("		</tbody>").append("\n");
		html.append("	</table>").append("\n");
		html.append("</fieldset>").append("\n");
//		html.append("<script type=\"text/javascript\">").append("\n");
//		html.append("	$(document).ready(function() {").append("\n");
//		html.append("		$(\"table.treetable\").treeTable();").append("\n");
//		html.append("	});").append("\n");
//		html.append("</script>").append("\n");
	}
	private Object getValue(T instance,String name){
		String methodName = "get"+name.substring(0, 1).toUpperCase()+name.substring(1);
		String invokeErrorMessage = instance.getClass().getName()+"."+methodName+"()�������ó���";
		Object returnValue = null;
		try {
			Method method = instance.getClass().getMethod(methodName);
			returnValue = method.invoke(instance);	//���ýڵ�Bean�ϵ�getXxx()����
			//ȡ�ֶ��ϵĴ����
			Map<String,String> fieldMap = codeMap.get(name);	
			if(fieldMap!=null&&fieldMap.containsKey(returnValue)){	
				returnValue = fieldMap.get(returnValue);
			}
		} catch (SecurityException e) {
			throw new FacesRunTimeException("");
		} catch (NoSuchMethodException e) {
			throw new FacesRunTimeException(invokeErrorMessage+"���÷���������");
		} catch (IllegalArgumentException e) {
			throw new FacesRunTimeException(invokeErrorMessage+"��������������ȷ");
		} catch (IllegalAccessException e) {
			throw new FacesRunTimeException(invokeErrorMessage);
		} catch (InvocationTargetException e) {
			throw new FacesRunTimeException(invokeErrorMessage);
		}
		return returnValue;
	}
	@SuppressWarnings("unchecked")
	public void encodeBody(FacesContext context, T node) throws Exception {
		String cssClass = "";
		UIComponent parent = node.getParent();
		if(parent!=null)cssClass += "child-of-"+parent.getId();
		String jsonData = ObjectHelper.convert2JSONObject(node).toJSONString();
		//������Լ�
		html.append("			<tr id='").append(node.getId()).append("' class='").append(cssClass).append("' nodeData='").append(jsonData).append("'>").append("\n");
		for(int i=0;i<metadata.length;i++){
			Object value = getValue(node,metadata[i].getName());
			String stringValue = "";
			if(value!=null)stringValue=value.toString();
			html.append("			<td name='").append(metadata[i].getName()).append("'>").append(stringValue).append("</td>").append("\n");
		}
		html.append("			</tr>").append("\n");
		//�ݹ�����ӽڵ�
		List<UIComponent> children = node.getChildren();
		for(int i=0;i<children.size();i++){
			UIComponent component = children.get(i);
			if(component instanceof TreeNode){
				encodeBody(context,(T)component);
			}
		}
	}

	/**
	 * ��ȡ��ͷ
	 * @return
	 */
	public String getHeaderSetting() {
		return headerSetting;
	}
	/***
	 * ���ñ�ͷ
	 * @param headerSetting
	 */
	public void setHeaderSetting(String headerSetting) {
		this.headerSetting = headerSetting;
	}
	/**
	 * ���ô���ӳ���
	 * @return
	 */
	public String getCodeSetting() {
		return codeSetting;
	}
	/**
	 * ��ȡ����ӳ���
	 * @param codeMap
	 */
	public void setCodeSetting(String codeSetting) {
		this.codeSetting = codeSetting;
	}
	public String getHTML() {
		return html.toString();
	}
	class Metadata<D>{
		private String header = "";
		private String name = "";
		public String getHeader() {
			return header;
		}
		public void setHeader(String header) {
			this.header = header;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
	}
}
