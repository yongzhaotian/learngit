package com.amarsoft.app.awe.config.function.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 功能点删除处理，删除功能点记录的同时删除其与可见角色的关联关系
 * @author xhgao
 *
 */
public class DeleteFunctionAction {

	//定义变量
	private String functionID; //功能点编号

	public String getFunctionID() {
		return functionID;
	}

	public void setFunctionID(String functionID) {
		this.functionID = functionID;
	}

	public String deleteFuncAndRela(JBOTransaction tx) throws Exception{
		
		//先删除功能点下的权限点
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.awe.AWE_FUNCTION_URL");
		BizObjectQuery q = bom.createQuery("SELECT * FROM O WHERE FunctionID = :FunctionID").setParameter("FunctionID", functionID);
		List<BizObject> list = q.getResultList(false);
		for(BizObject bo :list){
			DeleteRightPointAction delRight = new DeleteRightPointAction();
			delRight.setRightPointURL(bo.getAttribute("URL").getString());
			delRight.deleteRightAndRela(tx);
		}
		
		//删除指定功能点与可见角色的关联
		bom = JBOFactory.getBizObjectManager("jbo.awe.AWE_ROLE_FUNCTION");
		tx.join(bom);
		bom.createQuery("DELETE FROM O where FunctionID = :FunctionID").setParameter("FunctionID", functionID).executeUpdate();
		
		//删除指定功能点信息
		bom = JBOFactory.getBizObjectManager("jbo.awe.AWE_FUNCTION_INFO");
		tx.join(bom);
		bom.createQuery("DELETE FROM O WHERE FunctionID = :FunctionID").setParameter("FunctionID", functionID).executeUpdate();
		
		return "SUCCEEDED";
	}
}
