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

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.annotation.Comment;
import com.amarsoft.sadre.app.widget.tree.ITreeNode;
import com.amarsoft.sadre.app.widget.tree.LeafNode;
import com.amarsoft.sadre.app.widget.tree.RootNode;
import com.amarsoft.sadre.cache.Synonymns;
import com.amarsoft.sadre.rules.aco.Synonymn;
import com.amarsoft.web.ui.HTMLTreeView;

 /**
 * <p>Title: MethodTree.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-4-10 ����3:55:59
 *
 * logs: 1. 
 */
public class MethodTree implements ITreeNode{
	private Map<String,RootNode> sortedMethod = new LinkedHashMap<String,RootNode>();
	
	public MethodTree(){
		sortedMethod.put(String.valueOf(Comment.�ͻ������), new TypeNode("0001","�ͻ������"));
		sortedMethod.put(String.valueOf(Comment.ҵ�������), new TypeNode("0002","ҵ�������"));
		sortedMethod.put(String.valueOf(Comment.ͨ�������), new TypeNode("0003","ͨ�������"));
		sortedMethod.put(String.valueOf(Comment.���������), new TypeNode("0004","���������"));
		sortedMethod.put(String.valueOf(Comment.δ�������), new TypeNode("0009","δ�������"));
	}
	
	
	public void appendTreeNode(HTMLTreeView tviTemp,
			Map<String, String> attributes, Transaction sqlca) {
		
		Synonymn synonymn = Synonymns.getSynonymn("default");
		if(synonymn==null){
			ARE.getLog().warn("��Ȩ��������δ����!");
			return;
		}
		Class aux = null;
		try {
			aux = Class.forName(synonymn.getImpl());
		} catch (ClassNotFoundException e) {
			ARE.getLog().error(e);
			return;
		}
		
		Method[] methods = aux.getDeclaredMethods();
		for(int i=0; i<methods.length; i++){
			/*
			 public static final int PRIVATE 2 
			 public static final int PROTECTED 4 
			 public static final int PUBLIC 1 
			 public static final int STATIC 8 
			 */
			if(methods[i].getModifiers()==Modifier.PUBLIC 
					|| methods[i].getModifiers()==Modifier.PROTECTED){		//�оٳ�public/protected���෽��
				String methodReturnType = methods[i].getReturnType().getSimpleName();		//���˷Ƿ�����ֵ�ķ���
				if(!methodReturnType.matches("(String|double|int)")){continue;}
				
				String methodName = methods[i].getName();
//				ARE.getLog().info(methods[i].getReturnType().getSimpleName());
				/*�������̳е�4���ڲ�����*/
				if(!methodName.matches("(finalPost|getType|process|releaseResource|prepare)")){
					String returnType = methods[i].getGenericReturnType().toString();
					
					RootNode root = null;
					Comment ann = methods[i].getAnnotation(Comment.class);
					if(ann==null) {
						root = sortedMethod.get(String.valueOf(Comment.δ�������));
					}else{
						switch(ann.type()){
							case Comment.�ͻ������:
							case Comment.ҵ�������:
							case Comment.ͨ�������:
							case Comment.���������:
								root = sortedMethod.get(String.valueOf(ann.type()));
								break;
							default:	//δ����
								root = sortedMethod.get(String.valueOf(Comment.δ�������));
						}
					}
					MethodNode mn = new MethodNode(methodName,methodReturnType);
					//add xqkong 2012-09-24 ����ע����������
					if(ann!=null){
						mn.methodDescribe=ann.describe();
					}
					//end
					root.addLeaf(mn);
					
				}
			}
		}
		
		//------------append treeNode to TreeView
		int folderCount = 1;
		Iterator<RootNode> tk = sortedMethod.values().iterator();
		while(tk.hasNext()){
			RootNode typeNode = tk.next();
			/*�Է���������Ϊ1stĿ¼*/
			String sTmpFolder = tviTemp.insertFolder("root",typeNode.getDescribe(),"",folderCount++);
			
			/*���µķ����б�*/
			int iLeaf = 1;
			Iterator<LeafNode> rtor = typeNode.getLeafs().values().iterator();
			while(rtor.hasNext()){
				LeafNode implNode = rtor.next();
				tviTemp.insertPage(sTmpFolder,implNode.getDescribe(),"${"+synonymn.getId()+"."+implNode.getName()+"}","",iLeaf++);
			}
		}
		
//		return nodes;
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
	
	private class MethodNode extends LeafNode{
		private String returnType = "";
		//add xqkong  2012-09-24 ����ע����������
		private String methodDescribe="";
		//end
		public MethodNode(String id,String returnType){
			this.nodeId = id;
			this.nodeName = id;
			this.returnType = returnType;
		}
		
		
		public String getDescribe() {
			return returnType+" "+getName()+"    "+methodDescribe;
		}
		
	}

}

