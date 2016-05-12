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
 * @date 2011-4-15 下午03:23:53
 *
 * logs: 1. 
 */
public class RuleScene extends AbstractDataLoader{
	
	public static final int 规则处理_成功 	= 1;
	public static final int 规则处理_失败 	= 9;
	public static final int 规则配置_为空 	= 3;
	public static final int 授权规则_不存在 	= -1;
	
	public static final int 授权方案_复制失败 = 19;
	public static final int 授权方案_复制成功 = 11;
	
	/*授权方案编号*/
	private String ruleSceneId;
	/*授权方案名称*/
	private String ruleSceneName;
	
	/*被授权人角色(必输项)*/
	private String[] authorizeeRoles;
	/*被授权人编号(可选项)*/
	private String[] authorizeeIds;
	/*被授权人所属机构(可选项)*/
	private String[] authorizeeOrgs;
	
	/*授权人角色(可选项) */
	private String[] grantorRoles;
	/*授权人编号(可选项) */
	private String[] grantorIds;
	/*授权人所属机构(可选项) */
	private String[] grantorOrgs;
	/*授权方案生效日 */
	private String effectiveDate;
	/*授权方案失效日 */
	private String maturity;
	/*适用流程 */
	private String[] flows;
	/*方案包含的授权参数 */
	private String[] includes;
	
	/*包含的规则集合*/
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
	 * 通过数组设定授权场景维度数组
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
	 * 通过数组设定授权场景授权对象数组
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
	
	/*授权人信息*/
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
	 * 通过数组设定授权场景授权对象数组
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
	 * 判断传入的审批人是否满足授权方案要求：<br>
	 * 1. 该授权方案的"被授权人编号"与传入的审批人匹配;<br>
	 * 2. 该授权方案无"被授权人编号",视为无审批人限定
	 * @param userId
	 * @return
	 */
	public boolean lookupScenceUser(String userId){
//		if(getAuthorizees()==null 
//				||(getAuthorizees().length==1 && getAuthorizees()[0].length()==0)) return true;	//无指定"同岗差异授权对象"
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
	 * 授权方案是否指定被授权人的所属机构
	 * @return
	 */
	public boolean unspecificBelongOrg(){
		return (getAuthorizeeOrgs()==null || getAuthorizeeOrgs().length==0)?true:false; 
	}
	
	/**
	 * 授权方案是否制定被授权人的用户编号
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
		
		rules.clear();		//赋值前先清空rule
		
		String sAssumptionId 	= "";
		String sDescription  	= "";
		String sAssumptionSet 	= "";
		String sActions	 	 	= "";
		String sPriority	 	= "";
		int iRuleType		 	= RuleImpl.规则类型_未知;
		String sDecision	 	= "";
		String sRefRules		= "";
		String sql = "select SCENEID,ASSUMPTIONID,ASSUMPTIONSET,PRIORITY,ACTIONS,NOTE,DECISION,RULETYPE,REFRULES " +
				"from SADRE_ASSUMPTION " +
				"where SCENEID=? " +
				"order by PRIORITY,ASSUMPTIONID asc";	//0为最高优先级
		try {
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, getRuleSceneId());
			ResultSet ruleset = psmt.executeQuery();
			while(ruleset.next()){
				sAssumptionId	= StringUtil.getString(ruleset.getString("ASSUMPTIONID"));
				sDescription 	= StringUtil.getString(ruleset.getString("NOTE"));
				sAssumptionSet 	= StringUtil.getString(ruleset.getString("ASSUMPTIONSET"));			//维度条件集合
				sActions 		= StringUtil.getString(ruleset.getString("ACTIONS"));
				sPriority		= StringUtil.getString(ruleset.getString("PRIORITY"));
				iRuleType		= ruleset.getInt("RULETYPE");
				sDecision		= StringUtil.getString(ruleset.getString("DECISION"));
				sRefRules		= StringUtil.getString(ruleset.getString("REFRULES"));
//				ARE.getLog().info("sDescription: id="+sAssumptionId+" |sDescription="+sDescription);
				RuleImpl rule = new RuleImpl(sAssumptionId,sDescription,parseAssumptions(sAssumptionSet));
				rule.setActions(sActions);
				rule.setPriority(sPriority);
//				rule.setSub((sIsSub!=null && sIsSub.equals("yes"))?true:false);		//是否子规则
				rule.setRuleType(iRuleType);		//规则类型
				rule.setDecision(sDecision);
//				rule.setSubRules(sSubRules);		//对子规则的实例化放在所有的规则初始化结束之后
//				ARE.getLog().debug("sRefRules-1:"+sRefRules);
				rule.setReferenceRule(sRefRules);
//				ARE.getLog().debug("sRefRules-2:"+rule.getReferenceRule());
				
				rules.add(rule);
			}
			ruleset.close();
			
			//------前置规则的实例化,避免出现规则环
			applyReferenceRuleLink();
			
		} catch (SQLException e) {
			e.printStackTrace();
			ARE.getLog().error("授权规则场景获取失败!",e);
			throw new SADREException(e);
		}
		
		return true;
		
	}
	
	/**
	 * 将方案下所包含的规则项下前置规则,由规则编号转换为规则链,避免形成规则环.<br>
	 * 1.规则之间的前置关系局限在相同一个授权方案中,不能跨方案进行前置引用
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
//				if(subrule == null || subrule.getRuleType()==RuleImpl.规则类型_单一规则){
//					ARE.getLog().warn(rule.getName()+"项下子规则["+rule.getSubRuleIds()[sr]+"]不存在或者不是子规则!");
//					continue;
//				}
//				rule.getSubRuleObjs().add(subrule);
//			}
////			ARE.getLog().trace(rule.getSubRuleObjs());
			if(rule.getName().equals(rule.getReferenceRule())){
				ARE.getLog().warn("["+rule.getName()+"] 前置规则配置错误！ERR=不能指定自身为前置规则.");
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
	 * 重新加载该授权场景下的所有规则
	 * @param ruleId
	 * @return
	 */
	public boolean reloadRules(){
		try {
			this.load();
			ARE.getLog().info("授权场景["+this.getRuleSceneName()+"]重新加载完成!");
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
				ARE.getLog().warn("数据库连接关闭失败!",e);
			}
		}
		
	}
	
