package demo;

import java.net.*;

import java.io.*;

/**
 * 
 * @author jlwu
 *
 */
public class XJServerPutOut{

	private ServerSocket ss;
	private Socket socket;
	private BufferedReader in;
	private PrintWriter out;
	
	public XJServerPutOut(){
		System.out.println("������������...");
	}

	public void putOut(){
		try{
			//�����󶨵��ض��˿ڵķ������׽��֡�
			ss = new ServerSocket(10000);
			while (true){
				//���������ܵ����׽��ֵ����ӡ�
				socket = ss.accept();
				//������������������룬ͬʱ����һ��IutputStream����ʵ��
				in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				//�������ӵ���һ�˽��õ����룬ͬʱ����һ��OutputStream����ʵ��
				out = new PrintWriter(socket.getOutputStream(), true);
				String line = in.readLine();
				System.out.println("�ӿͻ��˴�������Ϣ��"+line);
				String tradeno = line.substring(24, 28);
				System.out.println("tradeno="+tradeno);
				//���ͻ���������Ӧ
				if(tradeno.equals("UP01")){
				out.write("2009-06-2411062312345678901234567890000000chenggong                                                   ab");
				}else if(tradeno.equals("UP03")){
					out.write("2009-06-2413462312345678901234567890000000chenggong                                                   ab");
					out.flush();
					out.write("20061017000014       89122015201020000918            60200     01 ��ʢ����  0000005000000.012007-01-012008-12-120000007000000.00");
					out.flush();
					out.write("20061017000015       89161018251010800368            60200     01 ��������  0000003200000.562007-01-022008-12-110000009000000.00");
					out.flush();
				}
				out.flush();
				out.close();
				in.close();
				socket.close();
			}
		}catch (IOException e){
			e.printStackTrace();
		}
	}

	public static void main(String[] args){
		new XJServerPutOut().putOut();
	}
}


