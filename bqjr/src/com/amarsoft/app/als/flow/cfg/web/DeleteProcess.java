package com.amarsoft.app.als.flow.cfg.web;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.app.als.flow.cfg.domain.Process;
import com.amarsoft.app.als.flow.cfg.domain.ProcessResult;
import com.amarsoft.app.als.flow.cfg.domain.logic.ProcessService;
import com.amarsoft.app.als.flow.cfg.domain.logic.ProcessServiceImpl;
import com.amarsoft.app.als.flow.cfg.util.SimpleXMLWorkShop;
import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;

public class DeleteProcess extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        ServletContext servletContext = request.getSession().getServletContext();
        String webRootPath = servletContext.getRealPath("/");
        processService = new ProcessServiceImpl(webRootPath);

        String name = request.getParameter("name");

        log.info("delete process:" + name);

        Process process = new Process();
        process.setName(name);
        ProcessResult processResult = this.getProcessService()
                .deleteProcess(process);

        response.setContentType("text/xml");
        response.setHeader("Cache-Control", "no-cache");
        SimpleXMLWorkShop.outputXML(ProcessResult.convertXml(processResult),
                response.getOutputStream());

        //not redirect to other view,it processed on response
        //return null;
    }

    /**
     * @return Returns the processService.
     */
    public ProcessService getProcessService() {
        return processService;
    }

    /**
     * @param processService The processService to set.
     */
    public void setProcessService(ProcessService processService) {
        this.processService = processService;
    }

    private Log log = ARE.getLog();

    private ProcessService processService;
}
