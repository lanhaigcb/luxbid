package com.shop.admin.controller.cfd;
import com.alibaba.fastjson.JSON;
import com.mine.bizservice.CfdBizService;
import com.mine.bizservice.CfdCurrencyService;
import com.mine.bizservice.CfdNodeService;
import com.mine.common.cfdCurrencyVo.CfdCurrencyAdminVo;
import com.mine.common.enums.AccountLogType;
import com.mine.common.enums.cfd.CfdApplyType;
import com.mine.common.enums.cfd.CfdNodeType;
import com.mine.common.vo.admin.AdminQueryVo;
import com.mine.common.vo.cfd.*;
import com.shop.admin.controller.BaseController;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import com.shop.admin.util.RedisUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.*;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/8/17 上午12:59
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/cfd")
public class CfdController extends BaseController {

    @Autowired
    private CfdBizService cfdBizService;

    @Autowired
    private CfdNodeService cfdNodeService;

    @Autowired
    private CfdCurrencyService cfdCurrencyService;

    @Autowired
    private RedisUtil redisUtil;

    @RequestMapping("position")
    public String index(ModelMap modelMap) {
        //所有节点
        List<CfdNodeVo> list = cfdNodeService.list(new CfdNodeVo(), 0, Integer.MAX_VALUE);
        modelMap.addAttribute("nodes", list);
        //币种
        List<CfdCurrencyAdminVo> list1 = cfdCurrencyService.getList(null, null, 0, Integer.MAX_VALUE);
        modelMap.addAttribute("cfdCurrencys", list1);
        return "cfd/position_index";
    }

