/**
 * Class <code>BusinessObject</code> 是所有核算对象的基础
 * 它用来表达每一个核算对象以及核算对象的关联子对象. 
 *
 * @author  xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.are.jbo.BizObject
 * @see com.amarsoft.are.jbo.BizObjectClass
 * @since   JDK1.6
 */
package com.amarsoft.app.accounting.businessobject;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.sql.ResultSet;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;

public class BusinessObject implements Serializable{

	private static final long serialVersionUID = 1L;
	//本业务对象存在多字段主键，在体现ObjectNo时多字段值之间的分隔符
	public static final String splitRegex = ",";
	//本业务对象数据操作表示insert、update、delete
	public String db_operate_flag;
	//本业务对象关联的一对多的业务对象，以ObjectType为key，value为对象组成的list（有顺序）
	private ASValuePool relativeObjectList = new ASValuePool();
	//本业务对象关联的一对多的业务对象，，以ObjectType为key，value为对象组成的ASValuePool（无顺序）
	//relativeObjectList与relativeObjectMap内容一样，存储形式不一样，为了解决效率问题，两种形式分别索引
	private ASValuePool relativeObjectMap = new ASValuePool();
	//BizObject对象以List存储数据，导致set和get方法循环过多，效率低下。本对象已HASHMAP的方式存储数组的下标加快获取效率
	private HashMap<String,Integer> attributesIndex = new HashMap<String,Integer>();
	//BizObject对象数据存储，主对象
	private BizObject bo = null;
	//其他变量存储
	private ASValuePool ex_attributes = new ASValuePool();
	
	private String objectType = null;
	
	
	/**
	 * 构造函数 该构造方法只使用那些不保存的临时对象
	 * @param clazz
	 * @return this
	 */
	public BusinessObject(String clazz) throws Exception{
		this.bo = new DefaultBizObject(clazz);
		init();
	}
	
	
	/**
	 * 构造函数 该构造方法使用结果集初始化对象
	 * @param clazz
	 * @return this
	 */
	public BusinessObject(String clazz,ResultSet rs) throws Exception{
		this(clazz);
		for(DataElement de:this.bo.getAttributes()){
			if(de.getType() == 0)//string
				de.setValue(rs.getString(de.getName()));
			else if(de.getType() == 1)//int
				de.setValue(rs.getInt(de.getName()));
			else if(de.getType() == 2)//long
				de.setValue(rs.getLong(de.getName()));
			else if(de.getType() == 4)//double
				de.setValue(rs.getDouble(de.getName()));
			else if(de.getType() == 8)//boolean
				de.setValue(rs.getBoolean(de.getName()));
			else
				de.setValue(rs.getString(de.getName()));
		}
		
		DefaultBizObject sbo = (DefaultBizObject)this.bo;
		sbo.setState(BizObject.STATE_SYNC);
	}
	
	/**
	 * 构造函数 该构造方法只使用那些不保存的临时对象
	 * @param clazz
	 * @return this
	 */
	public BusinessObject(ASValuePool as) throws Exception{
		for(Object o : as.getKeys())
		{
			this.ex_attributes.setAttribute(((String)o).toUpperCase(), as.getAttribute((String)o));
		}
	}

	/**
	 * 构造函数
	 * @param BizObjectClass
	 * @return this
	 */
	public BusinessObject(BizObjectClass clazz,AbstractBusinessObjectManager bomanager) throws Exception{
		DefaultBizObject dbo = new DefaultBizObject(clazz);
		dbo.setState(BizObject.STATE_NEW);
		this.bo = dbo;
		init();
		if(bomanager==null){
			
		}
		else {
			bomanager.generateObjectNo(this);
		}
	}
	
	/**
	 * 构造函数
	 * @param clazz
	 * @return this
	 */
	public BusinessObject(String clazz,AbstractBusinessObjectManager bomanager) throws Exception{
		DefaultBizObject dbo = new DefaultBizObject(clazz);
		dbo.setState(BizObject.STATE_NEW);
		this.bo = dbo;
		init();
		if(bomanager==null){
			
		}
		else {
			bomanager.generateObjectNo(this);
		}
	}
	
	/**
	 * 构造函数
	 * @param bo
	 * @return this
	 */
	public BusinessObject(BizObject bo) throws Exception{
		if(!(bo instanceof StateBizObject))
			throw new Exception("请用StateBizObject实例化对象！");
		this.bo = bo;
		init();
	}
	
