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
package com.amarsoft.sadre.cache.snap;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.rules.aco.WorkingObject;

 /**
 * <p>Title: ExecutionSnap.java </p>
 * <p>Description: 针对运行期的维度计算做snap快照,对于已经存在结果快照的维度不再进行实时计算. </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-9-30 上午10:38:59
 *
 * logs: 1. 
 */
public class ExecutionSnap {
	private static Map<String,Snap> snapPool = new Hashtable<String,Snap>();
	
	private volatile static ExecutionSnap snap = null;
	
	private ExecutionSnap(){}

	public static ExecutionSnap getInstance(){
		if(snap == null){
			synchronized (ExecutionSnap.class){
				if(snap == null){
					snap = new ExecutionSnap();
				}
			}
		}
		return snap;
	}
	
	public Snap getSnap(Object obj){
		WorkingObject wo = (WorkingObject)obj;
		Snap snap = null;
		if(snapPool.containsKey(wo.uniqeCode())){
			snap = snapPool.get(wo.uniqeCode());
		}else{
			snap = new Snap(wo);
			snapPool.put(wo.uniqeCode(), snap);
		}
		return snap;
	}
	
	public void clearSnap(Hashtable<String,Object> workingMemory){
//		ARE.getLog().trace(snapPool);
//		ARE.getLog().trace(workingMemory);
		Iterator<Object> tk = workingMemory.values().iterator();
		while(tk.hasNext()){
//			String objCode = tk.next();
			WorkingObject wo = (WorkingObject)tk.next();
//			ARE.getLog().debug("objCode="+wo.uniqeCode());
			if(snapPool.containsKey(wo.uniqeCode())){
				//-------clear snapElement
				Snap snap = snapPool.get(wo.uniqeCode());
				snap.clearSnaps();
				//-------clear snapPool
				snapPool.remove(wo.uniqeCode());
//				ARE.getLog().trace("WorkingObject["+wo.getClass().getName()+"] snap removed!");
			}else{
//				ARE.getLog().trace("WorkingObject["+wo.getClass().getName()+"] is not snaped!");
			}
		}
//		ARE.getLog().trace("workingMemory snaps clear sussessful!");
	}
}
