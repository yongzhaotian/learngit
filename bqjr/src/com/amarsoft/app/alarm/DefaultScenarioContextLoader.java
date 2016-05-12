package com.amarsoft.app.alarm;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.BizletExecutor;

/**
 * @author syang
 * @date 2011-6-29
 * @describe �Զ�����̽�ⳡ��������
 */
public class DefaultScenarioContextLoader extends ScenarioContextLoader{
	private ScenarioContext context = null;
	private String scenarioID = null;
	private String parameter = null;
	private String subTypeNo = null;
	private Transaction sqlca = null;
	@Override
	public ScenarioContext getContext() {
		return context;
	}
	/**
	 * ��ʼ��������
	 * @param sqlca ���ݿ�����
	 * @param scenarioID ������
	 * @param parameter ҵ�����
	 * @throws Exception
	 */
	public void init(Transaction sqlca,String scenarioID,String parameter) throws Exception{
		init(sqlca,scenarioID,parameter,"");
	}
	public void init(Transaction sqlca,String scenarioID,String parameter,String subTypeNo) throws Exception{
		this.context = new ScenarioContext();
		this.sqlca = sqlca;
		this.scenarioID = scenarioID;
		this.parameter = parameter;
		this.subTypeNo = subTypeNo;
		loadScenarioModel();		//���س���ģ��
		loadGroup();				//���ط����Լ������µļ����
		loadParameter();			//���س�������
		ARE.getLog().debug("==================================�Զ�����̽�ⳡ��==================================");
		ARE.getLog().debug("[�����ţ�"+context.getScenario().getScenarioID()+",������:"+context.getScenario().getScenarioName()+",��ʼ����:"+context.getScenario().getInitiateClass()+"]");
		ARE.getLog().debug("---------------������------------");
		Iterator<String> iterator = context.getParameter().keySet().iterator();
		while(iterator.hasNext()){
			String name = iterator.next();
			ARE.getLog().debug("["+name+"="+context.getParameter(name)+"]");
		}
		ARE.getLog().debug("---------------------------------");
	}
	/**
	 * ��ȡ��������ģ��
	 * @param scenarioID
	 * @throws Exception
	 */
	private void loadScenarioModel() throws Exception{
		Scenario scenario = new Scenario();
		//��ʼ������������Ϣ
		ARE.getLog().trace("1.��ȡ����...");
		BizObject bo = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_CATALOG").createQuery("ScenarioID=:ScenarioID").setParameter("ScenarioID",scenarioID).getSingleResult(false);
		if(bo != null){
			scenario.setScenarioID(scenarioID);
			scenario.setScenarioName(bo.getAttribute("ScenarioName").getString());
			scenario.setScenarioDescibe(bo.getAttribute("ScenarioDescribe").getString());
			scenario.setInitiateClass(bo.getAttribute("InitiateClass").getString());
			scenario.setInitParameter(parameter);
			context.setScenario(scenario);
		}else{
			throw new Exception(scenarioID+"����δ���壡");
		}
	}
	/**
	 * ��ȡ����
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	private void loadGroup() throws JBOException{
		ARE.getLog().trace("2.��ȡ����...");
		String query = "ScenarioID=:ScenarioID order by SortNo asc,GroupID asc";
		List<BizObject> jList = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_GROUP")
				.createQuery(query)
				.setParameter("ScenarioID", context.getScenario().getScenarioID())
				.getResultList(false);
		for(int i=0;i<jList.size();i++){
			BizObject bo = jList.get(i);
			String groupID = bo.getAttribute("GroupID").getString();
			String groupName = bo.getAttribute("GroupName").getString();
			ItemGroup group = new ItemGroup(context.getScenario(),groupID,groupName);
			loadItem(group);	//���ط����µ�����
			context.getScenario().addItemGroup(group);	//��ӷ���
		}
	}
	private void loadItem(ItemGroup group) throws JBOException{
		ARE.getLog().trace("3.��ȡ�����������["+group.getGroupID()+"-"+group.getGroupName()+"]");
		
		String query = "Select \"O.*\" from O,jbo.sys.SCENARIO_RELATIVE SR where O.ScenarioID = SR.ScenarioID and O.ModelID = SR.ModelID "+
					" and O.Status=:Status and SR.ScenarioID=:ScenarioID and SR.GroupID=:GroupID";
		if(subTypeNo!=null && subTypeNo.length()>=0)query += " and SubTypeNo like :SubTypeNo";
		query += " order by SortNo asc";
		BizObjectQuery q =  JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_MODEL").createQuery(query);
		q.setParameter("Status","1").setParameter("ScenarioID",group.getScenario().getScenarioID()).setParameter("GroupID",group.getGroupID());
		if(subTypeNo!=null && subTypeNo.length()>=0)q.setParameter("SubTypeNo","%"+subTypeNo+"%");
		@SuppressWarnings("unchecked")
		List<BizObject> bos = q.getResultList(false);
		for(int i = 0; i < bos.size(); i++){
			CheckItem checkItem = new CheckItem();
			BizObject bo = (BizObject) bos.get(i);
			//��ȡ����ӳ������
			checkItem.setItemID(bo.getAttribute("ModelID").getString());
			checkItem.setItemName(bo.getAttribute("ModelName").getString());
			checkItem.setItemDescribe(bo.getAttribute("ModelDescribe").getString());
			checkItem.setRunScript(bo.getAttribute("ExecuteScript").getString());
			checkItem.setRunCondition(bo.getAttribute("RunCondition").getString());
			checkItem.setNoPassDeal(bo.getAttribute("NoPassDeal").getString());
			checkItem.setPassDeal(bo.getAttribute("PassDeal").getString());
			checkItem.setPassMessage(bo.getAttribute("PassMessage").getString());
			checkItem.setNoPassMessage(bo.getAttribute("NoPassMessage").getString());
			checkItem.setBizViewer(bo.getAttribute("BizViewer").getString());
			checkItem.setRemark(bo.getAttribute("Remark").getString());
			//ת�����з�ʽֵ
			String runType = bo.getAttribute("ModelType").getString();		//ȡ��ִ������: 10 Java�෽ʽ ,20 SQL,30 AmarScript
			if("10".equals(runType))checkItem.setRunnerType(CheckItem.RunnerType.Java);
			else if("20".equals(runType))checkItem.setRunnerType(CheckItem.RunnerType.SQL);
			else if("30".equals(runType))checkItem.setRunnerType(CheckItem.RunnerType.AmarScript);
			
			group.addCheckItem(checkItem);
		}
	}
	/**
	 * ���ز���
	 * @throws Exception
	 */
	private void loadParameter() throws Exception{
		ARE.getLog().trace("4.���س�ʼ������...");
		loadModelParameter();	//1.���س�ʼ����
		loadSQLParameter();		//2.����SQL���õĳ�ʼ������
		loadInitClass();		//3.���س�ʼ����
	}
	private void loadModelParameter(){
		//�Դ���ʼ������
		String sParameter = context.getScenario().getInitParameter();
		if(sParameter==null)return;
		StringTokenizer st = new StringTokenizer(sParameter,",");
		while (st.hasMoreElements()){
			String sTempString = st.nextToken();
			if(sTempString==null || sTempString.equals("")) continue;
			String sKey = StringFunction.getSeparate(sTempString,"=",1);
			String sValue = StringFunction.getSeparate(sTempString,"=",2);
			setContextParameter(sKey,sValue);
		}
	}
	/**
	 * ����SQL���õĳ�ʼ������
	 * @throws Exception 
	 */
	private void loadSQLParameter() throws Exception{
		//��ѯ����SQL
		@SuppressWarnings("unchecked")
		List<BizObject> jList = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_ARGS")
				.createQuery("Status=:Status and ScenarioID=:ScenarioID order by SortNo asc")
				.setParameter("Status","1").setParameter("ScenarioID",this.scenarioID)
				.getResultList(false);
		List<String[]> list = new ArrayList<String[]>();
		for(int i = 0; i < jList.size(); i++){
			BizObject bo = jList.get(i);
			list.add(new String[]{bo.getAttribute("ArgsString").getString(),	// key
								  bo.getAttribute("QuerySQL").getString()});	// value SQL
		}
		//ִ�в���SQL
		for(int i=0;i<list.size();i++){
			String[] arg = (String[])list.get(i);
			String[] names = arg[0].split(",");						//��ֲ���
			String argSql = StringTool.pretreat(context.getParameter(),arg[1]);

			ARE.getLog().trace("����ҵ�����SQL:"+argSql);
			ASResultSet rs = null;
			try{
				rs  = sqlca.getASResultSet(argSql);	//ִ�в������õ�SQL
				if(rs.next()){
					for( int m=0;m<names.length;m++){
						setContextParameter(names[m], rs.getString(names[m]));
					}
				}
				rs.getStatement().close();
				rs = null;
			}catch(Exception e){
				throw new Exception("��ע��:�����ִ��в�����Ҫ��SQL��ѯ�еı���һһ��Ӧ��\r\n �����ִ���"+arg[0]+"\r\n����SQL:"+argSql+"\r\n�쳣��Ϣ:"+e.getMessage());
			}finally{
				if(rs != null)
					rs.getStatement().close();
			}
		}
		
	}
	private void loadInitClass() throws Exception{
		String className = context.getScenario().getInitiateClass();
		if(className == null || className.length() == 0)return ;
		
		//��ȡ�������в���
		ASValuePool pool = new ASValuePool();
	    String keys[] = context.getParameterNames();
	    for(String name:keys)pool.setAttribute(name, context.getParameter(name));
	    
	    //ִ�г�ʼ����
		BizletExecutor executor = new BizletExecutor();
        ASValuePool rets = (ASValuePool)executor.execute(sqlca,className,pool);
        Object [] oKeys = rets.getKeys();
        
        //��д����
        for(int i = 0; i < oKeys.length; i++) setContextParameter((String)oKeys[i],rets.getAttribute((String)oKeys[i]));
	}
	/**
	 * ������������
	 * @param key
	 * @param value
	 */
	private void setContextParameter(String key,Object value){
		ARE.getLog().trace("����ҵ�����["+key+"="+value+"]");
		context.setParameter(key,value);
	}
}