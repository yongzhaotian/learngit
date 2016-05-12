/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.rules.aco;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.app.als.sadre.util.Escape;
import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.cache.loader.AbstractDataLoader;
import com.amarsoft.sadre.jsr94.admin.RuleImpl;
import com.amarsoft.sadre.rules.op.Operator;

 /**
 * <p>Title: RuleScene.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 ����03:23:53
 *
 * logs: 1. 
 */
public class RuleScene extends AbstractDataLoader{
	
	public static final int ������_�ɹ� 	= 1;
	public static final int ������_ʧ�� 	= 9;
	public static final int ��������_Ϊ�� 	= 3;
	public static final int ��Ȩ����_������ 	= -1;
	
	public static final int ��Ȩ����_����ʧ�� = 19;
	public static final int ��Ȩ����_���Ƴɹ� = 11;
	
	/*��Ȩ�������*/
	private String ruleSceneId;
	/*��Ȩ��������*/
	private String ruleSceneName;
	
	/*����Ȩ�˽�ɫ(������)*/
	private String[] authorizeeRoles;
	/*����Ȩ�˱��(��ѡ��)*/
	private String[] authorizeeIds;
	/*����Ȩ����������(��ѡ��)*/
	private String[] authorizeeOrgs;
	
	/*��Ȩ�˽�ɫ(��ѡ��) */
	private String[] grantorRoles;
	/*��Ȩ�˱��(��ѡ��) */
	private String[] grantorIds;
	/*��Ȩ����������(��ѡ��) */
	private String[] grantorOrgs;
	/*��Ȩ������Ч�� */
	private String effectiveDate;
	/*��Ȩ����ʧЧ�� */
	private String maturity;
	/*�������� */
	private String[] flows;
	/*������������Ȩ���� */
	private String[] includes;
	
	/*�����Ĺ��򼯺�*/
	private List<RuleImpl> rules = new ArrayList<RuleImpl>();
	
	private PreparedStatement psmt = null;

	public RuleScene(String id,String name){
		this.ruleSceneId = id;
		this.ruleSceneName = name;
		try {
			this.load();
		} catch (SADREException e) {
			ARE.getLog().error(e);
		}
	}
	
	public String[] getAuthorizeeOrgs() {
		return authorizeeOrgs;
	}
	
	public void setAuthorizeeOrgs(String belongOrgs) {
		this.authorizeeOrgs = (belongOrgs==null || belongOrgs.trim().length()==0)?null:belongOrgs.split(",");
	}
	
	public void setAuthorizeeOrgs(String[] orgs){
		if(orgs==null) return;
		this.authorizeeOrgs = new String[orgs.length];
		for(int i=0; i<orgs.length; i++){
			this.authorizeeOrgs[i] = orgs[i];
		}
	}

	public String[] getIncludeDimensions() {
		return includes;
	}

	public void setIncludeDimensions(String includeDimensions) {
		this.includes = (includeDimensions==null || includeDimensions.trim().length()==0)?null:includeDimensions.split(",");
	}
	
	/**
	 * ͨ�������趨��Ȩ����ά������
	 * @param includeDimensions
	 */
	public void setIncludeDimensions(String[] dimensions) {
		if(dimensions==null) return;
		this.includes = new String[dimensions.length];
		for(int i=0; i<dimensions.length; i++){
			this.includes[i] = dimensions[i];
		}
	}

	public String[] getAuthorizeeRoles() {
		return authorizeeRoles;
	}

	public void setAuthorizeeRoles(String roles) {
		this.authorizeeRoles = (roles==null || roles.trim().length()==0)?null:roles.split(",");
	}
	
	/**
	 * ͨ�������趨��Ȩ������Ȩ��������
	 * @param scenceObjects
	 */
	public void setAuthorizeeRoles(String[] roles) {
		if(roles==null) return;
		this.authorizeeRoles = new String[roles.length];
		for(int i=0; i<roles.length; i++){
			this.authorizeeRoles[i] = roles[i];
		}
	}

	public String[] getAuthorizees() {
		return authorizeeIds;
	}

	public void setAuthorizees(String[] users) {
		if(users==null) return;
		this.authorizeeIds = new String[users.length];
		for(int i=0; i<users.length; i++){
			this.authorizeeIds[i] = users[i];
		}
	}
	
