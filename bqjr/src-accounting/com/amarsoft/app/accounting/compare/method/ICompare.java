package com.amarsoft.app.accounting.compare.method;


/**
 * 
 *ʵ���������ݶ���ıȽϣ��Ƚ�ƥ���򷵻�true����false
 *  
 *�ȽϷ�ʽ���£�
 * = ����
 * != ������
 * > ����
 * >= ���ڵ���
 * < С��
 * <= С�ڵ���
 * Start ��ͷ��
 * NoStart ��ͷ����
 * End ��β��
 * NoEnd ��β����
 * Contain ����
 * NoContain ������
 * in ������
 * not in ��������
 *  
 * @author xjzhao@amarsoft.com
 * @since 1.0
 * @since JDK1.6
 */

public interface ICompare{
 
 /**
  * ƥ���������ݶ���
  * @param a
  * @param b
  * @return ƥ����
  * @throws Exception
  */
 public boolean compare(Object a,Object b) throws Exception;
 
}
