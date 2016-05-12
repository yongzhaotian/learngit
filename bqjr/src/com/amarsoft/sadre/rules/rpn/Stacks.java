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
package com.amarsoft.sadre.rules.rpn;

import java.util.LinkedList;

/**
 * Stacks.java desc:
 * 
 * @author zllin@amarsoft.com 2008 ÏÂÎç12:43:05
 * 
 */
public class Stacks {
	private LinkedList<Object> list = new LinkedList<Object>();
	int top = -1;

	public void push(Object value) {
		top++;
		list.addFirst(value);
	}

	public Object pop() {
		Object temp = list.getFirst();
		top--;
		list.removeFirst();
		return temp;

	}

	public Object top() {
		return list.getFirst();
	}
	
	public String toString(){
		return list.toString();
	}
	
}
