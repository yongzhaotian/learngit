package demo;

import java.net.*;

import java.io.*;

/**
 * �������� �˷���˿�����Ϊ�����ͽ��׵ķ���ˡ�����Ϊ88011��9613���׵ķ����
 * �����������һ������������һֱ����10000�˿ڣ��ȴ��û����ӡ��ڽ������Ӻ���ͻ��˷���һ����Ϣ��Ȼ������Ự���������һ��ֻ�ܽ���һ���ͻ����ӡ�
 * @author jlwu
 *
 */
public class ServerPutout{

	private ServerSocket ss;
	private Socket socket;
	private BufferedReader in;
	private PrintWriter out;
	public ServerPutout(){
		
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
				//���ͻ���������Ӧ
				out.write("   0");
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
		new ServerPutout().putOut();
	}
}