	/**
	 * 初始化数据字段索引
	 *
	 */
	private void init(){
		DataElement[] de = this.bo.getAttributes();
		for(int i = 0; i < de.length; i ++)
		{
			attributesIndex.put(de[i].getName().toUpperCase(), i);
		}
	}
	
	public BizObject getBo() {
		return bo;
	}
	
	private ASValuePool getExattributes() {
		return ex_attributes;
	}
	
	
	public String[] getAttributeIDArray(){
		String[] a =null,b = null;
		if(ex_attributes!=null&&!ex_attributes.isEmpty()){
			a = new String[ex_attributes.getKeys().length];
			Object[] os=this.ex_attributes.getKeys();
			for(int i = 0; i < os.length; i++)
			{
				Object o = os[i];
				a[i] = (String)o;
			}
		}
		if(attributesIndex!=null&&!attributesIndex.isEmpty()){
			b = new String[attributesIndex.size()];
			b=this.attributesIndex.keySet().toArray(b);
		}
		if(a==null) return b;
		if(b==null) return a;
		else return Arrays.copyOf(a, a.length + b.length);
	}

	/**
	 * 获取对应属性的字符串值
	 * @param attributeID
	 * @return String
	 * @throws Exception
	 */
	public String  getString(String attributeID) throws Exception{
		Integer index = attributesIndex.get(attributeID.toUpperCase());
		if(index==null) 
		{
			Object value = ex_attributes.getAttribute(attributeID.toUpperCase());
			if(value==null || "".equals(value)) value = "";
			if(String.class.isInstance(value))  return String.valueOf(value);
			else
			{
				NumberFormat nf = NumberFormat.getInstance();
				nf.setMaximumFractionDigits(10);
				nf.setMinimumFractionDigits(10);
				return nf.format(value).replaceAll(",", "");
			}
		}
		else
		{
			DataElement value = this.bo.getAttribute(index.intValue());
			if(value==null) throw new DataException("未定义变量"+attributeID+"值，请检查！");
			return value.getString();
		}
	}
	
	/**
	 * 获取对应属性的浮点数
	 * @param attributeID
	 * @return double
	 * @throws Exception
	 */
	public double getDouble(String attributeID) throws Exception{
		Integer index = attributesIndex.get(attributeID.toUpperCase());
		if(index==null)
		{
			Object value = ex_attributes.getAttribute(attributeID.toUpperCase());
			if(value==null || "".equals(value)) value = "0.0";
			return Double.parseDouble(value.toString());
		}
		else
		{
			DataElement value = this.bo.getAttribute(index.intValue());
			if(value==null || "".equals(value)) throw new DataException("未定义变量"+attributeID+"值，请检查！");;
			return value.getDouble();
		}
	}
	
	/**
	 * 获取对应属性的浮点数（保留小数点后8位，本系统中只有利率才使用）
	 * @param attributeID
	 * @return double
	 * @throws Exception
	 */
	public double getRate(String attributeID) throws Exception{
		double d = getDouble(attributeID);
		return Arith.round(d, ACCOUNT_CONSTANTS.Number_Precision_Rate);
	}
	
	/**
	 * 获取对应属性的浮点数据（保留小数点后2位，本系统中只有最终金额使用，计算中间数值变量请勿用以免丢失精度）
	 * @param attributeID
	 * @return double
	 * @throws Exception
	 */
	public double getMoney(String attributeID) throws Exception{
		double d=this.getDouble(attributeID);
		return Arith.round(d, 2);
	}
	
	/**
	 * 获取对应属性的整数
	 * @param attributeID
	 * @return int
	 * @throws Exception
	 */
	public int getInt(String attributeID) throws Exception{
		Integer index = attributesIndex.get(attributeID.toUpperCase());
		if(index==null) 
		{
			Object value = ex_attributes.getAttribute(attributeID.toUpperCase());
			if(value==null || "".equals(value)) value = "0";
			return Integer.parseInt(value.toString());
		}
		else
		{
			DataElement value = this.bo.getAttribute(index.intValue());
			if(value==null || "".equals(value)) throw new DataException("未定义变量"+attributeID+"值，请检查！");
			return value.getInt();
		}
	}
	
	/**
	 * 获取对应属性的长整型数值
	 * @param attributeID
	 * @return long
	 * @throws Exception
	 */
	public long getLong(String attributeID) throws Exception{
		Integer index = attributesIndex.get(attributeID.toUpperCase());
		if(index==null)
		{
			Object value = ex_attributes.getAttribute(attributeID.toUpperCase());
			if(value==null || "".equals(value)) value = "0";
			return Long.parseLong(value.toString());
		}
		else
		{
			DataElement value = this.bo.getAttribute(index.intValue());
			if(value==null || "".equals(value)) throw new DataException("未定义变量"+attributeID+"值，请检查！");
			return value.getLong();
		}
	}
	
