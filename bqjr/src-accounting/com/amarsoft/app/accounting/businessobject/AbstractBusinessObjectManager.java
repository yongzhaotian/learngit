/**
 * Class <code>AbstractBusinessObjectManager</code> 是所有核算对象的管理器
 * 它用来管理<code>com.amarsoft.app.accounting.businessobject.BusinessObject</code>产生的对象
 * 主要负责从数据库加载数据、更新数据、插入数据等动作. 
 *
 * @author  ygwang xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.are.jbo.JBOException
 * @see com.amarsoft.are.jbo.JBOFactory
 * @see com.amarsoft.are.jbo.JBOTransaction
 * @see com.amarsoft.are.jbo.impl.ALSBizObjectManager
 * @see com.amarsoft.app.accounting.businessobject.BusinessObject
 * @since   JDK1.6
 */

package com.amarsoft.app.accounting.businessobject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.impl.ALSBizObjectManager;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;

public abstract class AbstractBusinessObjectManager{
	
	/**
	 * 定义对象的数据的操作方式，分为insert、update、delete
	 */
	public static final String operateflag_new 		     = "insert";
	public static final String operateflag_update 		 = "update";
	public static final String operateflag_delete 		 = "delete";
	/**
	 * 需要保存的数据对象数量，程序会在<tt>setBusinessObject<tt>方法中累加
	 */
	protected int objectNum = 0; 
	/**
	 * 定义不同的数据内存对象池，分别保存insert、update、delete状态的业务对象
	 * <code>com.amarsoft.app.accounting.businessobject.BusinessObject</code>
	 */
	protected ASValuePool newObjects=new ASValuePool();
	protected ASValuePool updateObjects=new ASValuePool();
	protected ASValuePool deleteObjects=new ASValuePool();
	/**
	 * 定义处理数据对象的“管理器”缓存池
	 * 1、如果使用com.amarsoft.are.jbo.BizObjectManager管理器，则该对象中存储该管理器实例化对象
	 * 2、如果使用java.sql.PreparedStatement管理对象，则该对象中存储java.sql.PreparedStatement的实例化对象和多次需执行的组装SQL语句
	 * 用户可以在继承类中根据自己的需要来扩充用法
	 */
	protected ASValuePool objectManagers = new ASValuePool();
	/**
	 * 定义数据库表流水缓存池：
	 *  其用法与数据库最大流水表类似
	 *  	key=表名+字段名+日期格式+数值流水格式
	 *      value=[流水起始值,流水终止值]
	 * 其设计意义：
	 * 1、每次按批次获取流水，获取流水批次后放入缓存对象中，程序在使用时直接从缓存读取，减少数据库与应用之间的交互加快效率
	 * 2、通过java中同步机制在获取缓存流水时，多线程之间不会出现获取到同一流水的情况
	 * 3、通过数据库层面数据操作同步机制，在多进程情况下也不会存在获取到同一流水的情况
	 */
	public static ASValuePool serialNoPool = new ASValuePool();
	/**
	 * 定义数据处理连接，为了兼容JBO基础数据处理结构，此处定义JBOTransaction、Transaction，
	 * 并使用JBOTransaction、Transaction来读写数据，推荐使用JBOTransaction
	 */
	protected JBOTransaction tx;
	protected Transaction sqlca;
	
	/**
	 * 构造函数，通过传入<code>com.amarsoft.are.sql.Transaction</code>进行实例化
	 * 本抽象类以及其继承类中都采用传入的数据库连接，不单独实例化数据库连接
	 * 避免多头数据库操作导致死锁，避免多头数据库操作事务无法控制。
	 * 
	 * 基于AWE程序，为了兼用原程序逻辑，所以本抽象类中传入的Transaction对象必须注册JBOTransaction对象
	 * 避免页面和调用代码出现无意识的多数据连接更新
	 * @param sqlca
	 * @throws JBOException
	 */
	protected AbstractBusinessObjectManager(Transaction sqlca) throws JBOException,SQLException{
		this.sqlca = sqlca;
		this.tx = sqlca.getTransaction();
		if(this.tx == null) throw  new JBOException("该Sqlca未注册JBOTransaction对象，不能调用该方法");
		this.tx.getConnection(this.sqlca).setAutoCommit(false);
	}
	
