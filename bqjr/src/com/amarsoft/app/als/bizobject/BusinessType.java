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
			ARE.getLog().error("δ�ҵ�BUSINESS_TYPE.TypeNo=["+typeNo+"]��ҵ��Ʒ��!");
		}
		return bt;
	}
	
	private String typeNo = null;			//�ͻ���
	private String typeName = null;		//�ͻ���
	private String sortNo = null;		//Ӣ����
	private String offSheetFlag = null;		//�ͻ�������
	private String isInUse = null;		//�ͻ���������
	private String applyDetailNo = null;		//������ʾģ��
	private String approveDetailNo = null;		//������ʾģ��
	private String contractDetailNo = null;		//��ͬ��ʾģ��
	private String displayTemplet = null;		//������ʾģ��
	private String subtypeCode = null;		//�ſ�֪ͨ��
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