	/**
	 * 将维度规则表达式转换为规则对象,对标识为"忽略"的规则不予加载
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
			ARE.getLog().error("维度条件["+assumptions+"]解析失败!",e);
			throw new SADREException("授权维度解析失败!",e);
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
			ARE.getLog().warn("授权维度配置有误,未能找到<assumption-set>标签!");
			return null;
		}
		
		String nodeDimension = "";
		String nodeOp 		 = "";
		String nodeTarget 	 = "";
		Iterator iterator = element.getChildren("assumption").iterator();
		while(iterator.hasNext()){
			node = (Element)iterator.next();
			nodeDimension = node.getAttribute("dimension").getValue();		//维度编号
			nodeOp 		  = node.getAttribute("op").getValue();
			nodeTarget 	  = node.getAttribute("target").getValue();
//			ARE.getLog().info(nodeDimension+" "+nodeOp+" "+nodeTarget);
			if(nodeOp.equals(Operator.忽略)) continue;
			
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
	 * 根据指定的规则Id返回对应对象
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
	 * 更新/新增规则表达式
	 * @param page
	 * @return 保存处理结果 1保存成功 3数据非法 -1保存失败
	 */
	public int saveRule(Page page,ASUser CurUser,Transaction Sqlca) throws Exception{
		//获得组件参数	
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
		String assumptionObj = "";		//维度编号
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
			if(parameter.paraName.startsWith("sadre_op_")){		//搜索操作符
				assumptionObj = parameter.paraName.substring(9);
				assumptionOp = (String)parameter.paraValue;
				if(assumptionOp.equals(Operator.忽略)) continue;
				
//				assumptionValue = DataConvert.toRealString(5,page.getParameter("sadre_value_"+assumptionObj));
//				ARE.getLog().info("sadre_value1_"+assumptionObj+" = '"+page.getParameter("sadre_value_"+assumptionObj)+"'");
				/*ALS6需要对*/
				assumptionValue = Escape.unescape(StringUtil.getString(page.getParameter("sadre_value_"+assumptionObj)));
				/*ALS7在接受参数时已经完成了unescape*/
				//assumptionValue = StringUtil.getString(page.getParameter("sadre_value_"+assumptionObj));
//				ARE.getLog().info("sadre_value2_"+assumptionObj+" = '"+assumptionValue+"'");
				if(assumptionValue==null || assumptionValue.trim().length()==0) continue;
				
//				xmlScript.append("  <assumption dimension=\"").append(assumptionObj)
//								.append("\" op=\"").append(assumptionOp)
//								.append("\" target=\"").append(assumptionValue).append("\" />");
				//-----------由于对ui提交的维度顺序难以控制,改为内部优化为:将金额类维度计算放到字符型维度之后。
				String dimensionScript = " <assumption dimension=\""+assumptionObj+"\" op=\""+assumptionOp+"\" target=\""+assumptionValue+"\" />";
				if(Dimensions.getDimension(assumptionObj).getType()==Dimension.维度值类型_字符型){
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
				
				return 规则处理_成功;
			}catch(Exception e){
				ARE.getLog().error("授权场景["+sSceneId+"]更新授权规则["+sRuleId+"]失败!",e);
//				throw e;
				return 规则处理_失败;
			}
		}else{
			return 规则配置_为空;
		}
//		ARE.getLog().info("xmlScript="+xmlScript);
		
	}
	