	/**
	 * 生成对象流水号字段
	 * 	根据JBO配置文件判断主键字段个数，主键字段个数大于1则不生成流水信息，如果本身配置文件就不创建主键流水，这里也忽略。
	 *  流水的创建调用方法<tt>getSerialNo</tt>，这里采用的日期为系统交易日期（即表SYSTEM_SETUP.BUSINESSDATE值）不在采用系统日期
	 *  所以在向前调整交易日期时需要注意，以免出现流水冲突错误
	 *  通过JBO配置文件中参数query.InitNum值来指定每次获取流水个数放入缓存当中，缓存中流水使用完后再从数据库中获取
	 * @param businessObject
	 * @throws Exception
	 */
	public void generateObjectNo(BusinessObject businessObject) throws Exception{
		String objectNo="";
		DataElement[] keys = businessObject.getBo().getKey().getAttributes();
		if(keys==null||keys.length == 0) 
		       throw new Exception("对象"+businessObject.getObjectType()+"的Key值未定义!");
		if(keys.length>1) 
		{
			return;
		}
		JBOFactory f = JBOFactory.getFactory();
		ALSBizObjectManager m = (ALSBizObjectManager)f.getManager(businessObject.getObjectType());
		if(keys[0].getType() == 0 && m.isCreateKey())//字符串才使用
		{
			objectNo=businessObject.getString(keys[0].getName());
			if(objectNo==null||objectNo.length()==0){
				Object o = m.getQueryProperties().get("InitNum");
				Object p = m.getQueryProperties().get("Pre");
				String pre = "";
				int initNum = 1;
				if(o != null) initNum = Integer.valueOf((String)o);
				if(p != null) pre = String.valueOf(p);
				objectNo = AbstractBusinessObjectManager.getSerialNo(this.sqlca.getDatabase(),businessObject.getBo().getBizObjectClass().getName(),keys[0].getName(),"yyyyMMdd","00000000",StringFunction.getToday(),initNum);
				businessObject.setAttributeValue(keys[0].getName(), pre+objectNo);
			}
		}
	}
	
	public void setObjectNo(BusinessObject businessObject,String objectNo) throws Exception{
		DataElement[] keys = businessObject.getBo().getKey().getAttributes();
		if(keys==null||keys.length == 0) 
		       throw new Exception("对象"+businessObject.getObjectType()+"的Key值未定义!");
		if(keys.length>1) 
		{
			return;
		}
		JBOFactory f = JBOFactory.getFactory();
		ALSBizObjectManager m = (ALSBizObjectManager)f.getManager(businessObject.getObjectType());
		if(keys[0].getType() == 0 && m.isCreateKey())//字符串才使用
		{
			objectNo=businessObject.getString(keys[0].getName());
			if(objectNo==null||objectNo.length()==0){
				businessObject.setAttributeValue(keys[0].getName(), objectNo);
			}
		}
	}
	
	public void generateObjectNo(BusinessObject businessObject,String type) throws Exception{
		String objectNo=null;
		if("UUID".equals(type)){
			objectNo=ExtendedFunctions.replaceAllIgnoreCase(java.util.UUID.randomUUID().toString(),"-","");
			setObjectNo(businessObject, objectNo);
		}
		else{
			generateObjectNo(businessObject);
		}
	}

