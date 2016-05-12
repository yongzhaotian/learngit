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
package com.amarsoft.sadre;

 /**
 * <p>Title: SADREException.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 ����10:50:47
 *
 * logs: 1. 
 */
public class SADREException extends Exception {

	/**
     * �޲����Ĺ��캯��������һ��û��ϸ��Ϣ������
     */
    public SADREException() {
        super();
    }
    /**
     * ���ݸ�����Ϣ��������
     *
     * @param message ��ϸ��Exception��Ϣ
     */
    public SADREException(String message) {
        super(message);
    }

    /**
     * ���ݸ�����ԭʼ���⹹��һ���µ��쳣��ԭ��������Ϊ��ϸ��Ϣ
     *
     * @param cause Դ����
     */
    public SADREException(Throwable cause) {
        this((cause == null) ? null : cause.toString(), cause);
    }

    /**
     * ���ݸ�����ԭʼ�������Ϣ����һ���µ��쳣����ϸ��Ϣ�Ǹ�������Ϣ��Դ��������
     *
     * @param message ��ϸ��Ϣ
     * @param cause ԭʼ����
     */
    public SADREException(String message, Throwable cause) {
        super(message + " (Caused by " + cause + ")");
        this.cause = cause; // Two-argument version requires JDK 1.4 or later
    }

    /**
     * ԭʼ����.
     */
    protected Throwable cause = null;
    /**
     * Return the underlying cause of this exception (if any).
     */
    public Throwable getCause() {
        return (this.cause);
    }
}
