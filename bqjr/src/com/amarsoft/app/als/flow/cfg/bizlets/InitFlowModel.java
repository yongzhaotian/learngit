package com.amarsoft.app.als.flow.cfg.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitFlowModel extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		String sModelNo = (String)this.getAttribute("ModelNo");
		if(sModelNo==null) sModelNo="";
		String sSql="INSERT INTO FLOW_MODEL (FLOWNO,PHASENO,PHASETYPE,PHASENAME,PHASEDESCRIBE,PHASEATTRIBUTE,PRESCRIPT,INITSCRIPT,CHOICEDESCRIBE,CHOICESCRIPT,ACTIONDESCRIBE,ACTIONSCRIPT,POSTSCRIPT,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,AAENABLED,AAPOINTINITSCRIPT,AAPOINTCOMP,AAPOINTCOMPURL,STANDARDTIME1,STANDARDTIME2,COSTLOB,STRIPS,CHECKLIST,DECISIONSCRIPT,RISKSCANRULE,BUTTONSET2,INPUTUSER,INPUTTIME,UPDATEUSER,UPDATETIME,DISTRIBUTERULE,ID,TYPE,NAME,XCOORDINATE,YCOORDINATE,WIDTH,HEIGHT) VALUES ";
		
		
		String sValue1=" (:FLOWNO,'0010','1010','客户经理发起申请','','','','{#UserID}','请选择动作','{\"提交\"}','请提交认定','!审批流程.当前机构角色人员列表(#OrgID,#UserID,480)','''0020''','viewTab,viewReport,viewOpinions,signOpinion,riskSkan,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','01','1','',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:42','',null,null,null,null,null,null,null) ";
		String sValue2=" (:FLOWNO,'0020','1020','协办客户经理审核','','','','toStringArray(''#PhaseAction'',\",\",\" \",1)','请选择动作','{\"提交\"}','请提交','!审批流程.所有机构角色人员列表(480)','','viewReport,viewOpinions,signOpinion,riskSkan,viewTab,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','10','1','','','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:42','',null,null,null,null,null,null,null) ";
		String sValue3=" (:FLOWNO,'1000','1040','通过','','','','{\"system\"}','','','','','','viewTab,viewOpinions,signOpinion,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','01','1','',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:45','',null,null,null,null,null,null,null) ";
		String sValue4=" (:FLOWNO,'8000','1050','否决','','','','{\"system\"}','','','','','','viewTab,viewReport,viewOpinions,signCheckOpinion,riskSkan,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','01','1','',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:45','',null,null,null,null,null,null,null) ";
		String sValue5=" (:FLOWNO,'3000','1030','退回补充资料','','','','!审批流程.流程阶段承办人定位(#ObjectType,#ObjectNo,#FlowNo,0010)','请输入意见','{\"补充完全\"}','请选择提交动作','!审批流程.发回人(#ObjectNo,#SerialNo)','!审批流程.发回阶段(#ObjectNo,#SerialNo)','viewTab,viewReport,viewOpinions,riskSkan,doSubmit,backStep','viewTab,viewReport,viewOpinions,riskSkan','all_except',' ',null,' ','01','1',' ',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2009/02/25 15:25:02','',null,null,null,null,null,null,null)";
	    
		SqlObject so1 = new SqlObject(sSql+sValue1);
		SqlObject so2 = new SqlObject(sSql+sValue2);
		SqlObject so3 = new SqlObject(sSql+sValue3);
		SqlObject so4 = new SqlObject(sSql+sValue4);
		SqlObject so5 = new SqlObject(sSql+sValue5);
		
		so1.setParameter("FLOWNO", sModelNo);
		so2.setParameter("FLOWNO", sModelNo);
		so3.setParameter("FLOWNO", sModelNo);
		so4.setParameter("FLOWNO", sModelNo);
		so5.setParameter("FLOWNO", sModelNo);
		
		Sqlca.executeSQL(so1);
		Sqlca.executeSQL(so2);
		Sqlca.executeSQL(so3);
		Sqlca.executeSQL(so4);
		Sqlca.executeSQL(so5);
		
		String sSql1="select FlowType from FLOW_CATALOG where FlowNo =:FlowNo";
		SqlObject sso = new SqlObject(sSql1);
		sso.setParameter("FlowNo", sModelNo);
		String sFlowType=Sqlca.getString(sso);
		
		SqlObject sosql;
		
		if(sFlowType==null) sFlowType="";
		if(sFlowType.equals("CreditLineApply")){//综合授信
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealCompleteApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,viewReport,riskSkan,doSubmit,backStep',Attribute2='viewTab,viewOpinions,viewReport'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealCreditRefuseApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='8000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!BusinessManage.UpdateBAStatus(#ObjectNo,1030)' where FlowNo =:FlowNo and PhaseNo='1030'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);//取消额度计算的标志	
		}else if(sFlowType.equals("ContractApply")){//合同
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealContractApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,riskSkan,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
		}else if(sFlowType.equals("DependentApply")||sFlowType.equals("BusinessExtend")){//授信项下业务，展期业务
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealCompleteApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,viewReport,riskSkan,doSubmit,backStep',Attribute2='viewTab,viewOpinions,viewReport'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!BusinessManage.UpdateBAStatus(#ObjectNo,1030)' where FlowNo =:FlowNo and PhaseNo='1030'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);//取消额度计算的标志	
			
			sSql1="update FLOW_MODEL set PRESCRIPT='WorkFlowEngine.DealCreditRefuseApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1050'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
		} else if (sFlowType.equals("CreditCogApply")) {//信用等级
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.FinishEvaluate(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='viewDetail,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewDetail,viewOpinions'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="delete from FLOW_MODEL where FlowNo =:FlowNo and PhaseNo='8000' ";//评级不需要否决
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		} else if (sFlowType.equals("PutOutApply")) {//放贷,出账
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealPutOutApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("RiskApply")) {//风险预警信号发起			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealRiskApplyAction(#ObjectType,#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealRiskApplyAction(#ObjectType,#ObjectNo,8000)' where FlowNo =:FlowNo and PhaseNo='8000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='signOpinion,viewOpinions,viewTab,viewFile,doSubmit',Attribute2='viewTab,viewFile'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("RiskRelieve")) {//风险预警信号解除发起
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealRiskApplyAction(#ObjectType,#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealRiskApplyAction(#ObjectType,#ObjectNo,8000)' where FlowNo =:FlowNo  and PhaseNo='8000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='signOpinion,viewOpinions,viewDetail,viewFile,doSubmit',Attribute2='viewDetail,viewFile'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("GroupApply")) {// 集团客户认定
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealGroupApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='backStep,viewTab,doSubmit',Attribute2='viewTab'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("TransformApply")) {// 担保合同变更申请  
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealTransformAction(#ObjectType,#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("GuarantyChange")) {// 抵质押价值变更申请
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,signOpinion,viewTab,doSubmit',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdateGuarantyChangeApply(#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("PropertyAccept")) {//抵债资产接收
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdatePDAPhase(#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("PropertyProcess")) {// 抵债资产处置
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdatePDAEnd(#ObjectNo,#EndTime)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("CustomerConfirm")) {// 客户分类
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,signOpinion,doSubmit,viewTab',Attribute2='viewOpinions,viewTab'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealCustomerConfirm(#ObjectType,#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealCustomerConfirm(#ObjectType,#ObjectNo,8000)' where FlowNo =:FlowNo  and PhaseNo='8000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("BlackSheetApply")) {// 黑名单认定
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,signOpinion,viewTab,doSubmit,backStep',Attribute2='viewOpinions,viewTab'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealBlackCustomer(#ObjectType,#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealBlackCustomer(#ObjectType,#ObjectNo,8000)' where FlowNo =:FlowNo  and PhaseNo='8000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("InterestRateApply")) {// 利率调整
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,viewTab,viewDueBill,viewContract,signOpinion,doSubmit,backStep',Attribute2='viewOpinions,viewTab,viewDueBill,viewContract'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("DunCAVApply")) {// 不良资产核销
			sSql1="update FLOW_MODEL set Attribute1='viewReport,viewOpinions,signOpinion,riskSkan,viewTab,doSubmit,backStep',Attribute2='viewTab,viewReport,viewOpinions,riskSkan,viewFlowGraph'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("LawCaseApply")) {// 诉讼管理
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,signOpinion,viewTab,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdateLawPhase(#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("BadAccountAffirm")) {// 呆滞呆账
			sSql1="update FLOW_MODEL set Attribute1='viewReport,viewOpinions,signOpinion,viewTab,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("ClassifyApply")) {// 风险分类
			sSql1="update FLOW_MODEL set Attribute1='viewTab,WorkSheet,viewDetail,viewOpinions,ViewConfirmTable,signOpinion,doSubmit,backStep,doApproveAll,SubmitToNext',Attribute2='ViewTab,WorkSheet,ViewConfirmTable,viewDetail,viewOpinions,ViewReport'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealClassifyResult(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("CreditFreezeApply")) {// 额度冻结
			sSql1="update FLOW_MODEL set Attribute1='doSubmit,FreezeHistory,signOpinion,viewOpinions,viewContract,viewTab,FreezeIn',Attribute2='FreezeHistory,viewOpinions,viewContract,viewTab,FreezeIn'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdateCreditFreezeFlag(#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}
		return "true";
	}

}
