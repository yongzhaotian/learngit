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
 * @describe 自动风险探测场景加载器
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
	 * 初始化加载器
	 * @param sqlca 数据库连接
	 * @param scenarioID 场景号
	 * @param parameter 业务参数
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
		loadScenarioModel();		//加载场景模型
		loadGroup();				//加载分组以及分组下的检查项
		loadParameter();			//加载场景参数
		ARE.getLog().debug("==================================自动风险探测场景==================================");
		ARE.getLog().debug("[场景号："+context.getScenario().getScenarioID()+",场景名:"+context.getScenario().getScenarioName()+",初始化类:"+context.getScenario().getInitiateClass()+"]");
		ARE.getLog().debug("---------------参数池------------");
		Iterator<String> iterator = context.getParameter().keySet().iterator();
		while(iterator.hasNext()){
			String name = iterator.next();
			ARE.getLog().debug("["+name+"="+context.getParameter(name)+"]");
		}
		ARE.getLog().debug("---------------------------------");
	}
	/**
	 * 读取场景基本模型
	 * @param scenarioID
	 * @throws Exception
	 */
	private void loadScenarioModel() throws Exception{
		Scenario scenario = new Scenario();
		//初始化场景基本信息
		ARE.getLog().trace("1.读取场景...");
		BizObject bo = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_CATALOG").createQuery("ScenarioID=:ScenarioID").setParameter("ScenarioID",scenarioID).getSingleResult(false);
		if(bo != null){
			scenario.setScenarioID(scenarioID);
			scenario.setScenarioName(bo.getAttribute("ScenarioName").getString());
			scenario.setScenarioDescibe(bo.getAttribute("ScenarioDescribe").getString());
			scenario.setInitiateClass(bo.getAttribute("InitiateClass").getString());
			scenario.setInitParameter(parameter);
			context.setScenario(scenario);
		}else{
			throw new Exception(scenarioID+"场景未定义！");
		}
	}
	/**
	 * 读取分组
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	private void loadGroup() throws JBOException{
		ARE.getLog().trace("2.读取分组...");
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
			loadItem(group);	//加载分组下的子项
			context.getScenario().addItemGroup(group);	//添加分组
		}
	}
	private void loadItem(ItemGroup group) throws JBOException{
		ARE.getLog().trace("3.读取分组检查项，分组["+group.getGroupID()+"-"+group.getGroupName()+"]");
		
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
			//读取基本映射属性
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
			//转换运行方式值
			String runType = bo.getAttribute("ModelType").getString();		//取出执行类型: 10 Java类方式 ,20 SQL,30 AmarScript
			if("10".equals(runType))checkItem.setRunnerType(CheckItem.RunnerType.Java);
			else if("20".equals(runType))checkItem.setRunnerType(CheckItem.RunnerType.SQL);
			else if("30".equals(runType))checkItem.setRunnerType(CheckItem.RunnerType.AmarScript);
			
			group.addCheckItem(checkItem);
		}
	}
	/**
	 * 加载参数
	 * @throws Exception
	 */
	private void loadParameter() throws Exception{
		ARE.getLog().trace("4.加载初始化参数...");
		loadModelParameter();	//1.加载初始参数
		loadSQLParameter();		//2.加载SQL配置的初始化参数
		loadInitClass();		//3.加载初始化类
	}
	private void loadModelParameter(){
		//自带初始化参数
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
	 * 加载SQL设置的初始化参数
	 * @throws Exception 
	 */
	private void loadSQLParameter() throws Exception{
		//查询参数SQL
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
		//执行参数SQL
		for(int i=0;i<list.size();i++){
			String[] arg = (String[])list.get(i);
			String[] names = arg[0].split(",");						//拆分参数
			String argSql = StringTool.pretreat(context.getParameter(),arg[1]);

			ARE.getLog().trace("场景业务参数SQL:"+argSql);
			ASResultSet rs = null;
			try{
				rs  = sqlca.getASResultSet(argSql);	//执行参数配置的SQL
				if(rs.next()){
					for( int m=0;m<names.length;m++){
						setContextParameter(names[m], rs.getString(names[m]));
					}
				}
				rs.getStatement().close();
				rs = null;
			}catch(Exception e){
				throw new Exception("请注意:参数字串中参数名要与SQL查询中的别名一一对应！\r\n 参数字串："+arg[0]+"\r\n参数SQL:"+argSql+"\r\n异常消息:"+e.getMessage());
			}finally{
				if(rs != null)
					rs.getStatement().close();
			}
		}
		
	}
	private void loadInitClass() throws Exception{
		String className = context.getScenario().getInitiateClass();
		if(className == null || className.length() == 0)return ;
		
		//读取参数池中参数
		ASValuePool pool = new ASValuePool();
	    String keys[] = context.getParameterNames();
	    for(String name:keys)pool.setAttribute(name, context.getParameter(name));
	    
	    //执行初始化类
		BizletExecutor executor = new BizletExecutor();
        ASValuePool rets = (ASValuePool)executor.execute(sqlca,className,pool);
        Object [] oKeys = rets.getKeys();
        
        //回写参数
        for(int i = 0; i < oKeys.length; i++) setContextParameter((String)oKeys[i],rets.getAttribute((String)oKeys[i]));
	}
	/**
	 * 设置容器参数
	 * @param key
	 * @param value
	 */
	private void setContextParameter(String key,Object value){
		ARE.getLog().trace("设置业务参数["+key+"="+value+"]");
		context.setParameter(key,value);
	}
}