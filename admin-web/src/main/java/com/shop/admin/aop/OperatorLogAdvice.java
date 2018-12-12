package com.shop.admin.aop;

import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.mine.util.ip.IPUtil;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Arrays;

/**
 */
public class OperatorLogAdvice {

    private static Logger logger = LoggerFactory.getLogger(OperatorLogAdvice.class);

//    @Autowired
//    private OperatorLogService operatorLogService;


    public void writeLogInfo(JoinPoint joinPoint) throws Exception,
            IllegalAccessException {

        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes()).getRequest();

        Staff staff = SecurityUtil.currentLogin();


        Object target = joinPoint.getTarget();
        String methodName = joinPoint.getSignature().getName();

        Class[] parameterTypes = ((MethodSignature) joinPoint.getSignature()).getMethod().getParameterTypes();

        Method method = target.getClass().getMethod(methodName, parameterTypes);

        OperatorLogger operatorLogger = method.getAnnotation(OperatorLogger.class);


        String actionName = joinPoint.getSignature().getDeclaringTypeName();

        String content = Arrays.toString(joinPoint.getArgs());
        content = actionName + "." + methodName + ":" + content;
        String ip = IPUtil.getRemoteIPAddress(request) + "(" + IPUtil.getLocalIp(request) + ")";

        //记录日志后台用户{}，在【{}】操作【{}】详细信息【{}】,
        if (null != operatorLogger) {
//            operatorLogService.addOperatorLog(operatorLogger.operatorName(), content, ip, staff);
        }

    }
}
