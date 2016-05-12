/**
 * Class <code>BatchBusinessObjectManager</code> 是所有核算对象的管理器
 * 它用来管理<code>BusinessObject</code>产生的对象，包括加载、更新、插入等动作. 
 * 该管理器是基于ResultSet\PreparedStatement的数据对象加载、更新、插入管理，并将这些PreparedStatement缓存。
 * @author  ygwang xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.are.jbo.BizObject
 * @see com.amarsoft.are.jbo.BizObjectClass
 * @see com.amarsoft.are.jbo.BizObjectKey
 * @see BusinessObject
 * @since   JDK1.6
 */

package com.amarsoft.app.accounting.businessobject;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;

public class BatchBusinessObjectManager extends AbstractBusinessObjectManager{
	
	public BatchBusinessObjectManager(Transaction sqlca) throws JBOException, SQLException{
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
		PreparedStatement ps = null;
		ArrayList<String> lsvalue = new ArrayList<String>();
		ArrayList<Byte> lstype = new ArrayList<Byte>();
		if(objectManagers.getAttribute("Select-"+objectType+"-"+whereClause.trim()) == null)
		{
			BizObjectClass clazz = JBOFactory.getBizObjectClass(objectType);
			StringBuffer selCode = new StringBuffer();
			selCode.append("select ");
			for(DataElement attr : clazz.getAttributes())
			{
				selCode.append(attr.getName());
				selCode.append(",");
			}
			selCode = new StringBuffer(selCode.substring(0, selCode.length()-1));
			
			selCode.append(" from ");
			selCode.append(clazz.getName());
			
			String appendWC = whereClause;
			String wc = whereClause;
			ArrayList<String> keys = new ArrayList<String>();
			while(wc.indexOf(":") >= 0)
			{
				wc = wc.substring(wc.indexOf(":")+1);
				String key = wc.substring(0, wc.indexOf(" ") >0 ? wc.indexOf(" ") : wc.length()).trim();
				key = key.substring(0,key.indexOf(",") >0 ? key.indexOf(",") : key.length()).trim();
				key = key.substring(0,key.indexOf(")") >0 ? key.indexOf(")") : key.length()).trim();
				String value = parameter.getString(key);
				if(value == null || "".equals(value)) throw new Exception("未传入变量【"+key+"】的值！");
				lsvalue.add(value);
				String feild = appendWC.substring(0,appendWC.indexOf(":"+key)).trim();
				feild = feild.substring(0,feild.lastIndexOf("=")>0 ? feild.lastIndexOf("=") : feild.lastIndexOf(" ")).trim();
				feild = feild.substring(feild.lastIndexOf(" ")+1).trim();
				lstype.add(clazz.getAttribute(feild).getType());
				appendWC = appendWC.replaceFirst(":"+key, "?");
				keys.add(key);
			}
			while(appendWC.indexOf("jbo")>=0)
			{
				String s = appendWC.substring(appendWC.indexOf("jbo"));
				s = s.substring(0, s.indexOf(" ") >0 ? s.indexOf(" ") : s.length());
				s = s.trim();
				BizObjectClass cz = JBOFactory.getBizObjectClass(objectType);
				appendWC = appendWC.replaceAll(cz.getPackageName()+".", "");
			}
			selCode.append(" where ");
			selCode.append(appendWC);
			
			ps = this.tx.getConnection(this.sqlca).prepareStatement(selCode.toString());
			
			objectManagers.setAttribute("Select-"+objectType+"-"+whereClause.trim(), ps);
			objectManagers.setAttribute("SelectKey-"+objectType+"-"+whereClause.trim(), keys);
			objectManagers.setAttribute("SelectKeyType-"+objectType+"-"+whereClause.trim(), lstype);
		}
		else
		{
			ps = (PreparedStatement)objectManagers.getAttribute("Select-"+objectType+"-"+whereClause.trim());
			ArrayList<String> keys = (ArrayList<String>)objectManagers.getAttribute("SelectKey-"+objectType+"-"+whereClause.trim());
			for(String key:keys)
			{
				String value = parameter.getString(key);
				if(value == null || "".equals(value)) throw new Exception("未传入变量【"+key+"】的值！");
				lsvalue.add(value);
			}
			lstype = (ArrayList<Byte>)objectManagers.getAttribute("SelectKeyType-"+objectType+"-"+whereClause.trim());
		}
		
		for(int i =0;i < lsvalue.size(); i ++)
		{
			String value = lsvalue.get(i);
			byte type = lstype.get(i);
			if(type == 0)//string
				ps.setString(i+1, value);
			else if(type == 1)//int
				ps.setInt(i+1, Integer.valueOf(value));
			else if(type == 2)//long
				ps.setLong(i+1, Long.valueOf(value));
			else if(type == 4)//double
				ps.setDouble(i+1, Double.valueOf(value));
			else if(type == 8)//boolean
				ps.setBoolean(i+1, Boolean.valueOf(value));
			else
				ps.setString(i+1, value);
		}
		
		ResultSet rs = ps.executeQuery();
		List<BusinessObject> boList = new ArrayList<BusinessObject>();
		while(rs.next())
		{
			boList.add(new BusinessObject(objectType,rs));
		}
		rs.close();
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
		List<BusinessObject> boList = (List<BusinessObject>)this.loadBusinessObjects(objectType, whereClause,parameter);
		boList = this.loadBusinessObjects(boList, relaObjectType, relaWhereClause, rela);
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
		for(BusinessObject bo:boList)
		{
			for(Object key:rela.getKeys())
			{
				String s = rela.getString((String)key);
				if(s.indexOf("${") >= 0)
					rela.setAttribute((String)key, bo.getString(s.replace("${", "").replace("}", "")));
			}
			List<BusinessObject> relaObjects = this.loadBusinessObjects(relaObjectType, relaWhereClause, rela);
			bo.setRelativeObjects(relaObjects);
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
		for(Object key:rela.getKeys())
		{
			String s = rela.getString((String)key);
			if(s.indexOf("${") >= 0)
				rela.setAttribute((String)key, bo.getString(s.replace("${", "").replace("}", "")));
		}
		List<BusinessObject> relaObjects = this.loadBusinessObjects(relaObjectType, relaWhereClause, rela);
		bo.setRelativeObjects(relaObjects);
		return bo;
	}
	
	/**
	 * 根据传入的BusinessObejct找到对应的BizObjectManager，并使用它保存该对象数据
	 * 单一对象数据保存
	 * @param businessobject
	 * @throws Exception
	 */
	public void updateBusinessObject(BusinessObject businessobject) throws Exception{
		PreparedStatement ps = null;
		StateBizObject sbo = (StateBizObject)businessobject.getBo();
		BizObjectClass clazz = sbo.getBizObjectClass();
		StringBuffer updateCode = new StringBuffer();
		updateCode.append(" update ");
		updateCode.append(clazz.getName());
		updateCode.append(" set ");
		DataElement[] attrs =  sbo.getChangedAttributes();
		if(attrs == null || attrs.length == 0)
		{
			return;
		}
		for(DataElement attr : attrs)
		{
			updateCode.append(attr.getName());
			updateCode.append("=?,");
		}
		updateCode = new StringBuffer(updateCode.substring(0, updateCode.length()-1));
		updateCode.append(" where 1=1 ");
		if(clazz.getKeyAttributes().length == 0) throw new Exception("未定义该对象的主键，无法进行更新！");
		for(String attr : clazz.getKeyAttributes())
		{
			updateCode.append(" and ");
			updateCode.append(attr);
			updateCode.append("=?");
		}
		
		if(objectManagers.getAttribute(operateflag_update+"-"+businessobject.getObjectType()+updateCode) == null)
		{
			ps = this.tx.getConnection(this.sqlca).prepareStatement(updateCode.toString());
			
			objectManagers.setAttribute(operateflag_update+"-"+businessobject.getObjectType()+updateCode, ps);
		}
		else
			ps = (PreparedStatement)objectManagers.getAttribute(operateflag_update+"-"+businessobject.getObjectType()+updateCode);
		
		int i=1;
		for(DataElement attr : sbo.getChangedAttributes())
		{
			
			byte type = attr.getType();
			if(attr.isNull())
			{
				if(type == 0)//string
					ps.setNull(i++, java.sql.Types.VARCHAR);
				else if(type == 1)//int
					ps.setNull(i++, java.sql.Types.INTEGER);
				else if(type == 2)//long
					ps.setNull(i++, java.sql.Types.BIGINT);
				else if(type == 4)//double
					ps.setNull(i++, java.sql.Types.DOUBLE);
				else if(type == 8)//boolean
					ps.setNull(i++, java.sql.Types.BIT);
				else
					ps.setNull(i++, java.sql.Types.VARCHAR);
			}
			else
			{
				if(type == 0)//string
					ps.setString(i++, attr.getString());
				else if(type == 1)//int
					ps.setInt(i++, attr.getInt());
				else if(type == 2)//long
					ps.setLong(i++, attr.getLong());
				else if(type == 4)//double
					ps.setDouble(i++, attr.getDouble());
				else if(type == 8)//boolean
					ps.setBoolean(i++, attr.getBoolean());
				else
					ps.setString(i++, attr.getString());
			}
		}
		
		for(String attr : clazz.getKeyAttributes())
		{
			byte type = businessobject.getBo().getAttribute(attr).getType();
			
			if(businessobject.getBo().getAttribute(attr).isNull())
			{
				if(type == 0)//string
					ps.setNull(i++, java.sql.Types.VARCHAR);
				else if(type == 1)//int
					ps.setNull(i++, java.sql.Types.INTEGER);
				else if(type == 2)//long
					ps.setNull(i++, java.sql.Types.BIGINT);
				else if(type == 4)//double
					ps.setNull(i++, java.sql.Types.DOUBLE);
				else if(type == 8)//boolean
					ps.setNull(i++, java.sql.Types.BIT);
				else
					ps.setNull(i++, java.sql.Types.VARCHAR);
			}
			else
			{
				if(type == 0)//string
					ps.setString(i++, businessobject.getBo().getAttribute(attr).getString());
				else if(type == 1)//int
					ps.setInt(i++, businessobject.getBo().getAttribute(attr).getInt());
				else if(type == 2)//long
					ps.setLong(i++, businessobject.getBo().getAttribute(attr).getLong());
				else if(type == 4)//double
					ps.setDouble(i++, businessobject.getBo().getAttribute(attr).getDouble());
				else if(type == 8)//boolean
					ps.setBoolean(i++, businessobject.getBo().getAttribute(attr).getBoolean());
				else
					ps.setString(i++, businessobject.getBo().getAttribute(attr).getString());
			}
		}
		ps.addBatch();
	}
	
	/**
	 * 根据传入的BusinessObejct找到对应的BizObjectManager，并使用它保存该对象数据
	 * 单一对象数据保存
	 * @param businessobject
	 * @throws Exception
	 */
	public void insertBusinessObject(BusinessObject businessobject) throws Exception{
		PreparedStatement ps = null;
		BizObjectClass clazz = businessobject.getBo().getBizObjectClass();
		if(objectManagers.getAttribute(operateflag_new+"-"+businessobject.getObjectType()) == null)
		{
			StringBuffer insertCode = new StringBuffer();
			StringBuffer valueCode = new StringBuffer();
			insertCode.append(" insert into ");
			insertCode.append(clazz.getName());
			insertCode.append("(");
			for(DataElement attr : businessobject.getBo().getAttributes())
			{
				insertCode.append(attr.getName());
				insertCode.append(",");
				valueCode.append("?,");
			}
			insertCode = new StringBuffer(insertCode.substring(0, insertCode.length()-1));
			valueCode = new StringBuffer(valueCode.substring(0, valueCode.length()-1));
			insertCode.append(") values(");
			insertCode.append(valueCode);
			insertCode.append(")");
			ps = this.tx.getConnection(this.sqlca).prepareStatement(insertCode.toString());
			objectManagers.setAttribute(operateflag_new+"-"+businessobject.getObjectType(), ps);
		}
		else
			ps = (PreparedStatement)objectManagers.getAttribute(operateflag_new+"-"+businessobject.getObjectType());
		
		int i=1;
		for(DataElement attr : businessobject.getBo().getAttributes())
		{
			byte type = attr.getType();
			if(attr.isNull())
			{
				if(type == 0)//string
					ps.setNull(i++, java.sql.Types.VARCHAR);
				else if(type == 1)//int
					ps.setNull(i++, java.sql.Types.INTEGER);
				else if(type == 2)//long
					ps.setNull(i++, java.sql.Types.BIGINT);
				else if(type == 4)//double
					ps.setNull(i++, java.sql.Types.DOUBLE);
				else if(type == 8)//boolean
					ps.setNull(i++, java.sql.Types.BIT);
				else
					ps.setNull(i++, java.sql.Types.VARCHAR);
			}
			else
			{
				if(type == 0)//string
					ps.setString(i++, attr.getString());
				else if(type == 1)//int
					ps.setInt(i++, attr.getInt());
				else if(type == 2)//long
					ps.setLong(i++, attr.getLong());
				else if(type == 4)//double
					ps.setDouble(i++, attr.getDouble());
				else if(type == 8)//boolean
					ps.setBoolean(i++, attr.getBoolean());
				else
					ps.setString(i++, attr.getString());
			}
		}
		ps.addBatch();
	}
	
	/**
	 * 根据传入的BusinessObejct找到对应的BizObjectManager，并使用它删除该对象数据
	 * @param businessobject
	 * @throws Exception
	 */
	public void deleteBusinessObject(BusinessObject businessobject) throws Exception{
		PreparedStatement ps = null;
		BizObjectClass clazz = businessobject.getBo().getBizObjectClass();
		if(objectManagers.getAttribute(operateflag_delete+"-"+businessobject.getObjectType()) == null)
		{
			StringBuffer deleteCode = new StringBuffer();
			deleteCode.append(" delete from ");
			deleteCode.append(clazz.getName());
			deleteCode.append(" where 1=1 and ");
			if(clazz.getKeyAttributes().length == 0) throw new Exception("未定义该对象的主键，无法进行更新！");
			for(String attr : clazz.getKeyAttributes())
			{
				deleteCode.append(attr);
				deleteCode.append("=");
				deleteCode.append("?,");
			}
			deleteCode = new StringBuffer(deleteCode.substring(0, deleteCode.length()-1));
			ps = this.tx.getConnection(this.sqlca).prepareStatement(deleteCode.toString());
			
			objectManagers.setAttribute(operateflag_delete+"-"+businessobject.getObjectType(), ps);
		}
		else
			ps = (PreparedStatement)objectManagers.getAttribute(operateflag_delete+"-"+businessobject.getObjectType());
		
		int i=1;
		for(String attr : clazz.getKeyAttributes())
		{
			byte type = businessobject.getBo().getAttribute(attr).getType();
			if(type == 0)//string
				ps.setString(i++,  businessobject.getBo().getAttribute(attr).getString());
			else if(type == 1)//int
				ps.setInt(i++,  businessobject.getBo().getAttribute(attr).getInt());
			else if(type == 2)//long
				ps.setLong(i++,  businessobject.getBo().getAttribute(attr).getLong());
			else if(type == 4)//double
				ps.setDouble(i++,  businessobject.getBo().getAttribute(attr).getDouble());
			else if(type == 8)//boolean
				ps.setBoolean(i++,  businessobject.getBo().getAttribute(attr).getBoolean());
			else
				ps.setString(i++,  businessobject.getBo().getAttribute(attr).getString());
		}
		ps.addBatch();
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
				if(businessobject.getBo() instanceof DefaultBizObject)
				{
					DefaultBizObject dbo = (DefaultBizObject)businessobject.getBo();
					dbo.setState(BizObject.STATE_SYNC);
				}
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
				if(businessobject.getBo() instanceof DefaultBizObject)
				{
					DefaultBizObject dbo = (DefaultBizObject)businessobject.getBo();
					dbo.setState(BizObject.STATE_SYNC);
				}
			}
		}
		updateObjects.resetPool();
		for(Object key:objectManagers.getKeys())
		{
			if(((String)key).startsWith("SelectKey")) continue;
			PreparedStatement ps = (PreparedStatement)objectManagers.getAttribute((String)key);
			if(ps != null)
			{
				if(((String)key).startsWith(operateflag_new) || ((String)key).startsWith(operateflag_delete) || ((String)key).startsWith(operateflag_update))
				{
					ps.executeBatch();
				}
			}
		}
		//对象数量统计清零
		objectNum = 0;
	}
	
	/**
	 * 清理管理器中的资源，如objectManagers对象中保存的Statement等
	 * @throws Exception
	 */
	public void close() throws Exception
	{
		for(Object key:objectManagers.getKeys())
		{
			if(((String)key).startsWith("SelectKey")) continue;
			PreparedStatement ps = (PreparedStatement)objectManagers.getAttribute((String)key);
			if(ps != null)
			{
				ps.close();
			}
		}
		objectManagers.resetPool();
	}
}
