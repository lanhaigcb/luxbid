package com.shop.admin.controller.file;

import com.alibaba.fastjson.JSON;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.file.UploadException;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import com.mine.util.file.FTPUtil;
import com.mine.util.string.StringUtils;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * 文件上传
 */
@Controller
@RequestMapping("/file")
public class FileController {

    private static Logger logger = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private SystemSettingService systemSettingService;

    @RequestMapping(value = "index", method = RequestMethod.GET)
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("file/upload");
        return mv;
    }

    @RequestMapping(value = "fileUpload", method = RequestMethod.POST)
    @ResponseBody
    public void updateFile(HttpServletRequest request, HttpServletResponse response, Model model, String name) {
        logger.info("upload file ,start process...");
//        String contentType = file.getContentType();
//        String fileName = file.getName();
//        String fileOriginalName = file.getOriginalFilename();
//        logger.info("upload file ,file name:[" + fileName + "::::" + fileOriginalName + "],contentType:[" + contentType + "]"
//                + "model:" + model + "nameField:" + name);
        String dir = "kindeditor";
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (!ServletFileUpload.isMultipartContent(request)) {
            resultMap.put("msg", "上传文件为空!");
            writeJson(response, resultMap);
            return;
        }
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        Iterator item = multipartRequest.getFileNames();
        while (item.hasNext()) {
            String _fileName = (String) item.next();
            MultipartFile file = multipartRequest.getFile(_fileName);
            try {
                // 取得当前上传文件的文件名称
                String myFileName = file.getOriginalFilename();
                // 如果名称不为“”,说明该文件存在，否则说明该文件不存在
                if (!StringUtils.isEmpty(myFileName)) {
                    String suffix = file.getOriginalFilename().substring(
                            file.getOriginalFilename().lastIndexOf("."));
                    // 重命名上传后的文件名
                    // 定义上传路径
                    String uploadDir = dir + (StringUtils.isEmpty(dir) ? "" : (dir.endsWith("/") ? "" : "/"));
                    String fileName = new Date().getTime() + new Random().nextInt(1000000) + suffix;

                    SystemSetting server = systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_IP);
                    if (null == server) {
                        throw new SystemSettingException("系统参数：" + SystemSettingType.FTP_FILE_SERVER_IP + ",获取失败");
                    }
                    SystemSetting user = systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_USERNAME);
                    if (null == user) {
                        throw new SystemSettingException("系统参数：" + SystemSettingType.FTP_FILE_SERVER_USERNAME + ",获取失败");
                    }
                    SystemSetting pwd = systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_PASSWORD);
                    if (null == pwd) {
                        throw new SystemSettingException("系统参数：" + SystemSettingType.FTP_FILE_SERVER_PASSWORD + ",获取失败");
                    }

                    FTPUtil.putFile(server.getValue(),
                            systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_USERNAME).getValue(),
                            systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_PASSWORD).getValue(),
                            file.getInputStream(), fileName, uploadDir);
                    SystemSetting serverURL = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);

                    resultMap.put("isSuccess", true); // 文件上传成功
                    resultMap.put("url", serverURL.getValue() + "/" + uploadDir + fileName);
                    resultMap.put("fileName", myFileName); // 原文件名
                    resultMap.put("strFullFileDir", uploadDir + fileName); // 完整的文件保存路径
                    resultMap.put("strNewFileName", fileName);
                    resultMap.put("error", 0);
                    writeJson(response, resultMap);
                } else {
                    logger.error("文件为空");
                    resultMap.put("msg", "上传文件为空!");
                    writeJson(response, resultMap);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("文件上传失败" + e.getMessage());
                throw new UploadException("文件上传失败");
            }
        }
        logger.info("upload file ,end process!!!");
    }

    private void writeJson(HttpServletResponse response, Object msg) {
        /************以下是解决避免ie下载文件 start*************/
        response.reset();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        PrintWriter writer = null;
        try {
            writer = response.getWriter();

            writer.println(JSON.toJSONString(msg));

            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        /************以下是解决避免ie下载文件 end*************/
    }
}
