package com.amarsoft.app.awe.config.dw.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class DataObjectLibListAction {
	private String DONO;
	private String colIndex;
	private String doWithX;
	public static String doX = "";

	/**
	 * 复制
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String quickCopyLib(JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_LIBRARY");
		BizObjectManager mD = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_CATALOG");
		tx.join(m);
		tx.join(mD);
		String colindex =  colIndex;
		BizObject lib = m.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO", DONO).setParameter("ColIndex", colIndex).getSingleResult(false);
		BizObject libx = null;
		while(true){
			colindex +="_copy";
			libx = m.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO", DONO).setParameter("ColIndex", colindex).getSingleResult(false);
			if(libx==null)
			break;
		}
		BizObject newLib = m.newObject();
		newLib.setAttributesValue(lib);
		newLib.setAttributeValue("ColIndex", colindex);
		m.saveObject(newLib);
		List<BizObject> bizList = mD.createQuery("PARENT=:PARENT").setParameter("PARENT", DONO).getResultList(false);
		if(bizList!=null){
			if(doWithX.equals("1")){
				for(int i = 0;i<bizList.size();i++){
					BizObject newLibX = m.newObject();
					newLibX.setAttributesValue(lib);
					newLibX.setAttributeValue("DONO", bizList.get(i).getAttribute("DONO"));
					newLibX.setAttributeValue("COLINDEX", colindex);
					newLibX.setAttributeValue("ISUPDATE", "");
					newLibX.setAttributeValue("PARENTCOLINDEX", colindex);
					m.saveObject(newLibX);
				}
			}
		}
		initData();
		return "SUCCESS";
	}
	
	/**
	 * 删除
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String quickDeleteLib(JBOTransaction tx) throws JBOException{
		BizObjectManager mD = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_CATALOG");
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_LIBRARY");
		tx.join(m);
		tx.join(mD);
		List<BizObject> bizList = mD.createQuery("PARENT=:PARENT").setParameter("PARENT", DONO).getResultList(false);
		if(bizList!=null){
			BizObject lib = m.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO", DONO).setParameter("ColIndex", colIndex).getSingleResult(false);
			if(doWithX.equals("1")){
				for(int i = 0;i<bizList.size();i++){
					BizObject libX = m.createQuery("DONO = :DONO and PARENTCOLINDEX = :PARENTCOLINDEX").setParameter("DONO", bizList.get(i).getAttribute("DONO").getValue().toString()).setParameter("PARENTCOLINDEX", colIndex).getSingleResult(false);
					m.deleteObject(libX);
				}
			}
			m.deleteObject(lib);
		}
		initData();
		return "SUCCESS";
	}
	
	/**
	 * 判断是否要弹出对话框对子模板进行操作
	 * @return
	 * @throws JBOException 
	 */
	public String isAlert(JBOTransaction tx) throws JBOException {
		BizObjectManager dm = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_CATALOG");
		List<BizObject> listBiz= dm.createQuery("PARENT =:PARENT").setParameter("PARENT",DONO).getResultList(false);
		tx.join(dm);
		int j = 0;
		if(listBiz!=null){
			BizObjectManager m = JBOFactory.getBizObjectManager("jbo.sys.DATAOBJECT_LIBRARY");
			tx.join(m);
			for(int i  = 0;i<listBiz.size();i++){
				BizObject lib = m.createQuery("DONO = :DONO and PARENTCOLINDEX = :PARENTCOLINDEX").setParameter("DONO", listBiz.get(i).getAttribute("DONO").getValue().toString()).setParameter("PARENTCOLINDEX", colIndex).getSingleResult(false);
				if(lib!=null){
					if(lib.getAttribute("ISUPDATE").getValue()!=null&&lib.getAttribute("ISUPDATE").getValue().toString().equals("1")){
					}else{
						j++;
					}
			}
				if(j>0)return "SUCCESS";
			}
		}
		return "FAILED";
	}
	
	/**
	 * 初始数据
	 */
	private void initData() {
		XFrameHandler.sMap.clear();
		XFrameHandler.bizI = 0;
		XFrameHandler.bizN = 0;
	}
	
	public void setDoX(JBOTransaction tx) throws JBOException{
	}
	
	public String getDoX() {
		return doX;
	}

	public  void setDoX(String doX) {
		this.doX = doX;
	}

	public String getDONO() {
		return DONO;
	}

	public void setDONO(String dONO) {
		DONO = dONO;
	}

	public String getColIndex() {
		return colIndex;
	}

	public void setColIndex(String colIndex) {
		this.colIndex = colIndex;
	}

	public String getDoWithX() {
		return doWithX;
	}

	public void setDoWithX(String doWithX) {
		this.doWithX = doWithX;
	}
	
}