    @ResponseBody
    @RequestMapping("position/list")
    public Object list(Integer nodeId,Integer cfdCurrencyId,Integer customerId, String mobile, String email,Integer inviteeId,
                       CfdApplyType cfdApplyType, Date start, Date end, BigDecimal min, BigDecimal max,
                       Integer offset, Integer limit) {

        total = cfdBizService.cfdOrderAdminCount(inviteeId, nodeId,cfdCurrencyId,customerId, mobile,email, cfdApplyType,start, end,min,max);
        if(total >0 ){
            list = cfdBizService.cfdOrderAdminList(inviteeId,nodeId,cfdCurrencyId,customerId,mobile,email,cfdApplyType,offset,limit,start,end,min,max);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }

    @RequestMapping(value = "position/export")
    @ResponseBody
    public Map<String, Object> exportPositionExcel(Integer inviteeId, Integer nodeId,Integer cfdCurrencyId,HttpServletResponse response, Integer customerId, String mobile, String email,
                                                   CfdApplyType cfdApplyType, Date start, Date end, BigDecimal min, BigDecimal max) {

        list = cfdBizService.cfdOrderAdminList(inviteeId,nodeId,cfdCurrencyId,customerId,mobile,email,cfdApplyType,0,Integer.MAX_VALUE,start,end,min,max);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("cfdPosition");
            String dist = ExcelUtil.export(excelTable, list, "cfdPosition_ColumnName", "cfdPosition_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

    /**
     *差价合约-节点持仓单查询
     * @return
     */
    @RequestMapping("nodePosition")
    public String nodeIndex(ModelMap modelMap)
    {

        CfdNodeVo cfdNode =  new CfdNodeVo();
        cfdNode.setCfdNodeType(CfdNodeType.GENERAL);

        //所有节点
        List<CfdNodeVo> list = cfdNodeService.list(cfdNode, 0, Integer.MAX_VALUE);
        modelMap.addAttribute("nodes",list);
        //币种
        List<CfdCurrencyAdminVo> list1 = cfdCurrencyService.getList(null, null, 0, Integer.MAX_VALUE);
        modelMap.addAttribute("cfdCurrencys",list1);
        return "cfd/position_node_index";
    }


    /**
     *差价合约-节点持仓单查询
     * @return
     */
    @ResponseBody
    @RequestMapping("position/nodeList")
    public Object NodeList(Integer nodeId,Integer cfdCurrencyId, String mobile, String email,
                           CfdApplyType cfdApplyType, Date start, Date end, BigDecimal min, BigDecimal max,
                           Integer offset, Integer limit)
    {

        total = cfdBizService.nodeOrderCount( nodeId,cfdCurrencyId, mobile,email, cfdApplyType,start, end,min,max);
        if(total >0 ){
            list = cfdBizService.nodeOrderList(nodeId,cfdCurrencyId,mobile,email,cfdApplyType,offset,limit,start,end,min,max);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }
    /**
     *差价合约-节点持仓单导出
     * @return
     */
    @RequestMapping(value = "position/exportNode")
    @ResponseBody
    public Map<String, Object> exportPositionNodeExcel(Integer nodeId,Integer cfdCurrencyId,HttpServletResponse response, Integer customerId, String mobile, String email,
                                                   CfdApplyType cfdApplyType, Date start, Date end, BigDecimal min, BigDecimal max) {

        list = cfdBizService.nodeOrderList(nodeId,cfdCurrencyId,mobile,email,cfdApplyType,0,Integer.MAX_VALUE,start,end,min,max);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("cfdNodePosition");
            String dist = ExcelUtil.export(excelTable, list, "cfdNodePosition_ColumnName", "cfdNodePosition_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }



    @RequestMapping("customerUnwind")
    public String customerUnwind(ModelMap modelMap) {

        //所有节点
        List<CfdNodeVo> list = cfdNodeService.list(new CfdNodeVo(), 0, Integer.MAX_VALUE);
        modelMap.addAttribute("nodes", list);
        List<CfdCurrencyVo> vos = cfdBizService.cfgCurrencyList();
        modelMap.addAttribute("currencys", vos);
        return "cfd/customer_unwind_index";
    }

    @ResponseBody
    @RequestMapping("unwind/list")
    public Object unwindList(Integer inviteeId,  Integer nodeId, Integer customerId, String mobile, String email,
                             CfdApplyType cfdApplyType, Date start, Date end, String remark, String symbol,
                             Integer offset, Integer limit) {

        total = cfdBizService.adminUnwindCount(nodeId, customerId, inviteeId,mobile, email, cfdApplyType, remark, start, end,symbol);
        if (total > 0) {
            list = cfdBizService.adminUnwindList(nodeId, customerId, inviteeId, mobile, email, cfdApplyType, remark, start, end,symbol, offset, limit);
        }
        result = true;

        message = "查询成功";
        return getResultMap();
    }

    @RequestMapping("nodeUnwind")
    public String nodeUnwind(ModelMap modelMap) {

        CfdNodeVo cfdNode =  new CfdNodeVo();
        cfdNode.setCfdNodeType(CfdNodeType.GENERAL);
        //所有节点
        List<CfdNodeVo> list = cfdNodeService.list(cfdNode, 0, Integer.MAX_VALUE);
        List<CfdCurrencyVo> vos = cfdBizService.cfgCurrencyList();
        modelMap.addAttribute("nodes", list);
        modelMap.addAttribute("currencys", vos);
        return "cfd/nodeUnwind_index";
    }

    @ResponseBody
    @RequestMapping("nodeUnwind/list")
    public Object nodeUnwindList(Integer nodeId, String mobile, String email,
                             CfdApplyType cfdApplyType, Date start, Date end, String remark, String symbol,
                             Integer offset, Integer limit) {
        total = cfdBizService.nodeUnwindCount(nodeId, mobile, email, cfdApplyType, remark, start, end, symbol);
        if (total > 0) {
            list = cfdBizService.nodeUnwindList(nodeId, mobile, email, cfdApplyType, remark, start, end, symbol, offset, limit);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }

    @RequestMapping(value = "unwind/export")
    @ResponseBody
    public Map<String, Object> exportUnwindExcel(Integer inviteeId,  Integer nodeId, HttpServletResponse response, Integer customerId, String mobile, String email,
                                                 CfdApplyType cfdApplyType, Date start, Date end, String symbol, String remark) {
        list = cfdBizService.nodeUnwindList(nodeId, mobile, email, cfdApplyType, remark, start, end,symbol, 0, Integer.MAX_VALUE);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("cfdUnwind");
            String dist = ExcelUtil.export(excelTable, list, "cfdUnwind_ColumnName", "cfdUnwind_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

    //跳转页面的方法
    @RequestMapping("statistics")
    public String statistics(ModelMap modelMap) {
        //所有节点
        CfdNodeVo cfdNodeVo = new CfdNodeVo();
        cfdNodeVo.setCfdNodeType(CfdNodeType.GENERAL);
        List<CfdNodeVo> list = cfdNodeService.list(cfdNodeVo, 0, Integer.MAX_VALUE);
        modelMap.addAttribute("nodes",list);

        //币种
        List<CfdCurrencyAdminVo> list1 = cfdCurrencyService.getList(null, null, 0, Integer.MAX_VALUE);
        modelMap.addAttribute("cfdCurrencys",list1);
        return "cfd/statistics_index";
    }

    /**
     * 查看持仓统计数据的方法
     * <p>
     * 根据币种来选择不同的虚拟货币
     */
    @ResponseBody
    @RequestMapping("statistics/list")
    public Object statisticsList(Integer cfdCurrencyId, Integer nodeId) {
        List<CfdPositionVo> statisticsList = cfdBizService.findStatisticsList(cfdCurrencyId, nodeId);
        total = statisticsList.size();
        list = statisticsList;
        result = true;
        message = "查询成功";
        return getResultMap();
    }

    @RequestMapping("capitalFlow")
    public String capitalFlow(ModelMap modelMap) {

        //所有节点
        List<CfdNodeVo> list = cfdNodeService.list(new CfdNodeVo(), 0, Integer.MAX_VALUE);
        List<CfdBenchmarkingCurrencyVo> benchmarkingCurrencyList = cfdBizService.getBenchmarkingCurrencyList();
        modelMap.addAttribute("currencys", benchmarkingCurrencyList);
        modelMap.addAttribute("nodes", list);
        return "cfd/capitalFlow_index";
    }

    @ResponseBody
    @RequestMapping("capitalFlow/list")
    public Object capitalFlowList(Integer customerId, Integer inviterId, String realName, AccountLogType accountLogType, String mobile, String email, Date start, Date end, String symbol,
                                  Integer offset, Integer limit) {

        total = cfdBizService.capitalFlowCount(customerId, inviterId, realName, accountLogType, mobile, email, start, end, symbol);
        if (total > 0) {
            list = cfdBizService.capitalFlowList(customerId, inviterId, realName, accountLogType, mobile, email, start, end, symbol, offset, limit);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }

    @RequestMapping("sd")
    @ResponseBody
    public  void  unwidJob(){

        Date start = new Date();

        cfdBizService.autoUnwind("USDT");

        Date end = new Date();
    }

}
