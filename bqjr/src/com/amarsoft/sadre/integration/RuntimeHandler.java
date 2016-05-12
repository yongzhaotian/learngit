/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.integration;

import java.util.Iterator;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.jsr94.admin.RuleImpl;
import com.amarsoft.sadre.lic.SADRELicense;
import com.amarsoft.sadre.rules.aco.Assumption;
import com.amarsoft.sadre.services.SADREService;

 /**
 * <p>Title: RuntimeHandler.java </p>
 * <p>Description: ������Ϊ�������ĳ���ģ��,��ɹ��ò��ֵĶ����ʵ��,��������ɾ������ü���ʵ��. </p>
 * 
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 ����11:53:26
 *
 * logs: 1.  
 */
public abstract class RuntimeHandler implements RuleDataObject{
//	/*���ݿ�����*/
//	protected Connection connection;
//	
//	protected Transaction sqlca;			//�ⲿ�����Ӧ�����ݿ�����,���ⲿӦ�����й���
	
	protected RuleImpl runtimeBindingRule = null;	//�����ڹ�������(RunTime-Binding) add at 2011-6-16
	
	public RuleImpl getRuntimeRule() {
		return runtimeBindingRule;
	}
	
	public void bindingRuntimeRule(RuleImpl runtimeRule) {
		this.runtimeBindingRule = runtimeRule;
//		ARE.getLog().debug(this.getClass().getName()+" binding-rule: "+runtimeRule);
	}
	
	/**
	 * 
	 * @param implName
	 * @return
	 * @throws SADREException
	 */
	private Assumption searchRuntimeAssumption(String implName) throws SADREException{
		if(this.runtimeBindingRule==null) {
			throw new SADREException("Runtime-Binding Rule is null!");
		}
		Iterator<Assumption> tk = this.runtimeBindingRule.getAssumptions().iterator();
		while(tk.hasNext()){
			Assumption asmt = tk.next();
			if(asmt.belongDimension().getImpl().equals(implName)){	//${apply.getVouchType}
				return asmt;
			}
		}
//		ARE.getLog().trace("<"+this.getClass().getName()+"> ��Ȩ����ά���������޸�ά�ȶ���"+implName+"!");
		return null;
	}
	
	/**
	 * У���Ƿ�������Ȩ�����ά������
	 * @param sourceValue �Ƚ�ԭֵ
	 * @param mapId 		�Ƚ�ά��ӳ��ID
	 * @return 1.���Ƚ�ά�Ȳ�����,����true;<br>
	 * 			2. ���Ƚ�ά�ȴ���,�򷵻رȽϽ��
	 * @throws SADREException 
	 */
	public boolean validateRuntime(String bindingName,String sourceValue) throws SADREException{
		if(SADREService.getLicenseType()!=SADRELicense.��Ȩ����_������Ȩ){
			ARE.getLog().info("δ��Ȩ�汾����ʹ�������ڰ󶨹���.");
			return false;
		}
		
		boolean vldtStatus = false;
		switch(existsRuntime(bindingName)){
			case �����ڱ���_�Ƿ�:
//				ARE.getLog().info("�����ڱ���_�Ƿ�:"+mapId);
				break;
			case �����ڱ���_������:
//				ARE.getLog().info("�����ڱ���_������:"+mapId);
				vldtStatus = true;		//���������в�������Ϊtrue
				break;
			default:
				String assuptionImpl = Dimensions.getBindingDimensionImpl(bindingName);		//pojoά��ʵ�ֱ��ʽ ${apply.getXXX}
				Assumption asmp = this.searchRuntimeAssumption(assuptionImpl);
				vldtStatus = asmp.doValidate(sourceValue);
		}
		
		return vldtStatus;
		
	}
	
	/**
	 * �Ƿ����ά������
	 * @param mapId
	 * @return
	 */
	public int existsRuntime(String bindingName) throws SADREException{
		if(!Dimensions.isBindingDimension(bindingName)){
			ARE.getLog().warn(this.getClass().getName()+":������ͨ�������ڰ󶨸ñ���["+bindingName+"]!");
			return �����ڱ���_�Ƿ�;
		}
		
		String assuptionImpl = Dimensions.getBindingDimensionImpl(bindingName);		//pojoά��ʵ�ֱ��ʽ ${apply.getXXX}
		Assumption asmp = this.searchRuntimeAssumption(assuptionImpl);
		if(asmp==null){		//asmp==nullΪ��ǰ�����е���Ȩ������û�����ø�ά�ȵ�����,��Ϊ�����Ƹ�ά��
			return �����ڱ���_������;
		}
		
		return �����ڱ���_����;
	}

//	public final void loadData() throws SADREException{
//		try {
//			connection = SADREService.getDBConnection();
////			sqlca = new Transaction(connection);
//		} catch (SQLException e) {
//			e.printStackTrace();
//			throw new SADREException(e);
//		} catch (Exception e) {
//			e.printStackTrace();
//			throw new SADREException(e);
//		}
//		
//		try {
//			execute();
//		} catch (SADREException e) {
//			e.printStackTrace();
//			throw e;
//		}finally{
//			release();
//		}
//	}
//	
//	abstract protected void execute() throws SADREException;
//	
//	/**
//	 * ��������ɶ�������Դռ�õ��ͷ�ʵ��
//	 */
//	abstract protected void releaseResource();
//	
//	private void release(){
//		
//		releaseResource();		//�ͷ������ռ����Դ
//		
//		if(connection!=null){
//			try {
//				connection.close();
//			} catch (SQLException e) {
//				ARE.getLog().warn("���ݿ����ӹر�ʧ��!",e);
//			}
//		}
//	}
//	
//	
}