	/**
	 * 批量获取指定数据表及字段的流水，为了避免高并发下出现死锁的情况，在本获取流水号程序中采用指定值更新递归调用的方式，不使用锁表操作方式
	 * @param sDatabase 数据库连接
	 * @param sTable 表名
	 * @param sColumn 字段名
	 * @param sDateFmt 日期格式 一般yyyyMMdd
	 * @param sNoFmt 流水格式
	 * @param today 当前日期 yyyy/MM/dd 传入交易日期
	 * @param Num 每次获取流水总数 可以从jbo配置文件属性query.InitNum中获取值
	 * @return 返回加1的新流水号
	 * @throws Exception
	 * @author xjzhao
	 */
	public synchronized final static String getSerialNo(String sDatabase, String sTable, String sColumn, String sDateFmt, String sNoFmt, String today,int Num)
    throws Exception
	{
		if(Num <= 0) Num = 1;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	    SimpleDateFormat simpledateformat = new SimpleDateFormat(sDateFmt);
	    DecimalFormat decimalformat = new DecimalFormat(sNoFmt);
	    String sDate = simpledateformat.format(sdf.parse(today));
	    int iDateLen = sDate.length();
		
	    //先从内存中取是否有已获取的未使用的流水
		String[] serialNo = (String[])serialNoPool.getAttribute(sTable+sColumn+sDateFmt+sNoFmt);
		if(serialNo != null && !serialNo[0].equals(serialNo[1]) && serialNo[0].startsWith(sDate))//缓存中存在、缓存中的流水未使用完、缓存中的流水必须匹配传入日期
		{
			int iMaxNo = Integer.valueOf(serialNo[0].substring(iDateLen)).intValue();
			serialNo[0] = sDate + decimalformat.format(iMaxNo + 1);
			return serialNo[0];
		}
		
	    Connection conn = null;
	    String sQuerySql = "select MaxSerialNo from OBJECT_MAXSN where TableName=? and ColumnName=? and DateFmt=? and NoFmt=?";
	    String sUpdateSql = "update OBJECT_MAXSN set MaxSerialNo = ? where TableName=? and ColumnName=? and DateFmt=? and NoFmt=? and MaxSerialNo = ?";
	    String sInsertSql = "insert into OBJECT_MAXSN (TABLENAME,COLUMNNAME,MAXSERIALNO,DATEFMT,NOFMT) values (?,?,?,?,?)";
	    
	    String[] sNewSerialNo = new String[2];
	    sTable = sTable.toUpperCase();
	    sColumn = sColumn.toUpperCase();
	    int iMaxNo = 0;
	    try
	    {
	        conn = ARE.getDBConnection(sDatabase);
	        conn.setAutoCommit(false);
	    }
	    catch(SQLException ex)
	    {
	        throw new JBOException(1327, ex);
	    }
	    try
	    {
	        PreparedStatement pst = conn.prepareStatement(sQuerySql);
	        pst.setString(1, sTable);
	        pst.setString(2, sColumn);
	        pst.setString(3, sDateFmt);
	        pst.setString(4, sNoFmt);
	        ResultSet rs = pst.executeQuery();
	        if(rs.next())
	        {
	            String sMaxSerialNo = rs.getString(1);
	            rs.close();
	            pst.close();
	            iMaxNo = 0;
	            if(sMaxSerialNo != null && sMaxSerialNo.indexOf(sDate, 0) != -1&&(SystemConfig.getSystemDate().compareTo(sDate)<=0 || SystemConfig.getBusinessDate().compareTo(sDate)<=0))
	            {
	                iMaxNo = Integer.valueOf(sMaxSerialNo.substring(iDateLen)).intValue();
	                sNewSerialNo[0] = sDate + decimalformat.format(iMaxNo + 1);
	                sNewSerialNo[1] = sDate + decimalformat.format(iMaxNo + Num);
	            } else
	            {
	            	sNewSerialNo[0] = getInitSerialNo(sTable, sColumn, sDateFmt, sNoFmt, sdf.parse(today), conn);
	            	iMaxNo = Integer.valueOf(sNewSerialNo[0].substring(iDateLen)).intValue();
	            	sNewSerialNo[1] = sDate + decimalformat.format(iMaxNo + Num-1);
	            }
	            PreparedStatement pst_update = conn.prepareStatement(sUpdateSql);
	            pst_update.setString(1, sNewSerialNo[1]);
	            pst_update.setString(2, sTable);
	            pst_update.setString(3, sColumn);
	            pst_update.setString(4, sDateFmt);
	            pst_update.setString(5, sNoFmt);
	            pst_update.setString(6, sMaxSerialNo);
	            int i = pst_update.executeUpdate();
	            pst_update.close();
	            if(i<=0)//未更新到数据则递归调用该方法重新获取
	            {
	            	return AbstractBusinessObjectManager.getSerialNo(sDatabase, sTable, sColumn, sDateFmt, sNoFmt, today, Num);
	            }
	        } else
	        {
	            rs.close();
	            pst.close();
	            sNewSerialNo[0] = getInitSerialNo(sTable, sColumn, sDateFmt, sNoFmt, sdf.parse(today), conn);
	            iMaxNo = Integer.valueOf(sNewSerialNo[0].substring(iDateLen)).intValue();
	            sNewSerialNo[1] = sDate + decimalformat.format(iMaxNo + Num-1);
	            PreparedStatement pst_insert = conn.prepareStatement(sInsertSql);
	            pst_insert.setString(1, sTable);
	            pst_insert.setString(2, sColumn);
	            pst_insert.setString(3, sNewSerialNo[1]);
	            pst_insert.setString(4, sDateFmt);
	            pst_insert.setString(5, sNoFmt);
	            pst_insert.executeUpdate();
	            pst_insert.close();
	        }
	        conn.commit();
	    }
	    catch(Exception e)
	    {
	        try
	        {
	            conn.rollback();
	        }
	        catch(SQLException e1)
	        {
	            ARE.getLog().error(e1);
	        }
	        ARE.getLog().debug("getSerialNo...\u5931\u8D25[" + e.getMessage() + "]!", e);
	        throw new JBOException(1327, e);
	    }
	    finally
	    {
	        if(conn != null)
	        {
	            try
	            {
	                conn.close();
	            }
	            catch(SQLException e)
	            {
	                ARE.getLog().error(e);
	            }
	            conn = null;
	        }
	    }
	    serialNoPool.setAttribute(sTable+sColumn+sDateFmt+sNoFmt, sNewSerialNo);//将新的流水区间放入缓存中
	    return sNewSerialNo[0];
	}
	
