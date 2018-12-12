package com.shop.admin.controller.biz;

import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.currency.CurrencyException;
import com.mine.common.exception.file.FileException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.vo.SeriesVo;
import com.shop.admin.aop.annotation.OperatorLogger;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * CurrencyController(币种)
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/currency")
public class CurrencyController extends FileUploadController {

    private static Logger logger = LoggerFactory.getLogger(CurrencyController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private SystemSettingService systemSettingService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @Autowired
    private ExchangeService exchangeService;

    /**
     * 进入Currency管理
     */
    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入Currency管理")
    public ModelAndView currencyManage() {
        ModelAndView mv = new ModelAndView("currency/index");
        return mv;
    }

    /**
     * 获取所有Currency
     *
     * @return
     */
    @RequestMapping("/findListAll")
    @OperatorLogger(operatorName = "获取所有Currency")
    @ResponseBody
    public Response listAllBack(String symbol, String chName, Integer offset,
                                Integer limit) {
        total = (int) currencyService.getCount(symbol, chName);
        if (total > 0) {
            List<CurrencyVo> currencyVos = currencyService.listAll(symbol, chName, getOffset(offset), getLimit(limit));
            list = (currencyVos == null ? new ArrayList<>() : currencyVos);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 进入添加Currency页面
     */
    @RequestMapping("/addInput")
    @OperatorLogger(operatorName = "进入添加Currency页面")
    public ModelAndView addCurrencyIndex() {
        ModelAndView mv = new ModelAndView("currency/add");

        List<SeriesVo> seriesVos = currencyService.listAllSeries();
        mv.addObject("series", seriesVos);
        return mv;
    }

    /**
     * 添加Currency
     *
     * @return
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加Currency")
    @ResponseBody
    public Map<String, Object> addCurrency(HttpServletRequest request, CurrencyVo currencyVo) {
        try {
            List<String> paths = filesUpload(request, "currency", "image","jpg", "jpeg", "png");

            if (null == paths || paths.size() == 0) {
                result = false;
                message = "文件上传失败";
                return getResultMap();
            }
            final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);
            if (null == systemSetting) {
                throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
            }
            currencyVo.setImage(systemSetting.getValue() + paths.get(0));
            currencyService.add(currencyVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("新增币种", staff.getRealname() + "-新增币种：" + currencyVo.getSymbol(), staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("currency.add.success");
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
            logger.error("currency 处理错误", currencyException);
            return getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("currency.add.failed");
            logger.error("添加currency未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 进入修改Currency页面
     */
    @RequestMapping("/updateInput")
    @OperatorLogger(operatorName = "进入修改Currency页面")
    public ModelAndView modifyCurrency(Integer id) {
        ModelAndView mv = new ModelAndView("currency/edit");
        CurrencyVo currencyVo = currencyService.getCurrencyInfoById(id);
        List<SeriesVo> seriesVos = currencyService.listAllSeries();
        mv.addObject("series", seriesVos);
        mv.addObject("currency", currencyVo);
        return mv;
    }

    /**
     * 更新Currency信息
     */
    @RequestMapping("/update")
    @OperatorLogger(operatorName = "修改Currency")
    @ResponseBody
    public Map<String, Object> modifyCurrency(HttpServletRequest request, CurrencyVo currencyVo) {
        try {
            List<String> paths = filesUpload(request, "currency", "image","jpg", "jpeg", "png");

            if (null != paths && paths.size() > 0) {
                final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);
                if (null == systemSetting) {
                    throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
                }
                currencyVo.setImage(systemSetting.getValue() + paths.get(0));
                exchangeService.batchUpdateImageUrl(currencyVo.getId(), currencyVo.getImage());
            }
            currencyService.update(currencyVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("修改币种", staff.getRealname() + "-修改币种：" + currencyVo.getSymbol(), staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("currency.update.success");
            return getResultMap();
        } catch (FileException fileException) {
            result = false;
            message = fileException.getLocalizedMessage();
            logger.error("文件错误", fileException);
            return getResultMap();
        } catch (CurrencyException currencyException) {
            result = false;
            message = currencyException.getLocalizedMessage();
            logger.error("currency 处理错误", currencyException);
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("currency.update.failed");
            logger.error("添加currency未知错误", e);
            return getResultMap();
        }
    }
}
