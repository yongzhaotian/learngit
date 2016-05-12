/*
 * @(#)FlowTask.java
 *
 * Copyright 2001-2012 Amarsoft, Inc. All Rights Reserved.
 * 
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * 
 * Author:RCZhu
 */
 
package com.amarsoft.biz.workflow;

import java.sql.SQLException;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.proj.action.P2PCreditCommon;
	
/**�����������*/
public class FlowTask extends Object {
	public String SerialNo,RelativeSerialNo,ObjectType,ObjectNo,FlowNo,PhaseNo,PhaseType,ApplyType,UserID,OrgID,BeginTime,EndTime,PhaseAction;
	public String FlowName,UserName,OrgName,PhaseName,PhaseChoice,PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3,PhaseOpinion4,ForkState;
	public FlowPhase RelativeFlowPhase;//��ǰ�����������������̽׶�
	public FlowObject RelativeFlowObject;//��ǰ������������������ת����
	Transaction Sqlca ;
	
	public FlowTask(String sSerialNo, Transaction transSql) throws Exception {
		ASResultSet rsFlowTask ;
		this.SerialNo = sSerialNo;
		this.Sqlca = transSql;
		//��õ�ǰ��������ĸ�������
		rsFlowTask = Sqlca.getASResultSet("select FLOW_TASK.* from FLOW_TASK where SerialNo='"+sSerialNo+"'");
		if (rsFlowTask.next()){
			this.RelativeSerialNo = rsFlowTask.getString("RelativeSerialNo")==null?"":rsFlowTask.getString("RelativeSerialNo");
			this.ObjectType = rsFlowTask.getString("ObjectType")==null?"":rsFlowTask.getString("ObjectType");
			this.ObjectNo = rsFlowTask.getString("ObjectNo")==null?"":rsFlowTask.getString("ObjectNo");
			this.FlowNo = rsFlowTask.getString("FlowNo")==null?"":rsFlowTask.getString("FlowNo");
			this.FlowName = rsFlowTask.getString("FlowName")==null?"":rsFlowTask.getString("FlowName");
			this.PhaseNo = rsFlowTask.getString("PhaseNo")==null?"":rsFlowTask.getString("PhaseNo");
			this.PhaseName = rsFlowTask.getString("PhaseName")==null?"":rsFlowTask.getString("PhaseName");
			this.PhaseType = rsFlowTask.getString("PhaseType")==null?"":rsFlowTask.getString("PhaseType");
			this.ApplyType = rsFlowTask.getString("ApplyType")==null?"":rsFlowTask.getString("ApplyType");
			this.UserID = rsFlowTask.getString("UserID")==null?"":rsFlowTask.getString("UserID");
			this.UserName = rsFlowTask.getString("UserName")==null?"":rsFlowTask.getString("UserName");
			this.OrgID = rsFlowTask.getString("OrgID")==null?"":rsFlowTask.getString("OrgID");
			this.OrgName = rsFlowTask.getString("OrgName")==null?"":rsFlowTask.getString("OrgName");
			this.BeginTime = rsFlowTask.getString("BeginTime")==null?"":rsFlowTask.getString("BeginTime");
			this.EndTime = rsFlowTask.getString("EndTime")==null?"":rsFlowTask.getString("EndTime");
			this.PhaseChoice = rsFlowTask.getString("PhaseChoice")==null?"":rsFlowTask.getString("PhaseChoice");
			this.PhaseAction = rsFlowTask.getString("PhaseAction")==null?"":rsFlowTask.getString("PhaseAction");
			this.PhaseOpinion = rsFlowTask.getString("PhaseOpinion")==null?"":rsFlowTask.getString("PhaseOpinion");
			this.PhaseOpinion1 = rsFlowTask.getString("PhaseOpinion1")==null?"":rsFlowTask.getString("PhaseOpinion1");
			this.PhaseOpinion2 = rsFlowTask.getString("PhaseOpinion2")==null?"":rsFlowTask.getString("PhaseOpinion2");
			this.PhaseOpinion3 = rsFlowTask.getString("PhaseOpinion3")==null?"":rsFlowTask.getString("PhaseOpinion3");
			this.PhaseOpinion4 = rsFlowTask.getString("PhaseOpinion4")==null?"":rsFlowTask.getString("PhaseOpinion4");
			this.ForkState = rsFlowTask.getString("ForkState")==null?"":rsFlowTask.getString("ForkState");
		}else{
			rsFlowTask.getStatement().close();
			throw new FlowException("�������������׶���ˮ��:'"+sSerialNo+"' �����ڣ�");	
		}	
		rsFlowTask.getStatement().close();

		//ȡ�õ�ǰ���������Ӧ�׶ζ���
		this.RelativeFlowPhase = new FlowPhase(this.FlowNo,this.PhaseNo,this.Sqlca);

		//ȡ�õ�ǰ������������������ת����
		this.RelativeFlowObject = new FlowObject(this.ObjectType,this.ObjectNo,this.Sqlca);
	}
	