	/**
	 * 获取对应Object
	 * @param attributeID
	 * @return long
	 * @throws Exception
	 */
	public Object getObject(String attributeID) throws Exception{
		Integer index = attributesIndex.get(attributeID.toUpperCase());
		if(index==null)
		{
			Object value = ex_attributes.getAttribute(attributeID.toUpperCase());
			return value;
		}
		else
		{
			DataElement value = this.bo.getAttribute(index.intValue());
			if(value==null) throw new DataException("【"+this.getObjectType()+"】未定义变量"+attributeID+"值，请检查！");
			return value.getValue();
		}
	}
	
	/**
	 * 获取该对象的编号（唯一表示该对象的字符串，及JBO中定义主键以逗号分隔的拼接）
	 * @param void
	 * @return String    Key1Value,Key2Value,Key3Value,……
	 * @throws Exception
	 */
	public String getObjectNo() throws Exception{
		DataElement[] keyValues = this.bo.getKey().getAttributes();
		if(keyValues.length <= 0) throw new DataException(this.bo.getBizObjectClass().getAbsoluteName()+"未定义主键，请检查！");
		String key = keyValues[0].getString();
		for(int i = 1; i < keyValues.length; i ++ )
		{
			key +=splitRegex+ keyValues[i].getString();
		}
		return key;
	}
	
	/**
	 * 获取该对象的类型（及JBO的完全路径和名称）
	 * @param void
	 * @return String
	 * @throws Exception
	 */
	public String getObjectType() throws Exception{
		if(objectType!=null) return objectType;//每次都循环没必要
		String packageName = this.bo.getBizObjectClass().getPackageName();
		String name = this.bo.getBizObjectClass().getName();
		if(name.lastIndexOf("X") > -1) name = name.substring(0,name.lastIndexOf("X"));
		objectType=packageName+"."+name;
		return objectType;
	}
	
	public void setValue(BusinessObject bo) throws Exception{
		for(int i = 0; i < bo.getBo().getAttributes().length; i ++ )
		{
			for(DataElement e :bo.getBo().getKey().getAttributes())
			{
				if(e.getName().equals(bo.getBo().getAttributes()[i].getName())) continue;
				this.setAttributeValue(bo.getBo().getAttributes()[i].getName(), bo.getBo().getAttributes()[i].getValue());
			}
		}
		for(int i = 0; i < bo.getExattributes().getKeys().length; i ++)
		{
			this.setAttributeValue((String)bo.getExattributes().getKeys()[i], bo.getExattributes().getAttribute((String)bo.getExattributes().getKeys()[i]));
		}
	}
	
	public void setAttributeValue(String name,String Value) throws Exception{

		Integer index = attributesIndex.get(name.toUpperCase());
		if(index==null)
		{
			ex_attributes.setAttribute(name.toUpperCase(), Value);
		}
		else
		{
			this.bo.setAttributeValue(index.intValue(), Value);
		}
	}
	
	public void setAttributeValue(String name,Any anyValue) throws Exception{
		String type = anyValue.getType();
		if(type.equalsIgnoreCase("Number"))
			setAttributeValue(name,anyValue.doubleValue());
		else
			setAttributeValue(name,anyValue.stringValue());
	}
	
	public void setAttributeValue(String name,double Value) throws Exception{

		Integer index = attributesIndex.get(name.toUpperCase());
		if(index==null)
		{
			ex_attributes.setAttribute(name.toUpperCase(), Value);
		}
		else
		{
			this.bo.setAttributeValue(index.intValue(), Value);
		}
	}
	
	public void setAttributeValue(String name,long Value) throws Exception{

		Integer index = attributesIndex.get(name.toUpperCase());
		if(index==null)
		{
			ex_attributes.setAttribute(name.toUpperCase(), Value);
		}
		else
		{
			this.bo.setAttributeValue(index.intValue(), Value);
		}
	}
	
	public void setAttributeValue(String name,int Value) throws Exception{

		Integer index = attributesIndex.get(name.toUpperCase());
		if(index==null)
		{
			ex_attributes.setAttribute(name.toUpperCase(), Value);
		}
		else
		{
			this.bo.setAttributeValue(index.intValue(), Value);
		}
	}
	
