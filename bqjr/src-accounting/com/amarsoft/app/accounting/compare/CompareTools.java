package com.amarsoft.app.accounting.compare;

import java.util.ArrayList;
import java.util.List;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.compare.method.ICompare;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class CompareTools {
	
	public static boolean ruleAnalysis(List<BusinessObject> ruleList,BusinessObject bo,Transaction sqlca) throws Exception
	{
		ASValuePool as = new ASValuePool();
		//对条件规则进行分组
		for(BusinessObject rule:ruleList)
		{
			List<BusinessObject> ls = (List<BusinessObject>)as.getAttribute(rule.getString("RuleID"));
			if(ls == null)
			{
				ls = new ArrayList<BusinessObject>();
				as.setAttribute(rule.getString("RuleID"), ls);
			}
			ls.add(rule);
		}
		
		//组与组之间为或、组内为且
		boolean allFlag = false;
		for(Object s : as.getKeys())
		{
			String key = (String)s;
			List<BusinessObject> ls = (List<BusinessObject>)as.getAttribute(key);
			boolean flag = (ls.size() != 0);
			for(BusinessObject l:ls)
			{
				String colID = l.getString("ColID");
				String colType = l.getString("ColType");
				String valueList = l.getString("ValueList");
				String compareType = l.getString("CompareType");
				if(colID == null || "".equals(colID) 
					|| colType == null || "".equals(colType)
					|| valueList == null || "".equals(valueList)
					|| compareType == null || "".equals(compareType))
				{
					flag = false;
					break;
				}
				
				
				Item item = CodeCache.getItem("CompareType", compareType);
				String className = item.getItemDescribe();
				if(className == null || "".equals(className))
				{
					flag = false;
					break;
				}
				Class<?> c = Class.forName(className);
				ICompare compareClass=((ICompare)c.newInstance());
				
				item = CodeCache.getItem("TermAttribute", l.getString("ColID"));
				String objectAttributes = item.getAttribute3();//获取属性所对应的数据库表字段
				if(objectAttributes.indexOf("${") >=0) //表达式直接计算结果
				{
					//如果出现异常，则默认结果为FLASE
					try
					{
						if("2".equals(colType))//小数
						{
							Double colValue = ExtendedFunctions.getScriptDoubleValue(objectAttributes,bo,sqlca);
							Double colValueList = Double.parseDouble(valueList);
							flag = (flag&&compareClass.compare(colValue, colValueList));
						}else if("5".equals(colType))//整数
						{
							Integer colValue = ExtendedFunctions.getScriptIntValue(objectAttributes,bo,sqlca);
							Integer colValueList = Integer.parseInt(valueList);
							flag = (flag&&compareClass.compare(colValue, colValueList));
						}
						else//字符串
						{
							String colValue = ExtendedFunctions.getScriptStringValue(objectAttributes,bo,sqlca);
							flag = (flag&&compareClass.compare(colValue, valueList));
						}
					}catch(Exception ex)
					{
						flag = false;
						break;
					}
				}
				else //非表达式直接取值
				{
					if("2".equals(colType))//小数
					{
						Double colValue = null;
						for(String objectAttribute:objectAttributes.split(","))
						{
							String objectType = objectAttribute.substring(0, objectAttribute.lastIndexOf("."));
							String attributeID = objectAttribute.substring(objectAttribute.lastIndexOf(".")+1);
							if(bo.getObjectType().equals(objectType))
								colValue = bo.getDouble(attributeID);
							/*
							else
							{
								List<BusinessObject> relativeObjects = bo.getRelativeObjects(objectType);
								if(relativeObjects != null && relativeObjects.size()!=0)
								{
									colValue = relativeObjects.get(0).getDouble(attributeID);
								}
							}*/
						}
						if(colValue == null){
							flag = false;
							break;
						}
						else
						{
							Double colValueList = Double.parseDouble(valueList);
							flag = (flag&&compareClass.compare(colValue, colValueList));
						}
					}
					else if("5".equals(colType))//整数
					{
						Integer colValue = null;
						for(String objectAttribute:objectAttributes.split(","))
						{
							String objectType = objectAttribute.substring(0, objectAttribute.lastIndexOf("."));
							String attributeID = objectAttribute.substring(objectAttribute.lastIndexOf(".")+1);
							if(bo.getObjectType().equals(objectType))
								colValue = bo.getInt(attributeID);
							/*
							else
							{
								List<BusinessObject> relativeObjects = bo.getRelativeObjects(objectType);
								if(relativeObjects != null && relativeObjects.size()!=0)
								{
									colValue = relativeObjects.get(0).getInt(attributeID);
								}
							}*/
						}
						if(colValue == null)
						{
							flag = false;
							break;
						}
						else
						{
							Integer colValueList = Integer.parseInt(valueList);
							flag = (flag&&compareClass.compare(colValue, colValueList));
						}
					}
					else //字符串
					{
						String colValue = null;
						for(String objectAttribute:objectAttributes.split(","))
						{
							String objectType = objectAttribute.substring(0, objectAttribute.lastIndexOf("."));
							String attributeID = objectAttribute.substring(objectAttribute.lastIndexOf(".")+1);
							if(bo.getObjectType().equals(objectType))
								colValue = bo.getString(attributeID);
							/*
							else
							{
								List<BusinessObject> relativeObjects = bo.getRelativeObjects(objectType);
								if(relativeObjects != null && relativeObjects.size()!=0)
								{
									colValue = relativeObjects.get(0).getString(attributeID);
								}
							}*/
						}
						if(colValue == null)
						{
							flag = false;
							break;
						}
						else
						{
							String colValueList = valueList;
							flag = (flag&&compareClass.compare(colValue, colValueList));
						}
					}
				}
				if(!flag)//false则无需再循环处理
					break;
			}
			
			allFlag = (allFlag || flag);
			if(allFlag)
				break;
		}
		
		return allFlag;
	}
	
}
