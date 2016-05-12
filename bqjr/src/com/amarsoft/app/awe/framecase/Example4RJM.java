package com.amarsoft.app.awe.framecase;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
/**
 * 
 * RunJavaMethod,
 * RunJavaMethodSqlca,
 * RunJavaMethodTrans������ʾ����
 * 1.��Ա����(=Run����)�����ṩset������
 * 2.Transaction�����JBOTransaction������߼�һ�㲻Ҫ���á�
 * 3.������run����ʱ���д��������������ֹ������ˣ�������֤һ����������ֻ��һ������Ϊ�á�
 *
 */
public class Example4RJM {
	//run����ʱ����Ĳ���
	public String ExampleId;
	public String applySum;
	
	/**
	 * RunJavaMethod���ò��������java����ʾ��
	 * @return �޲���
	 * @throws JBOException
	 */
	public String getExampleName() throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.EXAMPLE_INFO");
		BizObject bo = bm.createQuery("ExampleId=:ExampleId").setParameter("ExampleId",ExampleId).getSingleResult(false);
		if(bo!=null) return bo.getAttribute("ExampleName").getString();
		return "";
	}
	
	/**
	 * RunJavaMethodSqlca���ô�Transaction�����java����ʾ�������������߼���һ�������������ύ�ͻع������ֹ�����</br>
	 * �߼���ʵ�֣�������Ҫ��JBO��
	 * ����ALS7C�ı���淶��SQL����SqlObject��װ��
	 * @param sqlca ���ҽ���Transaction���������ò���ֵ��run����ʱ���ã�����Ҫ������ֵ����
	 * @return
	 * @throws Exception
	 */
	public String deleteExampleByIds(Transaction sqlca) throws Exception{
		String[] ids = ExampleId.split("@");
		for(int i=0;i<ids.length;i++){
			sqlca.executeSQL(new SqlObject("delete from Example_Info where ExampleId=:ExampleId").setParameter("ExampleId", ids[i]));
		}			
		return "SUCCESS";
	}
	
	/**
	 * RunJavaMethodSqlca���ô�Transaction�����java����ʾ�������������߼���һ�������������ύ�ͻع������ֹ�����</br>
	 * �߼���ʵ�֣�������Ҫ��JBO��
	 * ����ALS7C�ı���淶��SQL����SqlObject��װ��
	 * @param sqlca ���ҽ���Transaction���������ò���ֵ��run����ʱ���ã�����Ҫ������ֵ����
	 * @return
	 * @throws Exception
	 */
	public String deleteExample(Transaction sqlca) throws Exception{
		ASResultSet rs = sqlca.getASResultSet(new SqlObject("select ParentExampleId from Example_Info where ExampleId=:ExampleId").setParameter("ExampleId", ExampleId));
		if(rs.next()) {
			String sParentID = rs.getString(1);
			sqlca.executeSQL(new SqlObject("delete from Example_Info where ExampleId=:ExampleId").setParameter("ExampleId", sParentID));
		}
		rs.getStatement().close();
		sqlca.executeSQL(new SqlObject("delete from Example_Info where ExampleId=:ExampleId").setParameter("ExampleId", ExampleId));
		return "SUCCESS";
	}
	
	/**
	 * RunJavaMethodTrans���ô�JBOTransaction�����java����ʾ�������������߼���һ�������������ύ�ͻع������ֹ�����</br>
	 * �߼���ʵ�֣�������Ҫ��SqlCa��
	 * @param tx ���ҽ���JBOTransaction���������ò���ֵ��run����ʱ���ã�����Ҫ������ֵ����
	 * @return
	 * @throws JBOException
	 */
	public String changeExample(JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.EXAMPLE_INFO");
		tx.join(bm);
		BizObject bo = bm.createQuery("ExampleId=:ExampleId").setParameter("ExampleId",ExampleId).getSingleResult(true);
		if(bo!=null) {
			//����һ����ʾ�������Ƹ�ʾ������Ϣ
			BizObject bo1 = bm.newObject();
			bo1.setValue(bo);
			bo1.getAttribute("ExampleId").setNull();
			bo1.setAttributeValue("ParentExampleId", ExampleId);
			bm.saveObject(bo1);
			//��ʾ������������
			bo.setAttributeValue("ApplySum", applySum);
			bm.saveObject(bo);
		}else{
			return "FAILURE";
		}
		return "SUCCESS";
	}

	public String getExampleId() {
		return ExampleId;
	}

	public void setExampleId(String ExampleId) {
		this.ExampleId = ExampleId;
	}

	public String getApplySum() {
		return applySum;
	}

	public void setApplySum(String applySum) {
		this.applySum = applySum;
	}
	
}