	/**
	 * 在不存在流水的情况下，通过搜索表实际数据初始化流水初始值
	 * @param sTable
	 * @param sColumn
	 * @param sDateFmt
	 * @param sNoFmt
	 * @param today
	 * @param conn
	 * @return 表实际数据流水+1的初始值
	 * @throws Exception
	 */
	private final static String getInitSerialNo(String sTable, String sColumn, String sDateFmt, String sNoFmt, Date today, Connection conn)
	    throws Exception
	{
	    SimpleDateFormat sdfTemp = new SimpleDateFormat(sDateFmt);
	    DecimalFormat dfTemp = new DecimalFormat(sNoFmt);
	    ResultSet rsTemp = null;
	    String sPrefix = sdfTemp.format(today);
	    int iDateLen = sPrefix.length();
	    String sSql = "select max(" + sColumn + ") from " + sTable + " where " + sColumn + " like '" + sPrefix + "%' ";
	    Statement st = conn.createStatement();
	    rsTemp = st.executeQuery(sSql);
	    int iMaxNo = 0;
	    if(rsTemp.next())
	    {
	        String sMaxSerialNo = rsTemp.getString(1);
	        if(sMaxSerialNo != null)
	            iMaxNo = Integer.valueOf(sMaxSerialNo.substring(iDateLen)).intValue();
	    }
	    st.close();
	    rsTemp.close();
	    String sNewSerialNo = sPrefix + dfTemp.format(iMaxNo + 1);
	    ARE.getLog().info("newSerialNo[" + sTable + "][" + sColumn + "]=[" + sNewSerialNo + "]");
	    return sNewSerialNo;
	}
	
	/**
	 * 获取变量tx对象
	 * @return JBOTransaction
	 */
	
	public JBOTransaction getTx() {
		return tx;
	}
	
	/**
	 * 获取变量sqlca对象
	 * @return
	 */
	public Transaction getSqlca() {
		return sqlca;
	}

	/**
	 * 获取变量对象数量
	 * @return
	 */
	public int getObjectNum() {
		return objectNum;
	}
	
	/**
	 * 对列表数据（装有com.amarsoft.app.accounting.businessobject.BusinessObject）针对某个属性按照字符串进行升序排列
	 * @param list
	 * @param attributeID
	 */
	public void sortBusinessObject(List<BusinessObject> list,String attributeID){
		sortBusinessObject(list, attributeID, BUSINESSOBJECT_CONSTATNTS.TYPE_STRING, BusinessObjectComparator.sortIndicator_asc);
	}
	
