/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.bizlet;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.sadre.app.action.BasicWebAction;
import com.amarsoft.sadre.app.action.RemoveDimension;
import com.amarsoft.sadre.app.action.RemoveScene;
import com.amarsoft.sadre.app.action.RemoveSceneGroup;
import com.amarsoft.sadre.app.action.ReplicateScene;
import com.amarsoft.sadre.app.action.UpdateDimension;
import com.amarsoft.sadre.app.action.UpdateScene;
import com.amarsoft.sadre.app.action.WebAction;

/**
 * <p>Title: AuthorObjectManage.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2012-4-10 下午2:47:02</p>
 *
 * logs: 1. </p>
 */
public class AuthorObjectManage extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	@Override
	public Object run(Transaction sqlca) throws Exception {
		//操作类型 update更新 remove删除
		String actionType 	= DataConvert.toString((String)this.getAttribute("ActionType"));
		//对象类型 scene授权方案 dimension授权参数
		String objectType 	= DataConvert.toString((String)this.getAttribute("ObjectType"));
		//与对象类型相对应的对象编号  方案编号/参数编号
		String objectNo 	= DataConvert.toString((String)this.getAttribute("ObjectNo"));
		
		if(actionType.length()==0 || objectType.length()==0 || objectNo.length()==0){
			ARE.getLog().warn("参数非法,不允许为空! ActionType="+actionType+" |ObjectType="+objectType+" |ObjectNo="+objectNo);
//			return WebAction.ACTION_DESC_失败;
			throw new Exception("参数非法,不允许为空! ActionType="+actionType+" |ObjectType="+objectType+" |ObjectNo="+objectNo);
		}
		
		//ARE.getLog().info(actionType.toUpperCase().matches("([\']?UPDATE[\']?|[\']?REMOVE[\']?)"));
		//将'update' -> update
		actionType = actionType.replaceAll("\'", "");
		objectType = objectType.replaceAll("\'", "");
		if(!actionType.toUpperCase().matches("(UPDATE|REMOVE|REPLICATE)")
				|| !objectType.toUpperCase().matches("(SCENE|DIMENSION|SCENEGROUP)")){
			ARE.getLog().warn("参数非法,错误的参数! ActionType="+actionType+" |ObjectType="+objectType);
//			return WebAction.ACTION_DESC_失败;
			throw new Exception("参数非法,错误的参数! ActionType="+actionType+" |ObjectType="+objectType);
		}
//		ARE.getLog().debug("ActionType="+actionType+" |ObjectType="+objectType);
		
		WebAction action = null;
		if(objectType.equalsIgnoreCase("SCENE")){
			if(actionType.equalsIgnoreCase("UPDATE")){
				//UpdateScene
				action = new UpdateScene();
				((UpdateScene)action).setSceneId(objectNo);
				
			}else if(actionType.equalsIgnoreCase("REMOVE")){
				//RemoveScene
				action = new RemoveScene();
				((RemoveScene)action).setSceneId(objectNo);
			}else if(actionType.equalsIgnoreCase("REPLICATE")){
				//ReplicateScene
				action = new ReplicateScene();
				((ReplicateScene)action).setSceneId(objectNo);
			}
		}else if(objectType.equalsIgnoreCase("DIMENSION")){
			if(actionType.equalsIgnoreCase("UPDATE")){
				//UpdateDimension
				action = new UpdateDimension();
				((UpdateDimension)action).setDimensionId(objectNo);
				
			}else if(actionType.equalsIgnoreCase("REMOVE")){
				//RemoveDimension
				action = new RemoveDimension();
				((RemoveDimension)action).setDimensionId(objectNo);
				
			}
		}else if(objectType.equalsIgnoreCase("SCENEGROUP")){
			if(actionType.equalsIgnoreCase("REMOVE")){
				//RemoveSceneGroup
				action = new RemoveSceneGroup();
				((RemoveSceneGroup)action).setGroupID(objectNo);
				
			}
		}
		
		return BasicWebAction.describe(action.execute(sqlca));
	}

}
