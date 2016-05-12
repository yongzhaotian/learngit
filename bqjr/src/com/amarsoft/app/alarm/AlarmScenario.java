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
 * ����Ԥ��ɨ�賡����
 * 	1.�����װ�˳�������������������ģ�͵Ļ������Զ���
 * 	2.�����װ�˳���ģ�͵�ִ��
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
	 * ������������
	 */
	private String scenarioID = "";
	private String scenarioName = "";
	private String scenarioDescibe = "";
	private String scenarioArgs = "";
	private String initiateClass = "";
	
	/**
	 * �������������������
	 */
	private Vector vModelkeys = null;		//������������ģ�͵�ģ�ͺ�
	private Map mArgs = new HashMap();	    //����������
	private Map mModels = null;				//�����е�ȫ��ģ��������
	
	/**
	 * �����ͺ�
	 */
	private String subTypeNo = "";
	
	/**
	 * ���캯������ʼ������
	 * @param scenarioID ����ID
	 * @param objectType ��������
	 * @param objectNo ������
	 * @throws Exception
	 */
	public AlarmScenario(String scenarioID) throws Exception{
		this.scenarioID = scenarioID;
	}
	
	/**
	 * ���캯������ʼ������
	 * @param scenarioID ����ID
	 * @param objectType ��������
	 * @param objectNo ������
	 * @param exeTypeNo ִ�����ͺ�
	 * @throws Exception 
	 */
	public AlarmScenario(String scenarioID,String args) throws Exception{
		this(scenarioID);
		this.scenarioArgs = args;
	}
	
	
	/**
	 * ���캯��
	 * @param scenarioID ����ID
	 * @param objectType ��������
	 * @param objectNo ������
	 * @param exeTypeNo ִ�������ͺ�
	 * @param args �����б� ��ʽ��a1=10&a2=20&a3=30����Щ���������õ�������
	 * @throws Exception
	 */
	public AlarmScenario(String scenarioID,String args,String exeTypeNo) throws Exception{
		this(scenarioID,args);
		this.subTypeNo = exeTypeNo;
		this.initArgPoolsFromProfileString(args, ",");
	}
	
	
	/**
	 * ��ʼ������
	 * @param sqlca
	 * @throws Exception
	 */
	public void init(Transaction sqlca) throws Exception{
		
		//��ʼ������������Ϣ
		ARE.getLog().debug("+-----------------+");
		ARE.getLog().debug("| ALS6 ����Ԥ������ |");
		ARE.getLog().debug("+-----------------+");
		ARE.getLog().debug("1.��ȡ����...");
		String sTmp = null;
		BizObject bo = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_CATALOG").createQuery("ScenarioID=:ScenarioID").setParameter("ScenarioID",this.scenarioID).getSingleResult(false);
		if(bo != null){
			this.scenarioName = bo.getAttribute("ScenarioName").getString();
			this.scenarioDescibe = bo.getAttribute("ScenarioDescribe").getString();
			sTmp = bo.getAttribute("DefaultSubTypeNo").getString();
			this.initiateClass = bo.getAttribute("InitiateClass").getString();
		}else{
			throw new Exception(this.scenarioID+"����δ���壡");
		}
		
		//���û�д���exeTypeNo��������ʹ�����õ�Ĭ��ֵ
		if(subTypeNo == null || subTypeNo.length() == 0){
			this.subTypeNo = sTmp;
		}
		ARE.getLog().debug("2.��ʼ������ģ��...");
		initModel(sqlca);	//��ʼ��ģ��
		ARE.getLog().debug("3.��ʼ��ҵ�����...");
		initArgs(sqlca);	//��ʼ��������
		initClass(sqlca);	//������ʼ����̬������
		ARE.getLog().debug("4.������ʼ����ϣ�");
	}
	
	/**
	 * ��ʼ����������
	 * @throws Exception 
	 */
	private void initArgs(Transaction sqlca) throws SQLException,Exception{
		
		this.initArgPoolsFromProfileString(this.scenarioArgs, ",");
		//ȡ����������
		Vector v = new Vector();
		
		List bos = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_ARGS").createQuery("Status=:Status and ScenarioID=:ScenarioID order by SortNo asc").setParameter("Status","1").setParameter("ScenarioID",this.scenarioID).getResultList(false);
		BizObject bo = null;
		for(int i = 0; i < bos.size(); i++){
			bo = (BizObject) bos.get(i);
			v.add(new String[]{bo.getAttribute("ArgsString").getString(),	// key
					           bo.getAttribute("QuerySQL").getString()});	// value SQL
		}
		
		//���ݲ������õ�SQL�����ò���
		for(int i=0;i<v.size();i++){
			String[] arg = (String[])v.get(i);
			String[] keys = arg[0].split(",");						//��ֲ���
			String argSql = pretreat(arg[1]);

			Vector vValues = new Vector();
			
			ARE.getLog().debug("[���ã�����ҵ�����SQL]"+argSql);
			try{
				ASResultSet ars  = sqlca.getASResultSet(argSql);	//ִ�в������õ�SQL
				if(ars.next()){
					for( int m=0;m<keys.length;m++){
						vValues.add(ars.getString(keys[m]));
					}
				}
				ars.getStatement().close();
				ars = null;
			}catch(Exception e){
				throw new Exception("��ע��:�����ִ��в�����Ҫ��SQL��ѯ�еı���һһ��Ӧ��\r\n �����ִ���"+arg[0]+"\r\n����SQL:"+argSql+"\r\n�쳣��Ϣ:"+e.getMessage());
			}
			String[] values = (String [])vValues.toArray( new String[0]);
			setAttribute(keys,values);								//���ò�����
		}
	}
	
	/**
	 * ��ʼ��ģ��
	 * @param sqlca ���ݿ�����
	 * @throws Exception 
	 */
	private void initModel(Transaction sqlca) throws Exception{
		
		mModels = new HashMap();	//��ʼ��ģ�ͳ�
		vModelkeys = new Vector();		//��ʼ��ģ��������
		
		String selectColumn = "ModelID,ModelName,ModelDescribe,ModelType,RunCondition,NoPassDeal,PassDeal,ExecuteScript,PassMessage,NoPassMessage,Remark";
		String[] colArray = selectColumn.split(",");
		
		List bos = JBOFactory.getFactory().getManager("jbo.sys.SCENARIO_MODEL").createQuery("Status=:Status and SubTypeNo like :SubTypeNo and ScenarioID=:ScenarioID order by SortNo asc").setParameter("Status","1").setParameter("SubTypeNo","%"+this.subTypeNo+"%").setParameter("ScenarioID",this.scenarioID).getResultList(false);
		BizObject bo = null;
		for(int i = 0; i < bos.size(); i++){
			bo = (BizObject) bos.get(i);
			Map vp = new HashMap();
			StringBuffer sModeProperties = new StringBuffer("[���ã�����.ģ������]:");
			for(int j = 0; j < colArray.length; j++){
				sModeProperties.append(colArray[j] + "=" + bo.getAttribute(colArray[j]).getString() + "|");
				vp.put(colArray[j], bo.getAttribute(colArray[j]).getString());
			}
			ARE.getLog().debug(sModeProperties.toString());
			vModelkeys.add(bo.getAttribute("ModelID").getString());			//����ģ��KEY
			mModels.put(bo.getAttribute("ModelID").getString(), vp);	//����ģ��
		}
	}
	
	
	/**
	 * ִ�г�����ʼ����
	 * @param sqlca ���ݿ�����
	 * @throws Exception
	 */
	private void initClass(Transaction sqlca) throws Exception{
		
		String sClassName = this.initiateClass;
		
		//���û�����ó�ʼ��ִ���࣬���˳�
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
			ARE.getLog().error("���س�����ʼ�������");
			throw e;
		}
		//������ʼ��ִ���ִ࣬����ɺ󣬷���һ��ASValuePools,����Щ���ݺϲ���������������
		if(tmpMemory != null && tmpMemory.size()>0){
			mArgs.putAll(tmpMemory);
		}
	}
	/**
	 * �������Լ��ϣ����������Լ�ֵ��׼�������ֵ���ˣ�������Ϊ�գ�����ֵ���ˣ������Ĳ��ֲ�����
	 * @param key ��ֵ����
	 * @param value ���Լ���
	 * @throws Exception 
	 * @throws Exception 
	 */
	private void setAttribute(String[] key,String[] value) throws Exception{
		for(int i=0;i<key.length;i++){
			if(i<value.length){
				try {
					setAttribute(key[i],value[i]);
				} catch (Exception e) {
					throw new Exception("����["+key[i]+"]-"+value[i]+"��������:"+e.getMessage());
				}
			}else{
				try {
					setAttribute(key[i],"");
				} catch (Exception e) {
					throw new Exception("����["+key[i]+"]-��������:"+e.getMessage());
				}
			}
		}
	}
	
	/**
	 * ʹ�ò������еĲ������滻���ַ����еĲ���
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
	 * ִ��ģ�ͽű�
	 * @param modelNo ģ�ͱ�� 
	 * @return
	 * @throws Exception 
	 */
	public AlarmMessage execute(Transaction sqlca,String modelNo) throws Exception{
		String sModelType = (String) this.getModelAttribute(modelNo, "ModelType");	//ȡ��ִ������: 10 Java�෽ʽ ,20 SQL,30 AmarScript
		String sScript = (String) this.getModelAttribute(modelNo, "ExecuteScript");	//ȡ��ִ��
		AlarmMessage bReturn  = null;
		if(sScript == null || sScript.length() == 0){
			throw new Exception("ģ��["+modelNo+"]û������ExecuteScript��������ֶ��Ƿ���ֵ");
		}
		sScript = pretreat(sScript.trim());//�ȴ���ű��еı���
		ARE.getLog().debug("[����ģ��]��ģ��:"+modelNo+",ִ�нű�:"+sScript);
		
		if(sModelType.equals("10")){		//java
			bReturn = executeClass(sqlca,modelNo,sScript);
		}else if(sModelType.equals("20")){	//SQL
			bReturn = executeSql(sqlca,modelNo,sScript);
		}else if(sModelType.equals("30")){	//AmarScript
			bReturn = executeAmarScript(sqlca,modelNo,sScript);
		}else{
			throw new Exception("��֧��ģ��["+modelNo+"],�����õĴ�������,�ֶ�ModelType��ֵ["+sModelType+"]����ֵֻ��Ϊ10,20,30");
		}
		return bReturn;
	}
	
	/**
	 * ִ��java���ʽ
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
			throw new Exception("ģ��["+modelNo+"]����,�Ҳ�����Ӧ���ࣺ"+sScript+"!");
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new Exception("ģ��["+modelNo+"]����,������["+sScript+"]ʱ����"+e.getMessage());
		}
		alarmBiz.setAttributePool(this.mArgs);
		AlarmMessage bReturn = null;
		try{
			alarmBiz.run(sqlca);					//ִ��ҵ��Ԥ�����ҵ����
			bReturn = alarmBiz.getAlarmMessage();	//ȡ��ִ�н��
		}catch(Exception e){
			e.printStackTrace();
			throw new Exception("ģ��["+modelNo+"]ִ�г���,���ʽ:"+sScript+"\n"+e.getMessage());
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
	private AlarmMessage executeSql(Transaction sqlca,String modelNo,String sScript) throws Exception{
		String sTmp = null;
		AlarmMessage am = new AlarmMessage();
		try{
			sTmp = sqlca.getString(sScript);
		}catch(Exception e){
			throw new Exception("ģ��["+modelNo+"]����,SQL:"+sScript+"\n"+e.getMessage());
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
	private AlarmMessage executeAmarScript(Transaction sqlca,String modelNo,String sScript) throws Exception{
		
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
			throw new Exception("ģ��["+modelNo+"]����,AmarScript:"+sScript+"\n"+e.getMessage());
		}
		return am;
	}
	
	/**
	 * ���ģ�������������ʽ�Ƿ������ģ������
	 * @param modelNo ģ�ͱ��
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
		if (!bResult )	//����
			return false;
		else
			return true;
	}
	
	/**
	 * ȡ��ģ���ж��������
	 * @param modelNo ģ�ͺ�
	 * @param key ����ֵkey
	 * @return
	 * @throws Exception 
	 */
	public Object getModelAttribute(String modelNo,String key) throws Exception{
		Map model = (HashMap)mModels.get(modelNo);
		return (String)model.get(key);
	}
	
	/**
	 * ��ȡ��������
	 * @param key ������������key
	 * @return
	 * @throws Exception
	 */
	public Object getAttribute(String key) throws Exception{
		return mArgs.get(key);
	}
	
	/**
	 * ���ó�������
	 * @param key ����key(��)
	 * @param value ����ֵ
	 * @throws Exception 
	 * @throws Exception
	 */
	public void setAttribute(String key,String value) throws Exception{
		ARE.getLog().trace("[���ã�����.ҵ�����]:"+key+"="+value);
		mArgs.put(key, value);
	}
	
	
	/**
	 * ������"A=1;B=2;C=3"��Profile Stringת����ValuePool<p>
	 * 
	 * @param data  ԭ�ַ���
	 * @param delim �����ַ���
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
			ARE.getLog().trace("[���ã�����.ҵ�����]:"+sKey+"="+sValue);
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
	 * ������ʼ����������
	 * @return the initiateClass
	 */
	public String getInitiateClass() {
		return initiateClass;
	}
}
