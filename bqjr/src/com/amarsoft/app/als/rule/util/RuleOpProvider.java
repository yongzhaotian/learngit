package com.amarsoft.app.als.rule.util;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.util.CommonUtil;
import com.amarsoft.core.util.StringUtil;

/**
 * 提供获取规则对象，编号的方法
 * @author zszhang
 */
public class RuleOpProvider {
	private static BizObjectManager bm = null;
	private static BizObjectQuery bq = null;
	private static BizObject bo = null;
	private static List boList = null;
	
    /**
     * 拼装BOMITEM的所属对象
     *
     * @param   modelID  模型编号
     * @param   record   模型记录
     * @return	拼装完成的JSON对象
     * @throws  Exception
     */
	public static JSONObject combineBomItem(String modelID,String record) throws Exception{
		JSONObject jObject = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEM");
		bq = bm.createQuery("BOMID like :BOMID");
		bq.setParameter("BOMID", modelID + "%");
		boList = bq.getResultList(false);
		if (boList != null) {
			for (int i = 0; i < boList.size(); i++) {
				String nodeID = ((BizObject) boList.get(i)).getAttribute("NodeID").toString();
				System.out.println("模型记录 record:"+record);
				String nodeValue = StringFunction.getProfileString(record.toString(),((BizObject) boList.get(i)).getAttribute("NodeID").toString());
				if (nodeValue != null && !"".equals(nodeValue))
					jObject = setNodeValue(jObject, nodeID,nodeValue);
			}
		}
		return jObject;
	}
	
    /**
     * 拼装BOMINFO的所属对象
     *
     * @param   modelID  模型编号
     * @param   record   模型记录
     * @return	拼装完成的JSON对象（String类型）
     * @throws  Exception
     */
	public static String combineBomInfo(String modelID,String record) throws Exception{
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOM_INFO");
		bq = bm.createQuery("ModelID=:ModelID");
		bq.setParameter("ModelID", modelID);
		boList = bq.getResultList(false);
		if (boList != null) {
			for (int i = 0; i < boList.size(); i++) {
				String[] aName = StringUtil.split(((BizObject)boList.get(i)).getAttribute("BomID").toString(), ".");
				record = CommonUtil.updateJSONString(record, "{\""+aName[0]+"\":{\""+aName[1]+"\":{\"Kind\":\""+((BizObject)boList.get(i)).getAttribute("BomType").toString()+"\"}}}");
			}
		}
		return record;
	}
	
    /**
     * 获取需要调用的规则编号
     *
     * @param   modelID  模型编号
     * @param   codeNo   代码编号
     * @Param   doTranStage 测算阶段
     * @return	规则编号
     * @throws JBOException 
     */
	public static String getRuleID(String modelID,String codeNo,String doTranStage) throws JBOException {
		String ruleID = null;
		bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		bq = bm.createQuery("CODENO =:CODENO and ITEMNO like :ITEMNO and relativeCode=:relativeCode");
		bq.setParameter("CODENO", codeNo);
		bq.setParameter("ITEMNO", modelID+"%");
		bq.setParameter("relativeCode",doTranStage);
		bo = bq.getSingleResult(false);
		if (bo != null) {
			ruleID = bo.getAttribute("ItemAttribute").toString();
		}
		return ruleID;
	}
	
	
	   /**
     * 获取需要调用的规则编号
     *
     * @param   modelID  模型编号
     * @param   codeNo   代码编号
     * @return	规则编号
     * @throws JBOException 
     */
	public static String getRuleID(String modelID,String codeNo) throws JBOException {
		String ruleID = null;
		bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		bq = bm.createQuery("CODENO =:CODENO and ITEMNO=:ITEMNO ");
		bq.setParameter("CODENO", codeNo);
		bq.setParameter("ITEMNO", modelID);
		bo = bq.getSingleResult(false);
		if (bo != null) {
			ruleID = bo.getAttribute("ItemAttribute").toString();
		}
		return ruleID;
	}
    /**
     * 把节点名称和值拼装进JSON对象
     *
     * @param   jObject  原JSON对象
     * @param   ID       节点名称
     * @param   value    节点值
     * @return  新JSON对象
     * @throws  Exception 
     */
	public static JSONObject setNodeValue(JSONObject jObject, String ID, String value) throws Exception {
		String[] aID = StringUtil.split(ID,".");
		if (value==null) {value = "";};
		String sObject = "";
		for (int i=aID.length-1;i>=0;i--) {
			if (i==aID.length-1) {
				if (value.length() > 1 && (value.substring(0, 1).equals("0") && !value.substring(1, 2).equals("."))) {
					sObject = "{"+aID[i]+":\""+value+"\"}";
				} else {
					try {
						sObject = "{"+aID[i]+":"+value+"}";
					} catch (Exception e) {
						sObject = "{"+aID[i]+":\""+value+"\"}";
					}
				}
			} else {
				sObject = "{"+aID[i]+":"+sObject+"}";
			}
		}
		JSONObject jObject1 = new JSONObject(sObject);

		return CommonUtil.updateJSONObject(jObject,jObject1);
	}
	
    /**
     * 获取JSON对象中某个节点的值
     *
     * @param   jObject  JSON对象
     * @param   ID       节点名称
     * @param   defaultvalue 默认值
     * @return  节点值
     * @throws  Exception 
     */
	public static String getNodeValue(JSONObject jObject,String ID, String defaultvalue) throws Exception {
		try {
			Object oValue = null;
			String s = null;
			JSONObject oj = jObject;
			String[] aName = StringUtil.split(ID, ".");
			for (int i = 0; i < aName.length; i++) {
				oValue = oj.get(aName[i]);
				if (oValue == null) {
					s = defaultvalue;
					break;
				}
				if (i == aName.length - 1) {
					s = oValue.toString();
				} else {
					oj = (JSONObject) oValue;
				}
			}
			if (s == null || s.equals("") || s.equals("null")) {
				s = defaultvalue;
			}
			return s;
		} catch (Exception e) {
			return defaultvalue;
		}
	}
}
