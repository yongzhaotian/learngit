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
package com.amarsoft.sadre.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.loader.BasicConfigLoader;
import com.amarsoft.sadre.cache.loader.ConfigLoader;
import com.amarsoft.sadre.rules.aco.Dimension;

 /**
 * <p>Title: Dimensions.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 上午11:40:21
 *
 * logs: 1. 
 */
public class Dimensions extends BasicConfigLoader {
	
	/*包含的维度集合*/
	private static Map<String,Dimension> dimensions = new HashMap<String,Dimension>();
	
	private PreparedStatement psmt = null;
	/**
	 * 运行期绑定维度映射表
	 */
	private static Hashtable<String,String> runtimeBindingMap = new Hashtable<String,String>();
	
	private volatile static Dimensions dms = null;
	
	private Dimensions(){}
	
	public static ConfigLoader getInstance(){
		if(dms == null){
			synchronized (Dimensions.class){
				if(dms == null){
					dms = new Dimensions();
				}
			}
		}
		return dms;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.aco.AbstractConfigObject#execute()
	 */
	public boolean load(Connection conn) throws SADREException {
		dimensions.clear();		//赋值前先清空Dimension
		String sDimensionId 	= "";
		String sDimensionName 	= "";
		String sDimensionType 	= "";
//		String sDimensionSource = "";
		String sDimensionImpl 	= "";
//		String sDimensionArgs 	= "";
		String sOptionType 		= "";
		String sOptionImpl 		= "";
//		String sBinding 		= "";
//		String sRuntimeName		= "";
		String sourceImpl="";
		String sql = "select DIMENSIONID,DIMENSIONNAME,DIMENSIONTYPE,DIMENSIONIMPL,OPTIONTYPE,OPTIONIMPL,SOURCEIMPL " +
				"from SADRE_DIMENSION";
		try {
			psmt = conn.prepareStatement(sql);
			ResultSet resultset = psmt.executeQuery();
			while(resultset.next()){
				sDimensionId 	= resultset.getString("DimensionId");
				sDimensionName 	= resultset.getString("DimensionName");
				sDimensionType 	= resultset.getString("DimensionType");
//				sDimensionSource = resultset.getString("DimensionSource");
				sDimensionImpl 	= resultset.getString("DimensionImpl");
//				sDimensionArgs 	= resultset.getString("DimensionArgs");
				sOptionType 	= resultset.getString("OptionType");
				sOptionImpl 	= resultset.getString("OptionImpl");
//				sBinding 		= resultset.getString("BINDING");
//				sRuntimeName 	= resultset.getString("RUNTIMENAME");
				sourceImpl=	 resultset.getString("SOURCEIMPL");
				Dimension dms = new Dimension(sDimensionId,sDimensionName);
				dms.setType(sDimensionType);
//				dms.setSourceType(sDimensionSource);
				dms.setImpl(sDimensionImpl);
//				dms.setArgs(sDimensionArgs);
				dms.setOptionType(sOptionType);
				dms.setOptionSource(sOptionImpl);
				dms.setSourceimpl(sourceImpl);
//				dms.setBinding(sBinding);
//				dms.setRuntimeName(sRuntimeName);
				dimensions.put(sDimensionId, dms);
				
//				//------------runtime binding dimensions
//				if(sBinding!=null && sBinding.equals("1")){		//选择了运行期绑定
//					if(sRuntimeName==null || sRuntimeName.trim().length()==0){
//						sRuntimeName = sDimensionName;
//					}
//					runtimeBindingMap.put(sRuntimeName, sDimensionImpl);
//				}
				if(dms.getType()==Dimension.维度值类型_字符型){	//字符型默认为运行期绑定
					runtimeBindingMap.put(dms.getName(), sDimensionImpl);
				}
			}
			resultset.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
			ARE.getLog().error(e);
			throw new SADREException(e);
		}
		
		return true;
	}
	
	/**
	 * 根据绑定维度名称获取维度的实现描述Impl
	 * @param bindingName
	 * @return
	 */
	public static String getBindingDimensionImpl(String bindingName){
		return runtimeBindingMap.get(bindingName);
	}
	
	/**
	 * 根据维度名称判断是否为运行期绑定
	 * @param bindingName
	 * @return
	 */
	public static boolean isBindingDimension(String bindingName){
		return runtimeBindingMap.containsKey(bindingName);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.aco.AbstractConfigObject#release()
	 */
	protected void releaseResource() {
		if(psmt!=null){
			try {
				psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
				ARE.getLog().warn("数据库连接关闭失败!",e);
			}
		}

	}
	
	public static void removeDimension(String dimensionId){
		if(containsDimension(dimensionId)){
			dimensions.remove(dimensionId);
			ARE.getLog().info("缓存清理完成!授权维度编号:"+dimensionId);
		}else{
			ARE.getLog().warn("删除目标维度["+dimensionId+"]不存在!");
		}
	}
	
	public static void addDimension(Dimension dimension){
		if(containsDimension(dimension.getId())){
			ARE.getLog().warn("授权维度新增失败!原因:["+dimension.getId()+"]已经存在!");
			
		}else{
			dimensions.put(dimension.getId(), dimension);
			ARE.getLog().info("授权维度缓存新增成功!维度编号:"+dimension.getId());
		}
		
	}
	
	public static boolean containsDimension(String key){
		return dimensions.containsKey(key);
	}
	
	public static Dimension getDimension(String key){
		if(containsDimension(key)){
			return (Dimension)dimensions.get(key);
		}
		return null;
	}
	
	public static Map<String,Dimension> getDimensions(){
		return dimensions;
	}

	
	public void clear() throws SADREException {
		dimensions.clear();
	}
	
}