	/** ���ܣ��Ը�������ж����ύ��ͬʱ���ݴ����������Ը�����Ͷ�Ӧ��ת������б��  ��������������  ����ֵ���½׶ζ��� */	
	public FlowPhase commitAction(String sPhaseAction) throws Exception {
		FlowPhase fpNext;	
		String sEndTime = StringFunction.getTodayNow();
		
		//�����ǰ����Ľ׶�������������̶���ĵ�ǰ�׶β�ͬ������ɵ�ǰ���񣬷���������̶���Ľ׶�
		if(!this.RelativeFlowPhase.equals(this.RelativeFlowObject.RelativeFlowPhase)) {
			this.finish(sEndTime,sPhaseAction); //ִ���������
			fpNext = this.RelativeFlowObject.RelativeFlowPhase;
		}else{	
			//ȡ�ú����׶ζ���
			fpNext = getNextFlowPhase(sPhaseAction);
			
			//�����׶�Ϊ�պ�Ϊ"NULL"��־�������к�������
			//�����׶κ͵�ǰ�׶���ͬ��ִ�е�ǰ������ɲ�����������
			//���������ִ��������ɡ��ı����̶������̽׶β���
			if(fpNext!=null&&!fpNext.PhaseNo.equals("")){
				if(RelativeFlowPhase.equals(fpNext)){
					this.finish(sEndTime,sPhaseAction);
				}else{
					this.finish(sEndTime,sPhaseAction); //ִ���������
					RelativeFlowObject.changePhase(fpNext,this,"");//�ı����̶����������ڽ׶�
				}	
			}	
		}
		return fpNext;
	}	
	
	/**add by zszhang 2013/06/14 */
	/**
	 * ��ȡ�Ƿ��Ǿ߱��ۺ�����
	 * @throws Exception 
	 * */	
	public String getJoinCondition(FlowTask flowTask,FlowPhase curFlowPhase,FlowPhase nextFlowPhase) throws Exception{
		Integer mNum = 0;
		
		String sSql = "select count(*) from FLOW_MODEL where FlowNo=:FlowNo and PostScript=:PostScript";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("FlowNo", this.FlowNo);
		so.setParameter("PostScript", curFlowPhase.PostScript);
		ASResultSet rsFlowModel = Sqlca.getASResultSet(so);
		if(rsFlowModel.next()){
			mNum = rsFlowModel.getInt(1);
		}
		rsFlowModel.getStatement().close();
		
		
		Integer tNum = 0;
		sSql = "select count(*) from FLOW_TASK where ObjectNo='"+this.ObjectNo+"' and ObjectType='"+this.ObjectType+"'and PhaseNo='"+nextFlowPhase.PhaseNo+"' and (Endtime is null or EndTime='')";
		ASResultSet rsFlowTask = Sqlca.getASResultSet(sSql);
		if(rsFlowTask.next()){
			tNum = rsFlowTask.getInt(1);
		}
		rsFlowTask.getStatement().close();
		
		//��������һ��Ҫ�ύ�ķ�֧���򷵻�join�����򷵻�wait��
		if (mNum-1 == tNum) {
			return "JOIN";
		} else {
			return "WAIT";
		}
	}
	
