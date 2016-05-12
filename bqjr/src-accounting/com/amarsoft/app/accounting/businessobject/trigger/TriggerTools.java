/**
 * Class <code>TriggerTools</code> �����ж���Ĵ��������ù�����
 * ������ִ��ĳ�������ڱ��ʱ��ͬʱ����������������󣬾���洢���ݿ�μ�<code>AbstractBusinessObjectManager.updateDB</code>����
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

	//����������
	public static void deal(AbstractBusinessObjectManager boManager,List<BusinessObject> boList) throws Exception {
		
		//���������󲻴��ڻ�Ϊ�գ����ٴ���
		if(boList == null || boList.isEmpty()) return;
		//ѭ��ִ�и������󴥷����Ӧ�Ĺ����������ݸ���
		for(BusinessObject bo:boList)
		{
			deal(boManager, bo);
		}
	}
	//����һ������
	public static void deal(AbstractBusinessObjectManager boManager,BusinessObject bo) throws Exception {
		if(bo == null) return;
		Item[] items = CodeCache.getItems("BusinessObjectTriggers");
		for(Item item:items)
		{
			if(item.getItemName().equals(bo.getObjectType()))//�������
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
					ARE.getLog().warn("δ�ҵ�����"+bo.getObjectType()+"���������¡�"+item.getBankNo()+"���Ĵ����࣬������롾BusinessObjectTriggers����");
					continue;
				}
			}
		}
	}
}
