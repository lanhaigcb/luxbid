package com.shop.admin.controller;

import com.google.common.collect.Lists;
import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.shop.admin.plugin.DefaultDateEditor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 基础的controller
 */
@ControllerAdvice
public class BaseController {
    private static final Logger logger = LoggerFactory.getLogger(BaseController.class);

    public static final String REQUEST_SCOPE = "prototype";

    protected Integer total;

    protected String message = "成功";

    protected List<?> list = Lists.newArrayList();
    protected boolean result;
    private Map<String, Object> resultMap;

    public int getFrom(Integer page, Integer rows) {
        return null == page ? 0 : getPageSize(rows) * (page - 1);
    }

    public int getPageSize(Integer rows) {
        return null == rows ? 10 : rows;
    }

    public int getOffset(Integer offset) { return null == offset ? 0 : offset; }

    public int getLimit(Integer limit) {
        return null == limit ? 10 : limit;
    }

    public Map<String, Object> getResultMap() {
        if (null == resultMap) {
            resultMap = new HashMap<String, Object>();
        }
        resultMap.put("total", total);
        resultMap.put("rows", list);
        resultMap.put("result", result);
        resultMap.put("message", message);
        return resultMap;
    }

    public void addResultMap(String key, Object value) {
        if (null == resultMap) {
            resultMap = new HashMap<String, Object>();
        }
        resultMap.put(key, value);
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Date.class, new DefaultDateEditor());//true:允许输入空值，false:不能为空值
    }

    @ExceptionHandler
    @ResponseBody
    public Object exceptionHandler(HttpServletRequest req, Exception e) {
        logger.error(e.getMessage(), e);
        return Response.responseWithCode(CommonResponseCode.HOME_COMMON_ERROR.code(),
                CommonResponseCode.HOME_COMMON_ERROR.getInfo());
    }
}

	