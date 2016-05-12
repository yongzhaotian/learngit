package com.amarsoft.app.als.flow.cfg.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitFlowModel extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		String sModelNo = (String)this.getAttribute("ModelNo");
		if(sModelNo==null) sModelNo="";
		String sSql="INSERT INTO FLOW_MODEL (FLOWNO,PHASENO,PHASETYPE,PHASENAME,PHASEDESCRIBE,PHASEATTRIBUTE,PRESCRIPT,INITSCRIPT,CHOICEDESCRIBE,CHOICESCRIPT,ACTIONDESCRIBE,ACTIONSCRIPT,POSTSCRIPT,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,AAENABLED,AAPOINTINITSCRIPT,AAPOINTCOMP,AAPOINTCOMPURL,STANDARDTIME1,STANDARDTIME2,COSTLOB,STRIPS,CHECKLIST,DECISIONSCRIPT,RISKSCANRULE,BUTTONSET2,INPUTUSER,INPUTTIME,UPDATEUSER,UPDATETIME,DISTRIBUTERULE,ID,TYPE,NAME,XCOORDINATE,YCOORDINATE,WIDTH,HEIGHT) VALUES ";
		
		
		String sValue1=" (:FLOWNO,'0010','1010','�ͻ�����������','','','','{#UserID}','��ѡ����','{\"�ύ\"}','���ύ�϶�','!��������.��ǰ������ɫ��Ա�б�(#OrgID,#UserID,480)','''0020''','viewTab,viewReport,viewOpinions,signOpinion,riskSkan,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','01','1','',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:42','',null,null,null,null,null,null,null) ";
		String sValue2=" (:FLOWNO,'0020','1020','Э��ͻ��������','','','','toStringArray(''#PhaseAction'',\",\",\" \",1)','��ѡ����','{\"�ύ\"}','���ύ','!��������.���л�����ɫ��Ա�б�(480)','','viewReport,viewOpinions,signOpinion,riskSkan,viewTab,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','10','1','','','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:42','',null,null,null,null,null,null,null) ";
		String sValue3=" (:FLOWNO,'1000','1040','ͨ��','','','','{\"system\"}','','','','','','viewTab,viewOpinions,signOpinion,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','01','1','',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:45','',null,null,null,null,null,null,null) ";
		String sValue4=" (:FLOWNO,'8000','1050','���','','','','{\"system\"}','','','','','','viewTab,viewReport,viewOpinions,signCheckOpinion,riskSkan,doSubmit,backStep','AppDetail,viewOpinions','all_except',' ',null,' ','01','1','',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2011/01/27 15:22:45','',null,null,null,null,null,null,null) ";
		String sValue5=" (:FLOWNO,'3000','1030','�˻ز�������','','','','!��������.���̽׶γа��˶�λ(#ObjectType,#ObjectNo,#FlowNo,0010)','���������','{\"������ȫ\"}','��ѡ���ύ����','!��������.������(#ObjectNo,#SerialNo)','!��������.���ؽ׶�(#ObjectNo,#SerialNo)','viewTab,viewReport,viewOpinions,riskSkan,doSubmit,backStep','viewTab,viewReport,viewOpinions,riskSkan','all_except',' ',null,' ','01','1',' ',' ','','',null,'',0,0,'','','','',null,'',null,null,'system','2009/02/25 15:25:02','',null,null,null,null,null,null,null)";
	    
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
		if(sFlowType.equals("CreditLineApply")){//�ۺ�����
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
			Sqlca.executeSQL(sosql);//ȡ����ȼ���ı�־	
		}else if(sFlowType.equals("ContractApply")){//��ͬ
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealContractApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
			
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,riskSkan,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
		}else if(sFlowType.equals("DependentApply")||sFlowType.equals("BusinessExtend")){//��������ҵ��չ��ҵ��
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
			Sqlca.executeSQL(sosql);//ȡ����ȼ���ı�־	
			
			sSql1="update FLOW_MODEL set PRESCRIPT='WorkFlowEngine.DealCreditRefuseApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1050'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);	
		} else if (sFlowType.equals("CreditCogApply")) {//���õȼ�
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.FinishEvaluate(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='viewDetail,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewDetail,viewOpinions'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="delete from FLOW_MODEL where FlowNo =:FlowNo and PhaseNo='8000' ";//��������Ҫ���
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		} else if (sFlowType.equals("PutOutApply")) {//�Ŵ�,����
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealPutOutApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("RiskApply")) {//����Ԥ���źŷ���			
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
		}else if (sFlowType.equals("RiskRelieve")) {//����Ԥ���źŽ������
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
		}else if (sFlowType.equals("GroupApply")) {// ���ſͻ��϶�
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealGroupApplyAction(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set Attribute1='backStep,viewTab,doSubmit',Attribute2='viewTab'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("TransformApply")) {// ������ͬ�������  
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealTransformAction(#ObjectType,#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("GuarantyChange")) {// ����Ѻ��ֵ�������
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,signOpinion,viewTab,doSubmit',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdateGuarantyChangeApply(#ObjectNo,1000)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("PropertyAccept")) {//��ծ�ʲ�����
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdatePDAPhase(#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("PropertyProcess")) {// ��ծ�ʲ�����
			sSql1="update FLOW_MODEL set Attribute1='viewTab,viewOpinions,signOpinion,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdatePDAEnd(#ObjectNo,#EndTime)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("CustomerConfirm")) {// �ͻ�����
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
		}else if (sFlowType.equals("BlackSheetApply")) {// �������϶�
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
		}else if (sFlowType.equals("InterestRateApply")) {// ���ʵ���
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,viewTab,viewDueBill,viewContract,signOpinion,doSubmit,backStep',Attribute2='viewOpinions,viewTab,viewDueBill,viewContract'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("DunCAVApply")) {// �����ʲ�����
			sSql1="update FLOW_MODEL set Attribute1='viewReport,viewOpinions,signOpinion,riskSkan,viewTab,doSubmit,backStep',Attribute2='viewTab,viewReport,viewOpinions,riskSkan,viewFlowGraph'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("LawCaseApply")) {// ���Ϲ���
			sSql1="update FLOW_MODEL set Attribute1='viewOpinions,signOpinion,viewTab,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
			
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.UpdateLawPhase(#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("BadAccountAffirm")) {// ���ʹ���
			sSql1="update FLOW_MODEL set Attribute1='viewReport,viewOpinions,signOpinion,viewTab,doSubmit,backStep',Attribute2='viewTab,viewOpinions'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("ClassifyApply")) {// ���շ���
			sSql1="update FLOW_MODEL set Attribute1='viewTab,WorkSheet,viewDetail,viewOpinions,ViewConfirmTable,signOpinion,doSubmit,backStep,doApproveAll,SubmitToNext',Attribute2='ViewTab,WorkSheet,ViewConfirmTable,viewDetail,viewOpinions,ViewReport'  where FlowNo =:FlowNo  ";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		
			sSql1="update FLOW_MODEL set PRESCRIPT='!WorkFlowEngine.DealClassifyResult(#ObjectType,#ObjectNo)' where FlowNo =:FlowNo  and PhaseNo='1000'";
			sosql = new SqlObject(sSql1);
			sosql.setParameter("FlowNo", sModelNo);
			Sqlca.executeSQL(sosql);
		}else if (sFlowType.equals("CreditFreezeApply")) {// ��ȶ���
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
