package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ���๦��˵��
 * @author ${����}
 * @since ${����}
 * ˵����1. ���������˶�JBO��ʹ�á������У��������϶࣬�����ͽ�Ϊ����ʱ���򵥵ĳ���������ʹ�����������Щ����
 *       	�����ʹ����JBO�����г�ʼ���࣬�������ƵĲ�����װΪһ��JBO���󣬴�ŵ������������У�����ʹ��ʱ����
 *       	����㲻��ʹ��JBO��Ҳû��ϵ��ֻҪ�ڳ�����ʼ�����У��Ѽ���JBO�ǲ���ȥ�����߲����ó�ʼ���༴��
 *       	��û��JBO������£�����ֱ�Ӱ����ҵ������ŵ������������У�ֱ��ʹ�á�ֻ�������ҪҪע�������Ҫ�໥����
 *       2.������Ƚϼ򵥣�ʹ��һ��SQL��伴����ɣ��򲻱�Ҫ����java�ֱ࣬���ڼ��ģ��������һ��������ģ����������ΪSQL���ɡ�
 *         ����ʵ����ο�[�����ţ�001,ģ�ͱ�ţ�010880]
 * @updatesuer:yhshan
 * @updatedate:2012/09/11
 */
public class DemoCheck extends AlarmBiz {
	
	/* ��Ա�������� */
	/**
	 * ͳ�Ƹ���
	 */
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/* ȡ���� */
		String sObjectType = (String)this.getAttribute("ObjectType");			//ObjectType�������κ�ҵ�����ֻ�ܵ�������ȡ,����һ�㲻����
		String sObjectNo = (String)this.getAttribute("ObjectNo");				//ObjectNo�������κ�ҵ�����ֻ�ܵ�������ȡ,����һ�㲻����
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");	//ȡ���ͻ�JBO����
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//ȡ������JBO����
		
		
		/* �������� */
		String sDirection = jboApply.getAttribute("Direction").getString();
		
		
		/* ������ */
		//ʹ���������ҵͶ��ƥ�����ݿ������õ�������ҵͶ��
		SqlObject so = new SqlObject("select count(CodeNo) from CODE_LIBRARY where CodeNo = 'IndustryType' and ItemNo =:ItemNo and ItemDescribe = '1'");
		so.setParameter("ItemNo", sDirection);
		sCount = Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0 ){				
			putMsg("���������ҵͶ��Ϊ����������ҵ");
		}
		
		demoFunc(sObjectNo);
		demoFunc(jboCustomer);
		
		/* ���ؽ������ */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
	
	/**
	 * ʾ������
	 * @param obj����������
	 * @return
	 */
	public Object demoFunc(Object obj){
		return null;
	}
}
