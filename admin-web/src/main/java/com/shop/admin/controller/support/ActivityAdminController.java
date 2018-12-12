package com.shop.admin.controller.support;

import com.mine.common.activity.ActivityInfoVo;
import com.mine.common.enums.ActivityStatus;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.activity.ActivityException;
import com.mine.common.exception.file.FileException;
import com.shop.admin.controller.BaseController;
import com.shop.admin.controller.FileUploadController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import com.mine.supportservice.service.ActivityInfoService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class ActivityAdminController extends FileUploadController {

    private static Logger logger = LoggerFactory.getLogger(ActivityAdminController.class);

    @Autowired
    private SystemSettingService systemSettingService;


    @Autowired
    private ActivityInfoService activityInfoService;

    @RequestMapping("act/index")
    public ModelAndView index() {
        ModelAndView modelAndView = new ModelAndView("activity/index");
        return modelAndView;
    }

    @RequestMapping("act/list")
    @ResponseBody
    public Map<String, Object> list(Integer offset, Integer limit, String status,String title) {

        ActivityStatus activityStatus = ActivityStatus.getByName(status);

        total = activityInfoService.countActivity(activityStatus,title,null);
        if (total > 0) {
            list = activityInfoService.listActivity(offset, limit, activityStatus, null,title);
        }
        result = true;
        message = "成功";
        return getResultMap();
    }

    @RequestMapping("act/addInput")
    public ModelAndView addView() {
        ModelAndView modelAndView = new ModelAndView("activity/add");
        return modelAndView;
    }

    /**
     * 增加
     *
     * @param activityInfoVo
     * @param request
     * @return
     */
    @RequestMapping("act/add")
    @ResponseBody
    public Map<String, Object> add(ActivityInfoVo activityInfoVo, HttpServletRequest request) {
        logger.info("activityInfoVo:" + activityInfoVo);
        try {
            List<String> paths = filesUpload(request, "activity", "imageURIFile","jpg", "jpeg", "png");

            if (null == paths || paths.size() == 0) {
                result = false;
                message = "文件上传失败";
                return getResultMap();
            }
            SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_HTTP_PREFIX);
            String imageURl = null;
            if (null != systemSetting) {
                imageURl = systemSetting.getValue() + paths.get(0);
            }
            activityInfoVo.setCoverPicURL(imageURl);
            activityInfoVo.setCreateTime(new Date());
            activityInfoVo.setUpdateTime(new Date());
            activityInfoService.addActivity(activityInfoVo);
            result = true;
            message = "添加成功";
            return getResultMap();
        } catch (FileException fileException) {
            result = false;
            message = fileException.getLocalizedMessage();
            logger.error("文件错误", fileException);
            return getResultMap();
        } catch (ActivityException activityException) {
            result = false;
            return getResultMap();
        } catch (Exception e) {
            result = false;
            return getResultMap();
        }
    }

    /**
     * update view render
     * @param id
     * @return
     */
    @RequestMapping("act/updateInput")
    public ModelAndView updateView(Integer id) {
        ActivityInfoVo activityInfoVo = activityInfoService.getById(id);
        ModelAndView modelAndView = new ModelAndView("activity/update");
        modelAndView.addObject("vo",activityInfoVo);
        return modelAndView;
    }

    /**
     * 更新
     * @param activityInfoVo
     * @param request
     * @return
     */
    @RequestMapping("act/update")
    @ResponseBody
    public Map<String, Object> update(ActivityInfoVo activityInfoVo, HttpServletRequest request) {
        logger.info("activityInfoVo:" + activityInfoVo);
        try {
            List<String> paths = filesUpload(request, "activity", "imageURIFile","jpg", "jpeg", "png");
            if (null == paths || paths.size() == 0) {
                logger.info("update activity no image !");
                activityInfoVo.setCoverPicURL(null);
            }else{
                String origin = paths.get(0);
                SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_HTTP_PREFIX);
                String imageURl = null;
                if (null != systemSetting) {
                    imageURl = systemSetting.getValue() + origin;
                }
                activityInfoVo.setCoverPicURL(imageURl);
            }
            activityInfoVo.setUpdateTime(new Date());
            activityInfoService.updateActivity(activityInfoVo);
            result = true;
            message = "更新成功";
            return getResultMap();
        } catch (FileException fileException) {
            result = false;
            message = fileException.getLocalizedMessage();
            logger.error("文件错误", fileException);
            return getResultMap();
        } catch (ActivityException activityException) {
            message="更新异常";
            result = false;
            return getResultMap();
        } catch (Exception e) {
            message="更新异常";
            result = false;
            return getResultMap();
        }
    }
}
