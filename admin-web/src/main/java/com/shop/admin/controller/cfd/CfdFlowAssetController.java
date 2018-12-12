package com.shop.admin.controller.cfd;


import com.mine.bizservice.CfdBizService;
import com.mine.bizservice.CfdFinalMoneyService;
import com.mine.bizservice.CfdNodeService;
import com.mine.bizservice.CfdSubAccountLogService;
import com.mine.common.cfd.CustomerFlowAssetVo;
import com.mine.common.enums.AccountLogType;
import com.mine.common.enums.cfd.CfdApplyType;
import com.mine.common.enums.cfd.CfdNodeRole;
import com.mine.common.vo.cfd.CfdNodeVo;
import com.shop.admin.controller.BaseController;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 * 节点出入金报Controller
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("cfdFlowAsset")
public class CfdFlowAssetController extends BaseController{

    @Autowired
    private CfdNodeService cfdNodeService;

    @Autowired
    CfdFinalMoneyService cfdFinalMoneyService;

    @Autowired
    CfdSubAccountLogService cfdSubAccountLogService;


    @Autowired
    private CfdBizService cfdBizService;

    /**
     * 节点出入金列表
     * @return
     */
    @RequestMapping("nodeFlowAsset")
    public String flowAssets(ModelMap modelMap){

        //所有节点
        List<CfdNodeVo> list = cfdNodeService.list(new CfdNodeVo(), 0, Integer.MAX_VALUE);
        modelMap.addAttribute("nodes", list);
        return "cfdFlowAsset/nodeIndex";
    }


    /**
     * 节点用户出入金列表
     * @param offset
     * @param limit
     * @param accountLogType
     * @param mobile
     * @param beginTime
     * @param endTime
     * @return
     */
    @ResponseBody
    @RequestMapping("nodeFlowAssetlist")
    public Object nodeFlowAssetlist(Integer offset, Integer limit, AccountLogType accountLogType, String mobile, Date beginTime, Date endTime,Integer nodeId,String email) {
        total = cfdSubAccountLogService.findNodeFlowAssetCount(CfdNodeRole.ADMIN,accountLogType,mobile,email,beginTime,endTime,null,null,nodeId).intValue();
        if(total >0 ){
            list = cfdSubAccountLogService.findNodeFlowAssetByTypeAndCustomerId(CfdNodeRole.ADMIN,getOffset(offset), getLimit(limit),accountLogType,mobile,email,beginTime,endTime,null,null,nodeId);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }


    /**
     * 节点出入金导出
     * @param response
     * @param accountLogType
     * @param mobile
     * @param beginTime
     * @param endTime
     * @return
     */
    @RequestMapping(value = "nodeExport")
    @ResponseBody
    public Map<String, Object> nodeExport(HttpServletResponse response,AccountLogType accountLogType, String mobile, Date beginTime, Date endTime,Integer nodeId,String email) {
        list = cfdSubAccountLogService.findNodeFlowAssetByTypeAndCustomerId(CfdNodeRole.ADMIN,0,Integer.MAX_VALUE,accountLogType,mobile,email,beginTime,endTime,null,null,nodeId);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("flowAsset");
            String dist = ExcelUtil.export(excelTable, list, "flowAsset_ColumnName", "flowAsset_Keys");
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
     * 客户出入金导出
     * @param response
     * @param accountLogType
     * @param mobile
     * @param beginTime
     * @param endTime
     * @return
     */
    @RequestMapping(value = "customerExport")
    @ResponseBody
    public Map<String, Object> customerExport(HttpServletResponse response,AccountLogType accountLogType, String mobile, Date beginTime, Date endTime, Integer inviter,Integer customerId,String email) {
        list = cfdSubAccountLogService.findNodeFlowAssetByTypeAndCustomerId(CfdNodeRole.CUSTOMER,0,Integer.MAX_VALUE,accountLogType,mobile,email,beginTime,endTime,inviter,customerId,null);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("flowAsset");
            String dist = ExcelUtil.export(excelTable, list, "flowAsset_ColumnName", "flowAsset_Keys");
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
     * 普通用户出入金列表
     * @return
     */
    @RequestMapping("customerFlowAsset")
    public String customerFlowAsset(){
        return "cfdFlowAsset/customerIndex";
    }


    /**
     * 普通用户出入金列表
     * @param offset
     * @param limit
     * @param accountLogType
     * @param mobile
     * @param beginTime
     * @param endTime
     * @return
     */
    @ResponseBody
    @RequestMapping("customerFlowAssetlist")
    public Object customerFlowAssetlist(Integer offset, Integer limit, AccountLogType accountLogType, String mobile, Date beginTime, Date endTime, Integer inviter,Integer customerId,String email) {
        total = cfdSubAccountLogService.findNodeFlowAssetCount(CfdNodeRole.CUSTOMER,accountLogType,mobile,email,beginTime,endTime,inviter,customerId,null).intValue();
        if(total >0 ){
            list = cfdSubAccountLogService.findNodeFlowAssetByTypeAndCustomerId(CfdNodeRole.CUSTOMER,getOffset(offset), getLimit(limit),accountLogType,mobile,email,beginTime,endTime,inviter,customerId,null);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }




    /**
     * 普通用户资金页
     * @return
     */
    @RequestMapping("customerAsset")
    public String customerAsset(){
        return "cfdFlowAsset/customerAssetIndex";
    }


    /**
     * 普通用户资金列表
     * @param offset
     * @param limit
     * @param accountLogType
     * @param mobile
     * @param beginTime
     * @param endTime
     * @return
     */
    @ResponseBody
    @RequestMapping("customerAssetlist")
    public Object customerAssetlist(Integer offset, Integer limit,Integer nodeId, Integer inviter, Integer customerId) {
        total = cfdBizService.findCustomerAssetCount(nodeId,inviter,customerId).intValue();
        if(total >0 ){
            list = cfdBizService.findCustomerAssetList(getOffset(offset), getLimit(limit),nodeId,inviter,customerId);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }


    /**
     * 用户资金详情导出
     * @param response
     * @param accountLogType
     * @param mobile
     * @param beginTime
     * @param endTime
     * @param inviter
     * @param customerId
     * @return
     */
    @RequestMapping(value = "customerAssetExport")
    @ResponseBody
    public Map<String, Object> customerAssetExport(HttpServletResponse response,Integer nodeId, Integer inviter, Integer customerId) {
        list = cfdBizService.findCustomerAssetList(0,Integer.MAX_VALUE,nodeId,inviter,customerId);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("cfdCustomerAsset");
            String dist = ExcelUtil.export(excelTable, list, "cfdCustomerAsset_ColumnName", "cfdCustomerAsset_Keys");
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


}
