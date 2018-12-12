package com.shop.admin.controller;


import com.google.common.collect.Lists;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.admin.UploadException;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import com.mine.util.file.FTPUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 */
public class FileUploadController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(FileUploadController.class);

    @Autowired
    private SystemSettingService systemSettingService;

    protected List<String> filesUpload(HttpServletRequest request, String dir, String start,String... postFix) {
        List<String> filePathList = null;
        try {
            filePathList = new ArrayList<String>();
            // 创建一个通用的多部分解析器
            CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
                    request.getSession().getServletContext());
            // 判断 request 是否有文件上传,即多部分请求
            if (multipartResolver.isMultipart(request)) {
                // 转换成多部分request
                MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
                // 取得request中的所有文件名
                Iterator<String> iter = multiRequest.getFileNames();
                while (iter.hasNext()) {
                    // 取得上传文件

                    MultipartFile file = multiRequest.getFile(iter.next());
                    logger.info("upload file:" + file.getName());
                    if (file != null && file.getName().startsWith(start)) {
                        // 取得当前上传文件的文件名称
                        String myFileName = file.getOriginalFilename();
                        // 如果名称不为“”,说明该文件存在，否则说明该文件不存在
                        if (!StringUtils.isEmpty(myFileName)) {




                            String suffix = file.getOriginalFilename().substring(
                                    file.getOriginalFilename().lastIndexOf("."));
                            // 重命名上传后的文件名
                            boolean isOk = checkSuffix(suffix, postFix);
                            if (!isOk) {
                                logger.error("非法文件后缀");
                                break;
                            }
                            // 定义上传路径
                            String uploadDir = dir + (StringUtils.isEmpty(dir) ? "" : (dir.endsWith("/") ? "" : "/"));
                            String fileName = new Date().getTime()+ new Random().nextInt(1000000) + suffix;

                            SystemSetting server = systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_IP);
                            if(null == server) {
                                throw new SystemSettingException("系统参数："+SystemSettingType.FTP_FILE_SERVER_IP+",获取失败");
                            }
                            SystemSetting user = systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_USERNAME);
                            if(null == user) {
                                throw new SystemSettingException("系统参数："+SystemSettingType.FTP_FILE_SERVER_USERNAME+",获取失败");
                            }
                            SystemSetting pwd = systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_PASSWORD);
                            if(null == pwd) {
                                throw new SystemSettingException("系统参数："+SystemSettingType.FTP_FILE_SERVER_PASSWORD+",获取失败");
                            }

                            FTPUtil.putFile(server.getValue(),
                                    systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_USERNAME).getValue(),
                                    systemSettingService.getByType(SystemSettingType.FTP_FILE_SERVER_PASSWORD).getValue(),
                                    file.getInputStream(), fileName, uploadDir);

                            filePathList.add(uploadDir + fileName);
                        } else {
                            logger.error("文件为空");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("文件上传失败" + e.getMessage());
            throw new UploadException("文件上传失败");
        }
        return filePathList;
    }

    private boolean checkSuffix(String suffix, String... okSuffix) {
        logger.info(" suffix:" + okSuffix + "   act:" + suffix);
        List<String> okList = Lists.newArrayList(okSuffix);
        if (okList.contains(suffix.replace(".",""))) {
            return true;
        } else {
            return false;
        }
    }

}
