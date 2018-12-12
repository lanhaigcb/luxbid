package com.shop.admin.controller.support;

import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.mine.common.Affiche.AfficheException;
import com.mine.common.enums.RegisterType;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.file.FileException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.suportVo.BannerVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.controller.FileUploadController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.setting.SystemSettingService;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.supportservice.service.BannerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * BannerController(轮播图:后台)
 */

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/banner")
public class BannerController extends FileUploadController {

    private static Logger logger = LoggerFactory.getLogger(BannerController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private BannerService bannerService;

    @Autowired
    private SystemSettingService systemSettingService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    /**
     * 进入Banner管理
     */
    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入Banner管理")
    public ModelAndView bannerManage(){
        ModelAndView mv = new ModelAndView("banner/index");
        return mv;
    }

    /**
     * 获取所有Banner(后台)
     * @return
     */
    @RequestMapping("/findListAllBack")
    @OperatorLogger(operatorName = "获取所有Banner(后台)")
    @ResponseBody
    public Response listAllBack(String name,String internationalType,Integer offset, Integer limit){
        final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);

        if (null == systemSetting) {
            throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
        }
        total = (int)bannerService.getCount(name,internationalType);
        if(total > 0){
            List<BannerVo> bannerVos = bannerService.listAllBack(name,internationalType,getOffset(offset), getLimit(limit));
            list = Lists.transform(bannerVos, new Function<BannerVo, BannerVo>() {
                @Override
                public BannerVo apply(BannerVo bannerVo) {
                    bannerVo.setImageURI(systemSetting.getValue() + bannerVo.getImageURI());
                    return bannerVo;
                }
            });
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 获取所有Banner(后台:已开启)
     */
    @RequestMapping("/findOpenListAllBack")
    @OperatorLogger(operatorName = "获取所有Banner(后台:已开启)")
    @ResponseBody
    public Response openListAllBack(@RequestParam(value = "from", defaultValue = "1") int from,
                                    @RequestParam(value = "pageSize", defaultValue = "10") int pageSize
                                    ){
        total = (int)bannerService.getOpenCount();
        if(total > 0){
            list = bannerService.openListAllBack(from, pageSize);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 获取所有Banner(后台:未开启)
     */
    @RequestMapping("/findCloseListAllBack")
    @OperatorLogger(operatorName = "获取所有Banner(后台:未开启)")
    @ResponseBody
    public Response closeListAllBack(@RequestParam(value = "from", defaultValue = "1") int from,
                                     @RequestParam(value = "pageSize", defaultValue = "10") int pageSize
                                     ){
        total = (int)bannerService.getCloseCount();
        if(total > 0){
            list = bannerService.closeListAllBack(from, pageSize);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 进入添加Banner页面
     */
    @RequestMapping("/addInput")
    @OperatorLogger(operatorName = "进入添加Banner页面")
    public ModelAndView addBannerIndex(){
        ModelAndView mv = new ModelAndView("banner/add");
        return mv;
    }


    /**
     * 添加Banner
     * @return
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加Banner")
    @ResponseBody
    public Map<String, Object> addBanner(HttpServletRequest request, BannerVo bannerVo){
        logger.info("bannerName:" + bannerVo.getName());
        try {
            List<String> paths = filesUpload(request, "banner", "imageURI","jpg", "jpeg", "png");

            if (null == paths || paths.size() == 0) {
                result = false;
                message = "文件上传失败";
                return getResultMap();
            }
            bannerVo.setImageURI(paths.get(0));
            bannerVo.setCreateTime(new Date());
            bannerService.addBanner(bannerVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("新增Banner",staff.getRealname()+"-新增Banner："+bannerVo.getName(),staff.getId(),staff.getRealname());
            result = true;
            message = messageSource.getMessage("banner.publish.success");
            return getResultMap();
        } catch (FileException fileException) {
            result = false;
            message = fileException.getLocalizedMessage();
            logger.error("文件错误", fileException);
            return getResultMap();
        } catch (AfficheException bannerException) {
            result = false;
            message = bannerException.getLocalizedMessage();
            logger.error("banner 处理错误", bannerException);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("banner.publish.failed");
            logger.error("添加banner未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 进入修改Banner页面
     */
    @RequestMapping("/updateInput")
    @OperatorLogger(operatorName = "进入修改Banner页面")
    public ModelAndView modifyBanner(Integer id){
        ModelAndView mv = new ModelAndView("banner/edit");
        BannerVo bannerVo = bannerService.getBannerInfoById(id);
        mv.addObject("banner", bannerVo);
        return mv;
    }

    /**
     * 更新Banner信息
     */
    @RequestMapping("/update")
    @OperatorLogger(operatorName = "修改Banner")
    @ResponseBody
    public Map<String, Object> modifyBanner(HttpServletRequest request, BannerVo bannerVo) {
        try {
            String createTime = request.getParameter("createTime");
            SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy", Locale.US);
            Date date = (Date) sdf.parse(createTime);
            bannerVo.setCreateTime(date);
            List<String> paths = filesUpload(request, "banner", "imageURI","jpg", "jpeg", "png");
            if (null != paths && paths.size() > 0) {
                bannerVo.setImageURI(paths.get(0));
            }
            bannerVo.setUpdateTime(new Date());
            bannerService.updateBanner(bannerVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("修改Banner",staff.getRealname()+"-修改Banner："+bannerVo.getName(),staff.getId(),staff.getRealname());
            result = true;
            message = messageSource.getMessage("banner.update.success");
            return getResultMap();
        } catch (FileException fileException) {
            result = false;
            message = fileException.getLocalizedMessage();
            logger.error("文件错误", fileException);
            return getResultMap();
        } catch (AfficheException bannerException) {
            result = false;
            message = bannerException.getLocalizedMessage();
            logger.error("banner 处理错误", bannerException);
            return getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("banner.update.failed");
            logger.error("添加banner未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 根据ID启用Banner
     */
    @RequestMapping("/enable")
    @OperatorLogger(operatorName = "启用Banner")
    @ResponseBody
    public Map<String, Object> openBanner(Integer bannerId) {
        try {
            bannerService.enableBanner(bannerId);
            result = true;
            message = messageSource.getMessage("enable.success");
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("enable.failed");
            logger.error("启用banner失败", e);
            return getResultMap();
        }
    }

    /**
     * 根据ID关闭Banner
     */
    @RequestMapping("/disableBanner")
    @OperatorLogger(operatorName = "关闭Banner")
    @ResponseBody
    public Map<String, Object> disableBanner(Integer bannerId) {
        try {
            bannerService.disableBanner(bannerId);
            result = true;
            message = messageSource.getMessage("disable.success");
            return getResultMap();
        } catch (AfficheException e) {
            result = false;
            message = e.getLocalizedMessage();
            logger.error("启用banner失败", e);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("disable.failed");
            logger.error("启用banner失败", e);
            return getResultMap();
        }
    }

}
