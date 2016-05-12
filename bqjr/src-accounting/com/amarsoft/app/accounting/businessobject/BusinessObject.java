/**
 * Class <code>BusinessObject</code> �����к������Ļ���
 * ���������ÿһ����������Լ��������Ĺ����Ӷ���. 
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
	//��ҵ�������ڶ��ֶ�������������ObjectNoʱ���ֶ�ֵ֮��ķָ���
	public static final String splitRegex = ",";
	//��ҵ��������ݲ�����ʾinsert��update��delete
	public String db_operate_flag;
	//��ҵ����������һ�Զ��ҵ�������ObjectTypeΪkey��valueΪ������ɵ�list����˳��
	private ASValuePool relativeObjectList = new ASValuePool();
	//��ҵ����������һ�Զ��ҵ����󣬣���ObjectTypeΪkey��valueΪ������ɵ�ASValuePool����˳��
	//relativeObjectList��relativeObjectMap����һ�����洢��ʽ��һ����Ϊ�˽��Ч�����⣬������ʽ�ֱ�����
	private ASValuePool relativeObjectMap = new ASValuePool();
	//BizObject������List�洢���ݣ�����set��get����ѭ�����࣬Ч�ʵ��¡���������HASHMAP�ķ�ʽ�洢������±�ӿ��ȡЧ��
	private HashMap<String,Integer> attributesIndex = new HashMap<String,Integer>();
	//BizObject�������ݴ洢��������
	private BizObject bo = null;
	//���������洢
	private ASValuePool ex_attributes = new ASValuePool();
	
	private String objectType = null;
	
	
	/**
	 * ���캯�� �ù��췽��ֻʹ����Щ���������ʱ����
	 * @param clazz
	 * @return this
	 */
	public BusinessObject(String clazz) throws Exception{
		this.bo = new DefaultBizObject(clazz);
		init();
	}
	
	
	/**
	 * ���캯�� �ù��췽��ʹ�ý������ʼ������
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
	 * ���캯�� �ù��췽��ֻʹ����Щ���������ʱ����
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
	 * ���캯��
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
	 * ���캯��
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
	 * ���캯��
	 * @param bo
	 * @return this
	 */
	public BusinessObject(BizObject bo) throws Exception{
		if(!(bo instanceof StateBizObject))
			throw new Exception("����StateBizObjectʵ��������");
		this.bo = bo;
		init();
	}
	
	/**
	 * ��ʼ�������ֶ�����
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
	 * ��ȡ��Ӧ���Ե��ַ���ֵ
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
			if(value==null) throw new DataException("δ�������"+attributeID+"ֵ�����飡");
			return value.getString();
		}
	}
	
	/**
	 * ��ȡ��Ӧ���Եĸ�����
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
			if(value==null || "".equals(value)) throw new DataException("δ�������"+attributeID+"ֵ�����飡");;
			return value.getDouble();
		}
	}
	
	/**
	 * ��ȡ��Ӧ���Եĸ�����������С�����8λ����ϵͳ��ֻ�����ʲ�ʹ�ã�
	 * @param attributeID
	 * @return double
	 * @throws Exception
	 */
	public double getRate(String attributeID) throws Exception{
		double d = getDouble(attributeID);
		return Arith.round(d, ACCOUNT_CONSTANTS.Number_Precision_Rate);
	}
	
	/**
	 * ��ȡ��Ӧ���Եĸ������ݣ�����С�����2λ����ϵͳ��ֻ�����ս��ʹ�ã������м���ֵ�������������ⶪʧ���ȣ�
	 * @param attributeID
	 * @return double
	 * @throws Exception
	 */
	public double getMoney(String attributeID) throws Exception{
		double d=this.getDouble(attributeID);
		return Arith.round(d, 2);
	}
	
	/**
	 * ��ȡ��Ӧ���Ե�����
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
			if(value==null || "".equals(value)) throw new DataException("δ�������"+attributeID+"ֵ�����飡");
			return value.getInt();
		}
	}
	
	/**
	 * ��ȡ��Ӧ���Եĳ�������ֵ
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
			if(value==null || "".equals(value)) throw new DataException("δ�������"+attributeID+"ֵ�����飡");
			return value.getLong();
		}
	}
	
	/**
	 * ��ȡ��ӦObject
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
			if(value==null) throw new DataException("��"+this.getObjectType()+"��δ�������"+attributeID+"ֵ�����飡");
			return value.getValue();
		}
	}
	
	/**
	 * ��ȡ�ö���ı�ţ�Ψһ��ʾ�ö�����ַ�������JBO�ж��������Զ��ŷָ���ƴ�ӣ�
	 * @param void
	 * @return String    Key1Value,Key2Value,Key3Value,����
	 * @throws Exception
	 */
	public String getObjectNo() throws Exception{
		DataElement[] keyValues = this.bo.getKey().getAttributes();
		if(keyValues.length <= 0) throw new DataException(this.bo.getBizObjectClass().getAbsoluteName()+"δ�������������飡");
		String key = keyValues[0].getString();
		for(int i = 1; i < keyValues.length; i ++ )
		{
			key +=splitRegex+ keyValues[i].getString();
		}
		return key;
	}
	
	/**
	 * ��ȡ�ö�������ͣ���JBO����ȫ·�������ƣ�
	 * @param void
	 * @return String
	 * @throws Exception
	 */
	public String getObjectType() throws Exception{
		if(objectType!=null) return objectType;//ÿ�ζ�ѭ��û��Ҫ
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
	 * ���ö������������Ϊ�գ��Զ�������ˮ������ʹ�ã�
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
	 * ��ȡ����ɸѡ�����Ĺ��������¼
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
	
	//����ָ������
	public void setRelativeObject(String objectType,BusinessObject businessObject) throws Exception {
		if(businessObject==null) return;
		if(businessObject.getObjectNo() ==null || "".equals(businessObject.getObjectNo()))
			throw new Exception("����"+businessObject+"���Ķ�����Ϊ�գ�");
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
	
	//����ָ������
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
	 * ���Ǹ����еĵ����ж�
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
