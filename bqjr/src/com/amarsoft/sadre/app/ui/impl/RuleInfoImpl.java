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
package com.amarsoft.sadre.app.ui.impl;

import java.io.IOException;
import java.io.Writer;
import java.util.Iterator;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.sadre.app.ui.AbstractSUIQuery;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.jsr94.admin.RuleImpl;
import com.amarsoft.sadre.rules.aco.Assumption;
import com.amarsoft.sadre.rules.aco.RuleScene;
import com.amarsoft.sadre.services.SADREService;
import com.amarsoft.web.ui.HTMLControls;

 /**
 * <p>Title: RuleInfoImpl.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-28 下午05:05:22
 *
 * logs: 1. 
 */
public class RuleInfoImpl extends AbstractSUIQuery {
	
	private String sceneId = "";
	
	private String ruleId = "";
	
	private RuleScene ruleScene = null;
	
	private RuleImpl rule = null;
	
	private boolean newDataFlg = false;
	
	private StringBuffer tableScript = new StringBuffer();

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.swui.SUIQuery#generateButtons(java.io.Writer, java.lang.String)
	 */
	
	public void generateButtons(Writer out, String url) throws Exception {
		out.write("<div class=\"buttons\">" +
					"<table style=\"border:0;width:800px;\" >" +
						"<tr>"+
						"  <td style=\"border:0;width:30%\">"+	//style=\"border:0\"
							"<button type=\"button\" class=\"regular\" name=\"return\" id=\"return\" onclick=\"javascript:myReturn('"+sceneId+"');\"><img src=\""+url+"/Common/Configurator/Authorization/ico/return.png\" alt=\"返回\"/> 返 回 </button>"+
							"<button type=\"button\" class=\"regular\" name=\"save\" id=\"save\" onclick=\"javascript:mySave();\"><img src=\""+url+"/Common/Configurator/Authorization/ico/save.png\" alt=\"保存\"/> 保  存  </button>"+
						"</td>"+
						"  </td>" +
						"  <td style=\"border:0;padding-top:10px;width:40%\"><div id=\"MyResult\"></div></td>"+
						"  <td style=\"border:0px;width:30%\" align=\"right\">授权配置管理(" +SADREService.getLicenseClient()+")</td>"+
						"</tr>"+
					"</table>" +
				"</div>");

//		out.write("<div>" +
//				"<table style='border:0;width:800px;'>" +
//					"<tr>"+
//					"  <td width='90px' align='center'>"+
//					(new Button(" 返 回  ","返回","javascript:myReturn('"+sceneId+"');","","sadre_icon_return","").getHtmlText())+
//					"  </td>" +
//					"  <td width='90px' align='center'>"+
//					(new Button(" 保 存  ","保存","javascript:mySave();","","sadre_icon_save","").getHtmlText())+
//					"  </td>" +
//					"  <td width='50%'><div id=\"MyResult\"></div></td>"+
//					"  <td width=\"30%\" align=\"right\">授权配置管理(" +SADREService.getLicenseClient()+")"+
//					"  </td>" +
//					"</tr>"+
//				"</table>" +
//			"</div>");

	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.swui.AbstractSUIQuery#drawHeader()
	 */
	
	public void drawHeader() {

	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.swui.AbstractSUIQuery#prepareRequest()
	 */
	
	public void prepareRequest() throws Exception {
		sceneId = this.getRequest("SceneId");
		ruleId 	= this.getRequest("RuleId");
		
		ruleScene 	= RuleScenes.getRuleScene(sceneId);
//		ARE.getLog().info("ruleScene="+ruleScene);
		if(ruleScene==null){
			throw new Exception("授权场景["+sceneId+"]不存在!");
		}
		
		if(ruleId==null || ruleId.length()==0){
			ARE.getLog().info("规则编号为空,视为新增操作.");
			newDataFlg = true;
			ruleId = DBKeyHelp.getSerialNo("SADRE_ASSUMPTION","ASSUMPTIONID","R");
			
		}else{
			rule = ruleScene.getRule(ruleId);
			if(rule==null){
				ARE.getLog().info("规则["+ruleId+"]不存在,视为新增操作.");
				newDataFlg = true;
			}
		}
		
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.swui.AbstractSUIQuery#doQuery()
	 */
	
	public void doQuery(String url) throws Exception {
		
//		tableScript.append("<br />");
		//tableScript.append("<table width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"1\">");//bgcolor='#DCDCDC'	//bgcolor=\"#FFFFFF\"
		StringBuffer includeDimensions = new StringBuffer();		//本规则中包含的授权维度,用于对已有配置的解析
		
		tableScript.append("<table class=\"styleta\">");
		//--------------add at 20110614 增加是否子规则标志+维度添加按钮
		tableScript.append("  <tr>");
//		tableScript.append("    <td width=\"15%\" class=\"titw1 titd\"><input type=\"checkbox\" name=\"ChkSub\" id=\"ChkSub\" "+((!newDataFlg && rule.isSub())?"checked":"")+" value=\"\" onclick=\"chkSub();\"/>作为子规则</td>");
		tableScript.append("    <td width=\"15%\" class=\"titw1 titd tdborder\">规则类型(RuleType)</td>");
		tableScript.append("    <td width=\"85%\" colspan=\"2\" style=\"border:1px;border-color:#FFF\">");
		tableScript.append("  		<input name=\"RuleType\" type=\"radio\" id=\"RuleType\" value=\""+RuleImpl.规则类型_独立规则+"\" "+((newDataFlg || (rule.getRuleType()==RuleImpl.规则类型_独立规则))?"checked":"")+" />独立规则 &nbsp;");
		tableScript.append("  		<input name=\"RuleType\" type=\"radio\" id=\"RuleType\" value=\""+RuleImpl.规则类型_前置规则+"\" "+((!newDataFlg && (rule.getRuleType()==RuleImpl.规则类型_前置规则))?"checked":"")+" />前置规则 &nbsp;");
		tableScript.append("  	</td>");
		tableScript.append("  	<td width=\"50%\" align=\"right\" style=\"border:0px\">");
		tableScript.append("		<button type=\"button\" class=\"regular\" name=\"add\" onclick=\"javascript:myAdd();\"><img src=\""+url+"/Common/Configurator/Authorization/ico/add.png\" alt=\"将维度添加到授权规则中\"/></button>");
//		tableScript.append(new Button("添加","添加","javascript:myAdd();","","sadre_icon_add","").getHtmlText());
		tableScript.append("    </td>");
		tableScript.append("  </tr>");
		//--------------add end
		tableScript.append("  <tr>");
		tableScript.append("    <td class=\"titw1 titd\">授权规则集合(DimensionSet)</td>");
		tableScript.append("    <td colspan=\"3\" class=\"tdborder\">");
//		tableScript.append("  <div style=\"border:1px solid #0066ff\" id=\"dmsdata\">");
		tableScript.append("    <table class=\"styletc\">");
		
		if(!newDataFlg){		//非新增操作时显示已经配置的维度条件
			Iterator<Assumption> tk = rule.getAssumptions().iterator();		//该规则下已经配置的维度条件
			while(tk.hasNext()){
				Assumption assumption = tk.next();
				
				if(assumption.belongDimension()==null) {
					ARE.getLog().info("授权规则条件有误!["+assumption.toString()+"]");
					continue;
				}
				
				tableScript.append(assumption.belongDimension().getHTMLScript(assumption, sqlca));
				includeDimensions.append(",").append(assumption.belongDimension().getId());

			}
		}
		
		tableScript.append("    </table>");
		tableScript.append("  <div id=\"dmsdata\">");	//div用于动态添加维度元素
		tableScript.append(newDataFlg?"<label style=\"background:#FF0\"><font color=\"red\">无有效的授权条件,请通过<img src=\""+url+"/Common/Configurator/Authorization/ico/add.png\" width=\"16\" height=\"16\"/>按钮添加.</font></label>":"");
		tableScript.append("  </div>");
		tableScript.append("  	</td>");
		tableScript.append("  </tr>");
		
		tableScript.append("  <tr>");
		tableScript.append("    <td class=\"titw1 titd tdborder\">规则优先级(Priority)</td>");
		tableScript.append("    <td colspan=\"3\" class=\"tdborder\">");
		tableScript.append("      <select name=\"priority\" id=\"priority\">");
		tableScript.append(HTMLControls.generateDropDownSelect(sqlca, "RulePriority", (newDataFlg?"3":rule.getPriority())));
//		tableScript.append(new ComboBox("priority",sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='RulePriority' and IsInUse='1'",1,2,(newDataFlg?"3":rule.getPriority())).getOptionString());
		tableScript.append("      </select>（Level_0最高）</td>");
		tableScript.append("  </tr>");
		
		tableScript.append("  <tr>");
		//-------------增加满足后"操作流向":continue/break;
		tableScript.append("    <td width=\"15%\" class=\"titw1 titd tdborder\">规则满足后动作(Action)</td>");
		tableScript.append("    <td width=\"35%\" class=\"tdborder\">");
//		tableScript.append("	<select name=\"actions\" id=\"actions\" "+((!newDataFlg && (rule.getRuleType()==RuleImpl.规则类型_子规则))?"disabled":"")+">");		//子规则默认disabled
		tableScript.append("	<select name=\"actions\" id=\"actions\" >");
		tableScript.append(HTMLControls.generateDropDownSelect(sqlca, "RuleAction", (newDataFlg?"break":rule.getActions())));
//		tableScript.append(new ComboBox("priority",sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='RuleAction' and IsInUse='1'",1,2,(newDataFlg?"break":rule.getActions())).getOptionString());
		tableScript.append("	</select></td>");
		
		tableScript.append("    <td width=\"15%\" class=\"titw1 titd tdborder\">规则结果(Decision)</td>");
		tableScript.append("    <td width=\"35%\" class=\"tdborder\">");
		tableScript.append("	<select name=\"decision\" id=\"decision\">");
		tableScript.append(HTMLControls.generateDropDownSelect(sqlca, "RuleDecision", (newDataFlg?"accept":rule.getDecision())));
//		tableScript.append(new ComboBox("priority",sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='RuleDecision' and IsInUse='1'",1,2,(newDataFlg?"accept":rule.getDecision())).getOptionString());
		tableScript.append("	</select></td>");
		tableScript.append("  </tr>");
		
		tableScript.append("  <tr>");
		tableScript.append("    <td class=\"titw1 titd tdborder\">前置规则(RefRules)</td>");
		tableScript.append("    <td colspan=\"3\" class=\"tdborder\"><label>");
//		String sSubRuleList = "";
//		if(!newDataFlg){
//			for(int i=0; i<rule.getSubRuleIds().length; i++){
//				sSubRuleList += ","+rule.getSubRuleIds()[i];
//			}
//			if(sSubRuleList.length()>0){
//				sSubRuleList = sSubRuleList.substring(1);
//			}
//			
//		}
		//tableScript.append("      <textarea name=\"subrules\" cols=\"80\" rows=\"5\" id=\"note\" style=\"overflow:auto\" readonly>").append(newDataFlg?"":rule.getReferenceRule()).append("</textarea>");
		tableScript.append(" 		<input type=\"text\" name=\"RefRules\" id=\"RefRules\" size=\"50\" readonly=\"readonly\" value=\""+(newDataFlg?"":rule.getReferenceRule())+"\"/>");
		tableScript.append("    </label>");
		tableScript.append("		<input type=\"button\" class=\"btncss3\" name=\"button_refrule\" value=\"...\" onclick=\"javascript:selectRefRule()\"/>");
		tableScript.append("		<span>仅独立规则可关联前置规则</span>");
		tableScript.append("	</td>");
		tableScript.append("  </tr>");
		
		tableScript.append("  <tr>");
		tableScript.append("    <td class=\"titw1 titd tdborder\">规则说明(Note)</td>");
		tableScript.append("    <td colspan=\"3\" class=\"tdborder\"><label>");
		tableScript.append("      <textarea name=\"note\" cols=\"80\" rows=\"5\" id=\"note\" style=\"overflow:auto\" >").append(newDataFlg?"":rule.getDescription()).append("</textarea>");
		tableScript.append("    </label></td>");
		tableScript.append("  </tr>");
		
		tableScript.append("</table>");
		
		tableScript.append("<input type=hidden name=\"SceneId\" value="+sceneId+">");
		tableScript.append("<input type=hidden name=\"RuleId\" value="+ruleId+">");
		
		if(includeDimensions.length()>0){
			includeDimensions = includeDimensions.deleteCharAt(0);
		}
		tableScript.append("<input type=hidden name=\"DimensionIds\" id=\"DimensionIds\" value=\""+includeDimensions.toString()+"\">");
		
		//-------------处理子规则选择框的事件
//		tableScript.append("<input type=hidden name=\"IsSub\" id=\"IsSub\" value=\""+((!newDataFlg && rule.isSub())?"yes":"no")+"\">");
		
		ARE.getLog().debug(tableScript.toString()); 
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.swui.AbstractSUIQuery#clearResource()
	 */
	
	public void clearResource() {
		// do nothings

	}
	
	public String generateHTMLScript() throws IOException {
		return tableScript.toString();
	}
	
}
