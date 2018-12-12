/**
 *
 */
package com.shop.admin.controller.convert;

import com.mine.bizservice.ConvertService;
import com.mine.bizservice.CurrencyService;
import com.mine.common.convert.ConvertRecordVo;
import com.mine.common.convert.ConvertVo;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.suportVo.AfficheVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.service.staff.StaffRoleService;
import com.shop.admin.service.staff.StaffService;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class ConvertController extends BaseController {

    private static Log logger = LogFactory.getLog(ConvertController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private ConvertService convertService;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    /**
     * 兑换规则管理页面
     */
    @RequestMapping(value = "convert/index")
    @OperatorLogger(operatorName = "进入兑换规则管理")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("convert/convert_index");
        return mv;
    }

    /***
     * 兑换规则列表
     *
     * @return
     */
    @RequestMapping(value = "convert/list")
    @OperatorLogger(operatorName = "查看兑换规则列表")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {
        total = (int) convertService.getCount();
        List<ConvertVo> convertVos = null;
        if (total > 0) {
            convertVos = convertService.listAll(getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, convertVos, "成功");
    }

    /**
     * 新增兑换规则页面
     *
     * @return
     */
    @RequestMapping(value = "convert/addInput")
    @OperatorLogger(operatorName = "进入添加兑换规则页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("convert/convert_add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /**
     * 新增兑换规则
     *
     * @return
     */
    @RequestMapping(value = "convert/add")
    @OperatorLogger(operatorName = "添加兑换规则")
    @ResponseBody
    public Map<String, Object> add(ConvertVo convertVo) {
        //参数验证
        int i = (int)convertService.getAllTrueStatus();
        ConvertVo convert = convertService.getConvertBySymbol(convertVo.getToSymbol());
        if(null != convert.getId()){
            result = false;
            message = messageSource.getMessage("每个币种只能设置一条兑换规则");
        }else if(convertVo.getSelfExchangeMax().compareTo(convertVo.getExchangeMax()) > 0){
            result = false;
            message = messageSource.getMessage("个人最高兑换额不能大于平台最高兑换额");
        }else if(convertVo.getExchangeScale().signum()<0){
            result = false;
            message = messageSource.getMessage("兑换比例不能为负数");
        }else if(i>0&&convertVo.getEnable()){
            result = false;
            message = messageSource.getMessage("只能启用一条兑换规则");
        }else{
            //逻辑判断//TODO
            BigDecimal exchangeMul = new BigDecimal("1").divide(convertVo.getExchangeScale());
            convertVo.setToCurrencyId(currencyService.getCurrencyBySymbol(convertVo.getToSymbol()).getId());
            convertVo.setExchangeMul(exchangeMul);
            try {
                convertService.add(convertVo);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("新增兑换规则",staff.getRealname()+"-新增兑换规则："+convertVo.getRule(),staff.getId(),staff.getRealname());
                result = true;
                message = messageSource.getMessage("add.success");
            } catch (StaffException e) {
                result = false;
                message = e.getMessage();
            } catch (Exception e) {
                result = false;
                message = messageSource.getMessage("add.failed");
            }
        }
        return getResultMap();
    }

    /**
     * 前往修改兑换规则页面
     *
     * @param request
     * @param response
     * @param
     * @return
     */
    @RequestMapping(value = "convert/updateInput")
    @OperatorLogger(operatorName = "进入修改兑换规则页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer id) {
        ConvertVo convertVo = convertService.getById(id);
        ModelAndView mv = new ModelAndView("convert/convert_edit");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        convertVo.setExchangeMax(convertVo.getExchangeMax().setScale(0, BigDecimal.ROUND_HALF_UP));
        convertVo.setSelfExchangeMax(convertVo.getSelfExchangeMax().setScale(0, BigDecimal.ROUND_HALF_UP));
        mv.addObject("currencys", currencyVos);
        mv.addObject("convert", convertVo);
        return mv;
    }

    //设置规则是否启用
    @ResponseBody
    @RequestMapping("convert/updateStatus")
    @OperatorLogger(operatorName = "修改兑换规则状态")
    public Map<String, Object> updateStatus(Integer id, String status) {
        int i = (int)convertService.getAllTrueStatus();
        if("enable".equals(status)&&i>0){
            result = false;
            message = "只能启用一条兑换规则";
            return getResultMap();
        }else{
            try {
                boolean flag = false;
                if ("enable".equals(status)&&i==0) {
                    flag = true;
                }
                convertService.updateStatus(id, flag);
                result = true;
                message = messageSource.getMessage("修改成功");
            } catch (Exception e) {
                e.printStackTrace();
                result = false;
                message = messageSource.getMessage("修改失败");
            }
        }
        return getResultMap();
    }

    @ResponseBody
    @RequestMapping("convert/update")
    @OperatorLogger(operatorName = "修改兑换规则")
    public Map<String, Object> update(ConvertVo convertVo) {
        //参数验证
        int i = (int)convertService.getAllTrueStatus();
        ConvertVo convert = convertService.getConvertBySymbol(convertVo.getToSymbol());
        if(convertVo.getId() != convert.getId()){
            result = false;
            message = messageSource.getMessage("每个币种只能设置一条兑换规则");
            return getResultMap();
        }else if(convertVo.getSelfExchangeMax().compareTo(convertVo.getExchangeMax()) > 0){
            result = false;
            message = messageSource.getMessage("个人最高兑换额不能大于平台最高兑换额");
            return getResultMap();
        }else if(convertVo.getExchangeScale().signum()<0){
            result = false;
            message = messageSource.getMessage("兑换比例不能为负数");
            return getResultMap();
        }else if(i>0&&convertVo.getEnable()){
            result = false;
            message = messageSource.getMessage("只能启用一条兑换规则");
            return getResultMap();
        }else{
            try {
                BigDecimal exchangeMul = new BigDecimal("1").divide(convertVo.getExchangeScale());
                convertVo.setExchangeMul(exchangeMul);
                convertVo.setToCurrencyId(currencyService.getCurrencyBySymbol(convertVo.getToSymbol()).getId());
                convertService.update(convertVo);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("修改兑换规则",staff.getRealname()+"-修改兑换规则："+convertVo.getRule(),staff.getId(),staff.getRealname());
                result = true;
            } catch (Exception e) {
                logger.error("修改convert未知错误", e);
                result = false;
            }
        }
        message = result ? "修改成功" : "修改失败";
        return getResultMap();
    }

    /**
     * 兑换记录页面
     */
    @RequestMapping(value = "convertRecord/index")
    @OperatorLogger(operatorName = "进入兑换记录页面")
    public ModelAndView recordiIndex() {
        ModelAndView mv = new ModelAndView("convertRecord/index");
        List<Map<String, Object>> currencyVos = convertService.getConvertSymbolList();
        mv.addObject("currencys", currencyVos);
        return mv;
    }
    /***
     * 兑换记录
     *
     * @return
     */
    @RequestMapping(value = "convertRecord/list")
    @OperatorLogger(operatorName = "查看兑换记录")
    @ResponseBody
    public Map<String, Object> convertRecord(Integer limit, Integer offset, String customerAccount,Integer customerId, String symbol, Date startDate, Date endDate) {
        total = (int) convertService.getRecordCount( customerAccount,  symbol,  startDate,  endDate);
        if (total > 0) {
            list = convertService.recordList(getOffset(offset), getLimit(limit), customerAccount,customerId,  symbol,  startDate,  endDate);
        }
        return getResultMap();
    }

    /**
     * 兑换记录页面
     */
    @RequestMapping(value = "convertInfo/index")
    @OperatorLogger(operatorName = "进入兑换规则管理")
    public ModelAndView convertInfoIndex() {
        ModelAndView mv = new ModelAndView("convertRecord/convertInfo");
        return mv;
    }


    /**
     *
     * @param customerAccount
     * @param customerId
     * @param symbol
     * @param startDate
     * @param endDate
     * @return
     */
    @ResponseBody
    @RequestMapping("convertRecord/total")
    @OperatorLogger(operatorName = "获取统计信息")
    public Map<String, Object> total(String customerAccount,Integer customerId, String symbol, Date startDate, Date endDate) {
        try {
            List<Map<String, Object>> convertTotalInof = convertService.getConvertTotalInfo(customerAccount, customerId, symbol, startDate,endDate);
            list = convertTotalInof;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        return getResultMap();
    }

    /***
     * 兑换统计
     *
     * @return
     */
    @RequestMapping(value = "convert/info")
    @OperatorLogger(operatorName = "兑换统计")
    @ResponseBody
    public Map<String, Object> convertInfo(Integer limit, Integer offset, String customerAccount, Date startDate, Date endDate) {
        total = (int) convertService.getConvertInfoCount();
        if (total > 0) {
            list = convertService.convertInfo(getOffset(offset), getLimit(limit),customerAccount,startDate,endDate);
        }
        return getResultMap();
    }

    /***
     * 兑换记录导出
     *
     * @return
     */
    @RequestMapping(value = "convert/record/export")
    @OperatorLogger(operatorName = "兑换记录导出")
    @ResponseBody
    public Map<String, Object> exportExcel(HttpServletResponse response,String customerAccount,Integer customerId, String symbol, Date startDate, Date endDate) {
        list = convertService.recordList(null, null, customerAccount,customerId,  symbol,  startDate,  endDate);
        if(list.size()>0){
            String excelTable = PropertyUtil.getProperty("convertRecord");
            String dist = ExcelUtil.export(excelTable,list,"convertRecord_ColumnName","convertRecord_Keys");
            try{
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("兑换记录导出",staff.getRealname()
                        +"-兑换记录导出"+list.size()+"条数据",staff.getId(),staff.getRealname());
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

}
