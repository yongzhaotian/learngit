package com.amarsoft.app.awe.config.dw.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * 父子模板方法类
 * @author xsli
 *
 */
public class XFrameHandler extends CommonHandler {
	
	public static Map<Integer,BizObject> sMap = new HashMap<Integer, BizObject>();
	public static Integer bizI = 0;
	public static Integer bizN = 0;
	
	/**
	 * 编辑对象初始化操作，对象页面渲染后即展现
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		sMap.put(bizI++,bo);
	}
	
	/**
	 * 插入页面对象后事务处理方法
	 * @param tx 事务控制对象
	 * @param bo 已插入的页面对象
	 * @throws Exception 
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo) throws Exception {
		BizObjectManager mD = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_CATALOG");
		tx.join(mD);
		String sDoNo = bo.getAttribute("DONO").getValue().toString();
		String sColindex = bo.getAttribute("COLINDEX").getValue().toString();
		List<BizObject> bizList = mD.createQuery("PARENT=:PARENT").setParameter("PARENT", sDoNo).getResultList(false);
		if(bizList!=null){
			for(int i = 0;i<bizList.size();i++){
			if(DataObjectLibListAction.doX.equals("1")){
				String sDoNoX = bizList.get(i).getAttribute("DONO").getValue().toString();
				BizObject lib = manager.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO",sDoNo ).setParameter("ColIndex", sColindex).getSingleResult(false);
				BizObject libExist = manager.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO", sDoNoX).setParameter("ColIndex", sColindex).getSingleResult(false);
				BizObject newLib = manager.newObject();
				if(libExist==null){
					newLib.setAttributesValue(lib);
					newLib.setAttributeValue("DONO", sDoNoX);
					newLib.setAttributeValue("PARENTCOLINDEX", sColindex);
					manager.saveObject(newLib);
				}else{
					BizObject test = manager.createQuery("DONO =:DONO ORDER BY COLINDEX DESC").setParameter("DONO", sDoNoX).getSingleResult(false);
					int newColindex =Integer.parseInt(test.getAttribute("COLINDEX").getValue().toString())+10;
					newLib.setAttributesValue(lib);
					newLib.setAttributeValue("DONO", sDoNoX);
					newLib.setAttributeValue("PARENTCOLINDEX", sColindex);
					newLib.setAttributeValue("COLINDEX", newColindex+"");
					newLib.setAttributeValue("COLINDEX",manager.createQuery("select max(colindex) from O  where DONO =:DONO").getSingleResult(false).getAttribute("COLINDEX").getValue().toString());
					manager.saveObject(newLib);
				}
			}
			}
		}
		
	}

	/**
	 * 页面对象修改后事务处理方法
	 * @param tx 事务控制对象
	 * @param bo 已修改的页面对象
	 * @throws Exception 
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception {
		
		BizObjectManager mD = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_CATALOG");
		tx.join(mD);
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_LIBRARY");
		tx.join(m);
		BizObject lib = sMap.get(bizN++);
		List<BizObject> bizList = mD.createQuery("PARENT=:PARENT").setParameter("PARENT", lib.getAttribute("DONO").getValue().toString()).getResultList(false);
		if(bizList!=null){
			for(int i = 0;i<bizList.size();i++){
				if(DataObjectLibListAction.doX.equals("1")){
					BizObject libX =m.createQuery("DONO=:DONO and PARENTCOLINDEX=:PARENTCOLINDEX").setParameter("DONO", bizList.get(i).getAttribute("DONO").getValue().toString()).setParameter("PARENTCOLINDEX", lib.getAttribute("COLINDEX").getValue().toString()).getSingleResult(false);
					BizObject newLib = m.newObject();
					if(libX!=null){
						if(libX.getAttribute("ISUPDATE").getValue()!=null&&libX.getAttribute("ISUPDATE").getValue().toString().equals("1")){
							newLib.setAttributesValue(libX);
							newLib.setAttributeValue("PARENTCOLINDEX",bo.getAttribute("COLINDEX").getValue().toString());
							m.deleteObject(libX);
							m.saveObject(newLib);
						}else{
							String colindexX  = libX.getAttribute("COLINDEX").getValue().toString();
							newLib.setAttributesValue(bo);
							newLib.setAttributeValue("DONO",bizList.get(i).getAttribute("DONO").getValue().toString());
							newLib.setAttributeValue("PARENTCOLINDEX",bo.getAttribute("COLINDEX").getValue().toString());
							newLib.setAttributeValue("COLINDEX",colindexX);
							m.deleteObject(libX);
							m.saveObject(newLib);
						}
					}
				}
			}
		}
		
	}
}
