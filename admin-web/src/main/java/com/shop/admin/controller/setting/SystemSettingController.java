package com.shop.admin.controller.setting;

import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import com.mine.util.enumeration.EnumUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 */
@Controller
@Scope("prototype")
public class SystemSettingController extends BaseController {


    private static Logger logger = LoggerFactory.getLogger(SystemSettingController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private SystemSettingService systemSettingService;

    @RequestMapping(value = "systemSetting/index")
    @OperatorLogger(operatorName = "进入系统参数")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("setting/index");
        return mv;
    }

    /**
     * 列表
     *
     * @return
     */
    @RequestMapping(value = "systemSetting/list")
    @OperatorLogger(operatorName = "查看系统参数列表")
    @ResponseBody
    public Map<String, Object> list(Integer limit,Integer offset) {
        total = (int) systemSettingService.listCount();
        if (total > 0) {
            list = systemSettingService.list(getOffset(offset), getLimit(limit));
        }
        return getResultMap();
    }


    @RequestMapping(value = "systemSetting/addInput")
    @OperatorLogger(operatorName = "进入添加系统参数页面")
    public ModelAndView addInput() {

        ModelAndView mv = new ModelAndView("setting/add");

        // 处理类型
        Map<String, String> settingType = systemSettingService.findNotExsitsType();
        mv.addObject("types", settingType);
        return mv;
    }

    @RequestMapping(value = "systemSetting/add")
    @OperatorLogger(operatorName = "添加系统参数")
    @ResponseBody
    public Map<String, Object> add(String name, String value, String systemSettingType) {


        try {
            systemSettingService.add(EnumUtil.getEnumByName(systemSettingType, SystemSettingType.class), name, value);
            result = true;
            message = messageSource.getMessage("add.success");
        } catch (SystemSettingException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("add.failed");
        }

        return getResultMap();
    }


    @RequestMapping(value = "systemSetting/updateInput")
    @OperatorLogger(operatorName = "进入修改系统参数页面")
    public ModelAndView updateInput( Integer systemSettingId) {
        SystemSetting systemSetting = systemSettingService.findSystemSettingById(systemSettingId);
        ModelAndView mv = new ModelAndView("setting/edit");
        mv.addObject("systemSetting", systemSetting);
        return mv;
    }

    @RequestMapping(value = "systemSetting/update")
    @OperatorLogger(operatorName = "修改系统参数")
    @ResponseBody
    public Map<String, Object> update(Integer systemSettingId, String name, String value) {
        try {
            systemSettingService.updateSystemSetting(systemSettingId, name, value);
            result = true;
            message = messageSource.getMessage("update.success");
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("update.failed");
        }
        return getResultMap();
    }

}
