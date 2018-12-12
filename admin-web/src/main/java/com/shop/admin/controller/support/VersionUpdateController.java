package com.shop.admin.controller.support;

import com.google.common.base.Strings;
import com.mine.common.enums.MobileOsType;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.mine.common.vo.mobile.IosVersionUpdateVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.FileUploadController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import com.mine.supportservice.service.VersionUpdateService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by yaojunbing on 2018/4/23.
 */
@Controller
@RequestMapping("versionUpdate")
public class VersionUpdateController extends FileUploadController {
    @Autowired
    private VersionUpdateService versionUpdateService;
    @Autowired
    private SystemSettingService systemSettingService;

    @OperatorLogger(operatorName = "进入手机版本更新管理")
    @RequestMapping("index")
    public String index() {
        return "versionUpdate/index";
    }


    @OperatorLogger(operatorName = "进入添加手机版本更新页面")
    @RequestMapping("addInput")
    public String addInput() {
        return "versionUpdate/add";
    }

    @OperatorLogger(operatorName = "进入添加手机版本更新页面")
    @RequestMapping("addInput2")
    public String addInput2() {
        return "versionUpdate/add2";
    }

    @OperatorLogger(operatorName = "进入修改手机版本更新页面")
    @RequestMapping("updateInput")
    public ModelAndView updateInput(Long id) {
        ModelAndView mv = new ModelAndView("help/edit");
        IosVersionUpdateVo vo = versionUpdateService.getById(id);
        mv.addObject("vo", vo);
        return mv;
    }

    @ResponseBody
    @RequestMapping("list")
    @OperatorLogger(operatorName = "获取所有手机版本更新(后台)")
    public Object list(IosVersionUpdateVo queryVo,
                       @RequestParam(value = "offset", defaultValue = "0") Integer from,
                       @RequestParam(value = "size", defaultValue = "10") Integer size) {
        int total = versionUpdateService.count(queryVo);
        if (total > 0) {
            list = versionUpdateService.list(queryVo, from, size);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 添加更新版本号
     *
     * @param mobileIosVersion
     * @return
     */
    @ResponseBody
    @RequestMapping("add")
    @OperatorLogger(operatorName = "添加手机版本更新(后台)")
    public Object add(IosVersionUpdateVo mobileIosVersion) {
        if (StringUtils.isEmpty(mobileIosVersion.getUrl())
                || mobileIosVersion.getNewVersion() == null
                || mobileIosVersion.getLowVersion() == null
                || mobileIosVersion.getOsType() == null) {
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        if (mobileIosVersion.getOsType().equals(MobileOsType.ANDROID) && Strings.isNullOrEmpty(mobileIosVersion.getVersionInfo())){
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        versionUpdateService.add(mobileIosVersion);
        return Response.simpleSuccess();
    }

    /**
     * 添加更新包含上传文件功能
     *
     * @param mobileIosVersion
     * @return
     */
    @ResponseBody
    @RequestMapping("add2")
    @OperatorLogger(operatorName = "添加手机版本更新(后台)")
    public Object add2(IosVersionUpdateVo mobileIosVersion, HttpServletRequest request) {
        if (mobileIosVersion.getNewVersion() == null
                || mobileIosVersion.getLowVersion() == null
                || mobileIosVersion.getOsType() == null) {
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        if (mobileIosVersion.getOsType().equals(MobileOsType.ANDROID) && Strings.isNullOrEmpty(mobileIosVersion.getVersionInfo())){
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        List<String> paths = filesUpload(request, "apk", "upload", "ipa", "apk");

        if (null == paths || paths.size() == 0) {
            result = false;
            message = "文件上传失败";
            return getResultMap();
        }
        final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);
        if (null == systemSetting) {
            throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
        }

        mobileIosVersion.setUrl(systemSetting.getValue() + paths.get(0));

        versionUpdateService.add(mobileIosVersion);
        return Response.simpleSuccess();
    }
//
    ///**
    // * 更新Banner信息
    // */
    //@RequestMapping("/update")
    //@OperatorLogger(operatorName = "修改手机版本更新")
    //@ResponseBody
    //public Object update(HelpCategoryVo categoryVo) {
    //	if (StringUtils.isEmpty(categoryVo.getCategory())
    //			|| StringUtils.isEmpty(categoryVo.getInternationalType())
    //			|| categoryVo.getSortParam() == null || categoryVo.getEnable() == null) {
    //		Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
    //		response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
    //		return response;
    //	}
    //	helpCategoryService.update(categoryVo);
    //	return Response.simpleSuccess();
    //}
}