	public void setAttributeValue(String name,Object Value) throws Exception{

		Integer index = attributesIndex.get(name.toUpperCase());
		if(index==null)
		{
			ex_attributes.setAttribute(name.toUpperCase(), Value);
		}
		else
		{
			this.bo.setAttributeValue(index.intValue(), Value);
		}
	}
	
	public void setAttributeValue(String name,boolean Value) throws Exception{

		Integer index = attributesIndex.get(name.toUpperCase());
		if(index==null)
		{
			ex_attributes.setAttribute(name.toUpperCase(), Value);
		}
		else
		{
			this.bo.setAttributeValue(index.intValue(), Value);
		}
	}
	
	/**
	 * 将该对象的主键设置为空，自动生成流水（谨慎使用）
	 * @param void
	 * @return void
	 * @throws Exception
	 */
	public void setKeyNull() throws Exception{
		DataElement[] keys = this.bo.getKey().getAttributes();
		for(int k=0;k<keys.length;k++){
			this.bo.setAttributeValue(keys[k].getName(), null);
		}
	}
	
	public ArrayList<BusinessObject> getRelativeObjects(String objectType) throws Exception {
		ArrayList<BusinessObject> list = (ArrayList<BusinessObject>) this.relativeObjectList.getAttribute(objectType);
		return list;
	}
	
	/**
	 * 获取满足筛选条件的关联对象记录
	 * @param objectType
	 * @param as
	 * @return
	 * @throws Exception
	 */
	public ArrayList<BusinessObject> getRelativeObjects(String objectType,ASValuePool as) throws Exception {
		ArrayList<BusinessObject> list = (ArrayList<BusinessObject>) this.relativeObjectList.getAttribute(objectType);
		ArrayList<BusinessObject> ls = new ArrayList<BusinessObject>();
		if(list != null)
		{
			for(BusinessObject bo:list)
			{
				boolean flag = true;
				for(Object s :as.getKeys())
				{
					if(!as.getString((String)s).equals(bo.getString((String)s)))
						flag = false;
				}
				if(flag)
					ls.add(bo);
			}
		}
		return ls;
	}
	
	public BusinessObject getRelativeObject(String objectType,String objectNo) throws Exception {
		HashMap<String,BusinessObject> objectPool = (HashMap<String,BusinessObject>)this.relativeObjectMap.getAttribute(objectType);
		if (objectPool == null) 
			return null;
		return objectPool.get(objectNo);
	}
	
	
	public void removeRelativeObjects(String objectType) throws Exception {
		HashMap<String,BusinessObject> objectPool = (HashMap<String,BusinessObject>)this.relativeObjectMap.getAttribute(objectType);
		if (objectPool == null) 
			return;
		objectPool.clear() ;
		this.getRelativeObjects(objectType).clear();
	}
	
	public void removeRelativeObjects(List<BusinessObject> relativeObjectList) throws Exception {
		for(BusinessObject relativeObject:relativeObjectList){
			removeRelativeObject(relativeObject);
		}
	}
	
	
	public void removeRelativeObject(String objectType,String objectNo) throws Exception {
		HashMap<String,BusinessObject> objectPool = (HashMap<String,BusinessObject>)this.relativeObjectMap.getAttribute(objectType);
		if (objectPool == null) 
			return;
		removeRelativeObject(objectPool.get(objectNo));
	}
	
	public void removeRelativeObject(List<BusinessObject> businessObjects) throws Exception {
		if(businessObjects == null) return;
		for(BusinessObject bo:businessObjects)
		{
			removeRelativeObject(bo);
		}
	}
	
	public void removeRelativeObject(BusinessObject businessObject) throws Exception {
		HashMap<String,BusinessObject> objectPool 
			= (HashMap<String,BusinessObject>)this.relativeObjectMap.getAttribute(businessObject.getObjectType());
		if (objectPool == null) return;
		objectPool.remove(businessObject.getObjectNo());
		this.getRelativeObjects(businessObject.getObjectType()).remove(businessObject);
	}
	
	public ArrayList<BusinessObject> getRelativeObjects() throws Exception {
		ArrayList<BusinessObject> list = new ArrayList<BusinessObject>();
		Object[] keys = this.relativeObjectList.getKeys();
		for(Object k : keys)
		{
			list.addAll((ArrayList<BusinessObject>)this.relativeObjectList.getAttribute((String)k));
		}
		return list;
	}
	
	public ASValuePool getRelativeObjectList() throws Exception {
		return this.relativeObjectList;
	}
	
	public void setRelativeObject(BizObject bo) throws Exception {
		setRelativeObject(new BusinessObject(bo));
	}
	
