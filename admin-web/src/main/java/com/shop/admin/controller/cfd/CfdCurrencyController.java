package com.shop.admin.controller.cfd;

import com.mine.bizservice.CfdCurrencyService;
import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.cfdCurrencyVo.CfdCurrencyAdminVo;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.currency.CurrencyException;
import com.mine.common.exception.file.FileException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.controller.BaseController;
import com.shop.admin.controller.FileUploadController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.setting.SystemSettingService;
import com.shop.admin.service.staff.StaffOperationLogService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("cfdCurrency")
public class CfdCurrencyController extends FileUploadController {

    private static Logger logger = LoggerFactory.getLogger(CfdCurrencyController.class);
    @Autowired
    private CfdCurrencyService cfdCurrencyService;
    @Autowired
    private SystemSettingService systemSettingService;
    @Autowired
    private StaffOperationLogService staffOperationLogService;
    @Autowired
    private MessageSource messageSource;
    @Autowired
    private ExchangeService exchangeService;
    @Autowired
    private CurrencyService currencyService;

    /**
     * 跳转合约币种管理页面的方法
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "index")
    public String products(ModelMap modelMap){
        return  "cfdCurrency/index";
    }

    /**
     * 合约币种管理list页面
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "findListAll")
    public Object findListAll(String symbol, String chName, Integer offset,
                              Integer limit){
        //1获取总条数
        total = cfdCurrencyService.getCount(symbol, chName);
        //2获取当前list
        if(total>0){
            List<CfdCurrencyAdminVo> cfdCurrencyAdminVos = cfdCurrencyService.getList(symbol, chName, getOffset(offset), getLimit(limit));
            list=cfdCurrencyAdminVos.size()>0?cfdCurrencyAdminVos:null;
        }
        //3返回
        result = true;
        message = "查询成功";
        return  getResultMap();
    }

    /**
     * 跳转添加合约币种的方法
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "addInput")
    public String addCfdCurrencyIndex(ModelMap modelMap){
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        modelMap.addAttribute("currency",currencyVos);
        return  "cfdCurrency/add";
    }

    /**
     * 添加合约币种的方法
     * @param cfdCurrencyAdminVo
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value="add")
    public Map<String, Object> addCfdCurrenyc(HttpServletRequest request, CfdCurrencyAdminVo cfdCurrencyAdminVo){
        try {
        List<String> paths = filesUpload(request, "cfdCurrency", "image","jpg", "jpeg", "png");
        if (null == paths || paths.size() == 0) {
            result = false;
            message = "文件上传失败";
            return getResultMap();
        }
        final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);
        if (null == systemSetting) {
            throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
        }
        cfdCurrencyAdminVo.setImage(systemSetting.getValue() + paths.get(0));
        cfdCurrencyAdminVo.setCreateTime(new Date());
        cfdCurrencyAdminVo.setEnable(false);
        cfdCurrencyService.addCfdCurrency(cfdCurrencyAdminVo);
        //记录用户操作日志
        Staff staff = SecurityUtil.currentLogin();
        staffOperationLogService.addStaffOperationLog("新增币种", staff.getRealname() + "-新增币种：" + cfdCurrencyAdminVo.getSymbol(), staff.getId(), staff.getRealname());
        result = true;
        message = messageSource.getMessage("cfdCurrency.add.success");
        return getResultMap();
    } catch (FileException fileException) {
        result = false;
        message = fileException.getLocalizedMessage();
        logger.error("文件错误", fileException);
        return getResultMap();
    } catch (CurrencyException currencyException) {
        currencyException.printStackTrace();
        result = false;
        message = currencyException.getLocalizedMessage();
        logger.error("cfdCurrency 处理错误", currencyException);
        return getResultMap();
    } catch (Exception e) {
        e.printStackTrace();
        result = false;
        message = messageSource.getMessage("cfdCurrency.add.failed");
        logger.error("添加cfdCurrency未知错误", e);
        return getResultMap();
    }

    }

    /**
     * 跳转更新合约币种页面的方法
     * @param modelMap
     * @param id
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "updateInput")
    public  String  updateCfdCurrencyIndex(ModelMap modelMap,Integer id){
        CfdCurrencyAdminVo cfdCurrency = cfdCurrencyService.getById(id);
        modelMap.addAttribute("cfdCurrency",cfdCurrency);
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        modelMap.addAttribute("currency",currencyVos);
        return  "cfdCurrency/edit";
    }

    /**
     * 修改合约币种的方法
     * @param cfdCurrencyAdminVo
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "update")
    public Map<String, Object> updateCfdCurrency(HttpServletRequest request,CfdCurrencyAdminVo cfdCurrencyAdminVo){
        try {
            List<String> paths = filesUpload(request, "cfdCurrency", "image","jpg", "jpeg", "png");

            if (null != paths && paths.size() > 0) {
                final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);
                if (null == systemSetting) {
                    throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
                }
                cfdCurrencyAdminVo.setImage(systemSetting.getValue() + paths.get(0));
                exchangeService.batchUpdateImageUrl(cfdCurrencyAdminVo.getId(), cfdCurrencyAdminVo.getImage());
            }
            cfdCurrencyAdminVo.setUpdateTime(new Date());
            cfdCurrencyService.updateCfdCurrency(cfdCurrencyAdminVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("修改币种", staff.getRealname() + "-修改币种：" + cfdCurrencyAdminVo.getSymbol(), staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("cfdCurrency.update.success");
            return getResultMap();
        } catch (FileException fileException) {
            result = false;
            message = fileException.getLocalizedMessage();
            logger.error("文件错误", fileException);
            return getResultMap();
        } catch (CurrencyException currencyException) {
            result = false;
            message = currencyException.getLocalizedMessage();
            logger.error("cfdCurrency 处理错误", currencyException);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("cfdCurrency.update.failed");
            logger.error("cfdCurrency", e);
            return getResultMap();
        }
    }

    /**
     * 修改禁用/启用状态的方法
     * @param id
     * @param enable
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "enable")
    public Map<String, Object> cfdCurrencyEnable(Integer id,Boolean enable){
        try {
            CfdCurrencyAdminVo cfdCurrencyAdminVo = cfdCurrencyService.updateEnable(id, enable);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("修改币种", staff.getRealname() + "-修改币种：" + cfdCurrencyAdminVo.getSymbol(), staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("合约币种更新状态成功");
            return getResultMap();
        } catch (CurrencyException currencyException) {
            result = false;
            message = currencyException.getLocalizedMessage();
            logger.error("cfdCurrency.enable 处理错误", currencyException);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("合约币种更新状态成功");
            logger.error("cfdCurrency", e);
            return getResultMap();
        }
    }

}
