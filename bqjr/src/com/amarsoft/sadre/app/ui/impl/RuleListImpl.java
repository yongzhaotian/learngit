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
import java.util.List;

import com.amarsoft.sadre.app.ui.AbstractSUIQuery;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.jsr94.admin.RuleImpl;
import com.amarsoft.sadre.rules.aco.Assumption;
import com.amarsoft.sadre.rules.aco.Dimension;
import com.amarsoft.sadre.rules.aco.RuleScene;
import com.amarsoft.sadre.services.SADREService;

 /**
 * <p>Title: RuleListImpl.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-27 下午05:58:59
 *
 * logs: 1. 
 */
public class RuleListImpl extends AbstractSUIQuery {
	/**
	 * 规则场景Id
	 */
	private String sceneId = "";
	
	private RuleScene ruleScene = null;
	
	private StringBuffer tableScript = new StringBuffer();
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.sui.SUIQuery#generateButtons(java.io.Writer, java.lang.String)
	 */
	
	public void generateButtons(Writer out, String url) throws Exception {
		out.write("<div>" +
					"<table style=\"border:0px\">" +
						"<tr>"+
						"  <td style=\"border:0px\">"+
						"<button type=\"button\" class=\"regular\" name=\"new\" onclick=\"javascript:myNew('"+ruleScene.getRuleSceneId()+"');\"><img src=\""+url+"/Common/Configurator/Authorization/ico/new.png\" alt=\"新增\"/>新增</button>"+
						"&nbsp;&nbsp;"+
						"<button type=\"button\" class=\"regular\" name=\"import\" onclick=\"javascript:myImport();\"><img src=\""+url+"/Common/Configurator/Authorization/ico/import.png\" alt=\"引入\"/>引入</button>"+
						"  </td>" +
						"  <td style=\"border:0;padding-top:10px;\"><div id=\"MyResult\"></div></td>"+
						"  <td style=\"border:0px\">" +
						"  <input type=\"text\" id=\"jumpId\" /> <input type=\"button\" name=\"jumpto\" id=\"jumpto\" value=\"转到规则\" onclick=\"javascript:jumpTo();\"/>" +
						"  </td>" +
						"  <td width=\"50%\" style=\"border:0px\" align=\"right\">授权配置管理(" +SADREService.getLicenseClient()+")"+
						"  </td>" +
						"</tr>"+
					"</table>" +
				"</div>");
		
//		out.write("<div>" +
//				"<table style='width:97%;border=0px'>" +
//					"<tr>"+
//					"  <td align='center' style=\"width:90px;\">"+
//					(new Button(" 新 增  ","新增授权规则","javascript:myNew('"+ruleScene.getRuleSceneId()+"');","","sadre_icon_new","").getHtmlText())+
//					"  </td>" +
//					"  <td align='center' style=\"width:90px;\">"+
//					(new Button(" 引 入  ","引入/复制规则","javascript:myImport();","","sadre_icon_import","").getHtmlText())+
//					"  </td>" +
//					"  <td ><div id=\"MyResult\" ></div></td>"+
//					"  <td width='5%'>" +
//					"  <input type=\"text\" id=\"jumpId\" />" +
//					"  </td>" +
//					"  <td >" +
//					(new Button(" 转到规则  ","转到指定规则","javascript:jumpTo();","","","").getHtmlText())+
//					"  </td>" +
//					"  <td width=\"60%\" align=\"right\">授权配置管理(" +SADREService.getLicenseClient()+")"+
//					"  </td>" +
//					"</tr>"+
//				"</table>" +
//			"</div>");

	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.sui.AbstractSUIQuery#drawHeader()
	 */
	
	public void drawHeader() {
		// not need to draw header

	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.sui.AbstractSUIQuery#prepareRequest()
	 */
	
	public void prepareRequest() throws Exception {
		sceneId 	= this.getRequest("SceneID");
//		ARE.getLog().info("sceneId="+sceneId);
//		ARE.getLog().info("size="+RuleScenes.getRuleScenes());
//		ARE.getLog().info(RuleScenes.containsRuleScene(sceneId));
		ruleScene 	= RuleScenes.getRuleScene(sceneId);
//		ARE.getLog().info("ruleScene="+ruleScene);
		if(ruleScene==null){
			throw new Exception("授权场景["+sceneId+"]不存在!");
		}
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.sui.AbstractSUIQuery#doQuery()
	 */
	
	public void doQuery(String url) throws Exception {
		
		int iCounter = 1;
		List<RuleImpl> rules = ruleScene.getRules();
		
		Iterator<RuleImpl> tk = rules.iterator();
		while(tk.hasNext()){
			RuleImpl rule = tk.next();
			
			//--------------逐个构建规则集合
			tableScript.append("<a name=\""+rule.getName()+"\" id=\""+rule.getName()+"\"></a>");
			tableScript.append("<table class=\"styletb\">");
			//-------------规则类型判断：P含有子规则  S自身为子规则 
			String ruleTitle = "";
			if(rule.hasReferencedRule()){		//存在前置规则
				ruleTitle = " <img src=\""+url+"/Common/Configurator/Authorization/ico/ref.png\" width=\"14\" height=\"14\" alt=\"前置规则:"+rule.getReferenceRule()+"\" />";
			}
			tableScript.append("  <tr>");
			tableScript.append("	<td colspan=\"2\" class=\"titd tdborder\" scope=\"col\">"+(iCounter++)+".规则说明：</td>");
			tableScript.append("    <td class=\"titd\" scope=\"col\" > 规则编号：").append(rule.getName()).append(ruleTitle).append("</td>");
			tableScript.append("    <td class=\"tdborder tdbtn\" style=\"padding:0\" scope=\"col\"><table style=\"margin:0 8px\"><tr><td style=\"padding:0;border:0\">" +
					"<img src=\""+url+"/Common/Configurator/Authorization/ico/del.png\" width=\"16\" height=\"16\" name=\"delete\"  onclick=\"javascript:mydelete('"+ruleScene.getRuleSceneId()+"@"+rule.getName()+"');\" alt=\"删除本笔规则\" style=\"cursor:hand\"/>"+					
					"&nbsp;&nbsp;" +
					"<img src=\""+url+"/Common/Configurator/Authorization/ico/detail.png\" width=\"16\" height=\"16\" name=\"detail\"  onclick=\"javascript:mydetail('"+ruleScene.getRuleSceneId()+"@"+rule.getName()+"');\" alt=\"查看规则详情\" style=\"cursor:hand\"/>"+
//					(new Button("","查看规则详情","javascript:mydetail('"+ruleScene.getRuleSceneId()+"@"+rule.getName()+"');","","btn_icon_edit","").getHtmlText())+					
//					"</td><td style=\"padding:0;border:0px\">&nbsp;</td><td style=\"padding:0;border:0px\">"+
//					(new Button("","删除本笔规则","javascript:mydelete('"+ruleScene.getRuleSceneId()+"@"+rule.getName()+"');","","btn_icon_delete","").getHtmlText())+
					"</td></tr></table>"
					//
					);
			tableScript.append("	</td>");
			tableScript.append("  </tr>");
			
			tableScript.append("  <tr>");
			tableScript.append("    <td colspan=\"2\" scope=\"col\" class=\"tdborder\">").append(rule.getDescription().length()==0?"&nbsp;":rule.getDescription().replaceAll(" ", "&nbsp;").replaceAll("\\\r\\\n", "<br />")).append("</td>");
			tableScript.append("    <td colspan=\"2\" rowspan=\"5\" valign=\"top\" scope=\"col\" class=\"tdborder\">");
			int effectiveAssm = 0;			//生效的维度规则
			List<Assumption> assumptions = rule.getAssumptions();
			Iterator<Assumption> ass = assumptions.iterator();
			while(ass.hasNext()){
				Assumption assumption = ass.next();
				Dimension dimension = assumption.belongDimension();
				if(dimension==null) continue;
				
				effectiveAssm++;
				//币种[在...中]：美元
				tableScript.append(effectiveAssm).append(".")
						.append(dimension.getName()).append(" [")
						.append(this.getCodeName("AssumptionOperator", assumption.getOperator(),sqlca))
						.append("]: ")
						.append(assumption.getTargetDescription(sqlca))
						.append(" <br />");
			}
			if(effectiveAssm==0) tableScript.append("<font color='blue'>无有效规则!</font>");
			tableScript.append("	</td>");
			tableScript.append("  </tr>");
			
			tableScript.append("  <tr>");
			tableScript.append("    <td width=\"15%\" class=\"titd tdborder\" scope=\"col\">规则类型：</td>");
			tableScript.append("    <td width=\"20%\" class=\"tdborder\">").append(rule.isReference()?"前置规则":"独立规则").append("</td>");
			tableScript.append("  </tr>");
			tableScript.append("  <tr>");
			tableScript.append("    <td width=\"15%\" class=\"titd tdborder\" scope=\"col\">规则优先级：</td>");
			tableScript.append("    <td width=\"20%\" class=\"tdborder\">").append(this.getCodeName("RulePriority", rule.getPriority(),sqlca)).append("</td>");
			tableScript.append("  </tr>");
			
			tableScript.append("  <tr>");
			tableScript.append("    <td class=\"titd tdborder\">满足后动作：</td>");
			//------------子规则不考虑动作流向,以父规则为准
			String actionDesc = this.getCodeName("RuleAction", rule.getActions(),sqlca);
			tableScript.append("    <td class=\"tdborder\">").append(actionDesc).append("</td>");
			tableScript.append("  </tr>");
			
			//------------父规则类不考虑动作流向,以子规则为准
			String decisionDesc = this.getCodeName("RuleDecision", rule.getDecision(),sqlca);
			tableScript.append("  <tr>");
			tableScript.append("    <td class=\"titd\">规则结果：</td>");
			tableScript.append("    <td class=\"tdborder\">").append(decisionDesc).append("</td>");
			tableScript.append("  </tr>");
			
			tableScript.append("</table>");
			
//			ARE.getLog().info("tableScript="+tableScript);
		}

	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.sui.AbstractSUIQuery#clearResource()
	 */
	
	public void clearResource() {
		

	}
	
	public String generateHTMLScript() throws IOException {
		return tableScript.toString();
	}


}