	public void setAuthorizees(String specificUsers) {
		this.authorizeeIds = (specificUsers==null || specificUsers.trim().length()==0)?null:specificUsers.split(",");
	}
	
	/*��Ȩ����Ϣ*/
	public String[] getGrantorOrgs() {
		return grantorOrgs;
	}

	public void setGrantorOrgs(String belongOrgs) {
		this.grantorOrgs = (belongOrgs==null||belongOrgs.trim().length()==0)?null:belongOrgs.split(",");
	}
	
	public void setGrantorOrgs(String[] orgs){
		if(orgs==null) return;
		this.grantorOrgs = new String[orgs.length];
		for(int i=0; i<orgs.length; i++){
			this.grantorOrgs[i] = orgs[i];
		}
	}
	
	public String[] getGrantorRoles() {
		return grantorRoles;
	}

	public void setGrantorRoles(String roles) {
		this.grantorRoles = (roles==null || roles.trim().length()==0)?null:roles.split(",");
	}
	
	/**
	 * ͨ�������趨��Ȩ������Ȩ��������
	 * @param scenceObjects
	 */
	public void setGrantorRoles(String[] roles) {
		if(roles==null) return;
		this.grantorRoles = new String[roles.length];
		for(int i=0; i<roles.length; i++){
			this.grantorRoles[i] = roles[i];
		}
	}

	public String[] getGrantors() {
		return grantorIds;
	}

	public void setGrantors(String[] users) {
		if(users==null) return;
		this.grantorIds = new String[users.length];
		for(int i=0; i<users.length; i++){
			this.grantorIds[i] = users[i];
		}
	}
	
	public void setGrantors(String specificUsers) {
		this.grantorIds = (specificUsers==null || specificUsers.trim().length()==0)?null:specificUsers.split(",");
	}
	
	public String getEffectiveDate() {
		return effectiveDate;
	}

	public void setEffectiveDate(String effectiveDate) {
		this.effectiveDate = effectiveDate;
	}

	public String getMaturity() {
		return maturity;
	}

	public void setMaturity(String maturity) {
		this.maturity = maturity;
	}

	public String[] getFlows() {
		return flows;
	}

	public void setFlows(String[] flows) {
		if(flows==null) return;
		this.flows = new String[flows.length];
		for(int i=0; i<flows.length; i++){
			this.flows[i] = flows[i];
		}
	}
	
	public void setFlows(String flows) {
		this.flows = (flows==null || flows.trim().length()==0)?null:flows.split(",");;
	}

	public boolean lookupScenceRole(String objectNo){
		String[] sceneRoles = getAuthorizeeRoles();
		for(int i=0; i<sceneRoles.length; i++){
			if(sceneRoles[i].equals(objectNo)){
				return true;
			}
		}
		return false;
	}
	
