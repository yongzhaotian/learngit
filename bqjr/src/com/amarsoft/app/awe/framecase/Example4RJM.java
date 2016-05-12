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
 * RunJavaMethodTrans调用类示例。
 * 1.成员变量(=Run参数)，请提供set方法。
 * 2.Transaction事务和JBOTransaction事务的逻辑一般不要混用。
 * 3.事务由run调用时进行处理，方法中无需手工处理了，尽量保证一个方法里是只有一个事务为好。
 *
 */
public class Example4RJM {
	//run调用时传入的参数
	public String ExampleId;
	public String applySum;
	
	/**
	 * RunJavaMethod调用不带事务的java方法示例
	 * @return 无参数
	 * @throws JBOException
	 */
	public String getExampleName() throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.EXAMPLE_INFO");
		BizObject bo = bm.createQuery("ExampleId=:ExampleId").setParameter("ExampleId",ExampleId).getSingleResult(false);
		if(bo!=null) return bo.getAttribute("ExampleName").getString();
		return "";
	}
	
	/**
	 * RunJavaMethodSqlca调用带Transaction事务的java方法示例，方法体中逻辑在一个事务里，事务的提交和回滚无需手工处理。</br>
	 * 逻辑的实现，尽量不要含JBO。
	 * 另外ALS7C的编码规范：SQL请用SqlObject封装。
	 * @param sqlca 有且仅有Transaction参数，但该参数值由run调用时设置，不需要真正传值进来
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
	 * RunJavaMethodSqlca调用带Transaction事务的java方法示例，方法体中逻辑在一个事务里，事务的提交和回滚无需手工处理。</br>
	 * 逻辑的实现，尽量不要含JBO。
	 * 另外ALS7C的编码规范：SQL请用SqlObject封装。
	 * @param sqlca 有且仅有Transaction参数，但该参数值由run调用时设置，不需要真正传值进来
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
	 * RunJavaMethodTrans调用带JBOTransaction事务的java方法示例，方法体中逻辑在一个事务里，事务的提交和回滚无需手工处理。</br>
	 * 逻辑的实现，尽量不要含SqlCa。
	 * @param tx 有且仅有JBOTransaction参数，但该参数值由run调用时设置，不需要真正传值进来
	 * @return
	 * @throws JBOException
	 */
	public String changeExample(JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.EXAMPLE_INFO");
		tx.join(bm);
		BizObject bo = bm.createQuery("ExampleId=:ExampleId").setParameter("ExampleId",ExampleId).getSingleResult(true);
		if(bo!=null) {
			//新增一个子示例，复制父示例的信息
			BizObject bo1 = bm.newObject();
			bo1.setValue(bo);
			bo1.getAttribute("ExampleId").setNull();
			bo1.setAttributeValue("ParentExampleId", ExampleId);
			bm.saveObject(bo1);
			//父示例更新申请金额
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
