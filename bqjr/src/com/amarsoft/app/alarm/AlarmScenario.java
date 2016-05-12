package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.BizletExecutor;

/**
 * 风险预警扫描场景类
 * 	1.此类封装了场景，场景参数，场景模型的基本属性定义
 * 	2.此类封装了场景模型的执行
 * @author syang
 * @version 1.0
 * @since 2009/09/10
 * 
 */
public class AlarmScenario implements Cloneable,Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 场景基本属性
	 */
	private String scenarioID = "";
	private String scenarioName = "";
	private String scenarioDescibe = "";
	private String scenarioArgs = "";
	private String initiateClass = "";
	
	/**
	 * 场景相关配置属性容器
	 */
	private Vector vModelkeys = null;		//场景包含所有模型的模型号
	private Map mArgs = new HashMap();	    //场景参数池
	private Map mModels = null;				//场景中的全部模型项容器
	
	/**
	 * 子类型号
	 */
	private String subTypeNo = "";
	
	/**
	 * 构造函数，初始化参数
	 * @param scenarioID 场景ID
	 * @param objectType 对象类型
	 * @param objectNo 对象编号
	 * @throws Exception
	 */
	public AlarmScenario(String scenarioID) throws Exception{
		this.scenarioID = scenarioID;
	}
	
	/**
	 * 构造函数，初始化参数
	 * @param scenarioID 场景ID
	 * @param objectType 对象类型
	 * @param objectNo 对象编号
	 * @param exeTypeNo 执行类型号
	 * @throws Exception 
	 */
	public AlarmScenario(String scenarioID,String args) throws Exception{
		this(scenarioID);
		this.scenarioArgs = args;
	}
	
	
	/**
	 * 构造函数
	 * @param scenarioID 场景ID
	 * @param objectType 对象类型
	 * @param objectNo 对象编号
	 * @param exeTypeNo 执行子类型号
	 * @param args 参数列表 格式如a1=10&a2=20&a3=30，这些参数会设置到场景中
	 * @throws Exception
	 */
	public AlarmScenario(String scenarioID,String args,String exeTypeNo) throws Exception{
		this(scenarioID,args);
		this.subTypeNo = exeTypeNo;
		this.initArgPoolsFromProfileString(args, ",");
	}
	
	
	/**
	 * 初始化场景
	 * @param sqlca
	 * @throws Exception
	 */
	public void init(Transaction sqlca) throws Exception{
		
		//初始化场景基本信息
		ARE.getLog().debug("+-----------------+");
		ARE.getLog().debug("| ALS6 风险预警场景 |");
		ARE.getLog().debug("+-----------------+");
		ARE.getLog().debug("1.读取场景...");
		String sTmp = null;
		BizObject bo = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_CATALOG").createQuery("ScenarioID=:ScenarioID").setParameter("ScenarioID",this.scenarioID).getSingleResult(false);
		if(bo != null){
			this.scenarioName = bo.getAttribute("ScenarioName").getString();
			this.scenarioDescibe = bo.getAttribute("ScenarioDescribe").getString();
			sTmp = bo.getAttribute("DefaultSubTypeNo").getString();
			this.initiateClass = bo.getAttribute("InitiateClass").getString();
		}else{
			throw new Exception(this.scenarioID+"场景未定义！");
		}
		
		//如果没有传入exeTypeNo参数，则使用设置的默认值
		if(subTypeNo == null || subTypeNo.length() == 0){
			this.subTypeNo = sTmp;
		}
		ARE.getLog().debug("2.初始化场景模型...");
		initModel(sqlca);	//初始化模型
		ARE.getLog().debug("3.初始化业务参数...");
		initArgs(sqlca);	//初始化参数池
		initClass(sqlca);	//场景初始化动态加载类
		ARE.getLog().debug("4.场景初始化完毕！");
	}
	
	/**
	 * 初始化场景参数
	 * @throws Exception 
	 */
	private void initArgs(Transaction sqlca) throws SQLException,Exception{
		
		this.initArgPoolsFromProfileString(this.scenarioArgs, ",");
		//取出参数配置
		Vector v = new Vector();
		
		List bos = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_ARGS").createQuery("Status=:Status and ScenarioID=:ScenarioID order by SortNo asc").setParameter("Status","1").setParameter("ScenarioID",this.scenarioID).getResultList(false);
		BizObject bo = null;
		for(int i = 0; i < bos.size(); i++){
			bo = (BizObject) bos.get(i);
			v.add(new String[]{bo.getAttribute("ArgsString").getString(),	// key
					           bo.getAttribute("QuerySQL").getString()});	// value SQL
		}
		
		//根据参数配置的SQL，设置参数
		for(int i=0;i<v.size();i++){
			String[] arg = (String[])v.get(i);
			String[] keys = arg[0].split(",");						//拆分参数
			String argSql = pretreat(arg[1]);

			Vector vValues = new Vector();
			
			ARE.getLog().debug("[设置｜场景业务参数SQL]"+argSql);
			try{
				ASResultSet ars  = sqlca.getASResultSet(argSql);	//执行参数配置的SQL
				if(ars.next()){
					for( int m=0;m<keys.length;m++){
						vValues.add(ars.getString(keys[m]));
					}
				}
				ars.getStatement().close();
				ars = null;
			}catch(Exception e){
				throw new Exception("请注意:参数字串中参数名要与SQL查询中的别名一一对应！\r\n 参数字串："+arg[0]+"\r\n参数SQL:"+argSql+"\r\n异常消息:"+e.getMessage());
			}
			String[] values = (String [])vValues.toArray( new String[0]);
			setAttribute(keys,values);								//设置参数池
		}
	}
	
	/**
	 * 初始化模型
	 * @param sqlca 数据库连接
	 * @throws Exception 
	 */
	private void initModel(Transaction sqlca) throws Exception{
		
		mModels = new HashMap();	//初始化模型池
		vModelkeys = new Vector();		//初始化模型主键池
		
		String selectColumn = "ModelID,ModelName,ModelDescribe,ModelType,RunCondition,NoPassDeal,PassDeal,ExecuteScript,PassMessage,NoPassMessage,Remark";
		String[] colArray = selectColumn.split(",");
		
		List bos = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_MODEL").createQuery("Status=:Status and SubTypeNo like :SubTypeNo and ScenarioID=:ScenarioID order by SortNo asc").setParameter("Status","1").setParameter("SubTypeNo","%"+this.subTypeNo+"%").setParameter("ScenarioID",this.scenarioID).getResultList(false);
		BizObject bo = null;
		for(int i = 0; i < bos.size(); i++){
			bo = (BizObject) bos.get(i);
			Map vp = new HashMap();
			StringBuffer sModeProperties = new StringBuffer("[设置｜场景.模型属性]:");
			for(int j = 0; j < colArray.length; j++){
				sModeProperties.append(colArray[j] + "=" + bo.getAttribute(colArray[j]).getString() + "|");
				vp.put(colArray[j], bo.getAttribute(colArray[j]).getString());
			}
			ARE.getLog().debug(sModeProperties.toString());
			vModelkeys.add(bo.getAttribute("ModelID").getString());			//设置模型KEY
			mModels.put(bo.getAttribute("ModelID").getString(), vp);	//设置模型
		}
	}
	
	
	/**
	 * 执行场景初始化类
	 * @param sqlca 数据库连接
	 * @throws Exception
	 */
	private void initClass(Transaction sqlca) throws Exception{
		
		String sClassName = this.initiateClass;
		
		//如果没有配置初始化执行类，则退出
		if(sClassName == null || sClassName.length() == 0){
			return;
		}
		
		BizletExecutor executor = new BizletExecutor();
		Map tmpMemory = new HashMap();
		
		try{
			ASValuePool args = new ASValuePool();
		    String sKeys[] = (String[])mArgs.keySet().toArray(new String[0]);
	        for(int i = 0; i < sKeys.length; i++) {
	        	args.setAttribute(sKeys[i], (Serializable)mArgs.get(sKeys[i]));
	        }
	        ASValuePool rets = (ASValuePool)executor.execute(sqlca,sClassName,args);
	        Object [] oKeys = rets.getKeys();
	        for(int i = 0; i < oKeys.length; i++) {
	        	tmpMemory.put((String)oKeys[i], rets.getAttribute((String)oKeys[i]));
	        }
		}catch(Exception e){
			ARE.getLog().error("加载场景初始化类出错");
			throw e;
		}
		//场景初始化执行类，执行完成后，返回一个ASValuePools,把这些内容合并到场景参数池中
		if(tmpMemory != null && tmpMemory.size()>0){
			mArgs.putAll(tmpMemory);
		}
	}
	/**
	 * 设置属性集合，参数个数以键值标准，如果键值多了，则设置为空，属性值多了，则多余的部分不设置
	 * @param key 键值集合
	 * @param value 属性集合
	 * @throws Exception 
	 * @throws Exception 
	 */
	private void setAttribute(String[] key,String[] value) throws Exception{
		for(int i=0;i<key.length;i++){
			if(i<value.length){
				try {
					setAttribute(key[i],value[i]);
				} catch (Exception e) {
					throw new Exception("参数["+key[i]+"]-"+value[i]+"构造有误:"+e.getMessage());
				}
			}else{
				try {
					setAttribute(key[i],"");
				} catch (Exception e) {
					throw new Exception("参数["+key[i]+"]-构造有误:"+e.getMessage());
				}
			}
		}
	}
	
	/**
	 * 使用参数池中的参数，替换掉字符串中的参数
	 * @param str
	 * @return
	 * @throws Exception 
	 */
	private String pretreat(String str) throws Exception{
		if(str == null) return str;
		String sReturn = macroReplace(mArgs,str.trim(),"#{","}");
		return sReturn;
	}
	
    public static String macroReplace(Map vpAttributes, String sSource, String sBeginIdentifier, String sEndIdentifier)
    throws Exception
{
    if(sSource == null)
        return null;
    if(vpAttributes == null || vpAttributes.size() == 0)
        return sSource;
    int iPosBegin = 0;
    int iPosEnd = 0;
    String sAttributeID = "";
    String sAttributeValue = "";
    Object oTmp = null;
    String sReturn = sSource;
    try
    {
        while((iPosBegin = sReturn.indexOf(sBeginIdentifier, iPosBegin)) >= 0) 
        {
            iPosEnd = sReturn.indexOf(sEndIdentifier, iPosBegin);
            sAttributeID = sReturn.substring(iPosBegin + sBeginIdentifier.length(), iPosEnd);
            oTmp = vpAttributes.get(sAttributeID);
            if(oTmp == null)
            {
                iPosBegin = iPosEnd;
            } else
            {
                sAttributeValue = (String)oTmp;
                sReturn = sReturn.substring(0, iPosBegin) + sAttributeValue + sReturn.substring(iPosEnd + sEndIdentifier.length());
            }
        }
    }
    catch(Exception ex)
    {
        throw new Exception("\u5B8F\u66FF\u6362\u9519\u8BEF:" + ex.toString());
    }
    return sReturn;
}
    
	/**
	 * 执行模型脚本
	 * @param modelNo 模型编号 
	 * @return
	 * @throws Exception 
	 */
	public AlarmMessage execute(Transaction sqlca,String modelNo) throws Exception{
		String sModelType = (String) this.getModelAttribute(modelNo, "ModelType");	//取出执行类型: 10 Java类方式 ,20 SQL,30 AmarScript
		String sScript = (String) this.getModelAttribute(modelNo, "ExecuteScript");	//取出执行
		AlarmMessage bReturn  = null;
		if(sScript == null || sScript.length() == 0){
			throw new Exception("模型["+modelNo+"]没有配置ExecuteScript，请检查该字段是否有值");
		}
		sScript = pretreat(sScript.trim());//先处理脚本中的变量
		ARE.getLog().debug("[运行模型]：模型:"+modelNo+",执行脚本:"+sScript);
		
		if(sModelType.equals("10")){		//java
			bReturn = executeClass(sqlca,modelNo,sScript);
		}else if(sModelType.equals("20")){	//SQL
			bReturn = executeSql(sqlca,modelNo,sScript);
		}else if(sModelType.equals("30")){	//AmarScript
			bReturn = executeAmarScript(sqlca,modelNo,sScript);
		}else{
			throw new Exception("不支持模型["+modelNo+"],所配置的处理类型,字段ModelType的值["+sModelType+"]，该值只能为10,20,30");
		}
		return bReturn;
	}
	
	/**
	 * 执行java表达式
	 * @param sqlca
	 * @param modelNo
	 * @param sScript
	 * @return
	 * @throws Exception
	 */
	private AlarmMessage executeClass(Transaction sqlca,String modelNo,String sScript) throws Exception{
		AlarmBiz alarmBiz = null;
		try{
			alarmBiz =(AlarmBiz)Class.forName(sScript).newInstance();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception("模型["+modelNo+"]出错,找不到对应的类："+sScript+"!");
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new Exception("模型["+modelNo+"]出错,构造类["+sScript+"]时出错："+e.getMessage());
		}
		alarmBiz.setAttributePool(this.mArgs);
		AlarmMessage bReturn = null;
		try{
			alarmBiz.run(sqlca);					//执行业务预警检查业务类
			bReturn = alarmBiz.getAlarmMessage();	//取得执行结果
		}catch(Exception e){
			e.printStackTrace();
			throw new Exception("模型["+modelNo+"]执行出错,表达式:"+sScript+"\n"+e.getMessage());
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
	private AlarmMessage executeSql(Transaction sqlca,String modelNo,String sScript) throws Exception{
		String sTmp = null;
		AlarmMessage am = new AlarmMessage();
		try{
			sTmp = sqlca.getString(sScript);
		}catch(Exception e){
			throw new Exception("模型["+modelNo+"]出错,SQL:"+sScript+"\n"+e.getMessage());
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
	private AlarmMessage executeAmarScript(Transaction sqlca,String modelNo,String sScript) throws Exception{
		
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
			throw new Exception("模型["+modelNo+"]出错,AmarScript:"+sScript+"\n"+e.getMessage());
		}
		return am;
	}
	
	/**
	 * 检查模型运行条件表达式是否允许该模型运行
	 * @param modelNo 模型编号
	 * @return
	 * @throws Exception 
	 */
	public boolean checkRunCondition(Transaction sqlca,String modelNo) throws Exception{
		Any anyResult;
		boolean bResult = true;
		String sRunCondition = (String)this.getModelAttribute(modelNo, "RunCondition");
		if(sRunCondition == null || sRunCondition.length() == 0) return bResult;
		sRunCondition = pretreat(sRunCondition);
		sRunCondition = Expression.pretreatMethod(sRunCondition,sqlca);
		anyResult = Expression.getExpressionValue(sRunCondition,sqlca);
		bResult = anyResult.booleanValue();
		if (!bResult )	//出错
			return false;
		else
			return true;
	}
	
	/**
	 * 取出模型中定义的属性
	 * @param modelNo 模型号
	 * @param key 属性值key
	 * @return
	 * @throws Exception 
	 */
	public Object getModelAttribute(String modelNo,String key) throws Exception{
		Map model = (HashMap)mModels.get(modelNo);
		return (String)model.get(key);
	}
	
	/**
	 * 获取场景参数
	 * @param key 场景参数属性key
	 * @return
	 * @throws Exception
	 */
	public Object getAttribute(String key) throws Exception{
		return mArgs.get(key);
	}
	
	/**
	 * 设置场景参数
	 * @param key 参数key(名)
	 * @param value 参数值
	 * @throws Exception 
	 * @throws Exception
	 */
	public void setAttribute(String key,String value) throws Exception{
		ARE.getLog().trace("[设置｜场景.业务参数]:"+key+"="+value);
		mArgs.put(key, value);
	}
	
	
	/**
	 * 把形似"A=1;B=2;C=3"的Profile String转换成ValuePool<p>
	 * 
	 * @param data  原字符串
	 * @param delim 结束字符串
	 * @return ValuePool
	 * @throws Exception 
	 */
	private void initArgPoolsFromProfileString(String data,String delim) throws Exception 
	{
		StringTokenizer st = new StringTokenizer(data,delim);
		while (st.hasMoreElements()){
			String sTempString = st.nextToken();
			if(sTempString==null || sTempString.equals("")) continue;
			String sKey = StringFunction.getSeparate(sTempString,"=",1);
			String sValue = StringFunction.getSeparate(sTempString,"=",2);
			mArgs.put(sKey,sValue);
			ARE.getLog().trace("[设置｜场景.业务参数]:"+sKey+"="+sValue);
		}
		
	}
	
	public String getScenarioID() {
		return scenarioID;
	}
	public String getScenarioName() {
		return scenarioName;
	}

	public String getScenarioDescibe() {
		return scenarioDescibe;
	}
	public Vector getModelkeys() {
		return vModelkeys;
	}

	/**
	 * 场景初始化，加载类
	 * @return the initiateClass
	 */
	public String getInitiateClass() {
		return initiateClass;
	}
}