	public boolean lookupScenceOrg(String orgId){

		if(getAuthorizeeOrgs()==null) return false;
		
		String[] orgSpecific = getAuthorizeeOrgs();
		for(int i=0; i<orgSpecific.length; i++){
			if(orgSpecific[i].equals(orgId)){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * �жϴ�����������Ƿ�������Ȩ����Ҫ��<br>
	 * 1. ����Ȩ������"����Ȩ�˱��"�봫���������ƥ��;<br>
	 * 2. ����Ȩ������"����Ȩ�˱��",��Ϊ���������޶�
	 * @param userId
	 * @return
	 */
	public boolean lookupScenceUser(String userId){
//		if(getAuthorizees()==null 
//				||(getAuthorizees().length==1 && getAuthorizees()[0].length()==0)) return true;	//��ָ��"ͬ�ڲ�����Ȩ����"
		if(getAuthorizees()==null) return false;
			
		String[] userSpecific = getAuthorizees();
		for(int i=0; i<userSpecific.length; i++){
			if(userSpecific[i].equals(userId)){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * ��Ȩ�����Ƿ�ָ������Ȩ�˵���������
	 * @return
	 */
	public boolean unspecificBelongOrg(){
		return (getAuthorizeeOrgs()==null || getAuthorizeeOrgs().length==0)?true:false; 
	}
	
	/**
	 * ��Ȩ�����Ƿ��ƶ�����Ȩ�˵��û����
	 * @return
	 */
	public boolean unspecificAuthorizee(){
		return (getAuthorizees()==null || getAuthorizees().length==0)?true:false;
	}

	public String getRuleSceneId() {
		return ruleSceneId;
	}

	public String getRuleSceneName() {
		return ruleSceneName;
	}

	protected boolean load(Connection conn) throws SADREException {
		
		rules.clear();		//��ֵǰ�����rule
		
		String sAssumptionId 	= "";
		String sDescription  	= "";
		String sAssumptionSet 	= "";
		String sActions	 	 	= "";
		String sPriority	 	= "";
		int iRuleType		 	= RuleImpl.��������_δ֪;
		String sDecision	 	= "";
		String sRefRules		= "";
		String sql = "select SCENEID,ASSUMPTIONID,ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES " +
				"from SADRE_ASSUMPTION " +
				"where SCENEID=? " +
				"order by PRIORITY,ASSUMPTIONID asc";	//0Ϊ������ȼ�
		try {
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, getRuleSceneId());
			ResultSet ruleset = psmt.executeQuery();
			while(ruleset.next()){
				sAssumptionId	= StringUtil.getString(ruleset.getString("ASSUMPTIONID"));
				sDescription 	= StringUtil.getString(ruleset.getString("NOTE"));
				sAssumptionSet 	= StringUtil.getString(ruleset.getString("ASSUMPTIONSET"));			//ά����������
				sActions 		= StringUtil.getString(ruleset.getString("ACTIONS"));
				sPriority		= StringUtil.getString(ruleset.getString("PRIORITY"));
				iRuleType		= ruleset.getInt("RULETYPE");
				sDecision		= StringUtil.getString(ruleset.getString("DECISION"));
				sRefRules		= StringUtil.getString(ruleset.getString("REFRULES"));
//				ARE.getLog().info("sDescription: id="+sAssumptionId+" |sDescription="+sDescription);
				RuleImpl rule = new RuleImpl(sAssumptionId,sDescription,parseAssumptions(sAssumptionSet));
				rule.setActions(sActions);
				rule.setPriority(sPriority);
//				rule.setSub((sIsSub!=null && sIsSub.equals("yes"))?true:false);		//�Ƿ��ӹ���
				rule.setRuleType(iRuleType);		//��������
				rule.setDecision(sDecision);
//				rule.setSubRules(sSubRules);		//���ӹ����ʵ�����������еĹ����ʼ������֮��
//				ARE.getLog().debug("sRefRules-1:"+sRefRules);
				rule.setReferenceRule(sRefRules);
//				ARE.getLog().debug("sRefRules-2:"+rule.getReferenceRule());
				
				rules.add(rule);
			}
			ruleset.close();
			
			//------ǰ�ù����ʵ����,������ֹ���
			applyReferenceRuleLink();
			
		} catch (SQLException e) {
			e.printStackTrace();
			ARE.getLog().error("��Ȩ���򳡾���ȡʧ��!",e);
			throw new SADREException(e);
		}
		
		return true;
		
	}
	
	/**
	 * ���������������Ĺ�������ǰ�ù���,�ɹ�����ת��Ϊ������,�����γɹ���.<br>
	 * 1.����֮���ǰ�ù�ϵ��������ͬһ����Ȩ������,���ܿ緽������ǰ������
	 */
	private void applyReferenceRuleLink(){

		Iterator<RuleImpl> tk = getRules().iterator();
		while(tk.hasNext()){
			RuleImpl rule = tk.next();
			if(!rule.hasReferencedRule()){
				continue;
			}
//			
//			for(int sr=0; sr<rule.getSubRuleIds().length; sr++){
//				RuleImpl subrule = getRule(rule.getSubRuleIds()[sr]);
////				if(subrule == null || !subrule.isSub()){
//				if(subrule == null || subrule.getRuleType()==RuleImpl.��������_��һ����){
//					ARE.getLog().warn(rule.getName()+"�����ӹ���["+rule.getSubRuleIds()[sr]+"]�����ڻ��߲����ӹ���!");
//					continue;
//				}
//				rule.getSubRuleObjs().add(subrule);
//			}
////			ARE.getLog().trace(rule.getSubRuleObjs());
			if(rule.getName().equals(rule.getReferenceRule())){
				ARE.getLog().warn("["+rule.getName()+"] ǰ�ù������ô���ERR=����ָ������Ϊǰ�ù���.");
				continue;
			}
			
			rule.generateRuleLink(this);
//			
//			for(int i=0;i<rule.getLinkedReferenceRules().length;i++){
//				ARE.getLog().info(rule.getName()+" ref:"+rule.getLinkedReferenceRules()[i]);
//			}
		}
		
	}
	
	/**
	 * ���¼��ظ���Ȩ�����µ����й���
	 * @param ruleId
	 * @return
	 */
	public boolean reloadRules(){
		try {
			this.load();
			ARE.getLog().info("��Ȩ����["+this.getRuleSceneName()+"]���¼������!");
			return true;
		} catch (SADREException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
	protected void releaseResource() {
		if(psmt!=null){
			try {
				psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
				ARE.getLog().warn("���ݿ����ӹر�ʧ��!",e);
			}
		}
		
	}
	
	/**
	 * ��ά�ȹ�����ʽת��Ϊ�������,�Ա�ʶΪ"����"�Ĺ��������
	 * @param assumptions
	 * @return
	 * @throws SADREException
	 */
	private List<Assumption> parseAssumptions(String assumptions) throws SADREException{
		
		List<Assumption> assumptionSet = new ArrayList<Assumption>();
		Document document = null;
		Element element = null;
		Element node = null;
		ByteArrayInputStream bais = new ByteArrayInputStream(assumptions.getBytes());
		try {
			document = new Document(bais);
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("ά������["+assumptions+"]����ʧ��!",e);
			throw new SADREException("��Ȩά�Ƚ���ʧ��!",e);
		}finally{
			try {
				bais.close();
			} catch (IOException e) {
				ARE.getLog().debug(e);
			}
		}
		
		/*
		 <assumption-set>
		    <assumption dimension="xxx" op="xx" target="xxx.xx.xxx" />
		    <assumption dimension="xxx" op="xx" target="xxx.xx.xxx" />
		 </assumption-set>
		 */
//		element = document.getRootElement().getChild("assumption-set");
		element = document.getRootElement();
		
		if(element==null){
			ARE.getLog().warn("��Ȩά����������,δ���ҵ�<assumption-set>��ǩ!");
			return null;
		}
		
		String nodeDimension = "";
		String nodeOp 		 = "";
		String nodeTarget 	 = "";
		Iterator iterator = element.getChildren("assumption").iterator();
		while(iterator.hasNext()){
			node = (Element)iterator.next();
			nodeDimension = node.getAttribute("dimension").getValue();		//ά�ȱ��
			nodeOp 		  = node.getAttribute("op").getValue();
			nodeTarget 	  = node.getAttribute("target").getValue();
//			ARE.getLog().info(nodeDimension+" "+nodeOp+" "+nodeTarget);
			if(nodeOp.equals(Operator.����)) continue;
			
			Assumption asum = new Assumption(Dimensions.getDimension(nodeDimension),nodeOp,nodeTarget);
//			ARE.getLog().info("asum="+asum);
			assumptionSet.add(asum);
		}
//		ARE.getLog().info("assumptionSet="+assumptionSet);
		return assumptionSet;
	}
	
	public List<RuleImpl> getRules(){
		return rules;
	}
	
	/**
	 * ����ָ���Ĺ���Id���ض�Ӧ����
	 * @param ruleId
	 * @return
	 */
	public RuleImpl getRule(String ruleId){
		for(int i=0; i<getRules().size(); i++){
			RuleImpl rule = getRules().get(i);
			if(rule.getName().equals(ruleId)){
				return rule;
			}
		}
		return null;
	}
	
	public String toString(){
		return "SceneId="+getRuleSceneId()+"|SceneName="+getRuleSceneName()+"|rules.size="+getRules().size();
	}
	
	/**
	 * ����/����������ʽ
	 * @param page
	 * @return ���洦���� 1����ɹ� 3���ݷǷ� -1����ʧ��
	 */
	public int saveRule(Page page,ASUser CurUser,Transaction Sqlca) throws Exception{
		//����������	
		String sSceneId 	= StringUtil.getString(page.getParameter("SceneId"));
		String sRuleId 		= StringUtil.getString(page.getParameter("RuleId"));
		String sPriority 	= StringUtil.getString(page.getParameter("priority"));
		String sActions 	= StringUtil.getString(page.getParameter("actions"));
		String sNote 		= Escape.unescape(StringUtil.getString(page.getParameter("note")));
//		String sIsSub		= StringUtil.getString(page.getParameter("IsSub"));
		String sRuleType	= StringUtil.getString(page.getParameter("RuleType"));
		String sDecision 	= StringUtil.getString(page.getParameter("decision"));
		String sRefRules 	= Escape.unescape(StringUtil.getString(page.getParameter("RefRules")));
//		ARE.getLog().debug("SceneId="+sSceneId);
//		ARE.getLog().debug("RuleId="+sRuleId);
//		ARE.getLog().debug("sPriority="+sPriority);
//		ARE.getLog().debug("sActions="+sActions);
//		ARE.getLog().debug("sNote="+sNote);
		ARE.getLog().trace("sRuleType="+sRuleType);
		ARE.getLog().trace("sRefRules="+sRefRules);
		
		Vector<Parameter> params = page.parameterList;
		//ARE.getLog().info("params="+params);
		StringBuffer xmlScript = new StringBuffer("");
		String assumptionObj = "";		//ά�ȱ��
		String assumptionOp = "";
		String assumptionValue = "";
		/*
		<assumption-set>
		    <assumption dimension="DMS2011042600000001" op="lteq" target="1500000" />
		    <assumption dimension="abc00002" op="in" target="14,13" />
		</assumption-set>
		*/
		for(int p=0; p<params.size(); p++){
			Parameter parameter = params.get(p);
			if(parameter.paraName.startsWith("sadre_op_")){		//����������
				assumptionObj = parameter.paraName.substring(9);
				assumptionOp = (String)parameter.paraValue;
				if(assumptionOp.equals(Operator.����)) continue;
				
//				assumptionValue = DataConvert.toRealString(5,page.getParameter("sadre_value_"+assumptionObj));
//				ARE.getLog().info("sadre_value1_"+assumptionObj+" = '"+page.getParameter("sadre_value_"+assumptionObj)+"'");
				/*ALS6��Ҫ��*/
				assumptionValue = Escape.unescape(StringUtil.getString(page.getParameter("sadre_value_"+assumptionObj)));
				/*ALS7�ڽ��ܲ���ʱ�Ѿ������unescape*/
				//assumptionValue = StringUtil.getString(page.getParameter("sadre_value_"+assumptionObj));
//				ARE.getLog().info("sadre_value2_"+assumptionObj+" = '"+assumptionValue+"'");
				if(assumptionValue==null || assumptionValue.trim().length()==0) continue;
				
//				xmlScript.append("  <assumption dimension=\"").append(assumptionObj)
//								.append("\" op=\"").append(assumptionOp)
//								.append("\" target=\"").append(assumptionValue).append("\" />");
				//-----------���ڶ�ui�ύ��ά��˳�����Կ���,��Ϊ�ڲ��Ż�Ϊ:�������ά�ȼ���ŵ��ַ���ά��֮��
				String dimensionScript = " <assumption dimension=\""+assumptionObj+"\" op=\""+assumptionOp+"\" target=\""+assumptionValue+"\" />";
				if(Dimensions.getDimension(assumptionObj).getType()==Dimension.ά��ֵ����_�ַ���){
					xmlScript.insert(0, dimensionScript);
				}else{
					xmlScript.append(dimensionScript);
				}
			}
		}
		if(xmlScript.length()>0){
			xmlScript.insert(0, "<?xml version=\"1.0\" encoding=\"GB2312\"?><assumption-set>").append("</assumption-set>");
			
			String updateSql = "";
			if(sRuleId==null || sRuleId.length()==0 ||getRule(sRuleId)==null){
				//SCENEID,ASSUMPTIONID,ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES
				updateSql = "insert into SADRE_ASSUMPTION (ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,SCENEID,ASSUMPTIONID) "+
								"values (?,?,?,?,?,?,?,?,?,?,?)";
				
				//sRuleId = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R",Sqlca);
			}else{
				updateSql = "update SADRE_ASSUMPTION set ASSUMPTIONSET=?,"+
									"PRIORITY=?,"+
									"ACTIONS=?,"+
									"NOTE=?," +
									"DECISION=?,"+
									"RULETYPE=?," +
									"REFRULES=?,"+
									"INPUTDATE=?,"+
									"INPUTUSER=? "+
								"where SCENEID=? and ASSUMPTIONID=?";
			}
			
			try{
				PreparedStatement psmtUpdate = Sqlca.getConnection().prepareStatement(updateSql);
				psmtUpdate.setString(1, xmlScript.toString());
				psmtUpdate.setString(2, sPriority);
				psmtUpdate.setString(3, sActions);
				psmtUpdate.setString(4, sNote);
				psmtUpdate.setString(5, sDecision);
				psmtUpdate.setString(6, sRuleType);
				psmtUpdate.setString(7, sRefRules);
				psmtUpdate.setString(8, DateUtil.getToday());
				psmtUpdate.setString(9, CurUser.getUserID());
				psmtUpdate.setString(10, sSceneId);
				psmtUpdate.setString(11, sRuleId);
				psmtUpdate.executeUpdate();
				
				Sqlca.getConnection().commit();
				
				return ������_�ɹ�;
			}catch(Exception e){
				ARE.getLog().error("��Ȩ����["+sSceneId+"]������Ȩ����["+sRuleId+"]ʧ��!",e);
//				throw e;
				return ������_ʧ��;
			}
		}else{
			return ��������_Ϊ��;
		}
//		ARE.getLog().info("xmlScript="+xmlScript);
		
	}
	
	/**
	 * �ӳ�����ɾ��ָ���Ĺ������(����ALS6)
	 * @param ruleId  ���������
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public int removeRule(String ruleId,Transaction Sqlca) throws SADREException{
		RuleImpl rule = this.getRule(ruleId);
		if(rule == null){
			ARE.getLog().warn("����["+ruleId+"]������");
			return ��Ȩ����_������;
		}
		
		try{
//			SqlObject sqlo = new SqlObject("delete from SADRE_ASSUMPTION where SCENEID='"+this.getRuleSceneId()+"' and ASSUMPTIONID='"+ruleId+"'");
			String sqlo = "delete from SADRE_ASSUMPTION where SCENEID='"+this.getRuleSceneId()+"' and ASSUMPTIONID='"+ruleId+"'";
			Sqlca.executeSQL(sqlo);
			Sqlca.getConnection().commit();
			
			//reload the specifical scene
			this.reloadRules();
		}catch(Exception e){
			ARE.getLog().error("ɾ������["+ruleId+"]ʧ��!",e);
			return ������_ʧ��;
		}
		
		return ������_�ɹ�;
	}
	/*
	public int removeRule(String ruleId) throws SADREException{
		RuleImpl rule = this.getRule(ruleId);
		if(rule == null){
			ARE.getLog().warn("����["+ruleId+"]������");
			return ��Ȩ����_������;
		}
		
		try{
			BizObjectQuery boq = JBOFactory.createBizObjectQuery("jbo.app.sadre.ASSUMPTION", 
					"delete from O where SCENEID=:SCENEID and ASSUMPTIONID=:ASSUMPTIONID");
			boq.setParameter("SCENEID", getRuleSceneId());
			boq.setParameter("ASSUMPTIONID", ruleId);
			boq.executeUpdate();
			
			//reload the specifical scene
			this.reloadRules();
		}catch(JBOException e){
			ARE.getLog().error("ɾ������["+ruleId+"]ʧ��!",e);
			return ������_ʧ��;
		}
		
		return ������_�ɹ�;
	}
	*/
	
	/**
	 * ��ָ���Ĺ������뵽��ǰ�ĳ�����
	 * @param ruleId
	 * @param sceneId
	 * @param Sqlca
	 * @return
	 * @throws SADREException
	 */
	public int importRule(String ruleId, String sceneId, Transaction Sqlca) throws SADREException{
		String sSerialNo = "";
		int processStatus = ������_�ɹ�;
		try {
//			sSerialNo = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R",Sqlca);
			sSerialNo = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R",Sqlca);
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		if(!RuleScenes.containsRuleScene(sceneId)){
			ARE.getLog().error("��Ȩ����["+sceneId+"]������!");
			return ��Ȩ����_������;
		}
		
		try {
			//-------------
//			SqlObject sqlo = new SqlObject("insert into SADRE_ASSUMPTION (ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,SCENEID,ASSUMPTIONID) " +
//					"select ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,'' as REFRULES,INPUTDATE,INPUTUSER,'"+this.getRuleSceneId()+"' as SCENEID,'"+sSerialNo+"' as ASSUMPTIONID " +
//					"from SADRE_ASSUMPTION " +
//					"where SCENEID='"+sceneId+"' " +
//					"and ASSUMPTIONID='"+ruleId+"' ");
			String sqlo = "insert into SADRE_ASSUMPTION (ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,SCENEID,ASSUMPTIONID) " +
					"select ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,'' as REFRULES,INPUTDATE,INPUTUSER,'"+this.getRuleSceneId()+"' as SCENEID,'"+sSerialNo+"' as ASSUMPTIONID " +
					"from SADRE_ASSUMPTION " +
					"where SCENEID='"+sceneId+"' " +
					"and ASSUMPTIONID='"+ruleId+"' ";
			Sqlca.executeSQL(sqlo);
			Sqlca.getConnection().commit();			//�����ύ,Ϊ��ֹ��reloadʱ����
		} catch (Exception e) {
			processStatus = ������_ʧ��;
			ARE.getLog().error("��������ʧ��!",e);
		}
		
		reloadRules();
		
		return processStatus;
	}
	
	/**
	 * 
	 * @return
	 */
	public int replicate(Transaction Sqlca) throws SADREException{
		String sSerialNo = "";
		Map<String,String> idMap = new HashMap<String,String>();
		int processStatus = ��Ȩ����_���Ƴɹ�;
		//---------step1. �������������Ĺ����Ŷ��չ�ϵ
		Iterator<RuleImpl> tk = getRules().iterator();
		while(tk.hasNext()){
			RuleImpl ruletmp = tk.next();
			try {
				sSerialNo = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R",Sqlca);
			} catch (Exception e) {
				throw new SADREException(e);
			}
			idMap.put(ruletmp.getName(), sSerialNo);
		}
		
		//--------step2. ������Ȩ������
		boolean commitStatus = true;
		try {
			commitStatus = Sqlca.getConnection().getAutoCommit();
			Sqlca.getConnection().setAutoCommit(false);		//�������ݿ��������
			
			//--------------������Ϣ����
			String tmpSceneId = "";
			try {
				tmpSceneId = DBKeyHelp.getSerialNo("SADRE_RULESCENE","SCENEID","S",Sqlca);
			} catch (Exception e) {
				throw new SADREException(e);
			}
			
//			SqlObject sqlo = new SqlObject("insert into SADRE_RULESCENE (SCENENAME,AUTHORIZEEROLE,AUTHORIZEEID,AUTHORIZEEORG," +
//						"GRANTORROLE,GRANTORID,GRANTORORG," +
//						"EFFECTIVEDATE,MATURITY,INCLUDES,STATUS,FLOWS," +
//						"NOTE,INPUTDATE,INPUTUSER,SCENEID) " +
//					"select SCENENAME,AUTHORIZEEROLE,'' as AUTHORIZEEID,'' as AUTHORIZEEORG," +
//						"GRANTORROLE,GRANTORID,GRANTORORG," +
//						"EFFECTIVEDATE,MATURITY,INCLUDES,STATUS,FLOWS," +
//						"NOTE,INPUTDATE,INPUTUSER,'"+tmpSceneId+"' as SCENEID " +
//					"from SADRE_RULESCENE " +
//					"where SCENEID='"+this.getRuleSceneId()+"'");
			String sqlo = "insert into SADRE_RULESCENE (SCENENAME,AUTHORIZEEROLE,AUTHORIZEEID,AUTHORIZEEORG," +
						"GRANTORROLE,GRANTORID,GRANTORORG," +
						"EFFECTIVEDATE,MATURITY,INCLUDES,STATUS,FLOWS," +
						"NOTE,INPUTDATE,INPUTUSER,SCENEID) " +
					"select SCENENAME,AUTHORIZEEROLE,'' as AUTHORIZEEID,'' as AUTHORIZEEORG," +
						"GRANTORROLE,GRANTORID,GRANTORORG," +
						"EFFECTIVEDATE,MATURITY,INCLUDES,STATUS,FLOWS," +
						"NOTE,INPUTDATE,INPUTUSER,'"+tmpSceneId+"' as SCENEID " +
					"from SADRE_RULESCENE " +
					"where SCENEID='"+this.getRuleSceneId()+"'";
			Sqlca.executeSQL(sqlo);
			
			/*��ȡ�����������ϵ*/
			String sBelongGroupId = "";
			ASResultSet group = Sqlca.getASResultSet("select GroupId from SADRE_SCENERELATIVE where SceneId='"+getRuleSceneId()+"'");
			if(group.next()){
				sBelongGroupId = StringUtil.getString(group.getString("GroupId"));
			}
			group.getStatement().close();
			
			if(sBelongGroupId!=null && sBelongGroupId.length()>0){
//				SqlObject sqloGroup = new SqlObject("insert into SADRE_SCENERELATIVE (GroupId,SceneId,note) values ('"+sBelongGroupId+"','"+tmpSceneId+"','replicate')");
				String sqloGroup = "insert into SADRE_SCENERELATIVE (GroupId,SceneId,note) values ('"+sBelongGroupId+"','"+tmpSceneId+"','replicate')";
				Sqlca.executeSQL(sqloGroup);
			}
			
			//--------------���¹�����
			Iterator<RuleImpl> rules = getRules().iterator();
			while(rules.hasNext()){
				RuleImpl ruletmp = rules.next();
				//-------------�������ǰ�ù���Ļ�,���ӹ���Ĺ����Ž���ת��Ϊ�µĹ�����
				String tmpRuleId = idMap.get(ruletmp.getName());
				//-------------
//				SqlObject sqlr = new SqlObject("insert into SADRE_ASSUMPTION (ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,SCENEID,ASSUMPTIONID) " +
//						"select ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,'"+tmpSceneId+"' as SCENEID,'"+tmpRuleId+"' as ASSUMPTIONID " +
//						"from SADRE_ASSUMPTION " +
//						"where SCENEID='"+this.getRuleSceneId()+"' " +
//						"and ASSUMPTIONID='"+ruletmp.getName()+"' ");
				String sqlr = "insert into SADRE_ASSUMPTION (ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,SCENEID,ASSUMPTIONID) " +
						"select ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES,INPUTDATE,INPUTUSER,'"+tmpSceneId+"' as SCENEID,'"+tmpRuleId+"' as ASSUMPTIONID " +
						"from SADRE_ASSUMPTION " +
						"where SCENEID='"+this.getRuleSceneId()+"' " +
						"and ASSUMPTIONID='"+ruletmp.getName()+"' ";
				Sqlca.executeSQL(sqlr);
			}
			
			Sqlca.getConnection().commit();
			
			//--------------�������ĳ������ӵ�������
			RuleScene rs = new RuleScene(tmpSceneId, this.getRuleSceneName());
			//���Ʊ���Ȩ�˽�ɫ
			rs.setAuthorizeeRoles(this.getAuthorizeeRoles());
			//���Ʊ���Ȩ����������
			rs.setAuthorizeeOrgs(this.getAuthorizeeOrgs());
			//���Ʊ���Ȩ��Id
			rs.setAuthorizees(this.getAuthorizees());
			//���ư�������Ȩά��
			rs.setIncludeDimensions(this.getIncludeDimensions());
			//������Ȩ����Ϣ
			rs.setGrantorOrgs(this.getGrantorOrgs());
			rs.setGrantorRoles(this.getGrantorRoles());
			rs.setGrantors(this.getGrantors());
			//����������Ϣ
			rs.setEffectiveDate(this.getEffectiveDate());
			rs.setMaturity(this.getMaturity());
			//����ʹ������
			rs.setFlows(this.getFlows());
			
			RuleScenes.addRuleScene(rs);
			
		} catch (Exception e) {
			processStatus = ��Ȩ����_����ʧ��;
			try {
				Sqlca.getConnection().rollback();
			} catch (SQLException e1) {
				ARE.getLog().warn("�����������ݿ�����ع�ʧ��!",e1);
			}
			
			ARE.getLog().error("��������ʧ��!",e);
			
		} finally{
			
			try {
				Sqlca.getConnection().setAutoCommit(commitStatus);
			} catch (SQLException e) {
				ARE.getLog().warn(e);
			}
		}
		
		return processStatus;
	}
}