	/**add by zszhang 2013/06/14 */
	/**
	 * ����Ƿ����˻�����
	 * @throws SQLException 
	 * @throws Exception 
	 * */
	public boolean haveBackTask() throws SQLException{
		Integer count = 0;
		String sSql = "select count(*) from FLOW_TASK where (EndTime='' or EndTime is null) " +
				"and ForkState=:ForkState and SerialNo <> :SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("ForkState", "BACK");
		so.setParameter("SerialNo", this.SerialNo);
		so.setParameter("ObjectNo", this.ObjectNo);
		so.setParameter("ObjectType", this.ObjectType);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			count = rs.getInt(1);
		}
		rs.getStatement().close();
		if(count>0){
			return true;
		}
		return false;
	}
	
	/**add by zywei 2005/12/15 */
	/** ���ܣ��Ը�������ж����ύ��ͬʱ���ݴ����������Ը�����Ͷ�Ӧ��ת������б��  ��������������,���  ����ֵ���½׶ζ��� 
	 * modefied by jbye 2009/02/20 �޸Ľ�������λ�÷��ڻ�ȡ��һ�׶�֮�� 
	 * modefied by zszhang 2013/07/03 ���Ӳ��б�ʶλ
	 * */	
	public FlowPhase[] commitAction(String sPhaseAction,String sPhaseOpinion1) throws Exception {	 	    
		String sEndTime = StringFunction.getTodayNow();
	    FlowPhase flowphase;
	    FlowPhase[] workFlowPhase = null;
	    
	    //��������Ե�ʣ�����ж�������������
//	    if(!RelativeFlowPhase.equals(RelativeFlowObject.RelativeFlowPhase)){
//	        finish(sEndTime, sPhaseAction, sPhaseOpinion1);
//	        flowphase = RelativeFlowObject.RelativeFlowPhase;
//	    }else{
	    
	    	workFlowPhase = getNextFlowPhase(sPhaseAction,sPhaseOpinion1);
	    	
	    	//�Բ������̵Ļ�۽ڵ�������
	    	if(workFlowPhase.length == 1){
	    		flowphase = workFlowPhase[0];
	    		//����ǻ�۽׶ν����۽׶δ���ģʽ
	    		if("JOIN".equalsIgnoreCase(flowphase.PhaseDescribe)){
					if(flowphase != null && !flowphase.PhaseNo.equals("")){
						if(RelativeFlowPhase.equals(flowphase)){
							finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
						}else{
							finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							String JoinFlag = getJoinCondition(this,this.RelativeFlowPhase,flowphase);
						 	RelativeFlowObject.changePhase(flowphase, this, JoinFlag);
						}
					}
	    		}else{
					if(flowphase != null && !flowphase.PhaseNo.equals("")){
						if(RelativeFlowPhase.equals(flowphase)){
							finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							//��������--�ҷý׶Σ���Ҫ��ǰ�׶��ύ����ǰ�׶�
							RelativeFlowObject.changePhase(flowphase, this,"");
						}else{
							finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							//��֧��״̬
							if("1".equals(this.ForkState) && !"".equals(sPhaseAction) && sPhaseAction!=null){
								boolean haveBackTask = haveBackTask();
								if(haveBackTask == true){
									throw new Exception("�����˻����񣬲������˻�");
								}else{
									RelativeFlowObject.changePhase(flowphase, this,"INFORK");
								}
							}else{
								//��֧���˻�״̬
								if("1".equals(this.ForkState) && ("".equals(sPhaseAction) || sPhaseAction==null)){
									boolean haveBackTask = haveBackTask();
									if(haveBackTask == true){
										throw new Exception("�����˻����񣬲������˻�");
									}else{
										RelativeFlowObject.changePhase(flowphase, this,"BACK");
									}
								}else{
									//�˻غ�ص���֧��״̬
									if("BACK".equals(this.ForkState)){
										RelativeFlowObject.changePhase(flowphase, this,"INFORK");
									}else{
										RelativeFlowObject.changePhase(flowphase, this,"");
										deleteSamePhaseTask(this.ObjectType,this.ObjectNo,this.FlowNo,this.PhaseNo,this.UserID,Sqlca);
									}
								}
							}
						}
					}
	    		}
	    	}else{
	    		//����Ƿ�֧�׶ν����֧�׶δ���ģʽ
	    		if("FORK".equalsIgnoreCase(RelativeFlowPhase.PhaseDescribe)){
					for(int i=0;i<workFlowPhase.length;i++)
				    {
						flowphase = (FlowPhase)workFlowPhase[i];
						if(flowphase != null && !flowphase.PhaseNo.equals("")){
							if(RelativeFlowPhase.equals(flowphase)){
								finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							}else{
								finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							 	RelativeFlowObject.changePhase(flowphase, this,	"FORK");
							}
						}
				    }
	    		}else{
					for(int i=0;i<workFlowPhase.length;i++)
				    {
						flowphase = (FlowPhase)workFlowPhase[i];
						if(flowphase != null && !flowphase.PhaseNo.equals("")){
							if(RelativeFlowPhase.equals(flowphase)){
								finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							}else{
								finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							 	RelativeFlowObject.changePhase(flowphase, this,"");
							}
						}
				    }
	    		}
	    	}
//	    }
	    return workFlowPhase;
	}

	/** ���ܣ���ø�������ָ�����������µ��½׶�,�����Ը�����Ͷ�Ӧ��ת������б��   ��������������  ����ֵ���½׶ζ��� */	
	public FlowPhase getNextFlowPhase(String sPhaseAction) throws Exception {
		String sNextFlowPhase,sNextFlowNo,sNextPhaseNo,sTips;
		FlowPhase fpNext = null;
		String sConstantList[][] = this.getConstantList();
		
		//���õ�ǰ������������	
		StringFunction.setAttribute(sConstantList,"#PhaseAction","'"+sPhaseAction+"'");

		//ִ�иý׶����̵�PostScript
		sNextFlowPhase = this.RelativeFlowPhase.executeScript("PostScript",sConstantList).toStringValue();
		
		if (sNextFlowPhase!=null && sNextFlowPhase.trim().length()>0){
			sNextFlowPhase = sNextFlowPhase.trim();
			
			//���������̺�,�׶κźͷ�����ʾ
			//���ַ�����ʽ����"FlowNo.PhaseNo Tips"				
			sTips = StringFunction.getSeparate(sNextFlowPhase," ",2);
			sNextFlowPhase = StringFunction.getSeparate(sNextFlowPhase," ",1);
			sNextFlowNo = StringFunction.getSeparate(sNextFlowPhase,".",1);
			sNextPhaseNo = StringFunction.getSeparate(sNextFlowPhase,".",2);
		
			if(sNextFlowNo.equalsIgnoreCase("Null")){ //�����ǰ���̺�Ϊ��Null��,���⴦��
				sNextPhaseNo = "Null";
				fpNext = new FlowPhase(sNextFlowNo,sNextPhaseNo,sTips);
			}else{
				if(sNextPhaseNo.equals("")){
					sNextPhaseNo = sNextFlowNo;
					sNextFlowNo = this.FlowNo;
				}
				fpNext = new FlowPhase(sNextFlowNo,sNextPhaseNo,sTips,Sqlca);
			}
		}
		return fpNext;
	}
	
	/**add by zywei 2005/12/12*/
	/** ���ܣ���ø�������ָ�����������µ��½׶�,�����Ը�����Ͷ�Ӧ��ת������б��   �������������������  ����ֵ���½׶ζ��� */
	public FlowPhase[] getNextFlowPhase(String sPhaseAction,String sPhaseOpinion1) throws Exception {
	    FlowPhase flowphase = null;
	    FlowPhase [] workFlowPhase = null;
	    String sConstantList[][] = getConstantList();
	    
	    //���õ�ǰ������������
	    StringFunction.setAttribute(sConstantList, "#PhaseAction", "'" + sPhaseAction + "'");
	    //���õ�ǰ�������
	    StringFunction.setAttribute(sConstantList, "#PhaseOpinion1", "'" + sPhaseOpinion1 + "'");
	    //ִ�иý׶����̵�PostScript
	    String sNextFlowPhase = RelativeFlowPhase.executeScript("PostScript", sConstantList).toStringValue();
	    
	    String[] NextFlowPhase = StringFunction.toStringArray(sNextFlowPhase,";");
	    workFlowPhase = new FlowPhase[NextFlowPhase.length];
	    
	    for(int i=0;i<NextFlowPhase.length;i++)
	    {	    	
	    	sNextFlowPhase = NextFlowPhase[i];
		    if(sNextFlowPhase != null && sNextFlowPhase.trim().length() > 0){
		    	sNextFlowPhase = sNextFlowPhase.trim();
		        String sTips = StringFunction.getSeparate(sNextFlowPhase, " ", 2);
		        sNextFlowPhase = StringFunction.getSeparate(sNextFlowPhase, " ", 1);
		        String sNextFlowNo = StringFunction.getSeparate(sNextFlowPhase, ".", 1);
		        String sNextPhaseNo = StringFunction.getSeparate(sNextFlowPhase, ".", 2);
		        if(sNextFlowNo.equalsIgnoreCase("Null")){ //�����ǰ���̺�Ϊ��Null��,���⴦��
		        	sNextPhaseNo = "Null";
		            flowphase = new FlowPhase(sNextFlowNo, sNextPhaseNo, sTips);
		        }else{
		            if(sNextPhaseNo.equals("")){
		            	sNextPhaseNo = sNextFlowNo;
		                sNextFlowNo = this.FlowNo;
		            }
		            flowphase = new FlowPhase(sNextFlowNo, sNextPhaseNo, sTips, Sqlca);
		            workFlowPhase[i] = flowphase;
		        }
		    }
	    }
	    return workFlowPhase;
    }
	
	/** ���ܣ���������Ľ���ʱ�䡢����  �������������ڡ������������ ����ֵ���� */	
	public void finish(String sEndTime, String sPhaseAction) throws Exception {
		this.EndTime = sEndTime;
		this.PhaseAction = sPhaseAction;
		Sqlca.executeSQL("update FLOW_TASK set EndTime='"+sEndTime+"',PhaseAction='"+sPhaseAction+"' where SerialNo='"+this.SerialNo+"'");
	}	
	
	/*add by zywei 2005/12/15*/
	/** ���ܣ���������Ľ���ʱ�䡢����  �������������ڡ��������������������� ����ֵ���� */	
	private void finish(String sEndTime, String sPhaseAction, String sPhaseOpinion1) throws Exception {
		this.EndTime = sEndTime;
		this.PhaseAction = sPhaseAction;
		this.PhaseOpinion1 = sPhaseOpinion1;	    
	    Sqlca.executeSQL("update FLOW_TASK set EndTime='" + sEndTime + "',PhaseAction='" + sPhaseAction + "',PhaseOpinion1='" +sPhaseOpinion1+ "'  where SerialNo='" + SerialNo + "'");
	}
	
	/** ���ܣ����������񣬲�������Ȩ�˻ظ����� ���������иò������û����� ����ֵ�� 0�˻���� -1�������ύ�����˻� -2�޸����� -3���ֵ�����  */	
	public ReturnMessage cancel(ASUser asuOperator) throws Exception {
		FlowTask ftParent;
		//�������и����������ֵ�����
		//������1.ɾ��������2.�������������ʱ��Ͷ���3.��������̶���׶���Ϊ������Ľ׶�
		//������ʾ�� 0�˻���� -1�������ύ�����˻� -2�޸����� -3���ֵ�����  
		
		if(this.EndTime!=null && !this.EndTime.trim().equals("")) return new ReturnMessage(-1,"���ύ���������˻�");	

		if(this.RelativeSerialNo==null || this.RelativeSerialNo.trim().equals("")){
			return new ReturnMessage(-2,"�޸��������˻�");	
		}else{
			ftParent = new FlowTask(this.RelativeSerialNo,Sqlca);
			if(ftParent.getChildTaskCount()>1){
				return new ReturnMessage(-3,"���׶λ��������а���,�����˻�");
			}else{
				//add by zszhang 20130701 ���ӶԾۺϽ׶ε��жϣ��ۺϽ׶β����˻�
				FlowTask ft = new FlowTask(this.SerialNo,Sqlca);
				String phaseDescribe = ft.RelativeFlowPhase.PhaseDescribe;
				if("join".equalsIgnoreCase(phaseDescribe)){
					//forkRollBack();
					return new ReturnMessage(-4,"���׶�Ϊ��֧�ۺϽ׶�,�����˻�");
				}else{
					boolean haveBackTask = haveBackTask();
					if(haveBackTask == true){
						return new ReturnMessage(-5,"�������������֧�����˻ز��������У���ȴ�������ȫ���˻أ�");
					}else{
						ftParent.finish("","",""); //�������������ʱ��Ͷ���
						this.RelativeFlowObject.updatePhase(ftParent.RelativeFlowPhase);//��������̶���׶���Ϊ������Ľ׶�
						FlowTask.deleteTask(this.SerialNo,Sqlca);//ɾ��������
					}
					//��ϵͳ��־�����¼�¼
					//asuOperator.addLog("���������˻�","��"+this.UserName+"��"+this.BeginTime+"�յ���"+this.PhaseName+"�����˻ص�"+ftParent.UserName+"�����"+ftParent.PhaseName+"�׶Σ���ˮ��Ϊ"+ftParent.SerialNo,Sqlca);
				}
			}
		}
		return new ReturnMessage(0,"�˻����");		
	}
	
	/** ���ܣ������ڷ�֧�ۺϽڵ�����������˻ص���֧�׶�  */
	private void forkRollBack() throws Exception {
		
		String sSql = "select SerialNo,RelativeSerialNo from FLOW_TASK where (EndTime=:EndTime or BeginTime=:BeginTime)"
				+ "and PhaseNo=:PhaseNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("EndTime", this.BeginTime);
		so.setParameter("BeginTime", this.BeginTime);
		so.setParameter("PhaseNo", this.PhaseNo);
		so.setParameter("ObjectNo", this.ObjectNo);
		so.setParameter("ObjectType", this.ObjectType);
		String [][] Array = Sqlca.getStringMatrix(so);
		int count = Array.length;
		
		//ɾ����ǰ�ۺϽ׶�����
		for (int i = 0; i < count; i++) {
			System.out.println(Array[i][0]);
			FlowTask.deleteTask(Array[i][0], Sqlca);
		}
		
		//������з�֧���׶ε���Ϣ
		for (int i = 0; i < count; i++) {
			System.out.println(Array[i][1]);
			FlowTask ft = new FlowTask(Array[i][1],Sqlca);
			ft.finish("", "", "");
			this.RelativeFlowObject.updatePhase(ft.RelativeFlowPhase);//��������̶���׶���Ϊ������Ľ׶�
		}
	}
	
	
	/** ���ܣ��ջر����񣬳���������������񣬻�ÿ���Ȩ ���������иò������û����� ����ֵ�� 0�˻���� 0 �ջ���� -1���������ύ����ǩ����� */	
	public ReturnMessage takeBack(ASUser asuOperator) throws Exception {
		int iCount = 0;
		//��������������������������ύ��δǩ�����
		//������1.ɾ������������ 2���������ʱ��Ͷ������ 3��������̶���׶���Ϊ������Ľ׶�
		//������ʾ��0 �ջ���� -1���������ύ����ǩ�����
		ASResultSet rsTemp = Sqlca.getASResultSet("select count(*) from FLOW_TASK where RelativeSerialNo = '"+this.SerialNo+"' "+
							" and ((EndTime is not null) or (PhaseChoice is not null) or (PhaseOpinion1 is not null) "+
							" or (PhaseOpinion2 is not null)  or (UserID ='system'))");
		if (rsTemp.next()) iCount = rsTemp.getInt(1);
		rsTemp.getStatement().close();
		
		if(iCount>0){
			return new ReturnMessage(-1,"�½׶��������ύ����ǩ������������ջ�");
		}else{
			iCount = this.getChildTaskCount();

			//��ϵͳ��־�����¼�¼
			//asuOperator.addLog("���������ջ�","��"+this.UserName+"��"+this.EndTime+"�ύ��"+this.PhaseName+"���������ջ�,ͬʱ����������"+iCount+"��",Sqlca);
			
			Sqlca.executeSQL("delete from FLOW_TASK where RelativeSerialNo = '"+this.SerialNo+"'");//ɾ������������
			this.finish("","");//���������ʱ��Ͷ������
			this.RelativeFlowObject.updatePhase(this.RelativeFlowPhase);//��������̶���׶���Ϊ������Ľ׶�
		}
		return new ReturnMessage(0,"�ջ����");
	}
	
	/** ���ܣ���ñ���������������� */	
	public int getChildTaskCount() throws Exception {
		int iCount = 0;
		ASResultSet rsTemp = Sqlca.getASResultSet("select count(*) from FLOW_TASK where RelativeSerialNo = '"+this.SerialNo+"'");
		if (rsTemp.next()) iCount = rsTemp.getInt(1);
		rsTemp.getStatement().close();
				
		return iCount;			
	}	

	/** ���ܣ���õ�ǰ�����Ӧ�׶ε������ʾ��ʹ�ñ���������ʹϵͳ�������ʾ��Ϊһ��Amarscript����  �������� ����ֵ��ִ�н��Ϊһ���ַ��� */
	public String getChoiceDescribe() throws Exception {
		return this.RelativeFlowPhase.executeScript("ChoiceDescribe",this.getConstantList()).toStringValue();
	}

	/** ���ܣ���õ�ǰ�����Ӧ�׶εĶ�����ʾ��ʹ�ñ���������ʹϵͳ�Ѷ�����ʾ��Ϊһ��Amarscript���� �������� ����ֵ��ִ�н��Ϊһ���ַ���*/
	public String getActionDescribe() throws Exception {
		return this.RelativeFlowPhase.executeScript("ActionDescribe",this.getConstantList()).toStringValue();
	}
	
	/** ���ܣ���õ�ǰ�����Ӧ�׶ο�ѡ�������б� �������� ����ֵ��ִ�н��Ϊһ���ַ������� */
	public String[] getChoiceList() throws Exception {
		String sReturn[];
		Any aChoiceList;
		try{
			aChoiceList = this.RelativeFlowPhase.executeScript("ChoiceScript",this.getConstantList());
		}catch(Exception ex){
			throw new FlowException(ex.toString()+" ȡ����б����");
		}
		if(aChoiceList==null) return null;
		else sReturn = aChoiceList.toStringArray();
		return sReturn;
	}
	
	/** ���ܣ���õ�ǰ�����Ӧ�׶ο�ѡ��Ķ����б� �������� ����ֵ��ִ�н��Ϊһ���ַ������� */
	public String[] getActionList() throws Exception {
		Any aActionList = null;
		String[] sActionList = null;
		aActionList = this.RelativeFlowPhase.executeScript("ActionScript",this.getConstantList());
		if(aActionList!=null) sActionList = aActionList.toStringArray();
		return sActionList;
	}
	
	/** ���ܣ���õ�ǰ�����Ӧ�׶ο�ѡ��Ķ����б� ��������� ����ֵ��ִ�н��Ϊһ���ַ�������*/
	public String[] getActionList(String sPhaseOpinion1) throws Exception {
	  	String sActionList[][] = getConstantList();
	    StringFunction.setAttribute(sActionList, "#PhaseOpinion1", "'" + sPhaseOpinion1 + "'");
	    return RelativeFlowPhase.executeScript("ActionScript", sActionList).toStringArray();
    }
	
	/** ���ܣ���õ�ǰ����Ĳ����� �������� ����ֵ��ִ�н��Ϊһ����ά�ַ������� */
	public String[][] getConstantList() throws Exception {
		FlowTask ftLast = null;
		String sConstantList[][] = {{"#SerialNo",this.SerialNo},
						   {"#ObjectType",this.ObjectType},
			    		   {"#ObjectNo",this.ObjectNo},
			    		   {"#FlowNo",this.FlowNo},
			    		   {"#FlowName",this.FlowName},
			     		   {"#PhaseNo",this.PhaseNo},
			     		   {"#PhaseName",this.PhaseName},
			     		   {"#PhaseType",this.PhaseType},
			     		   {"#ApplyType",this.ApplyType},
			     		   {"#PhaseChoice",this.PhaseChoice},
			     		   {"#PhaseAction",this.PhaseAction},
			     		   {"#PhaseOpinion1",this.PhaseOpinion1},
			     		   {"#BeginTime",this.BeginTime},
			     		   {"#EndTime",this.EndTime},
			     		   {"#UserID",this.UserID},
			     		   {"#UserName",this.UserName},
			     		   {"#OrgID",this.OrgID},
			     		   {"#OrgName",this.OrgName},
			      		   {"#LastFlowNo",""},
			      		   {"#LastFlowName",""},
			     		   {"#LastPhaseNo",""},
			     		   {"#LastPhaseName",""},
			     		   {"#LastPhaseType",""},
			     		   {"#LastApplyType",""},
			     		   {"#LastPhaseChoice",""},
			     		   {"#LastPhaseAction",""},			     		   
			     		   {"#LastBeginTime",""},			     		   			     		  
			     		   {"#LastEndTime",""},			     		   
			     		   {"#LastUserID",""},
			     		   {"#LastUserName",""},
			     		   {"#LastOrgID",""},
			     		   {"#LastOrgName",""}};
			     		   
		//�������������Դ������������չ����������ֵ
		if (this.RelativeSerialNo != null && !this.RelativeSerialNo.equals("")) {
			ftLast = new FlowTask(this.RelativeSerialNo,Sqlca);
			StringFunction.setAttribute(sConstantList,"#LastFlowNo",ftLast.FlowNo);
			StringFunction.setAttribute(sConstantList,"#LastFlowName",ftLast.FlowName);
			StringFunction.setAttribute(sConstantList,"#LastPhaseNo",ftLast.PhaseNo);
			StringFunction.setAttribute(sConstantList,"#LastPhaseName",ftLast.PhaseName);
			StringFunction.setAttribute(sConstantList,"#LastPhaseType",ftLast.PhaseType);
			StringFunction.setAttribute(sConstantList,"#LastApplyType",ftLast.ApplyType);
			StringFunction.setAttribute(sConstantList,"#LastPhaseChoice",ftLast.PhaseChoice);
			StringFunction.setAttribute(sConstantList,"#LastPhaseAction",ftLast.PhaseAction);
			StringFunction.setAttribute(sConstantList,"#LastBeginTime",ftLast.BeginTime);
			StringFunction.setAttribute(sConstantList,"#LastEndTime",ftLast.EndTime);
			StringFunction.setAttribute(sConstantList,"#LastUserID",ftLast.UserID);
			StringFunction.setAttribute(sConstantList,"#LastUserName",ftLast.UserName);
			StringFunction.setAttribute(sConstantList,"#LastOrgID",ftLast.OrgID);	
			StringFunction.setAttribute(sConstantList,"#LastOrgName",ftLast.OrgName);
		}
		
		return sConstantList;
	}	
	
	/**���ܣ�����ָ��������Ҫ�������ݱ������������� ����������Ļ���Ҫ�أ����������Զ����� ����ֵ����*/	
	//20130614 ���������޸�by zszhang ���Ӿۺϱ�ʶλ
	static public String newTask(String sRelativeSerialNo,String sObjectType,String sObjectNo,String sFlowNo,String sPhaseNo,String sApplyType,String sUserID,String sBeginTime,Transaction transSql,String fork) throws Exception
	{
		/*�˴���ASUserȡ����ص����ݿ��������� �޸�֮fmwu*/
		//ȡ��سа������������������źͻ�������
		String sUserName=transSql.getString("select UserName from USER_INFO where UserID = '"+sUserID+"'");
		String sOrgID=transSql.getString("select BelongOrg from USER_INFO where UserID = '"+sUserID+"'");
		String sOrgName=transSql.getString("select OrgName from ORG_INFO where OrgID = '"+sOrgID+"'");
		
		//ȡ����ؽ׶����ƺͽ׶�����
		FlowPhase fpTemp = new FlowPhase(sFlowNo,sPhaseNo,transSql);
		String sPhaseName = fpTemp.PhaseName;
		String sPhaseType = fpTemp.PhaseType;
		//ȡ�������������
		FlowCatalog fcTemp = new FlowCatalog(sFlowNo,transSql);
		String sFlowName = fcTemp.FlowName;
		
		if(sBeginTime == null) sBeginTime = StringFunction.getTodayNow();
		//����������ˮ��
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		String sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",transSql);*/
		String sSerialNo = DBKeyHelp.getWorkNo();
		/** --end --*/
		
		String sSql = "";
		if("".equals(fork)){	
			   sSql = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
				" PhaseNo,PhaseName,BeginTime,EndTime,UserID,UserName,OrgID,OrgName) " +
				" VALUES ( '"+sSerialNo+"','"+sRelativeSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"','"+sFlowName+"'," +
				" '"+sPhaseNo+"','"+sPhaseName+"','"+sBeginTime+"',null,'"+sUserID+"','"+sUserName+"','"+sOrgID+"','"+sOrgName+"')";	
		}else{
			if("WAIT".equals(fork)){
				   sSql = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,BeginTime,EndTime,UserID,UserName,OrgID,OrgName) " +
					" VALUES ( '"+sSerialNo+"','"+sRelativeSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"','"+sFlowName+"'," +
					" '"+sPhaseNo+"','"+sPhaseName+"','"+sBeginTime+"',null,'*"+sUserID+"','"+sUserName+"','"+sOrgID+"','"+sOrgName+"')";
			}else{
				if("FORK".equals(fork)||"INFORK".equals(fork)){
					   sSql = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
						" PhaseNo,PhaseName,BeginTime,EndTime,UserID,UserName,OrgID,OrgName,forkState) " +
						" VALUES ( '"+sSerialNo+"','"+sRelativeSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"','"+sFlowName+"'," +
						" '"+sPhaseNo+"','"+sPhaseName+"','"+sBeginTime+"',null,'"+sUserID+"','"+sUserName+"','"+sOrgID+"','"+sOrgName+"','1')";	
				}else{
					if("JOIN".equals(fork)){
					   sSql = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
						" PhaseNo,PhaseName,BeginTime,EndTime,UserID,UserName,OrgID,OrgName) " +
						" VALUES ( '"+sSerialNo+"','"+sRelativeSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"','"+sFlowName+"'," +
						" '"+sPhaseNo+"','"+sPhaseName+"','"+sBeginTime+"',null,'"+sUserID+"','"+sUserName+"','"+sOrgID+"','"+sOrgName+"')";
						//��֧��۽׶θ������з�֧��EndTime
					   endForkTask(sBeginTime, sObjectNo, sObjectType, transSql);
					}else{
						if("BACK".equals(fork)){
							 sSql = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
								" PhaseNo,PhaseName,BeginTime,EndTime,UserID,UserName,OrgID,OrgName,forkState) " +
								" VALUES ( '"+sSerialNo+"','"+sRelativeSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"','"+sFlowName+"'," +
								" '"+sPhaseNo+"','"+sPhaseName+"','"+sBeginTime+"',null,'"+sUserID+"','"+sUserName+"','"+sOrgID+"','"+sOrgName+"','BACK')";
						}else{
							throw new FlowException("�ύ���̳������߱��κ����ó���");
						}
					}
				}
			}
		}
		transSql.executeSQL(sSql);
		
		//�ѷ������ȡ�������ж��Ƿ񷵻�p2p��� add by dahl ccs-760
		if( ("8000").equals(sPhaseNo) || ("9000").equals(sPhaseNo) ){	
			P2PCreditCommon p2p = new P2PCreditCommon(sObjectNo, transSql);
			p2p.checkReturnP2pSum();
		}
		
		return sSerialNo;
	}	

	/**���ܣ�����ָ���������������ݱ���ɾ������ ����ֵ����*/	
	static public void deleteTask(String sSerialNo,Transaction transSql) throws Exception {
		transSql.executeSQL("delete from  FLOW_TASK where SerialNo= '"+sSerialNo+"'");
	}	
	
	/**���ܣ�����֧���з�֧�ս�ʱ�ս�������֧���� ����ֵ����*/	
	public static void endForkTask(String sEndTime,String sObjectNo,String sObjectType,Transaction transSql) throws Exception {
		transSql.executeSQL("update  FLOW_TASK set EndTime = '"+sEndTime+"' where ObjectNo ='"+sObjectNo+"' and ObjectType = '"+sObjectType+"' and (EndTime is null or EndTime = '')");
	}	
	
	/**���ܣ�ɾ��ͬ�����ֵ����� ����ֵ����*/	
	static public void deleteSamePhaseTask(String sObjectType,String sObjectNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction transSql) throws Exception
	{
		String sSql="delete from  FLOW_TASK where ObjectType = '"+sObjectType+"' and ObjectNo= '"+sObjectNo+"' and FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' and UserID <> '"+sUserID+"' and (EndTime is null or EndTime = '') ";						  
		transSql.executeSQL(sSql);
	}
}	