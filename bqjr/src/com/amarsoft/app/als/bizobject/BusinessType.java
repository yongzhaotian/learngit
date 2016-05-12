package com.amarsoft.app.als.bizobject;

import java.io.Serializable;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * @author hwang
 * @since 2012-12-20
 * @describe 
 */
public class BusinessType  implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2353950527781753939L;
	
	public BusinessType(){
		
	}
	
	public static BusinessType getInstance(String typeNo) throws JBOException{
		BusinessType bt = new BusinessType();
		BizObject boBT=JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE").createQuery("TypeNo=:TypeNo and IsInUse='1'").setParameter("TypeNo",typeNo).getSingleResult(false);
		if(boBT!=null){
			bt.setBizObject(boBT);
			ObjectHelper.fillObjectFromJBO(bt, boBT);
		}else{
			ARE.getLog().error("未找到BUSINESS_TYPE.TypeNo=["+typeNo+"]的业务品种!");
		}
		return bt;
	}
	
	private String typeNo = null;			//客户号
	private String typeName = null;		//客户名
	private String sortNo = null;		//英文名
	private String offSheetFlag = null;		//客户类别代码
	private String isInUse = null;		//客户类型名称
	private String applyDetailNo = null;		//申请显示模板
	private String approveDetailNo = null;		//批复显示模板
	private String contractDetailNo = null;		//合同显示模板
	private String displayTemplet = null;		//出帐显示模板
	private String subtypeCode = null;		//放款通知单
	private BizObject bizObject=null;
	
	public String getTypeNo() {
		return typeNo;
	}
	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getSortNo() {
		return sortNo;
	}
	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}
	public String getOffSheetFlag() {
		return offSheetFlag;
	}
	public void setOffSheetFlag(String offSheetFlag) {
		this.offSheetFlag = offSheetFlag;
	}
	public String getIsInUse() {
		return isInUse;
	}
	public void setIsInUse(String isInUse) {
		this.isInUse = isInUse;
	}
	public String getApplyDetailNo() {
		return applyDetailNo;
	}
	public void setApplyDetailNo(String applyDetailNo) {
		this.applyDetailNo = applyDetailNo;
	}
	public String getApproveDetailNo() {
		return approveDetailNo;
	}
	public void setApproveDetailNo(String approveDetailNo) {
		this.approveDetailNo = approveDetailNo;
	}
	public String getContractDetailNo() {
		return contractDetailNo;
	}
	public void setContractDetailNo(String contractDetailNo) {
		this.contractDetailNo = contractDetailNo;
	}
	public String getDisplayTemplet() {
		return displayTemplet;
	}
	public void setDisplayTemplet(String displayTemplet) {
		this.displayTemplet = displayTemplet;
	}
	public String getSubtypeCode() {
		return subtypeCode;
	}
	public void setSubtypeCode(String subtypeCode) {
		this.subtypeCode = subtypeCode;
	}

	public void setBizObject(BizObject bizObject) {
		this.bizObject = bizObject;
	}

	public BizObject getBizObject() {
		return bizObject;
	}
	
	
}
