
package com.shop.admin.controller.robot;

import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.RobotConfigService;
import com.mine.common.constants.Constants;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.robot.RobotConfigVo;
import com.mine.common.vo.quote.SymbolDetailBizVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.mine.util.date.DateTools.dateToString;
import static com.mine.util.date.DateTools.getEndOfDate;
import static com.mine.util.date.DateTools.getStartDate;


/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class RobotController extends BaseController {

    private static Log logger = LogFactory.getLog(RobotController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private RobotConfigService robotConfigService;

    @Autowired
    private CurrencyService currencyService;

    /**
     * 机器人配置页面
     */
    @RequestMapping(value = "robotConfig/index")
    @OperatorLogger(operatorName = "进入机器人配置")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("robot/robotConfig");
        return mv;
    }

    /***
     * 机器人配置列表
     *
     * @return
     */
    @RequestMapping(value = "robotConfig/list")
    @OperatorLogger(operatorName = "机器人配置列表")
    @ResponseBody
    public Response list(Date startDate, Date endDate,Integer limit, Integer offset) {
        total = (int) robotConfigService.getCount(startDate,endDate);
        List<RobotConfigVo> robotConfigVo = new ArrayList<>();
        if (total > 0) {
            robotConfigVo = robotConfigService.listAll(startDate, endDate,getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, robotConfigVo, "成功");
    }

    /**
     * 新增机器人配置页面
     *
     * @return
     */
    @RequestMapping(value = "robotConfig/addInput")
    @OperatorLogger(operatorName = "进入添加机器人配置页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("robot/robotConfig_add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    @RequestMapping(value = "robotConfig/add")
    @OperatorLogger(operatorName = "添加机器人价格配置")
    @ResponseBody
    public Map<String, Object> add(RobotConfigVo robotConfigVo) {
        try {
            Integer currencyId = currencyService.getCurrencyBySymbol(robotConfigVo.getSymbol()).getId();
            Integer today = (int)robotConfigService.getByToday(currencyId);
            if(today>0){
                result = false;
                message = messageSource.getMessage("今日该币种已设置价格");
            }else if(robotConfigVo.getUnitPrice().signum()<0){
                result = false;
                message = messageSource.getMessage("币种价格不能为负数");
            }else{
                robotConfigVo.setCurrencyId(currencyId);
                robotConfigVo.setNumber(robotConfigService.getRobotNumber(currencyId));
                robotConfigService.add(robotConfigVo);
                result = true;
                message = messageSource.getMessage("add.success");
            }
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("add.failed");
        }
        return getResultMap();
    }

    /**
     * 删除奖励发放记录
     * @param
     * @return
     */
    /*@ResponseBody
    @RequestMapping("award/deleteAwardGrant")
    @OperatorLogger(operatorName = "删除奖励发放记录")
    public Map<String, Object> deleteAwardGrant(Integer id) {
        try {
            AwardVo awardVo = awardService.getById(id);
            awardService.deledeleteAwardGrant(awardVo);
            result = true;
        } catch (Exception e) {
            logger.error("删除奖励发放记录未知错误", e);
            result = false;
        }
        message = result ? "删除成功" : "删除失败";
        return getResultMap();
    }*/


    /**
     * 机器人盈亏统计页面
     */
    @RequestMapping(value = "robotConfig/robotProfitTotalIndex")
    @OperatorLogger(operatorName = "进入机器人盈亏统计页面")
    public ModelAndView robotProfitTotalIndex() {
        ModelAndView mv = new ModelAndView("robot/robotProfitTotal");
        List<Map<String, Object>> robotConfigVos = robotConfigService.listPriceDate();
        mv.addObject("robotConfigVos", robotConfigVos);
        return mv;
    }

    /***
     * 机器人盈亏统计列表
     *
     * @return
     */
    @RequestMapping(value = "robotConfig/robotProfitTotalList")
    @OperatorLogger(operatorName = "查看机器人盈亏统计列表")
    @ResponseBody
    public Response robotProfitTotalList(Date priceDate,Integer limit, Integer offset) {
        List<RobotConfigVo> robotConfigVo = new ArrayList<>();
        if(priceDate!=null){
            //获取初始机器人信息
            robotConfigVo = robotConfigService.listAll(getStartDate(priceDate), getEndOfDate(priceDate),getOffset(offset), getLimit(limit));
            for (int i =0;i<robotConfigVo.size();i++){
                //初始金额
                robotConfigVo.get(i).setAmount(robotConfigVo.get(i).getNumber().multiply(robotConfigVo.get(i).getUnitPrice()));
                //当前数量
                robotConfigVo.get(i).setNowNumber(robotConfigService.getRobotNumber(robotConfigVo.get(i).getCurrencyId()));
                //当前价格
                robotConfigVo.get(i).setNowUnitPrice(currencyService.getPriceBySymbol(robotConfigVo.get(i).getSymbol()));
                //当前金额
                robotConfigVo.get(i).setNowAmount(robotConfigVo.get(i).getNowNumber().multiply(robotConfigVo.get(i).getNowUnitPrice()));
                //币种盈亏量
                robotConfigVo.get(i).setSymbolProfit(robotConfigVo.get(i).getNowNumber().subtract(robotConfigVo.get(i).getNumber()));
                //初始价计盈亏
                robotConfigVo.get(i).setInitProfit(robotConfigVo.get(i).getSymbolProfit().multiply(robotConfigVo.get(i).getUnitPrice()));
                //当前价计盈亏
                robotConfigVo.get(i).setNowProfit(robotConfigVo.get(i).getSymbolProfit().multiply(robotConfigVo.get(i).getNowUnitPrice()));
                //自然盈亏
                robotConfigVo.get(i).setNaturalProfit((robotConfigVo.get(i).getNowUnitPrice().subtract(robotConfigVo.get(i).getUnitPrice())).multiply(robotConfigVo.get(i).getNumber()));
                //净盈亏
                robotConfigVo.get(i).setProfit(robotConfigVo.get(i).getNowAmount().subtract(robotConfigVo.get(i).getAmount()));
            }
        }
        return Response.listSuccess(robotConfigVo.size(), robotConfigVo, "成功");
    }

    @ResponseBody
    @RequestMapping("robotConfig/robotProfitTotalInfo")
    @OperatorLogger(operatorName = "查看机器人盈亏统计信息")
    public Map<String, Object> total(Date priceDate) {
        try {
            List<Map<String, Object>> robotTotalInof = new ArrayList<>();
            if(priceDate!=null){
                List<RobotConfigVo> robotConfigVo = new ArrayList<>();
                //获取初始机器人信息
                robotConfigVo = robotConfigService.listAll(getStartDate(priceDate), getEndOfDate(priceDate));
                //初始金额统计
                BigDecimal initAmountTotal = BigDecimal.ZERO;
                //当前金额统计
                BigDecimal nowAmountTotal = BigDecimal.ZERO;
                //初始价计盈亏统计
                BigDecimal initProfitTotal = BigDecimal.ZERO;
                //当前价计盈亏统计
                BigDecimal nowProfitTotal = BigDecimal.ZERO;
                //自然盈亏统计
                BigDecimal naturalProfitTotal = BigDecimal.ZERO;
                //净盈亏统计
                BigDecimal profitTotal = BigDecimal.ZERO;
                for (int i =0;i<robotConfigVo.size();i++){
                    //初始金额
                    robotConfigVo.get(i).setAmount(robotConfigVo.get(i).getNumber().multiply(robotConfigVo.get(i).getUnitPrice()));
                    //当前数量
                    robotConfigVo.get(i).setNowNumber(robotConfigService.getRobotNumber(robotConfigVo.get(i).getCurrencyId()));
                    //当前价格
                    robotConfigVo.get(i).setNowUnitPrice(currencyService.getPriceBySymbol(robotConfigVo.get(i).getSymbol()));
                    //当前金额
                    robotConfigVo.get(i).setNowAmount(robotConfigVo.get(i).getNowNumber().multiply(robotConfigVo.get(i).getNowUnitPrice()));
                    //币种盈亏量
                    robotConfigVo.get(i).setSymbolProfit(robotConfigVo.get(i).getNowNumber().subtract(robotConfigVo.get(i).getNumber()));
                    //初始价计盈亏
                    robotConfigVo.get(i).setInitProfit(robotConfigVo.get(i).getSymbolProfit().multiply(robotConfigVo.get(i).getUnitPrice()));
                    //当前价计盈亏
                    robotConfigVo.get(i).setNowProfit(robotConfigVo.get(i).getSymbolProfit().multiply(robotConfigVo.get(i).getNowUnitPrice()));
                    //自然盈亏
                    robotConfigVo.get(i).setNaturalProfit((robotConfigVo.get(i).getNowUnitPrice().subtract(robotConfigVo.get(i).getUnitPrice())).multiply(robotConfigVo.get(i).getNumber()));
                    //净盈亏
                    robotConfigVo.get(i).setProfit(robotConfigVo.get(i).getNowAmount().subtract(robotConfigVo.get(i).getAmount()));

                    //初始金额累加
                    initAmountTotal = initAmountTotal.add(robotConfigVo.get(i).getAmount());
                    //当前金额累加
                    nowAmountTotal = nowAmountTotal.add(robotConfigVo.get(i).getNowAmount());
                    //初始价计盈亏累加
                    initProfitTotal = initProfitTotal.add(robotConfigVo.get(i).getInitProfit());
                    //当前价计盈亏累加
                    nowProfitTotal = nowProfitTotal.add(robotConfigVo.get(i).getNowProfit());
                    //自然盈亏累加
                    naturalProfitTotal = naturalProfitTotal.add(robotConfigVo.get(i).getNaturalProfit());
                    //净盈亏累加
                    profitTotal = profitTotal.add(robotConfigVo.get(i).getProfit());

                }
                //初始价计盈亏统计百分比
                BigDecimal initProfitTotalP = initProfitTotal.divide(initAmountTotal,2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100"));
                //当前价计盈亏统计百分比
                BigDecimal nowProfitTotalP = nowProfitTotal.divide(initAmountTotal,2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100"));
                //自然盈亏统计百分比
                BigDecimal naturalProfitTotalP = naturalProfitTotal.divide(initAmountTotal,2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100"));
                //净盈亏统计百分比
                BigDecimal profitTotalP = profitTotal.divide(initAmountTotal,2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100"));
                Map map = new HashMap();
                map.put("initAmountTotal",initAmountTotal);
                map.put("nowAmountTotal",nowAmountTotal);
                map.put("initProfitTotal",initProfitTotal);
                map.put("nowProfitTotal",nowProfitTotal);
                map.put("naturalProfitTotal",naturalProfitTotal);
                map.put("profitTotal",profitTotal);
                map.put("initProfitTotalP",initProfitTotalP);
                map.put("nowProfitTotalP",nowProfitTotalP);
                map.put("naturalProfitTotalP",naturalProfitTotalP);
                map.put("profitTotalP",profitTotalP);
                robotTotalInof.add(map);
            }
            list = robotTotalInof;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        return getResultMap();
    }

    /**
     * 机器人交易量统计页面
     */
    @RequestMapping(value = "robotConfig/robotVolumeTotalIndex")
    @OperatorLogger(operatorName = "进入机器人配置")
    public ModelAndView robotVolumeTotalIndex() {
        ModelAndView mv = new ModelAndView("robot/robotVolumeTotal");
        return mv;
    }

    /***
     * 机器人交易量统计列表
     *
     * @return
     */
    @RequestMapping(value = "robotConfig/robotVolumeTotalList")
    @OperatorLogger(operatorName = "机器人交易量统计列表")
    @ResponseBody
    public Response robotVolumeTotalList(Date startDate, Date endDate,Integer limit, Integer offset) {
        total = robotConfigService.getRobotVolumeCount(startDate,endDate);
        List<Map<String, Object>> list = new ArrayList<>();
        list=robotConfigService.getRobotVolume(startDate,endDate,getOffset(offset), getLimit(limit));
        BigDecimal allAmount = BigDecimal.ZERO;
        BigDecimal buyAmount = BigDecimal.ZERO;
        BigDecimal sellAmount = BigDecimal.ZERO;
        BigDecimal robotAmount = BigDecimal.ZERO;
        BigDecimal robotCustomerAmount = BigDecimal.ZERO;
        BigDecimal customerAmount = BigDecimal.ZERO;
        BigDecimal price = BigDecimal.ZERO;
        for (int i=0;i<list.size();i++){
            //0E-18转换为0
            buyAmount = (BigDecimal) list.get(i).get("buyAmount");
            if(buyAmount.compareTo(BigDecimal.ZERO) == 0){
                buyAmount = BigDecimal.ZERO;
            }
            sellAmount = (BigDecimal) list.get(i).get("sellAmount");
            if(sellAmount.compareTo(BigDecimal.ZERO) == 0){
                sellAmount = BigDecimal.ZERO;
            }
            robotAmount = buyAmount.compareTo(sellAmount)>=0?sellAmount:buyAmount;
            robotCustomerAmount = buyAmount.compareTo(sellAmount)>=0?buyAmount.subtract(sellAmount):sellAmount.subtract(buyAmount);
            allAmount = (BigDecimal) list.get(i).get("allAmount");
            if(allAmount.compareTo(BigDecimal.ZERO) == 0){
                allAmount = BigDecimal.ZERO;
            }
            customerAmount = allAmount.subtract(robotAmount).subtract(robotCustomerAmount);
            //机器人&机器人成交量
            list.get(i).put("robotAmount",robotAmount);
            //用户&用户成交量
            list.get(i).put("customerAmount",customerAmount);
            //机器人&用 户成交量
            list.get(i).put("robotCustomerAmount",robotCustomerAmount);
            //单价
            String currency = StringUtils.substringBefore(list.get(i).get("symbol").toString(),"/");
            price = currencyService.getPriceBySymbol(currency);
            list.get(i).put("price",price);
            //机器人&机器人成交额
            list.get(i).put("robotTurnover",robotAmount.multiply(price));
            //用户&用户成交额
            list.get(i).put("customerTurnover",customerAmount.multiply(price));
            //机器人&用户成交额
            list.get(i).put("robotCustomerTurnover",robotCustomerAmount.multiply(price));
            list.get(i).put("allTurnover",((BigDecimal) list.get(i).get("allAmount")).multiply(price));
        }
        return Response.listSuccess(total, list, "成功");
    }
}