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
	
/**流程任务对象*/
public class FlowTask extends Object {
	public String SerialNo,RelativeSerialNo,ObjectType,ObjectNo,FlowNo,PhaseNo,PhaseType,ApplyType,UserID,OrgID,BeginTime,EndTime,PhaseAction;
	public String FlowName,UserName,OrgName,PhaseName,PhaseChoice,PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3,PhaseOpinion4,ForkState;
	public FlowPhase RelativeFlowPhase;//当前流程任务所处的流程阶段
	public FlowObject RelativeFlowObject;//当前流程任务所关联的流转对象
	Transaction Sqlca ;
	
	public FlowTask(String sSerialNo, Transaction transSql) throws Exception {
		ASResultSet rsFlowTask ;
		this.SerialNo = sSerialNo;
		this.Sqlca = transSql;
		//获得当前流程任务的各项属性
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
			throw new FlowException("流程任务所处阶段流水号:'"+sSerialNo+"' 不存在！");	
		}	
		rsFlowTask.getStatement().close();

		//取得当前流程任务对应阶段对象
		this.RelativeFlowPhase = new FlowPhase(this.FlowNo,this.PhaseNo,this.Sqlca);

		//取得当前流程任务所关联的流转对象
		this.RelativeFlowObject = new FlowObject(this.ObjectType,this.ObjectNo,this.Sqlca);
	}
	
	/** 功能：对该任务进行动作提交，同时根据触发后的情况对该任务和对应流转对象进行变更  参数：触发动作  返回值：下阶段对象 */	
	public FlowPhase commitAction(String sPhaseAction) throws Exception {
		FlowPhase fpNext;	
		String sEndTime = StringFunction.getTodayNow();
		
		//如果当前任务的阶段与任务相关流程对象的当前阶段不同，则完成当前任务，返回相关流程对象的阶段
		if(!this.RelativeFlowPhase.equals(this.RelativeFlowObject.RelativeFlowPhase)) {
			this.finish(sEndTime,sPhaseAction); //执行任务完成
			fpNext = this.RelativeFlowObject.RelativeFlowPhase;
		}else{	
			//取得后续阶段对象
			fpNext = getNextFlowPhase(sPhaseAction);
			
			//后续阶段为空和为"NULL"标志：不进行后续处理
			//后续阶段和当前阶段相同：执行当前任务完成操作，并返回
			//其他情况：执行任务完成、改变流程对象流程阶段操作
			if(fpNext!=null&&!fpNext.PhaseNo.equals("")){
				if(RelativeFlowPhase.equals(fpNext)){
					this.finish(sEndTime,sPhaseAction);
				}else{
					this.finish(sEndTime,sPhaseAction); //执行任务完成
					RelativeFlowObject.changePhase(fpNext,this,"");//改变流程对象流程所在阶段
				}	
			}	
		}
		return fpNext;
	}	
	
	/**add by zszhang 2013/06/14 */
	/**
	 * 获取是否是具备聚合条件
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
		
		//如果是最后一条要提交的分支，则返回join，否则返回wait。
		if (mNum-1 == tNum) {
			return "JOIN";
		} else {
			return "WAIT";
		}
	}
	
	/**add by zszhang 2013/06/14 */
	/**
	 * 检查是否有退回任务
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
	/** 功能：对该任务进行动作提交，同时根据触发后的情况对该任务和对应流转对象进行变更  参数：触发动作,意见  返回值：下阶段对象 
	 * modefied by jbye 2009/02/20 修改结束流程位置放在获取下一阶段之后 
	 * modefied by zszhang 2013/07/03 增加并行标识位
	 * */	
	public FlowPhase[] commitAction(String sPhaseAction,String sPhaseOpinion1) throws Exception {	 	    
		String sEndTime = StringFunction.getTodayNow();
	    FlowPhase flowphase;
	    FlowPhase[] workFlowPhase = null;
	    
	    //并行流程缘故，这个判断条件不再适用
//	    if(!RelativeFlowPhase.equals(RelativeFlowObject.RelativeFlowPhase)){
//	        finish(sEndTime, sPhaseAction, sPhaseOpinion1);
//	        flowphase = RelativeFlowObject.RelativeFlowPhase;
//	    }else{
	    
	    	workFlowPhase = getNextFlowPhase(sPhaseAction,sPhaseOpinion1);
	    	
	    	//对并行流程的汇聚节点做处理
	    	if(workFlowPhase.length == 1){
	    		flowphase = workFlowPhase[0];
	    		//如果是汇聚阶段进入汇聚阶段处理模式
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
							//车贷流程--家访阶段，需要当前阶段提交到当前阶段
							RelativeFlowObject.changePhase(flowphase, this,"");
						}else{
							finish(sEndTime, sPhaseAction ,sPhaseOpinion1);
							//分支中状态
							if("1".equals(this.ForkState) && !"".equals(sPhaseAction) && sPhaseAction!=null){
								boolean haveBackTask = haveBackTask();
								if(haveBackTask == true){
									throw new Exception("已有退回任务，不允许退回");
								}else{
									RelativeFlowObject.changePhase(flowphase, this,"INFORK");
								}
							}else{
								//分支中退回状态
								if("1".equals(this.ForkState) && ("".equals(sPhaseAction) || sPhaseAction==null)){
									boolean haveBackTask = haveBackTask();
									if(haveBackTask == true){
										throw new Exception("已有退回任务，不允许退回");
									}else{
										RelativeFlowObject.changePhase(flowphase, this,"BACK");
									}
								}else{
									//退回后回到分支中状态
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
	    		//如果是分支阶段进入分支阶段处理模式
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

	/** 功能：获得该任务在指定动作触发下的下阶段,但不对该任务和对应流转对象进行变更   参数：触发动作  返回值：下阶段对象 */	
	public FlowPhase getNextFlowPhase(String sPhaseAction) throws Exception {
		String sNextFlowPhase,sNextFlowNo,sNextPhaseNo,sTips;
		FlowPhase fpNext = null;
		String sConstantList[][] = this.getConstantList();
		
		//设置当前触发动作参数	
		StringFunction.setAttribute(sConstantList,"#PhaseAction","'"+sPhaseAction+"'");

		//执行该阶段流程的PostScript
		sNextFlowPhase = this.RelativeFlowPhase.executeScript("PostScript",sConstantList).toStringValue();
		
		if (sNextFlowPhase!=null && sNextFlowPhase.trim().length()>0){
			sNextFlowPhase = sNextFlowPhase.trim();
			
			//解析出流程号,阶段号和返回提示
			//其字符串格式型如"FlowNo.PhaseNo Tips"				
			sTips = StringFunction.getSeparate(sNextFlowPhase," ",2);
			sNextFlowPhase = StringFunction.getSeparate(sNextFlowPhase," ",1);
			sNextFlowNo = StringFunction.getSeparate(sNextFlowPhase,".",1);
			sNextPhaseNo = StringFunction.getSeparate(sNextFlowPhase,".",2);
		
			if(sNextFlowNo.equalsIgnoreCase("Null")){ //如果当前流程号为“Null”,特殊处理
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
	/** 功能：获得该任务在指定动作触发下的下阶段,但不对该任务和对应流转对象进行变更   参数：触发动作、意见  返回值：下阶段对象 */
	public FlowPhase[] getNextFlowPhase(String sPhaseAction,String sPhaseOpinion1) throws Exception {
	    FlowPhase flowphase = null;
	    FlowPhase [] workFlowPhase = null;
	    String sConstantList[][] = getConstantList();
	    
	    //设置当前触发动作参数
	    StringFunction.setAttribute(sConstantList, "#PhaseAction", "'" + sPhaseAction + "'");
	    //设置当前意见参数
	    StringFunction.setAttribute(sConstantList, "#PhaseOpinion1", "'" + sPhaseOpinion1 + "'");
	    //执行该阶段流程的PostScript
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
		        if(sNextFlowNo.equalsIgnoreCase("Null")){ //如果当前流程号为“Null”,特殊处理
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
	
	/** 功能：设置任务的结束时间、动作  参数：结束日期、任务结束动作 返回值：无 */	
	public void finish(String sEndTime, String sPhaseAction) throws Exception {
		this.EndTime = sEndTime;
		this.PhaseAction = sPhaseAction;
		Sqlca.executeSQL("update FLOW_TASK set EndTime='"+sEndTime+"',PhaseAction='"+sPhaseAction+"' where SerialNo='"+this.SerialNo+"'");
	}	
	
	/*add by zywei 2005/12/15*/
	/** 功能：设置任务的结束时间、动作  参数：结束日期、任务结束动作、任务意见 返回值：无 */	
	private void finish(String sEndTime, String sPhaseAction, String sPhaseOpinion1) throws Exception {
		this.EndTime = sEndTime;
		this.PhaseAction = sPhaseAction;
		this.PhaseOpinion1 = sPhaseOpinion1;	    
	    Sqlca.executeSQL("update FLOW_TASK set EndTime='" + sEndTime + "',PhaseAction='" + sPhaseAction + "',PhaseOpinion1='" +sPhaseOpinion1+ "'  where SerialNo='" + SerialNo + "'");
	}
	
	/** 功能：撤销本任务，并将控制权退回父任务 参数：进行该操作的用户对象 返回值： 0退回完成 -1任务已提交不能退回 -2无父任务 -3有兄弟任务  */	
	public ReturnMessage cancel(ASUser asuOperator) throws Exception {
		FlowTask ftParent;
		//条件：有父任务且无兄弟任务
		//操作：1.删除本任务2.清除父任务的完成时间和动作3.将相关流程对象阶段设为父任务的阶段
		//错误提示： 0退回完成 -1任务已提交不能退回 -2无父任务 -3有兄弟任务  
		
		if(this.EndTime!=null && !this.EndTime.trim().equals("")) return new ReturnMessage(-1,"已提交的任务不能退回");	

		if(this.RelativeSerialNo==null || this.RelativeSerialNo.trim().equals("")){
			return new ReturnMessage(-2,"无父任务不能退回");	
		}else{
			ftParent = new FlowTask(this.RelativeSerialNo,Sqlca);
			if(ftParent.getChildTaskCount()>1){
				return new ReturnMessage(-3,"本阶段还有其他承办人,不能退回");
			}else{
				//add by zszhang 20130701 增加对聚合阶段的判断，聚合阶段不能退回
				FlowTask ft = new FlowTask(this.SerialNo,Sqlca);
				String phaseDescribe = ft.RelativeFlowPhase.PhaseDescribe;
				if("join".equalsIgnoreCase(phaseDescribe)){
					//forkRollBack();
					return new ReturnMessage(-4,"本阶段为分支聚合阶段,不能退回");
				}else{
					boolean haveBackTask = haveBackTask();
					if(haveBackTask == true){
						return new ReturnMessage(-5,"该任务的其他分支正在退回补充资料中，请等待补充完全再退回！");
					}else{
						ftParent.finish("","",""); //清除父任务的完成时间和动作
						this.RelativeFlowObject.updatePhase(ftParent.RelativeFlowPhase);//将相关流程对象阶段设为父任务的阶段
						FlowTask.deleteTask(this.SerialNo,Sqlca);//删除本任务
					}
					//在系统日志中留下记录
					//asuOperator.addLog("流程任务退回","将"+this.UserName+"于"+this.BeginTime+"收到的"+this.PhaseName+"任务退回到"+ftParent.UserName+"经办的"+ftParent.PhaseName+"阶段，流水号为"+ftParent.SerialNo,Sqlca);
				}
			}
		}
		return new ReturnMessage(0,"退回完成");		
	}
	
	/** 功能：将处在分支聚合节点的流程任务退回到分支阶段  */
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
		
		//删除当前聚合阶段任务
		for (int i = 0; i < count; i++) {
			System.out.println(Array[i][0]);
			FlowTask.deleteTask(Array[i][0], Sqlca);
		}
		
		//清空所有分支最后阶段的信息
		for (int i = 0; i < count; i++) {
			System.out.println(Array[i][1]);
			FlowTask ft = new FlowTask(Array[i][1],Sqlca);
			ft.finish("", "", "");
			this.RelativeFlowObject.updatePhase(ft.RelativeFlowPhase);//将相关流程对象阶段设为父任务的阶段
		}
	}
	
	
	/** 功能：收回本任务，撤销本任务的子任务，获得控制权 参数：进行该操作的用户对象 返回值： 0退回完成 0 收回完成 -1子任务已提交或已签署意见 */	
	public ReturnMessage takeBack(ASUser asuOperator) throws Exception {
		int iCount = 0;
		//条件：无子任务或所有子任务提交且未签署意见
		//操作：1.删除所有子任务 2本任务完成时间和动作清空 3将相关流程对象阶段设为本任务的阶段
		//错误提示：0 收回完成 -1子任务已提交或已签署意见
		ASResultSet rsTemp = Sqlca.getASResultSet("select count(*) from FLOW_TASK where RelativeSerialNo = '"+this.SerialNo+"' "+
							" and ((EndTime is not null) or (PhaseChoice is not null) or (PhaseOpinion1 is not null) "+
							" or (PhaseOpinion2 is not null)  or (UserID ='system'))");
		if (rsTemp.next()) iCount = rsTemp.getInt(1);
		rsTemp.getStatement().close();
		
		if(iCount>0){
			return new ReturnMessage(-1,"下阶段任务已提交或已签署意见，不能收回");
		}else{
			iCount = this.getChildTaskCount();

			//在系统日志中留下记录
			//asuOperator.addLog("流程任务收回","将"+this.UserName+"于"+this.EndTime+"提交的"+this.PhaseName+"任务重新收回,同时撤销子任务"+iCount+"件",Sqlca);
			
			Sqlca.executeSQL("delete from FLOW_TASK where RelativeSerialNo = '"+this.SerialNo+"'");//删除所有子任务
			this.finish("","");//本任务完成时间和动作清空
			this.RelativeFlowObject.updatePhase(this.RelativeFlowPhase);//将相关流程对象阶段设为本任务的阶段
		}
		return new ReturnMessage(0,"收回完成");
	}
	
	/** 功能：获得本任务的子任务数量 */	
	public int getChildTaskCount() throws Exception {
		int iCount = 0;
		ASResultSet rsTemp = Sqlca.getASResultSet("select count(*) from FLOW_TASK where RelativeSerialNo = '"+this.SerialNo+"'");
		if (rsTemp.next()) iCount = rsTemp.getInt(1);
		rsTemp.getStatement().close();
				
		return iCount;			
	}	

	/** 功能：获得当前任务对应阶段的意见提示，使用本方法将会使系统把意见提示作为一段Amarscript解释  参数：无 返回值：执行结果为一个字符串 */
	public String getChoiceDescribe() throws Exception {
		return this.RelativeFlowPhase.executeScript("ChoiceDescribe",this.getConstantList()).toStringValue();
	}

	/** 功能：获得当前任务对应阶段的动作提示，使用本方法将会使系统把动作提示作为一段Amarscript解释 参数：无 返回值：执行结果为一个字符串*/
	public String getActionDescribe() throws Exception {
		return this.RelativeFlowPhase.executeScript("ActionDescribe",this.getConstantList()).toStringValue();
	}
	
	/** 功能：获得当前任务对应阶段可选择的意见列表 参数：无 返回值：执行结果为一个字符串数组 */
	public String[] getChoiceList() throws Exception {
		String sReturn[];
		Any aChoiceList;
		try{
			aChoiceList = this.RelativeFlowPhase.executeScript("ChoiceScript",this.getConstantList());
		}catch(Exception ex){
			throw new FlowException(ex.toString()+" 取意见列表出错！");
		}
		if(aChoiceList==null) return null;
		else sReturn = aChoiceList.toStringArray();
		return sReturn;
	}
	
	/** 功能：获得当前任务对应阶段可选择的动作列表 参数：无 返回值：执行结果为一个字符串数组 */
	public String[] getActionList() throws Exception {
		Any aActionList = null;
		String[] sActionList = null;
		aActionList = this.RelativeFlowPhase.executeScript("ActionScript",this.getConstantList());
		if(aActionList!=null) sActionList = aActionList.toStringArray();
		return sActionList;
	}
	
	/** 功能：获得当前任务对应阶段可选择的动作列表 参数：意见 返回值：执行结果为一个字符串数组*/
	public String[] getActionList(String sPhaseOpinion1) throws Exception {
	  	String sActionList[][] = getConstantList();
	    StringFunction.setAttribute(sActionList, "#PhaseOpinion1", "'" + sPhaseOpinion1 + "'");
	    return RelativeFlowPhase.executeScript("ActionScript", sActionList).toStringArray();
    }
	
	/** 功能：获得当前任务的参数表 参数：无 返回值：执行结果为一个二维字符串数组 */
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
			     		   
		//如果本任务有来源任务，则设置扩展参数表属性值
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
	
	/**功能：根据指定的任务要素在数据表中生成新任务 参数：任务的基本要素，其他可以自动生成 返回值：无*/	
	//20130614 并行流程修改by zszhang 增加聚合标识位
	static public String newTask(String sRelativeSerialNo,String sObjectType,String sObjectNo,String sFlowNo,String sPhaseNo,String sApplyType,String sUserID,String sBeginTime,Transaction transSql,String fork) throws Exception
	{
		/*此处用ASUser取得相关的内容可能有问题 修改之fmwu*/
		//取相关承办人姓名和所属机构号和机构名称
		String sUserName=transSql.getString("select UserName from USER_INFO where UserID = '"+sUserID+"'");
		String sOrgID=transSql.getString("select BelongOrg from USER_INFO where UserID = '"+sUserID+"'");
		String sOrgName=transSql.getString("select OrgName from ORG_INFO where OrgID = '"+sOrgID+"'");
		
		//取得相关阶段名称和阶段类型
		FlowPhase fpTemp = new FlowPhase(sFlowNo,sPhaseNo,transSql);
		String sPhaseName = fpTemp.PhaseName;
		String sPhaseType = fpTemp.PhaseType;
		//取得相关流程名称
		FlowCatalog fcTemp = new FlowCatalog(sFlowNo,transSql);
		String sFlowName = fcTemp.FlowName;
		
		if(sBeginTime == null) sBeginTime = StringFunction.getTodayNow();
		//生成任务流水号
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
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
						//分支汇聚阶段更新所有分支的EndTime
					   endForkTask(sBeginTime, sObjectNo, sObjectType, transSql);
					}else{
						if("BACK".equals(fork)){
							 sSql = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
								" PhaseNo,PhaseName,BeginTime,EndTime,UserID,UserName,OrgID,OrgName,forkState) " +
								" VALUES ( '"+sSerialNo+"','"+sRelativeSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"','"+sFlowName+"'," +
								" '"+sPhaseNo+"','"+sPhaseName+"','"+sBeginTime+"',null,'"+sUserID+"','"+sUserName+"','"+sOrgID+"','"+sOrgName+"','BACK')";
						}else{
							throw new FlowException("提交流程出错，不具备任何适用场景");
						}
					}
				}
			}
		}
		transSql.executeSQL(sSql);
		
		//已否决，已取消，则判断是否返回p2p额度 add by dahl ccs-760
		if( ("8000").equals(sPhaseNo) || ("9000").equals(sPhaseNo) ){	
			P2PCreditCommon p2p = new P2PCreditCommon(sObjectNo, transSql);
			p2p.checkReturnP2pSum();
		}
		
		return sSerialNo;
	}	

	/**功能：根据指定的任务编号在数据表中删除任务 返回值：无*/	
	static public void deleteTask(String sSerialNo,Transaction transSql) throws Exception {
		transSql.executeSQL("delete from  FLOW_TASK where SerialNo= '"+sSerialNo+"'");
	}	
	
	/**功能：当分支中有分支终结时终结其他分支任务 返回值：无*/	
	public static void endForkTask(String sEndTime,String sObjectNo,String sObjectType,Transaction transSql) throws Exception {
		transSql.executeSQL("update  FLOW_TASK set EndTime = '"+sEndTime+"' where ObjectNo ='"+sObjectNo+"' and ObjectType = '"+sObjectType+"' and (EndTime is null or EndTime = '')");
	}	
	
	/**功能：删除同类型兄弟任务 返回值：无*/	
	static public void deleteSamePhaseTask(String sObjectType,String sObjectNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction transSql) throws Exception
	{
		String sSql="delete from  FLOW_TASK where ObjectType = '"+sObjectType+"' and ObjectNo= '"+sObjectNo+"' and FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' and UserID <> '"+sUserID+"' and (EndTime is null or EndTime = '') ";						  
		transSql.executeSQL(sSql);
	}
}	