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
 * @date 2011-4-15 上午10:50:47
 *
 * logs: 1. 
 */
public class SADREException extends Exception {

	/**
     * 无参数的构造函数，构造一个没详细消息的例外
     */
    public SADREException() {
        super();
    }
    /**
     * 根据给定信息构造例外
     *
     * @param message 详细的Exception信息
     */
    public SADREException(String message) {
        super(message);
    }

    /**
     * 根据给定的原始例外构成一个新的异常，原是例外作为详细消息
     *
     * @param cause 源例外
     */
    public SADREException(Throwable cause) {
        this((cause == null) ? null : cause.toString(), cause);
    }

    /**
     * 根据给定的原始例外和消息构成一个新的异常，详细信息是给定的信息和源例外的组合
     *
     * @param message 详细信息
     * @param cause 原始例外
     */
    public SADREException(String message, Throwable cause) {
        super(message + " (Caused by " + cause + ")");
        this.cause = cause; // Two-argument version requires JDK 1.4 or later
    }

    /**
     * 原始例外.
     */
    protected Throwable cause = null;
    /**
     * Return the underlying cause of this exception (if any).
     */
    public Throwable getCause() {
        return (this.cause);
    }
}
