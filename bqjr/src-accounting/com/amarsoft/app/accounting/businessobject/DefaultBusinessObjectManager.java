/**
 * Class <code>DefaultBusinessObjectManager</code> 是所有核算对象的管理器
 * 它用来管理<code>com.amarsoft.app.accounting.businessobject.BusinessObject</code>产生的对象，包括加载、更新、插入等动作. 
 * 该管理器是基于JBO的数据对象管理<code>com.amarsoft.are.jbo.BizObjectManager</code>，由于JBO是针对单笔数据进行处理，因此此管理器不适用于批量程序
 * 只能使用在效率要求不高的单笔数据处理。
 * @author  ygwang xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.are.jbo.BizObject
 * @see com.amarsoft.are.jbo.BizObjectManager
 * @see com.amarsoft.are.jbo.BizObjectKey
 * @see com.amarsoft.are.jbo.BizObjectQuery
 * @see com.amarsoft.app.accounting.businessobject.BusinessObject
 * @since   JDK1.6
 */

package com.amarsoft.app.accounting.businessobject;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;

public class DefaultBusinessObjectManager extends AbstractBusinessObjectManager{
	
	public DefaultBusinessObjectManager(Transaction sqlca) throws JBOException, SQLException{
		super(sqlca);
	}

	/**
	 * 根据ObjectType获取JBO的数据结构定义
	 * 根据Where条件和Where条件附带参数从数据库中加载多个数据对象
	 * 并返回多个数据对象的List
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public List<BusinessObject> loadBusinessObjects(String objectType,String whereClause,ASValuePool parameter) throws Exception{
		BizObjectManager m = null;
		if(objectManagers.getAttribute(objectType) == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m = f.getManager(objectType);
			tx.join(m);
			objectManagers.setAttribute(objectType, m);
		}
		else
			m = (BizObjectManager)objectManagers.getAttribute(objectType);
		
		BizObjectQuery q = m.createQuery(whereClause); 
		for(Object key:parameter.getKeys())
		{
			q.setParameter((String)key, parameter.getString((String)key));
		}
		List<BizObject> boTmp = (List<BizObject>)q.getResultList(true);
		List<BusinessObject> boList = new ArrayList<BusinessObject>();
		for(BizObject bo:boTmp)
		{
			boList.add(new BusinessObject(bo));
		}
		return boList;
	}
	
	
	/**
	 * 根据ObjectType获取JBO的数据结构定义
	 * 根据Where条件和Where条件附带参数从数据库中加载多个数据对象，并加载其关联对象
	 * 并返回多个数据对象的List
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public List<BusinessObject> loadBusinessObjects(String objectType,String whereClause,ASValuePool parameter,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception{
		BizObjectManager m = null;
		if(objectManagers.getAttribute(objectType) == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m = f.getManager(objectType);
			tx.join(m);
			objectManagers.setAttribute(objectType, m);
		}
		else
			m = (BizObjectManager)objectManagers.getAttribute(objectType);
		
		BizObjectQuery q = m.createQuery(whereClause); 
		for(Object key:parameter.getKeys())
		{
			q.setParameter((String)key, parameter.getString((String)key));
		}
		
		BizObjectManager m1 = null;
		if(objectManagers.getAttribute(relaObjectType) == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m1 = f.getManager(relaObjectType);
			tx.join(m1);
			objectManagers.setAttribute(relaObjectType, m1);
		}
		else
			m1 = (BizObjectManager)objectManagers.getAttribute(relaObjectType);
		
		BizObjectQuery q1 = m1.createQuery(relaWhereClause); 
		
		List<BizObject> boTmp = (List<BizObject>)q.getResultList(true);
		List<BusinessObject> boList = new ArrayList<BusinessObject>();
		for(BizObject bo:boTmp)
		{
			BusinessObject b = new BusinessObject(bo);
			boList.add(b);
			
			
			for(Object key:rela.getKeys())
			{
				String s = rela.getString((String)key);
				if(s.indexOf("${") >= 0)
					q1.setParameter((String)key, b.getString(s.replace("${", "").replace("}", "")));
				else
					q1.setParameter((String)key, s);
			}
			
			b.setRelativeObjects(q1.getResultList(true));
			
		}
		return boList;
	}
	
	/**
	 * 根据多个主对象加载关联对象信息
	 * 根据Where条件和Where条件附带参数从数据库中加载多个数据对象，并加载其关联对象
	 * 返回多个主对象
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public List<BusinessObject> loadBusinessObjects(List<BusinessObject> boList,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception{
		
		BizObjectManager m1 = null;
		if(objectManagers.getAttribute(relaObjectType) == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m1 = f.getManager(relaObjectType);
			tx.join(m1);
			objectManagers.setAttribute(relaObjectType, m1);
		}
		else
			m1 = (BizObjectManager)objectManagers.getAttribute(relaObjectType);
		
		BizObjectQuery q1 = m1.createQuery(relaWhereClause); 
		
		for(BusinessObject bo:boList)
		{
			for(Object key:rela.getKeys())
			{
				String s = rela.getString((String)key);
				if(s.indexOf("${") >= 0)
					q1.setParameter((String)key, bo.getString(s.replace("${", "").replace("}", "")));
				else
					q1.setParameter((String)key, s);
			}
			
			bo.setRelativeObjects(q1.getResultList(true));
			
		}
		return boList;
	}
	
	/**
	 * 根据一个主对象加载关联对象信息
	 * 根据Where条件和Where条件附带参数从数据库中加载多个数据对象，并加载其关联对象
	 * 返回多个主对象
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public BusinessObject loadBusinessObject(BusinessObject bo,String relaObjectType,String relaWhereClause,ASValuePool rela) throws Exception{
		
		BizObjectManager m1 = null;
		if(objectManagers.getAttribute(relaObjectType) == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m1 = f.getManager(relaObjectType);
			tx.join(m1);
			objectManagers.setAttribute(relaObjectType, m1);
		}
		else
			m1 = (BizObjectManager)objectManagers.getAttribute(relaObjectType);
		
		BizObjectQuery q1 = m1.createQuery(relaWhereClause); 
		
		for(Object key:rela.getKeys())
		{
			String s = rela.getString((String)key);
			if(s.indexOf("${") >= 0)
				q1.setParameter((String)key, bo.getString(s.replace("${", "").replace("}", "")));
			else
				q1.setParameter((String)key, s);
		}
		bo.setRelativeObjects(q1.getResultList(true));
		
		return bo;
	}
	
	/**
	 * 根据传入的BusinessObejct找到对应的BizObjectManager，并使用它保存该对象数据
	 * 单一对象数据保存
	 * @param businessobject
	 * @throws Exception
	 */
	public void updateBusinessObject(BusinessObject businessobject) throws Exception{
		BizObjectManager m = (BizObjectManager)objectManagers.getAttribute(businessobject.getObjectType());
		if(m == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m = f.getManager(businessobject.getObjectType());
			tx.join(m);
		}
		m.saveObject(businessobject.getBo());
	}
	
