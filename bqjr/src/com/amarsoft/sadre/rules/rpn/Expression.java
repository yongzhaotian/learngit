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

//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

/**
 * Expression.java desc:
 * 
 * @author zllin@amarsoft.com 2008 ����12:41:33
 * 
 */
public class Expression {
	private List<String> expression = new ArrayList<String>();// �洢������ʽ
	   
    private List<String> right = new ArrayList<String>();// �洢������ʽ
   
    //private String result;// ���
   
    // ����������Ϣ�������󣬽���ֵ�����������ArrayList��
    private Expression(String input) {    
        StringTokenizer st = new StringTokenizer(input, "+-*/()", true);    
        while (st.hasMoreElements()) {    
            expression.add(st.nextToken());    
        }    
    }    
    
    public static Expression getInstance(String input){
    	return new Expression(input);
    }
   
    // ��������ʽת��Ϊ������ʽ
    private void toRight() {    
        Stacks aStack = new Stacks();    
        String operator;    
        int position = 0;    
        while (true) {    
            if (Calculate.isOperator((String) expression.get(position))) {    
                if (aStack.top == -1   
                        || ((String) expression.get(position)).equals("(")) {    
                    aStack.push(expression.get(position));    
                } else {    
                    if (((String) expression.get(position)).equals(")")) {    
                        if (!((String) aStack.top()).equals("(")) {    
                            operator = (String) aStack.pop();    
                            right.add(operator);    
                        }    
                    } else {    
                        if (Calculate.priority((String) expression    
                                .get(position)) <= Calculate    
                                .priority((String) aStack.top())    
                                && aStack.top != -1) {    
                            operator = (String) aStack.pop();    
                            if (!operator.equals("("))    
                                right.add(operator);    
                        }    
                        aStack.push(expression.get(position));    
                    }    
                }    
            } else   
                right.add(expression.get(position));    
            position++;    
            if (position >= expression.size())    
                break;    
        }    
        while (aStack.top != -1) {    
            operator = (String) aStack.pop();    
            right.add(operator);    
        }    
    }
 // ��������ʽ������ֵ    
    public Object getCalculateValue() {    
        this.toRight();    
        Stacks aStack = new Stacks();    
        String op1, op2, is = null;    
        Iterator<String> it = right.iterator();    
   
        while (it.hasNext()) {    
            is = (String) it.next();    
            if (Calculate.isOperator(is)) {    
                op1 = (String) aStack.pop();    
                op2 = (String) aStack.pop();    
                aStack.push(Calculate.twoResult(is, op1, op2));    
            } else   
                aStack.push(is);    
        }    
        Object result = aStack.pop();    
//        it = expression.iterator();    
//        while (it.hasNext()) {    
//            System.out.print((String) it.next());    
//        }    
//        System.out.println("=" + result);  
        
        return result;
    }    
    
    /*
    public static void main(String avg[]) {    
        try {    
            System.out.println("Input a expression:");    
            BufferedReader is = new BufferedReader(new InputStreamReader(    
                    System.in));    
            for (;;) {    
                String input = new String();    
                input = is.readLine().trim();    
                if (input.equals("q"))    
                    break;    
                else {    
                    Expression boya = new Expression(input);    
                    boya.getCalculateValue();    
                }    
                System.out    
                        .println("Input another expression or input 'q' to quit:");    
            }    
            is.close();    
        } catch (IOException e) {    
            System.out.println("Wrong input!!!");    
        }    
    }    
     */
    
}
