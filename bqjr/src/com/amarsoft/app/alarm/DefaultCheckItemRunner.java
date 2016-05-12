package com.amarsoft.app.alarm;

import java.io.Serializable;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 默认探测检查项运行器。
 */
public class DefaultCheckItemRunner extends CheckItemRunner implements Serializable{

	private static final long serialVersionUID = 7877575360527804206L;

	@Override
	public Object run(Transaction sqlca,CheckItem checkItem) throws Exception {
		String sScript = StringTool.pretreat(getScenarioContext().getParameter(),checkItem.getRunScript());//先处理脚本中的变量
		ARE.getLog().debug("[运行检查项]：编号:"+checkItem.getItemID()+",执行脚本:"+checkItem.getRunScript());
		
		AlarmMessage oReturn = null;
		
		if(checkItem.getRunnerType()==CheckItem.RunnerType.Java){
			oReturn = executeClass(sqlca,checkItem,sScript);
		}else if(checkItem.getRunnerType()==CheckItem.RunnerType.SQL){
			oReturn = executeSql(sqlca,checkItem,sScript);
		}else if(checkItem.getRunnerType()==CheckItem.RunnerType.AmarScript){
			oReturn = executeAmarScript(sqlca,checkItem,sScript);
		}else{
			throw new Exception("不支持检查项["+checkItem.getItemID()+"],所配置的处理类型,字段ModelType的值["+checkItem.getRunnerType()+"]，该值只能为10,20,30");
		}
		return oReturn;
	}
	/**
	 * 执行java表达式
	 * @param sqlca
	 * @param modelNo
	 * @param sScript
	 * @return
	 * @throws Exception
	 */
	private AlarmMessage executeClass(Transaction sqlca,CheckItem checkItem,String sScript) throws Exception{
		AlarmBiz alarmBiz = null;
		try{
			alarmBiz =(AlarmBiz)Class.forName(sScript).newInstance();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception("检查项["+checkItem.getItemID()+"]出错,找不到对应的类："+sScript+"!");
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new Exception("检查项["+checkItem.getItemID()+"]出错,构造类["+sScript+"]时出错："+e.getMessage());
		}
		alarmBiz.setAttributePool(getScenarioContext().getParameter());
		AlarmMessage bReturn = null;
		try{
			alarmBiz.run(sqlca);					//执行业务预警检查业务类
			bReturn = alarmBiz.getAlarmMessage();	//取得执行结果
		}catch(Exception e){
			e.printStackTrace();
			throw new Exception("检查项["+checkItem.getItemID()+"]执行出错,表达式:"+sScript+"\n"+e.getMessage());
		}
		return bReturn;
	}
	
	/**
	 * 执行SQL表达式
	 * @param sqlca
	 * @param modelNo
	 * @param sScript
	 * @return
	 * @throws Exception
	 */
	private AlarmMessage executeSql(Transaction sqlca,CheckItem checkItem,String sScript) throws Exception{
		String sTmp = null;
		AlarmMessage am = new AlarmMessage();
		try{
			sTmp = sqlca.getString(sScript);
		}catch(Exception e){
			throw new Exception("检查项["+checkItem.getItemID()+"]出错,SQL:"+sScript+"\n"+e.getMessage());
		}
		if(sTmp == null) sTmp = "";
		//如果sql执行结果true,TRUE,1，只有在这三种情况下，认为是校验通过
		if(sTmp.equalsIgnoreCase("true") || sTmp.equals("1")){
			am.setPass(true);
		}else{
			am.setPass(false);
		}
		return am;
	}
	
	/**
	 * 执行AmarScript表达式
	 * @param sqlca
	 * @param modelNo
	 * @param sScript
	 * @return
	 * @throws Exception
	 */
	private AlarmMessage executeAmarScript(Transaction sqlca,CheckItem checkItem,String sScript) throws Exception{
		
		AlarmMessage am = new AlarmMessage();
		try{
			sScript = Expression.pretreatMethod(sScript,sqlca);
			Any anyResult = Expression.getExpressionValue(sScript,sqlca);
			String sTmp = anyResult.toStringValue();
			if(sTmp == null ) sTmp = "";
			ARE.getLog().debug("[AmarScript执行结果]"+sTmp);
			if(sTmp.equalsIgnoreCase("true")){
				am.setPass(true);
			}else{
				am.setPass(false);
			}
		}catch(Exception e){
			throw new Exception("检查项["+checkItem.getItemID()+"]出错,AmarScript:"+sScript+"\n"+e.getMessage());
		}
		return am;
	}
}