	/**
	 * 从场景中删除指定的规则对象(兼容ALS6)
	 * @param ruleId  规则对象编号
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public int removeRule(String ruleId,Transaction Sqlca) throws SADREException{
		RuleImpl rule = this.getRule(ruleId);
		if(rule == null){
			ARE.getLog().warn("规则["+ruleId+"]不存在");
			return 授权规则_不存在;
		}
		
		try{
//			SqlObject sqlo = new SqlObject("delete from SADRE_ASSUMPTION where SCENEID='"+this.getRuleSceneId()+"' and ASSUMPTIONID='"+ruleId+"'");
			String sqlo = "delete from SADRE_ASSUMPTION where SCENEID='"+this.getRuleSceneId()+"' and ASSUMPTIONID='"+ruleId+"'";
			Sqlca.executeSQL(sqlo);
			Sqlca.getConnection().commit();
			
			//reload the specifical scene
			this.reloadRules();
		}catch(Exception e){
			ARE.getLog().error("删除规则["+ruleId+"]失败!",e);
			return 规则处理_失败;
		}
		
		return 规则处理_成功;
	}
	/*
	public int removeRule(String ruleId) throws SADREException{
		RuleImpl rule = this.getRule(ruleId);
		if(rule == null){
			ARE.getLog().warn("规则["+ruleId+"]不存在");
			return 授权规则_不存在;
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
			ARE.getLog().error("删除规则["+ruleId+"]失败!",e);
			return 规则处理_失败;
		}
		
		return 规则处理_成功;
	}
	*/
	
	/**
	 * 将指定的规则引入到当前的场景中
	 * @param ruleId
	 * @param sceneId
	 * @param Sqlca
	 * @return
	 * @throws SADREException
	 */
	public int importRule(String ruleId, String sceneId, Transaction Sqlca) throws SADREException{
		String sSerialNo = "";
		int processStatus = 规则处理_成功;
		try {
//			sSerialNo = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R",Sqlca);
			sSerialNo = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R",Sqlca);
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		if(!RuleScenes.containsRuleScene(sceneId)){
			ARE.getLog().error("授权场景["+sceneId+"]不存在!");
			return 授权规则_不存在;
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
			Sqlca.getConnection().commit();			//必须提交,为防止在reload时互锁
		} catch (Exception e) {
			processStatus = 规则处理_失败;
			ARE.getLog().error("规则引入失败!",e);
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
		int processStatus = 授权方案_复制成功;
		//---------step1. 建立复制新增的规则编号对照关系
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
		
		//--------step2. 逐条授权规则复制
		boolean commitStatus = true;
		try {
			commitStatus = Sqlca.getConnection().getAutoCommit();
			Sqlca.getConnection().setAutoCommit(false);		//控制数据库操作事务
			
			//--------------场景信息复制
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
			
			/*获取方案组关联关系*/
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
			
			//--------------项下规则复制
			Iterator<RuleImpl> rules = getRules().iterator();
			while(rules.hasNext()){
				RuleImpl ruletmp = rules.next();
				//-------------如果存在前置规则的话,将子规则的规则编号进行转换为新的规则编号
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
			
			//--------------将新增的场景增加到缓存中
			RuleScene rs = new RuleScene(tmpSceneId, this.getRuleSceneName());
			//复制被授权人角色
			rs.setAuthorizeeRoles(this.getAuthorizeeRoles());
			//复制被授权人所属机构
			rs.setAuthorizeeOrgs(this.getAuthorizeeOrgs());
			//复制被授权人Id
			rs.setAuthorizees(this.getAuthorizees());
			//复制包含的授权维度
			rs.setIncludeDimensions(this.getIncludeDimensions());
			//复制授权人信息
			rs.setGrantorOrgs(this.getGrantorOrgs());
			rs.setGrantorRoles(this.getGrantorRoles());
			rs.setGrantors(this.getGrantors());
			//复制期限信息
			rs.setEffectiveDate(this.getEffectiveDate());
			rs.setMaturity(this.getMaturity());
			//复制使用流程
			rs.setFlows(this.getFlows());
			
			RuleScenes.addRuleScene(rs);
			
		} catch (Exception e) {
			processStatus = 授权方案_复制失败;
			try {
				Sqlca.getConnection().rollback();
			} catch (SQLException e1) {
				ARE.getLog().warn("方案复制数据库事务回滚失败!",e1);
			}
			
			ARE.getLog().error("方案复制失败!",e);
			
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
