package com.shop.admin.controller.support;

import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.mine.common.Affiche.AfficheException;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.suportVo.AfficheVo;
import com.mine.common.suportVo.BannerVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.controller.FileUploadController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.setting.SystemSettingService;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.supportservice.service.AfficheService;
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
 * AfficheController(公告:后台)
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/affiche")
public class AfficheController extends FileUploadController {

    private static Logger logger = LoggerFactory.getLogger(AfficheController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private AfficheService  afficheService;

    @Autowired
    private SystemSettingService systemSettingService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    /**
     * 根据ID获取公告详情(后台)
     */
    @RequestMapping("/findAfficheInfoByIdBack")
    @OperatorLogger(operatorName = "根据ID获取公告详情")
    public ModelAndView getAfficheInfoById(int id) {
        ModelAndView mv = new ModelAndView("affiche/info");
        AfficheVo afficheVo = afficheService.getAfficheInfoById(id);
        mv.addObject("afficheInfo", afficheVo);
        return mv;
    }

    /**
     * 进入公告管理
     */
    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入公告管理")
    public ModelAndView afficheManage(){
        ModelAndView mv = new ModelAndView("affiche/index");
        return mv;
    }

    /**
     * 获取全部公告(后台)
     * 分页
     */
    @RequestMapping("/findListAllBack")
    @OperatorLogger(operatorName = "获取全部公告(后台)")
    @ResponseBody
    public Map<String, Object> listAllBack(Integer offset, Integer limit, AfficheVo afficheVo){
        final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);

        if (null == systemSetting) {
            throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
        }
        total = (int)afficheService.getCountByTerms(afficheVo);
        if(total > 0){
            List<AfficheVo> afficheVoList  = afficheService.listByTerms(getOffset(offset), getLimit(limit),afficheVo);
            list = Lists.transform(afficheVoList, new Function<AfficheVo, AfficheVo>() {
                @Override
                public AfficheVo apply(AfficheVo afficheVo) {
                    afficheVo.setCoverImg(systemSetting.getValue() + afficheVo.getCoverImg());
                    return afficheVo;
                }
            });
        }
        result = true;
        return getResultMap();
    }

    /**
     * 获取全部已开启公告(后台)
     * 分页
     */
    @RequestMapping("/findOpenListAllBack")
    @OperatorLogger(operatorName = "获取全部已开启公告(后台)")
    @ResponseBody
    public Map<String, Object> openListAllBack(@RequestParam(value = "from", defaultValue = "1") int from,
                                               @RequestParam(value = "pageSize", defaultValue = "10") int pageSize
                                               ){
        total = (int)afficheService.getOpenCount();
        if(total > 0){
            list = afficheService.openListAllBack(from, pageSize);
        }
        result = true;
        return getResultMap();
    }

    /**
     * 获取全部未开启公告(后台)
     * 分页
     */
    @RequestMapping("/findCloseListAllBack")
    @OperatorLogger(operatorName = "获取全部未开启公告(后台)")
    @ResponseBody
    public Map<String, Object> closeListAllBack(@RequestParam(value = "from", defaultValue = "1") int from,
                                                @RequestParam(value = "pageSize", defaultValue = "10") int pageSize
                                                ){
        total = (int)afficheService.getCloseCount();
        if(total > 0){
            list = afficheService.closeListAllBack(from, pageSize);
        }
        result = true;
        return getResultMap();
    }

    /**
     * 进入查看公告页面
     */
    @RequestMapping("/lookInput")
    @OperatorLogger(operatorName = "进入查看公告页面")
    public ModelAndView lookAfficheIndex(Integer id){
        ModelAndView mv = new ModelAndView("affiche/info");
        AfficheVo afficheVo = afficheService.getAfficheInfoById(id);
        mv.addObject("afficheInfo", afficheVo);
        return mv;
    }

    /**
     * 进入添加公告页面
     */
    @RequestMapping("/addInput")
    @OperatorLogger(operatorName = "进入添加公告页面")
    public ModelAndView addAfficheIndex(){
        ModelAndView mv = new ModelAndView("affiche/add");
        return mv;
    }

    /**
     * 添加公告
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加公告")
    @ResponseBody
    public Map<String, Object> addAffiche(HttpServletRequest request,AfficheVo afficheVo) {
        logger.info("afficheTitle:" + afficheVo.getTitle());
        try {
            List<String> paths = filesUpload(request, "affiche", "imageURI","jpg", "jpeg", "png");
            if (null != paths && paths.size() > 0) {
                afficheVo.setCoverImg(paths.get(0));
            }
            afficheVo.setPublishTime(new Date());
            afficheService.addAffiche(afficheVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("新增公告",staff.getRealname()+"-新增公告："+afficheVo.getTitle(),staff.getId(),staff.getRealname());
            result = true;
            message = messageSource.getMessage("affiche.publish.success");
            return getResultMap();
        } catch (AfficheException afficheException) {
            result = false;
            message = afficheException.getLocalizedMessage();
            logger.error("affiche 处理错误", afficheException);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("affiche.publish.failed");
            logger.error("添加affiche未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 进入更新公告页面
     */
    @RequestMapping("/updateInput")
    @OperatorLogger(operatorName = "进入修改公告页面")
    public ModelAndView modifyAffiche(Integer id){
        ModelAndView mv = new ModelAndView("affiche/edit");
        AfficheVo afficheVo = afficheService.getAfficheInfoById(id);
        mv.addObject("afficheInfo", afficheVo);
        return mv;
    }

    /**
     * 更新公告
     */
    @RequestMapping("/update")
    @OperatorLogger(operatorName = "更新公告")
    @ResponseBody
    public Map<String, Object> updateAffiche(HttpServletRequest request,AfficheVo afficheVo) {
        try {
            afficheVo.setUpdateTime(new Date());
            List<String> paths = filesUpload(request, "affiche", "imageURI","jpg", "jpeg", "png");
            if (null != paths && paths.size() > 0) {
                afficheVo.setCoverImg(paths.get(0));
            }
            afficheService.updateAffiche(afficheVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("修改公告",staff.getRealname()+"-修改公告："+afficheVo.getTitle(),staff.getId(),staff.getRealname());
            result = true;
            message = messageSource.getMessage("affiche.update.success");
            return getResultMap();
        } catch (AfficheException afficheException) {
            result = false;
            message = afficheException.getLocalizedMessage();
            logger.error("affiche 处理错误", afficheException);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("affiche.update.failed");
            logger.error("添加affiche未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 开启公告
     */
    @RequestMapping("/enableAffiche")
    @OperatorLogger(operatorName = "开启公告")
    @ResponseBody
    public Map<String, Object> enableAffiche(Integer afficheId) {
        try {
            afficheService.enableAffiche(afficheId);
            result = true;
            message = messageSource.getMessage("enable.success");
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("enable.failed");
            logger.error("启用affiche失败", e);
            return getResultMap();
        }
    }

    /**
     * 关闭公告
     */
    @RequestMapping("/disableAffiche")
    @OperatorLogger(operatorName = "关闭公告")
    @ResponseBody
    public Map<String, Object> disableAffiche(Integer afficheId) {
        try {
            AfficheVo newAfficheVo = afficheService.disableAffiche(afficheId);
            result = true;
            message = "关闭成功！";
        } catch (Exception e) {
            result = false;
            message = "关闭失败！";
            e.printStackTrace();
        }
        return getResultMap();
    }
}