	/**
	 * 对列表数据（装有com.amarsoft.app.accounting.businessobject.BusinessObject）针对某个属性按照传入的数据类型和排序类型进行排列
	 * @param list
	 * @param attributeID
	 * @param dataType
	 * @param sortIndicator
	 */
	public void sortBusinessObject(List<BusinessObject> list,String attributeID,String dataType,int sortIndicator){
		BusinessObjectComparator comparator = new BusinessObjectComparator();
		comparator.attributeID=attributeID;
		comparator.sortIndicator = sortIndicator;
		comparator.dataType = dataType;
		Collections.sort(list,comparator);
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器对应操作的内存对象中
	 * 如果对象的操作状态为空或不存在则直接默认为新增状态
	 * @param businessobject
	 * @throws Exception
	 */
	public void setBusinessObject(BusinessObject businessobject) throws Exception{
		if(businessobject.db_operate_flag==null||businessobject.db_operate_flag.length()==0){
			businessobject.db_operate_flag=operateflag_new;
		}
		setBusinessObject(businessobject.db_operate_flag,businessobject);
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器指定操作方式的内存对象中
	 * @param operateFlag
	 * @param objectList
	 * @throws Exception
	 */
	public void setBusinessObjects(String operateFlag,List<BusinessObject> objectList) throws Exception{
		if(objectList == null) return;
		for(BusinessObject o:objectList)
		{
			setBusinessObject(operateFlag,o);
		}
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器指定操作方式的内存对象中
	 * @param operateFlag
	 * @param businessObject
	 * @throws Exception
	 */
	public void setBusinessObject(String operateFlag,BusinessObject businessObject) throws Exception{
		if(operateFlag.equalsIgnoreCase(operateflag_new)){
			ArrayList<BusinessObject> list=(ArrayList<BusinessObject>) newObjects.getAttribute(businessObject.getObjectType());
			if(list==null){
				list=new ArrayList<BusinessObject>();
				newObjects.setAttribute(businessObject.getObjectType(), list);
			}
			if(!list.contains(businessObject)){
				list.add(businessObject);
				this.objectNum++;
			}
		}
		else if(operateFlag.equalsIgnoreCase(operateflag_update)){
			ArrayList<BusinessObject> list=(ArrayList<BusinessObject>) updateObjects.getAttribute(businessObject.getObjectType());
			if(list==null){
				list=new ArrayList<BusinessObject>();
				updateObjects.setAttribute(businessObject.getObjectType(), list);
			}
			if(!list.contains(businessObject)){
				list.add(businessObject);
				this.objectNum++;
			}
		}
		else if(operateFlag.equalsIgnoreCase(operateflag_delete)){
			ArrayList<BusinessObject> list = (ArrayList<BusinessObject>)newObjects.getAttribute(businessObject.getObjectType());
			if(list!=null && list.contains(businessObject))
			{
				list.remove(businessObject);
				this.objectNum--;
			}
			else
			{
				list=(ArrayList<BusinessObject>) deleteObjects.getAttribute(businessObject.getObjectType());
				if(list==null){
					list=new ArrayList<BusinessObject>();
					deleteObjects.setAttribute(businessObject.getObjectType(), list);
				}
				if(!list.contains(businessObject)){
					list.add(businessObject);
					this.objectNum++;
				}
			}
		}
	}

	/**
	 * 根据传入的ObjectType、ObjectNo设置对应的BusinessObject对象，并将其存入到管理器删除操作的内存对象中
	 * @param objectType
	 * @param objectNo
	 * @throws Exception
	 */
	public void deleteBusinessObject(String objectType,String objectNo) throws Exception{
		BizObject bo = new BizObject(objectType);
		BusinessObject businessObject = new BusinessObject(bo);
		BizObjectKey boKey = businessObject.getBo().getKey();
		DataElement[] keyElement = boKey.getAttributes();
		if(keyElement == null || keyElement.length <= 0) throw new JBOException("该对象【"+objectType+"】未定义主键，不能进行删除操作！");
		String[] objects = objectNo.split(BusinessObject.splitRegex);
		if(keyElement.length != objects.length) throw new JBOException("该对象类型【"+objectType+"】的主键和传入的对象编号【"+objectNo+"】不匹配！");
		for(int i = 0; i < keyElement.length; i++)
		{
			businessObject.setAttributeValue(keyElement[i].getName(), objects[i]);
		}
		setBusinessObject(operateflag_delete, businessObject);
	}
	
	/**
	 * 根据ObjectType获取JBO的数据结构定义主键参数
	 * 根据ObjectNo获取主键各个字段的参数值构造：查询where条件和查询传入参数对象
	 * 通过上述值再调用对象获取方法loadBusinessObjects获取一个数据对象
	 * 
	 * 如果数据表主键为多个，则objectNo值采用多逗号分隔连接传入，传入顺序必须严格按照主键的定义的顺序
	 * @param objectType
	 * @param objectNo
	 * @return BusinessObject
	 * @throws Exception
	 */
	public BusinessObject loadObjectWithKey(String objectType,String objectNo) throws Exception{
		BizObjectClass clazz = JBOFactory.getBizObjectClass(objectType);
		String[] keys = clazz.getKeyAttributes();
		if(keys == null || keys.length <= 0) throw new JBOException("该对象【"+objectType+"】未定义主键！");
		String[] objects = objectNo.split(BusinessObject.splitRegex);
		if(keys.length != objects.length) throw new JBOException("该对象类型【"+objectType+"】的主键和传入的对象编号【"+objectNo+"】不匹配！");
		String filter = "1=1";
		ASValuePool parameter = new ASValuePool();
		for(int i = 0; i < keys.length; i++)
		{
			parameter.setAttribute(keys[i], objects[i]);
			filter += " and "+keys[i]+"=:"+keys[i];
		}
		List<BusinessObject> a=this.loadBusinessObjects(objectType, filter, parameter);
		if(a.isEmpty()) return null;
		return a.get(0);
	}
	
	/**
	 * 根据Where条件和附带参数从数据库中加载多个数据对象
	 * 注意附带参数必须覆盖Where条件所需的变量值
	 * Where条件的具体写法，请参见JBO查询写法的相关文档
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public abstract List<BusinessObject> loadBusinessObjects(String objectType,String whereClause,ASValuePool parameter) throws Exception;
	
	/**
	 * 根据Where条件和附带参数从数据库中加载多个数据对象，在根据加载的数据对象加载关联的数据对象，关联对象的参数的中以${变量名}的方式体现关联字段
	 * 注意附带参数必须覆盖Where条件所需的变量值
	 * Where条件的具体写法，请参见JBO查询写法的相关文档
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public abstract List<BusinessObject> loadBusinessObjects(String objectType,String whereClause,ASValuePool parameter,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception;
	
	/**
	 * 根据多个主对象加载关联对象信息
	 * 根据Where条件和附带参数从数据库中加载多个数据对象，关联对象的参数的中以${变量名}的方式体现关联字段
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public abstract List<BusinessObject> loadBusinessObjects(List<BusinessObject> boList,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception;
	
	/**
	 * 根据一个主对象加载关联对象信息
	 * 根据Where条件和附带参数从数据库中加载多个数据对象，关联对象的参数的中以${变量名}的方式体现关联字段
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return BusinessObject
	 * @throws Exception
	 */
	public abstract BusinessObject loadBusinessObject(BusinessObject bo,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception;
	
	/**
	 * 根据传入的BusinessObejct单一对象进行数据更新保存
	 * 此处的数据保存只是执行数据库更新动作，未执行数据库commit和rollback
	 * @param businessobject
	 * @throws Exception
	 */
	public abstract void updateBusinessObject(BusinessObject businessobject) throws Exception;
	
	
	/**
	 * 根据传入的BusinessObejct单一对象进行数据插入动作
	 * 此处的数据保存只是执行数据库插入动作，未执行数据库commit和rollback
	 * @param businessobject
	 * @throws Exception
	 */
	public abstract void insertBusinessObject(BusinessObject businessobject) throws Exception;
	

	/**
	 * 根据传入的BusinessObejct单一对象进行数据删除动作
	 * 此处的数据保存只是执行数据库删除动作，未执行数据库commit和rollback
	 * @param businessobject
	 * @throws Exception
	 */
	public abstract void deleteBusinessObject(BusinessObject businessobject) throws Exception;
	
	
	/**
	 * 根据内存对象池分别进行不同的数据更新操作
	 * 并将内存对象池中的数据清空
	 * @throws Exception
	 */
	public abstract void updateDB() throws Exception;
	
	
	/**
	 * 清理管理器中的对象信息
	 * @throws Exception
	 */
	public void clear() throws Exception{
		if(newObjects!=null) newObjects.resetPool();
		if(updateObjects!=null) updateObjects.resetPool();
		if(deleteObjects!=null) deleteObjects.resetPool();
	}
	
	
	
	/**
	 * 清理管理器中的资源，如objectManagers对象中保存的Statement等
	 * @throws Exception
	 */
	public abstract void close() throws Exception;
	
	/**
	 * 使用JVM回收机制，对象不使用时自动调用close方法释放资源，
	 * @throws Exception
	 */
	public void finalize() throws Exception{
		close();
	}
	
	/**
	 * 执行数据库提交
	 * @throws Exception
	 */
	public void commit() throws Exception{
		this.tx.getConnection(this.sqlca).commit();
	}
	
	/**
	 * 执行数据库回滚
	 * @throws Exception
	 */
	public void rollback() throws Exception{
		this.tx.getConnection(this.sqlca).rollback();
	}
	
	/**
	 * 传入的对象是原信贷系统的对象，转化后的对象直接得到表数据
	 */
	public static BusinessObject getBusinessObject(String objectType,String objectNo,Transaction Sqlca) throws Exception
	{
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		BusinessObject bo = null;
		if("CreditApply".equalsIgnoreCase(objectType))
		{
			bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_apply, objectNo);
			bo.setAttributeValue("Currency", bo.getString("BusinessCurrency"));
		}
		else if("ApproveApply".equalsIgnoreCase(objectType))
		{
			bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_approve, objectNo);
			bo.setAttributeValue("Currency", bo.getString("BusinessCurrency"));
		}
		else if("BusinessContract".equalsIgnoreCase(objectType) || "ReinforceContract".equalsIgnoreCase(objectType) || "AfterLoan".equalsIgnoreCase(objectType))
		{
			bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract, objectNo);
			bo.setAttributeValue("Currency", bo.getString("BusinessCurrency"));
		}
		else if("PutOutApply".equalsIgnoreCase(objectType))
		{
			bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_putout, objectNo);
			bo.setAttributeValue("Currency", bo.getString("BusinessCurrency"));
		}
		else if("Loan".equalsIgnoreCase(objectType))
		{
			bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan, objectNo);
		}
		else if(BUSINESSOBJECT_CONSTATNTS.loan_change.equalsIgnoreCase(objectType))
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("SerialNo", objectNo);
			List<BusinessObject> boList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_change, " select al.ProductVersion,al.BusinessType,al.Currency,\"o.*\" from o,jbo.app.ACCT_LOAN al where al.SerialNo = o.ObjectNo and o.ObjectType='jbo.app.ACCT_LOAN' and o.SerialNo = :SerialNo", as);
			if(boList.size() >= 1) bo = boList.get(0);
		}
		else if(BUSINESSOBJECT_CONSTATNTS.back_bill.equalsIgnoreCase(objectType))
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("SerialNo", objectNo);
			List<BusinessObject> boList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.back_bill, " select al.ProductVersion,al.BusinessType,\"o.*\" from o,jbo.app.ACCT_LOAN al where al.SerialNo = o.ObjectNo and o.ObjectType='jbo.app.ACCT_LOAN' and o.SerialNo = :SerialNo", as);
			if(boList.size() >= 1) bo = boList.get(0);
		}
		else if(BUSINESSOBJECT_CONSTATNTS.flow_opinion.equalsIgnoreCase(objectType))
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("OpinionNo", objectNo);
			List<BusinessObject> boList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, " select ba.ProductVersion,ba.BusinessType,o.BusinessCurrency as v.Currency,\"o.*\" from o,jbo.app.BUSINESS_APPLY ba where ba.SerialNo = o.ObjectNo and o.OpinionNo = :OpinionNo", as);
			if(boList.size() >= 1) bo = boList.get(0);
		}
		else bo = bom.loadObjectWithKey(objectType, objectNo);
		
		return bo;
	}
}
