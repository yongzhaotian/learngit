package com.amarsoft.app.accounting.exception;

public class LoanException extends Exception {
    
	private static final long serialVersionUID = -611389961470753722L;
	/**
     * �޲����Ĺ��캯��������һ��û��ϸ��Ϣ������
     */
    public LoanException() {
        super();
    }
    /**
     * ���ݸ�����Ϣ��������
     *
     * @param message ��ϸ��Exception��Ϣ
     */
    public LoanException(String message) {
        super(message);
    }

    /**
     * ���ݸ�����ԭʼ���⹹��һ���µ��쳣��ԭ��������Ϊ��ϸ��Ϣ
     *
     * @param cause Դ����
     */
    public LoanException(Throwable cause) {
        this((cause == null) ? null : cause.toString(), cause);
    }

    /**
     * ���ݸ�����ԭʼ�������Ϣ����һ���µ��쳣����ϸ��Ϣ�Ǹ�������Ϣ��Դ��������
     *
     * @param message ��ϸ��Ϣ
     * @param cause ԭʼ����
     */
    public LoanException(String message, Throwable cause) {
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
