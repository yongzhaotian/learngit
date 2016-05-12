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
 * <p>Description: 本类作为规则对象的抽象模板,完成共用部分的定义和实现,由子类完成具体配置加载实现. </p>
 * 
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 上午11:53:26
 *
 * logs: 1.  
 */
public abstract class RuntimeHandler implements RuleDataObject{
//	/*数据库连接*/
//	protected Connection connection;
//	
//	protected Transaction sqlca;			//外部传入的应用数据库连接,由外部应用自行管理
	
	protected RuleImpl runtimeBindingRule = null;	//运行期规则对象绑定(RunTime-Binding) add at 2011-6-16
	
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
//		ARE.getLog().trace("<"+this.getClass().getName()+"> 授权规则维度条件中无该维度定义"+implName+"!");
		return null;
	}
	
	/**
	 * 校验是否满足授权规则的维度条件
	 * @param sourceValue 比较原值
	 * @param mapId 		比较维度映射ID
	 * @return 1.当比较维度不存在,返回true;<br>
	 * 			2. 当比较维度存在,则返回比较结果
	 * @throws SADREException 
	 */
	public boolean validateRuntime(String bindingName,String sourceValue) throws SADREException{
		if(SADREService.getLicenseType()!=SADRELicense.授权类型_完整授权){
			ARE.getLog().info("未授权版本不能使用运行期绑定功能.");
			return false;
		}
		
		boolean vldtStatus = false;
		switch(existsRuntime(bindingName)){
			case 运行期变量_非法:
//				ARE.getLog().info("运行期变量_非法:"+mapId);
				break;
			case 运行期变量_不存在:
//				ARE.getLog().info("运行期变量_不存在:"+mapId);
				vldtStatus = true;		//规则配置中不存在视为true
				break;
			default:
				String assuptionImpl = Dimensions.getBindingDimensionImpl(bindingName);		//pojo维度实现表达式 ${apply.getXXX}
				Assumption asmp = this.searchRuntimeAssumption(assuptionImpl);
				vldtStatus = asmp.doValidate(sourceValue);
		}
		
		return vldtStatus;
		
	}
	
	/**
	 * 是否存在维度条件
	 * @param mapId
	 * @return
	 */
	public int existsRuntime(String bindingName) throws SADREException{
		if(!Dimensions.isBindingDimension(bindingName)){
			ARE.getLog().warn(this.getClass().getName()+":不允许通过运行期绑定该变量["+bindingName+"]!");
			return 运行期变量_非法;
		}
		
		String assuptionImpl = Dimensions.getBindingDimensionImpl(bindingName);		//pojo维度实现表达式 ${apply.getXXX}
		Assumption asmp = this.searchRuntimeAssumption(assuptionImpl);
		if(asmp==null){		//asmp==null为当前所运行的授权规则中没有配置该维度的条件,视为不控制该维度
			return 运行期变量_不存在;
		}
		
		return 运行期变量_存在;
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
//	 * 由子类完成对自身资源占用的释放实现
//	 */
//	abstract protected void releaseResource();
//	
//	private void release(){
//		
//		releaseResource();		//释放子类的占用资源
//		
//		if(connection!=null){
//			try {
//				connection.close();
//			} catch (SQLException e) {
//				ARE.getLog().warn("数据库连接关闭失败!",e);
//			}
//		}
//	}
//	
//	
}
