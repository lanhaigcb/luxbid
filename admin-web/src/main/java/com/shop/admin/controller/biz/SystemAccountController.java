package com.shop.admin.controller.biz;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.response.Response;
import com.mine.common.vo.ExchangeVo;
import com.mine.common.vo.admin.AdminCustomerAccountInfoVo;
import com.mine.common.vo.admin.AdminCustomerVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2018/5/2.
 */
@RequestMapping("systemAccount")
@Controller
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class SystemAccountController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(SystemAccountController.class);

    @Autowired
    private AdminService adminService;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private ExchangeService exchangeService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        List<CurrencyVo> voList = currencyService.listAllEnable();
        modelMap.addAttribute("voList", voList);
        return "systemAccount/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(@RequestParam(value = "offset", defaultValue = "1") int offset,
                       @RequestParam(value = "limit", defaultValue = "10") int limit,
                       Date startDate, Date endDate, String symbol) {

        total = adminService.countSystemAccount(symbol);
        if (total > 0) {
            list = adminService.listSystemAccount(startDate, endDate, symbol, offset, limit);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @RequestMapping(value = "/export")
    @ResponseBody
    @OperatorLogger(operatorName = "资产统计导出")
    public Map<String, Object> export(Date startDate, Date endDate, String symbol, HttpServletResponse response) {
        List<AdminCustomerAccountInfoVo> clist = adminService.listSystemAccount(startDate, endDate, symbol, null, null);
        if (clist.size() > 0) {
            String excelTable = PropertyUtil.getProperty("asset");
            String dist = ExcelUtil.export(excelTable, clist, "asset_ColumnName", "asset_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("资产统计导出", staff.getRealname()
                        + "-资产统计导出" + clist.size() + "条数据", staff.getId(), staff.getRealname());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

    @RequestMapping("makebargain")
    public String makebargain(ModelMap modelMap) {
        List<ExchangeVo> voList = exchangeService.listAllExchange();
        modelMap.addAttribute("voList", voList);
        return "systemAccount/makebargainIndex";
    }

    @ResponseBody
    @RequestMapping("makebargainlist")
    public Object makebargainlist(@RequestParam(value = "offset", defaultValue = "1") int offset,
                                  @RequestParam(value = "limit", defaultValue = "10") int limit,
                                  AdminCustomerAccountInfoVo vo) {

        total = adminService.countMakebargain(vo);
        if (total > 0) {
            list = adminService.listMakebargain(vo, offset, limit);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @RequestMapping(value = "makebargainlistExport")
    @ResponseBody
    @OperatorLogger(operatorName = "用户成交统计导出")
    public Map<String, Object> makebargainlistExport(AdminCustomerAccountInfoVo vo, HttpServletResponse response) {
        List<AdminCustomerAccountInfoVo> clist = adminService.listMakebargain(vo, null, null);
        if (clist.size() > 0) {
            String excelTable = PropertyUtil.getProperty("makebargain");
            String dist = ExcelUtil.export(excelTable, clist, "makebargain_ColumnName", "makebargain_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("用户成交统计导出", staff.getRealname()
                        + "-用户成交统计导出" + clist.size() + "条数据", staff.getId(), staff.getRealname());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }


    @RequestMapping("tradeFee")
    public String tradeFee(ModelMap modelMap) {
        List<CurrencyVo> voList = currencyService.listAllEnable();
        modelMap.addAttribute("voList", voList);
        return "systemAccount/tradeFeeIndex";
    }

    @ResponseBody
    @RequestMapping("tradeFeelist")
    public Object makebargainlist(@RequestParam(value = "offset", defaultValue = "1") int offset,
                                  @RequestParam(value = "limit", defaultValue = "10") int limit,
                                  String symbol) {

        total = adminService.countSystemAccount(symbol);
        if (total > 0) {
            list = adminService.listTradeFee(symbol, offset, limit);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @RequestMapping(value = "tradeFeelistExport")
    @ResponseBody
    @OperatorLogger(operatorName = "交易收益统计导出")
    public Map<String, Object> tradeFeelistExport(String symbol, HttpServletResponse response) {
        List<AdminCustomerAccountInfoVo> clist = adminService.listTradeFee(symbol, null, null);
        if (clist.size() > 0) {
            String excelTable = PropertyUtil.getProperty("tradeFee");
            String dist = ExcelUtil.export(excelTable, clist, "tradeFee_ColumnName", "tradeFee_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("交易收益统计导出", staff.getRealname()
                        + "-交易收益统计导出" + clist.size() + "条数据", staff.getId(), staff.getRealname());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

    @RequestMapping("haveAsset")
    public String haveAsset(ModelMap modelMap) {
        List<CurrencyVo> voList = currencyService.listAllEnable();
        modelMap.addAttribute("voList", voList);
        return "systemAccount/haveAssetIndex";
    }

    @ResponseBody
    @RequestMapping("haveAssetList")
    public Object haveAssetList(@RequestParam(value = "offset", defaultValue = "1") int offset,
                                  @RequestParam(value = "limit", defaultValue = "10") int limit,
                                  String symbol) {

        total = adminService.countAssetList(symbol);
        if (total > 0) {
            list = adminService.haveAssetList(symbol, offset, limit);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @RequestMapping(value = "haveAssetListExport")
    @ResponseBody
    @OperatorLogger(operatorName = "持币统计导出")
    public Map<String, Object> haveAssetListExport(String symbol, HttpServletResponse response) {
        List<AdminCustomerAccountInfoVo> clist = adminService.haveAssetList(symbol, null, null);
        if (clist.size() > 0) {
            String excelTable = PropertyUtil.getProperty("haveAsset");
            String dist = ExcelUtil.export(excelTable, clist, "haveAsset_ColumnName", "haveAsset_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("持币统计导出", staff.getRealname()
                        + "-持币统计导出" + clist.size() + "条数据", staff.getId(), staff.getRealname());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

}
