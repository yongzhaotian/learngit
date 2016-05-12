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
package com.amarsoft.sadre.app.widget;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.widget.tree.ITreeNode;
import com.amarsoft.sadre.app.widget.tree.LeafNode;
import com.amarsoft.sadre.app.widget.tree.RootNode;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.rules.aco.Dimension;
import com.amarsoft.web.ui.HTMLTreeView;

 /**
 * <p>Title: DimensionTree.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-23 下午4:29:13
 *
 * logs: 1. 
 */
public class DimensionTree implements ITreeNode {
	private Map<String,RootNode> sortedDimension = new LinkedHashMap<String,RootNode>();
	
	public DimensionTree(){
		sortedDimension.put("String", new TypeNode("0001","字符类参数"));
		sortedDimension.put("Number", new TypeNode("0002","金额类参数"));
		sortedDimension.put("Integer", new TypeNode("0003","整数类参数"));
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.awe.ui.widget.tree.IGetNodes#getNodes(java.util.Map, com.amarsoft.awe.util.Transaction)
	 */
	
	public void appendTreeNode(HTMLTreeView tviTemp,
			Map<String, String> attributes, Transaction sqlca) {
		
		String filterVar = StringUtil.getString(attributes.get("type"));
		
		Iterator<Dimension> tkd = Dimensions.getDimensions().values().iterator();
		while(tkd.hasNext()){
			Dimension tmp = tkd.next();
			RootNode root = sortedDimension.get(reverseType(tmp.getType()));
			if(root != null){
				if(filterVar==null || filterVar.length()==0 || reverseType(tmp.getType()).matches(filterVar)){
					DimensionNode mn = new DimensionNode(tmp);
					root.addLeaf(mn);
				}
			}
		}
		
		int folderCount = 1;
		Iterator<RootNode> roots = sortedDimension.values().iterator();
		while(roots.hasNext()){
			RootNode typeNode = roots.next();
			if(typeNode.getLeafCount()==0) continue;		//无叶节点不生成根节点
					
			/*以方法类型作为1st目录*/
			String sTmpFolder = tviTemp.insertFolder("root",typeNode.getDescribe(),"",folderCount++);
			
			/*项下的方法列表*/
			int iLeaf = 1;
			Iterator<LeafNode> rtor = typeNode.getLeafs().values().iterator();
			while(rtor.hasNext()){
				LeafNode implNode = rtor.next();
				tviTemp.insertPage(sTmpFolder,implNode.getDescribe(),implNode.getId(),"",iLeaf++);
			}
		}
		
	}
	
	private String reverseType(int type){
		switch(type){
			case Dimension.维度值类型_精度数:
				return "Number";
			case Dimension.维度值类型_整数型:
				return "Integer";
			default:
				return "String";
		}
	}
	
	private class TypeNode extends RootNode{
		public TypeNode(String id, String name){
			this.treeId = id;
			this.treeName = name;
			setSortNo(id);
		}

		
		public String getDescribe() {
			return getName();
		}
	}
	
	private class DimensionNode extends LeafNode{
		
		public DimensionNode(Dimension obj){
			this.nodeId = obj.getImpl();
			this.nodeName = obj.getName();
		}
		
		
		public String getDescribe() {
			return getName()+" "+getId();
		}
		
	}

}