	//可以指定别名
	public void setRelativeObject(String objectType,BusinessObject businessObject) throws Exception {
		if(businessObject==null) return;
		if(businessObject.getObjectNo() ==null || "".equals(businessObject.getObjectNo()))
			throw new Exception("对象【"+businessObject+"】的对象编号为空！");
		HashMap<String,BusinessObject> objectPool 
			= (HashMap<String,BusinessObject>)this.relativeObjectMap.getAttribute(objectType);
		if (objectPool == null) {
			objectPool = new HashMap<String,BusinessObject>();
			relativeObjectMap.setAttribute(objectType, objectPool);
		}
		if(objectPool.get(businessObject.getObjectNo())==null){
			List<BusinessObject> a= this.getRelativeObjects(objectType);
			if(a==null){
				a=new ArrayList<BusinessObject>();
				this.relativeObjectList.setAttribute(objectType, a);
			}
			a.add(businessObject);
			objectPool.put(businessObject.getObjectNo(),businessObject);
		}
	}
	
	
	public void setRelativeObject(BusinessObject businessObject) throws Exception {
		if(businessObject == null) return;
		setRelativeObject(businessObject.getObjectType(),businessObject);
	}
	
	//可以指定别名
	public void setRelativeObjects(String objectType,List boList) throws Exception {
		if(boList==null) return;
		int count=boList.size();
		for(int i=0;i<count;i++){
			Object b=boList.get(i);
			if(b instanceof BusinessObject)
				this.setRelativeObject(objectType,(BusinessObject)b);
			else
				this.setRelativeObject(objectType,new BusinessObject((BizObject)b));
		}
	}
	
	public void setRelativeObjects(List boList) throws Exception {
		if(boList==null) return;
		int count=boList.size();
		for(int i=0;i<count;i++){
			Object b=boList.get(i);
			if(b instanceof BusinessObject)
				this.setRelativeObject((BusinessObject)b);
			else
				this.setRelativeObject(new BusinessObject((BizObject)b));
		}
	}
	
	
	public  BusinessObject cloneObject()
			throws Exception {
		
		 ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
		 ObjectOutputStream out = new ObjectOutputStream(byteOut);
		 out.writeObject(this); 
		 ByteArrayInputStream byteIn = new ByteArrayInputStream(byteOut.toByteArray()); 
		 ObjectInputStream in = new ObjectInputStream(byteIn); 
		 BusinessObject objectclone =(BusinessObject)in.readObject(); 
		 return objectclone;
	}
	
	public boolean match(BusinessObject attributesFilter) throws Exception{
		if(attributesFilter==null) return true;
		String[] attributesFilterID=attributesFilter.getAttributeIDArray();
		for(String key:attributesFilterID){
			Object value=attributesFilter.getObject(key);
			if(value!=null&&!value.equals(this.getObject(key)))
				return false;
		}
		
		return true;
	}
	
	public List<BusinessObject> getRelativeObjects(String objectType,BusinessObject attributesFilter) throws Exception{
		List<BusinessObject> list = this.getRelativeObjects(objectType);
		
		ArrayList<BusinessObject> result = new ArrayList<BusinessObject>();
		if(list==null||list.isEmpty()){
			return result;
		}
		for(BusinessObject o:list){
			if(o.match(attributesFilter)){
				result.add(o);
			}
		}
		return result;
	}
	
	/**
	 * 覆盖父类中的等于判断
	 */
	public boolean equals(Object o)
	{
		try
		{
			BusinessObject bo = (BusinessObject)o;
			if(this.getObjectNo().equals(bo.getObjectNo()) && this.getObjectType().equals(bo.getObjectType()))
			{
				DataElement[] de = bo.getBo().getAttributes();
				DataElement[] cde = this.getBo().getAttributes();
				if(de.length != cde.length) return false;
				for(int i = 0; i < de.length; i ++)
				{
					if(!de[i].getName().equals(cde[i].getName()))
						return false;
					if(de[i].getValue() == null && cde[i].getValue() != null 
					|| de[i].getValue() != null && cde[i].getValue() == null)
					{
						return false;
					}
					
					if(de[i].getValue() != null && cde[i].getValue() != null
						&& !de[i].getValue().equals(cde[i].getValue()))
					{
						return false;
					}
				}
				
				return true;
			}
			else
				return false;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 
	 */
	
	public String toString()
	{
		StringBuffer sb=new StringBuffer(); 
		DataElement[] de = this.bo.getAttributes();
		for(int i = 0; i < de.length; i ++)
		{
			sb.append(de[i].getName()+"="+de[i].getString()+"\n");
		}
		return sb.toString();
	}
}
