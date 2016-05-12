/**
 * Class <code>TriggerTools</code> 是所有对象的触发器调用工具类
 * 它用来执行某个对象在变更时，同时触发更新其关联对象，具体存储数据库参见<code>AbstractBusinessObjectManager.updateDB</code>方法
 *
 * @author  xjzhao
 * @version 1.0, 13/09/23
 * @see com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager
 * @see com.amarsoft.app.accounting.businessobject.BusinessObject
 * @since  JDK1.6
 */
package com.amarsoft.app.accounting.businessobject.trigger;

import java.util.List;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.trigger.IBusinessObjectTrigger;
import com.amarsoft.are.ARE;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;


public class TriggerTools{

	//处理多个对象
	public static void deal(AbstractBusinessObjectManager boManager,List<BusinessObject> boList) throws Exception {
		
		//如果传入对象不存在或为空，则不再处理
		if(boList == null || boList.isEmpty()) return;
		//循环执行各个对象触发其对应的关联对象数据更新
		for(BusinessObject bo:boList)
		{
			deal(boManager, bo);
		}
	}
	//处理一个对象
	public static void deal(AbstractBusinessObjectManager boManager,BusinessObject bo) throws Exception {
		if(bo == null) return;
		Item[] items = CodeCache.getItems("BusinessObjectTriggers");
		for(Item item:items)
		{
			if(item.getItemName().equals(bo.getObjectType()))//对象相等
			{
				try
				{
					String className = item.getItemDescribe();
					if(className == null || className.length() == 0) continue;
					Class iclass = Class.forName(className);
					IBusinessObjectTrigger ibo = (IBusinessObjectTrigger)iclass.newInstance();
					ibo.trigger(boManager, bo,item.getBankNo());
				}catch(Exception ex)
				{
					ex.printStackTrace();
					ARE.getLog().warn("未找到对象【"+bo.getObjectType()+"】触发更新【"+item.getBankNo()+"】的处理类，请检查代码【BusinessObjectTriggers】！");
					continue;
				}
			}
		}
	}
}