	/**
	 * 根据传入的BusinessObejct找到对应的BizObjectManager，并使用它保存该对象数据
	 * 单一对象数据保存
	 * @param businessobject
	 * @throws Exception
	 */
	public void insertBusinessObject(BusinessObject businessobject) throws Exception{
		BizObjectManager m = (BizObjectManager)objectManagers.getAttribute(businessobject.getObjectType());
		if(m == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m = f.getManager(businessobject.getObjectType());
			tx.join(m);
		}
		m.saveObject(businessobject.getBo());
	}
	
	/**
	 * 根据传入的BusinessObejct找到对应的BizObjectManager，并使用它删除该对象数据
	 * @param businessobject
	 * @throws Exception
	 */
	public void deleteBusinessObject(BusinessObject businessobject) throws Exception{
		BizObjectManager m = (BizObjectManager)objectManagers.getAttribute(businessobject.getObjectType());
		if(m == null)
		{
			JBOFactory f = JBOFactory.getFactory();
			m = f.getManager(businessobject.getObjectType());
			tx.join(m);
		}
		m.deleteObject(businessobject.getBo());
	}
	
	/**
	 * 根据内存对象池分别进行不同的数据写入操作
	 * 并将内存对象池中的数据清空
	 * @throws Exception
	 */
	public void updateDB() throws Exception{
		Object[] keys = newObjects.getKeys();
		for (int i=0;i<keys.length;i++) {
			String objectType = (String) keys[i];
			ArrayList<BusinessObject> businessObjects = (ArrayList<BusinessObject>) newObjects.getAttribute(objectType);
			int size = businessObjects.size();
			for(int j=0;j<size;j++){
				BusinessObject businessobject=(BusinessObject) businessObjects.get(j);
				this.insertBusinessObject(businessobject);
				businessobject.db_operate_flag=	operateflag_update;
			}
		}
		newObjects.resetPool();
		
		keys = deleteObjects.getKeys();
		for (int i=0;i<keys.length;i++) {
			String objectType = (String) keys[i];
			ArrayList<BusinessObject> businessObjects = (ArrayList<BusinessObject>) deleteObjects.getAttribute(objectType);
			int size = businessObjects.size();
			for(int j=0;j<size;j++){
				BusinessObject businessobject=(BusinessObject) businessObjects.get(j);
				this.deleteBusinessObject(businessobject);
			}
		}
		deleteObjects.resetPool();
		
		
		keys = this.updateObjects.getKeys();
		for (int i=0;i<keys.length;i++) {
			String objectType = (String) keys[i];
			ArrayList<BusinessObject> businessObjects = (ArrayList<BusinessObject>) updateObjects.getAttribute(objectType);
			int size = businessObjects.size();
			for(int j=0;j<size;j++){
				BusinessObject businessobject=(BusinessObject) businessObjects.get(j);
				this.updateBusinessObject(businessobject);
			}
		}
		updateObjects.resetPool();
		objectManagers.resetPool();
		//对象数量统计清零
		objectNum = 0;
	}

	public void close() throws Exception {
		
	}
}
