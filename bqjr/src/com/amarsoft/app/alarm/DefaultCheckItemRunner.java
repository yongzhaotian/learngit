package com.amarsoft.app.alarm;

import java.io.Serializable;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;

/**
 * @author syang
 * @date 2011-6-29
 * @describe Ĭ��̽��������������
 */
public class DefaultCheckItemRunner extends CheckItemRunner implements Serializable{

	private static final long serialVersionUID = 7877575360527804206L;

	@Override
	public Object run(Transaction sqlca,CheckItem checkItem) throws Exception {
		String sScript = StringTool.pretreat(getScenarioContext().getParameter(),checkItem.getRunScript());//�ȴ���ű��еı���
		ARE.getLog().debug("[���м����]�����:"+checkItem.getItemID()+",ִ�нű�:"+checkItem.getRunScript());
		
		AlarmMessage oReturn = null;
		
		if(checkItem.getRunnerType()==CheckItem.RunnerType.Java){
			oReturn = executeClass(sqlca,checkItem,sScript);
		}else if(checkItem.getRunnerType()==CheckItem.RunnerType.SQL){
			oReturn = executeSql(sqlca,checkItem,sScript);
		}else if(checkItem.getRunnerType()==CheckItem.RunnerType.AmarScript){
			oReturn = executeAmarScript(sqlca,checkItem,sScript);
		}else{
			throw new Exception("��֧�ּ����["+checkItem.getItemID()+"],�����õĴ�������,�ֶ�ModelType��ֵ["+checkItem.getRunnerType()+"]����ֵֻ��Ϊ10,20,30");
		}
		return oReturn;
	}
	/**
	 * ִ��java���ʽ
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
			throw new Exception("�����["+checkItem.getItemID()+"]����,�Ҳ�����Ӧ���ࣺ"+sScript+"!");
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new Exception("�����["+checkItem.getItemID()+"]����,������["+sScript+"]ʱ����"+e.getMessage());
		}
		alarmBiz.setAttributePool(getScenarioContext().getParameter());
		AlarmMessage bReturn = null;
		try{
			alarmBiz.run(sqlca);					//ִ��ҵ��Ԥ�����ҵ����
			bReturn = alarmBiz.getAlarmMessage();	//ȡ��ִ�н��
		}catch(Exception e){
			e.printStackTrace();
			throw new Exception("�����["+checkItem.getItemID()+"]ִ�г���,���ʽ:"+sScript+"\n"+e.getMessage());
		}
		return bReturn;
	}
	
	/**
	 * ִ��SQL���ʽ
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
			throw new Exception("�����["+checkItem.getItemID()+"]����,SQL:"+sScript+"\n"+e.getMessage());
		}
		if(sTmp == null) sTmp = "";
		//���sqlִ�н��true,TRUE,1��ֻ��������������£���Ϊ��У��ͨ��
		if(sTmp.equalsIgnoreCase("true") || sTmp.equals("1")){
			am.setPass(true);
		}else{
			am.setPass(false);
		}
		return am;
	}
	
	/**
	 * ִ��AmarScript���ʽ
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
			ARE.getLog().debug("[AmarScriptִ�н��]"+sTmp);
			if(sTmp.equalsIgnoreCase("true")){
				am.setPass(true);
			}else{
				am.setPass(false);
			}
		}catch(Exception e){
			throw new Exception("�����["+checkItem.getItemID()+"]����,AmarScript:"+sScript+"\n"+e.getMessage());
		}
		return am;
	}
}

