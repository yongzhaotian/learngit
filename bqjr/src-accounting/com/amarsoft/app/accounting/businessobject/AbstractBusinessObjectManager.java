/**
 * Class <code>AbstractBusinessObjectManager</code> �����к������Ĺ�����
 * ����������<code>com.amarsoft.app.accounting.businessobject.BusinessObject</code>�����Ķ���
 * ��Ҫ��������ݿ�������ݡ��������ݡ��������ݵȶ���. 
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
	 * �����������ݵĲ�����ʽ����Ϊinsert��update��delete
	 */
	public static final String operateflag_new 		     = "insert";
	public static final String operateflag_update 		 = "update";
	public static final String operateflag_delete 		 = "delete";
	/**
	 * ��Ҫ��������ݶ����������������<tt>setBusinessObject<tt>�������ۼ�
	 */
	protected int objectNum = 0; 
	/**
	 * ���岻ͬ�������ڴ����أ��ֱ𱣴�insert��update��delete״̬��ҵ�����
	 * <code>com.amarsoft.app.accounting.businessobject.BusinessObject</code>
	 */
	protected ASValuePool newObjects=new ASValuePool();
	protected ASValuePool updateObjects=new ASValuePool();
	protected ASValuePool deleteObjects=new ASValuePool();
	/**
	 * ���崦�����ݶ���ġ��������������
	 * 1�����ʹ��com.amarsoft.are.jbo.BizObjectManager����������ö����д洢�ù�����ʵ��������
	 * 2�����ʹ��java.sql.PreparedStatement���������ö����д洢java.sql.PreparedStatement��ʵ��������Ͷ����ִ�е���װSQL���
	 * �û������ڼ̳����и����Լ�����Ҫ�������÷�
	 */
	protected ASValuePool objectManagers = new ASValuePool();
	/**
	 * �������ݿ����ˮ����أ�
	 *  ���÷������ݿ������ˮ������
	 *  	key=����+�ֶ���+���ڸ�ʽ+��ֵ��ˮ��ʽ
	 *      value=[��ˮ��ʼֵ,��ˮ��ֵֹ]
	 * ��������壺
	 * 1��ÿ�ΰ����λ�ȡ��ˮ����ȡ��ˮ���κ���뻺������У�������ʹ��ʱֱ�Ӵӻ����ȡ���������ݿ���Ӧ��֮��Ľ����ӿ�Ч��
	 * 2��ͨ��java��ͬ�������ڻ�ȡ������ˮʱ�����߳�֮�䲻����ֻ�ȡ��ͬһ��ˮ�����
	 * 3��ͨ�����ݿ�������ݲ���ͬ�����ƣ��ڶ���������Ҳ������ڻ�ȡ��ͬһ��ˮ�����
	 */
	public static ASValuePool serialNoPool = new ASValuePool();
	/**
	 * �������ݴ������ӣ�Ϊ�˼���JBO�������ݴ���ṹ���˴�����JBOTransaction��Transaction��
	 * ��ʹ��JBOTransaction��Transaction����д���ݣ��Ƽ�ʹ��JBOTransaction
	 */
	protected JBOTransaction tx;
	protected Transaction sqlca;
	
	/**
	 * ���캯����ͨ������<code>com.amarsoft.are.sql.Transaction</code>����ʵ����
	 * ���������Լ���̳����ж����ô�������ݿ����ӣ�������ʵ�������ݿ�����
	 * �����ͷ���ݿ�������������������ͷ���ݿ���������޷����ơ�
	 * 
	 * ����AWE����Ϊ�˼���ԭ�����߼������Ա��������д����Transaction�������ע��JBOTransaction����
	 * ����ҳ��͵��ô����������ʶ�Ķ��������Ӹ���
	 * @param sqlca
	 * @throws JBOException
	 */
	protected AbstractBusinessObjectManager(Transaction sqlca) throws JBOException,SQLException{
		this.sqlca = sqlca;
		this.tx = sqlca.getTransaction();
		if(this.tx == null) throw  new JBOException("��Sqlcaδע��JBOTransaction���󣬲��ܵ��ø÷���");
		this.tx.getConnection(this.sqlca).setAutoCommit(false);
	}
	
	/**
	 * ���ɶ�����ˮ���ֶ�
	 * 	����JBO�����ļ��ж������ֶθ����������ֶθ�������1��������ˮ��Ϣ��������������ļ��Ͳ�����������ˮ������Ҳ���ԡ�
	 *  ��ˮ�Ĵ������÷���<tt>getSerialNo</tt>��������õ�����Ϊϵͳ�������ڣ�����SYSTEM_SETUP.BUSINESSDATEֵ�����ڲ���ϵͳ����
	 *  ��������ǰ������������ʱ��Ҫע�⣬���������ˮ��ͻ����
	 *  ͨ��JBO�����ļ��в���query.InitNumֵ��ָ��ÿ�λ�ȡ��ˮ�������뻺�浱�У���������ˮʹ������ٴ����ݿ��л�ȡ
	 * @param businessObject
	 * @throws Exception
	 */
	public void generateObjectNo(BusinessObject businessObject) throws Exception{
		String objectNo="";
		DataElement[] keys = businessObject.getBo().getKey().getAttributes();
		if(keys==null||keys.length == 0) 
		       throw new Exception("����"+businessObject.getObjectType()+"��Keyֵδ����!");
		if(keys.length>1) 
		{
			return;
		}
		JBOFactory f = JBOFactory.getFactory();
		ALSBizObjectManager m = (ALSBizObjectManager)f.getManager(businessObject.getObjectType());
		if(keys[0].getType() == 0 && m.isCreateKey())//�ַ�����ʹ��
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
		       throw new Exception("����"+businessObject.getObjectType()+"��Keyֵδ����!");
		if(keys.length>1) 
		{
			return;
		}
		JBOFactory f = JBOFactory.getFactory();
		ALSBizObjectManager m = (ALSBizObjectManager)f.getManager(businessObject.getObjectType());
		if(keys[0].getType() == 0 && m.isCreateKey())//�ַ�����ʹ��
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
	 * ������ȡָ�����ݱ��ֶε���ˮ��Ϊ�˱���߲����³���������������ڱ���ȡ��ˮ�ų����в���ָ��ֵ���µݹ���õķ�ʽ����ʹ�����������ʽ
	 * @param sDatabase ���ݿ�����
	 * @param sTable ����
	 * @param sColumn �ֶ���
	 * @param sDateFmt ���ڸ�ʽ һ��yyyyMMdd
	 * @param sNoFmt ��ˮ��ʽ
	 * @param today ��ǰ���� yyyy/MM/dd ���뽻������
	 * @param Num ÿ�λ�ȡ��ˮ���� ���Դ�jbo�����ļ�����query.InitNum�л�ȡֵ
	 * @return ���ؼ�1������ˮ��
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
		
	    //�ȴ��ڴ���ȡ�Ƿ����ѻ�ȡ��δʹ�õ���ˮ
		String[] serialNo = (String[])serialNoPool.getAttribute(sTable+sColumn+sDateFmt+sNoFmt);
		if(serialNo != null && !serialNo[0].equals(serialNo[1]) && serialNo[0].startsWith(sDate))//�����д��ڡ������е���ˮδʹ���ꡢ�����е���ˮ����ƥ�䴫������
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
	            if(i<=0)//δ���µ�������ݹ���ø÷������»�ȡ
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
	    serialNoPool.setAttribute(sTable+sColumn+sDateFmt+sNoFmt, sNewSerialNo);//���µ���ˮ������뻺����
	    return sNewSerialNo[0];
	}
	
	/**
	 * �ڲ�������ˮ������£�ͨ��������ʵ�����ݳ�ʼ����ˮ��ʼֵ
	 * @param sTable
	 * @param sColumn
	 * @param sDateFmt
	 * @param sNoFmt
	 * @param today
	 * @param conn
	 * @return ��ʵ��������ˮ+1�ĳ�ʼֵ
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
	 * ��ȡ����tx����
	 * @return JBOTransaction
	 */
	
	public JBOTransaction getTx() {
		return tx;
	}
	
	/**
	 * ��ȡ����sqlca����
	 * @return
	 */
	public Transaction getSqlca() {
		return sqlca;
	}

	/**
	 * ��ȡ������������
	 * @return
	 */
	public int getObjectNum() {
		return objectNum;
	}
	
	/**
	 * ���б����ݣ�װ��com.amarsoft.app.accounting.businessobject.BusinessObject�����ĳ�����԰����ַ���������������
	 * @param list
	 * @param attributeID
	 */
	public void sortBusinessObject(List<BusinessObject> list,String attributeID){
		sortBusinessObject(list, attributeID, BUSINESSOBJECT_CONSTATNTS.TYPE_STRING, BusinessObjectComparator.sortIndicator_asc);
	}
	
	/**
	 * ���б����ݣ�װ��com.amarsoft.app.accounting.businessobject.BusinessObject�����ĳ�����԰��մ�����������ͺ��������ͽ�������
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
	 * �������BusinessObject������뵽��������Ӧ�������ڴ������
	 * �������Ĳ���״̬Ϊ�ջ򲻴�����ֱ��Ĭ��Ϊ����״̬
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
	 * �������BusinessObject������뵽������ָ��������ʽ���ڴ������
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
	 * �������BusinessObject������뵽������ָ��������ʽ���ڴ������
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
	 * ���ݴ����ObjectType��ObjectNo���ö�Ӧ��BusinessObject���󣬲�������뵽������ɾ���������ڴ������
	 * @param objectType
	 * @param objectNo
	 * @throws Exception
	 */
	public void deleteBusinessObject(String objectType,String objectNo) throws Exception{
		BizObject bo = new BizObject(objectType);
		BusinessObject businessObject = new BusinessObject(bo);
		BizObjectKey boKey = businessObject.getBo().getKey();
		DataElement[] keyElement = boKey.getAttributes();
		if(keyElement == null || keyElement.length <= 0) throw new JBOException("�ö���"+objectType+"��δ�������������ܽ���ɾ��������");
		String[] objects = objectNo.split(BusinessObject.splitRegex);
		if(keyElement.length != objects.length) throw new JBOException("�ö������͡�"+objectType+"���������ʹ���Ķ����š�"+objectNo+"����ƥ�䣡");
		for(int i = 0; i < keyElement.length; i++)
		{
			businessObject.setAttributeValue(keyElement[i].getName(), objects[i]);
		}
		setBusinessObject(operateflag_delete, businessObject);
	}
	
	/**
	 * ����ObjectType��ȡJBO�����ݽṹ������������
	 * ����ObjectNo��ȡ���������ֶεĲ���ֵ���죺��ѯwhere�����Ͳ�ѯ�����������
	 * ͨ������ֵ�ٵ��ö����ȡ����loadBusinessObjects��ȡһ�����ݶ���
	 * 
	 * ������ݱ�����Ϊ�������objectNoֵ���öය�ŷָ����Ӵ��룬����˳������ϸ��������Ķ����˳��
	 * @param objectType
	 * @param objectNo
	 * @return BusinessObject
	 * @throws Exception
	 */
	public BusinessObject loadObjectWithKey(String objectType,String objectNo) throws Exception{
		BizObjectClass clazz = JBOFactory.getBizObjectClass(objectType);
		String[] keys = clazz.getKeyAttributes();
		if(keys == null || keys.length <= 0) throw new JBOException("�ö���"+objectType+"��δ����������");
		String[] objects = objectNo.split(BusinessObject.splitRegex);
		if(keys.length != objects.length) throw new JBOException("�ö������͡�"+objectType+"���������ʹ���Ķ����š�"+objectNo+"����ƥ�䣡");
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
	 * ����Where�����͸������������ݿ��м��ض�����ݶ���
	 * ע�⸽���������븲��Where��������ı���ֵ
	 * Where�����ľ���д������μ�JBO��ѯд��������ĵ�
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public abstract List<BusinessObject> loadBusinessObjects(String objectType,String whereClause,ASValuePool parameter) throws Exception;
	
	/**
	 * ����Where�����͸������������ݿ��м��ض�����ݶ����ڸ��ݼ��ص����ݶ�����ع��������ݶ��󣬹�������Ĳ���������${������}�ķ�ʽ���ֹ����ֶ�
	 * ע�⸽���������븲��Where��������ı���ֵ
	 * Where�����ľ���д������μ�JBO��ѯд��������ĵ�
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public abstract List<BusinessObject> loadBusinessObjects(String objectType,String whereClause,ASValuePool parameter,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception;
	
	/**
	 * ���ݶ����������ع���������Ϣ
	 * ����Where�����͸������������ݿ��м��ض�����ݶ��󣬹�������Ĳ���������${������}�ķ�ʽ���ֹ����ֶ�
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public abstract List<BusinessObject> loadBusinessObjects(List<BusinessObject> boList,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception;
	
	/**
	 * ����һ����������ع���������Ϣ
	 * ����Where�����͸������������ݿ��м��ض�����ݶ��󣬹�������Ĳ���������${������}�ķ�ʽ���ֹ����ֶ�
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return BusinessObject
	 * @throws Exception
	 */
	public abstract BusinessObject loadBusinessObject(BusinessObject bo,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception;
	
	/**
	 * ���ݴ����BusinessObejct��һ����������ݸ��±���
	 * �˴������ݱ���ֻ��ִ�����ݿ���¶�����δִ�����ݿ�commit��rollback
	 * @param businessobject
	 * @throws Exception
	 */
	public abstract void updateBusinessObject(BusinessObject businessobject) throws Exception;
	
	
	/**
	 * ���ݴ����BusinessObejct��һ����������ݲ��붯��
	 * �˴������ݱ���ֻ��ִ�����ݿ���붯����δִ�����ݿ�commit��rollback
	 * @param businessobject
	 * @throws Exception
	 */
	public abstract void insertBusinessObject(BusinessObject businessobject) throws Exception;
	

	/**
	 * ���ݴ����BusinessObejct��һ�����������ɾ������
	 * �˴������ݱ���ֻ��ִ�����ݿ�ɾ��������δִ�����ݿ�commit��rollback
	 * @param businessobject
	 * @throws Exception
	 */
	public abstract void deleteBusinessObject(BusinessObject businessobject) throws Exception;
	
	
	/**
	 * �����ڴ����طֱ���в�ͬ�����ݸ��²���
	 * �����ڴ������е��������
	 * @throws Exception
	 */
	public abstract void updateDB() throws Exception;
	
	
	/**
	 * ����������еĶ�����Ϣ
	 * @throws Exception
	 */
	public void clear() throws Exception{
		if(newObjects!=null) newObjects.resetPool();
		if(updateObjects!=null) updateObjects.resetPool();
		if(deleteObjects!=null) deleteObjects.resetPool();
	}
	
	
	
	/**
	 * ����������е���Դ����objectManagers�����б����Statement��
	 * @throws Exception
	 */
	public abstract void close() throws Exception;
	
	/**
	 * ʹ��JVM���ջ��ƣ�����ʹ��ʱ�Զ�����close�����ͷ���Դ��
	 * @throws Exception
	 */
	public void finalize() throws Exception{
		close();
	}
	
	/**
	 * ִ�����ݿ��ύ
	 * @throws Exception
	 */
	public void commit() throws Exception{
		this.tx.getConnection(this.sqlca).commit();
	}
	
	/**
	 * ִ�����ݿ�ع�
	 * @throws Exception
	 */
	public void rollback() throws Exception{
		this.tx.getConnection(this.sqlca).rollback();
	}
	
	/**
	 * ����Ķ�����ԭ�Ŵ�ϵͳ�Ķ���ת����Ķ���ֱ�ӵõ�������
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
