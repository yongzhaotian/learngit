package com.amarsoft.app.accounting.exception;

public class LoanException extends Exception {
    
	private static final long serialVersionUID = -611389961470753722L;
	/**
     * 无参数的构造函数，构造一个没详细消息的例外
     */
    public LoanException() {
        super();
    }
    /**
     * 根据给定信息构造例外
     *
     * @param message 详细的Exception信息
     */
    public LoanException(String message) {
        super(message);
    }

    /**
     * 根据给定的原始例外构成一个新的异常，原是例外作为详细消息
     *
     * @param cause 源例外
     */
    public LoanException(Throwable cause) {
        this((cause == null) ? null : cause.toString(), cause);
    }

    /**
     * 根据给定的原始例外和消息构成一个新的异常，详细信息是给定的信息和源例外的组合
     *
     * @param message 详细信息
     * @param cause 原始例外
     */
    public LoanException(String message, Throwable cause) {
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
