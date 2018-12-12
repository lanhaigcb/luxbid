package com.shop.utils.string;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


/**
 * 自定义字符串工具
 */
public class StringUtils {

	public static final String SPLIT_COMMA = ",";

	public static boolean isEmpty(String string) {
		return org.apache.commons.lang3.StringUtils.isEmpty(string);
	}

	public static String replaceBlank(String str) {
		String dest = "";
		if (!isEmpty(str)) {
//            Pattern p = Pattern.compile("\\s*|\t|\r|\n");
//            Matcher m = p.matcher(str);
//            dest = m.replaceAll("");
			str = str.replaceAll("\\r", "").replaceAll("\\n", "").replaceAll("\\t", "").replaceAll("\"", "'");
			return str;
		}
		return dest;
	}

	public static String idCardDeal(String idCard) {
		if (isEmpty(idCard)) {
			return null;
		}
		int flag = 3;
		if(idCard.length()<6){
			flag = idCard.length()/2;
		}

		String start = idCard.substring(0, flag);
		String end = idCard.substring(idCard.length() - flag);
		return start + "****" + end;
	}

	public static String bankCardDeal(String bankCard) {
		if (isEmpty(bankCard)) {
			return null;
		}
		String end = bankCard.substring(bankCard.length() - 4);
		return end;
	}


	public static List<String> split(String str, String pattern) {

		if (isEmpty(str)) {
			return null;
		}

		String[] strArray = str.split(pattern);

		if (str.isEmpty()) {
			return null;
		}
		List<String> result = new ArrayList<String>();
		for (String string : strArray) {
			result.add(string);
		}
		return result;
	}

	/**
	 * @param src
	 * @param jiancount    从后面数第几位 开始银行卡替换为星号
	 * @param replacecount 后面留 4位
	 * @return
	 */
	public static String replaceCard(String src, int jiancount, int replacecount) {
		if (!isEmpty(src)) {
			StringBuilder resultBuilder = new StringBuilder();
			if (src.length() <= jiancount) {
				return src;
			}
			String part1 = src.substring(0, src.length() - jiancount);
			String part2 = src.substring(src.length() - replacecount, src.length());
			resultBuilder.append(part1);
			resultBuilder.append("****");
			resultBuilder.append(part2);
			return resultBuilder.toString();
		} else {
			return "";
		}

	}

	/**
	 * @param src
	 * @param jiancount    从后面数第几位 开始替换手机号为星号
	 * @param replacecount 替换后面留 3位
	 * @return
	 */
	public static String replaceMobile(String src, int jiancount, int replacecount) {

//        return src;
		if (!isEmpty(src)) {
			if (src.length() <= jiancount) {
				return src;
			}
			StringBuilder resultBuilder = new StringBuilder();
			String part1 = src.substring(0, src.length() - jiancount);
			String part2 = src.substring(src.length() - replacecount, src.length());
			resultBuilder.append(part1);
			resultBuilder.append("*****");
			resultBuilder.append(part2);
			return resultBuilder.toString();
		} else {
			return "";
		}
	}


	public static String replaceMobile(String mobile) {
		if (isEmpty(mobile)){
			return null;
		}
		return mobile.replaceAll("(\\d{3})\\d{4}(\\d{4})", "$1****$2");
	}

	/**
	 * @param src
	 * @param jiancount    从后面数第几位 开始替换身份证号为星号
	 * @param replacecount 替换后面留 3位
	 * @return
	 */
	public static String replaceIdCard(String src, int jiancount, int replacecount) {
		if (!isEmpty(src)) {

			if (src.length() <= jiancount) {
				return src;
			}
			StringBuilder resultBuilder = new StringBuilder();
			String part1 = src.substring(0, src.length() - jiancount);
			String part2 = src.substring(src.length() - replacecount, src.length());
			resultBuilder.append(part1);
			resultBuilder.append("*******");
			resultBuilder.append(part2);
			return resultBuilder.toString();
		} else {
			return "";
		}

	}

	public static String replaceIdCard(String idCard){
		return idCard.replaceAll("(\\d{4})\\d{10}(\\d{4})","$1****$2");
	}

	public static void main(String[] args) {

	}

	public static String replaceName(String name) {
		if (!isEmpty(name) && name.length() > 1) {
			name = "*" + name.substring(1, name.length());
		}
		return name;
	}

	/**
	 * 判断数组是否有重复元素
	 *
	 * @param array
	 * @return
	 */
	public static boolean checkRepeatArray(String[] array) {
		Set<String> set = new HashSet<String>();
		for (String str : array) {
			set.add(str);
		}
		if (set.size() != array.length) {
			return false;//有重复
		} else {
			return true;//不重复
		}
	}

	/**
	 * 判断数组是否有重复元素
	 *
	 * @param array
	 * @return
	 */
	public static String[] iniStringArray(String[] array, String value) {
		for (int i = 0; i < array.length; i++) {
			array[i] = value;
		}
		return array;
	}


	public static String mobileFormartAnonymous3t8(String mobile) {

		if (null == mobile) {
			return null;
		}

		if (!StringUtils.isEmpty(mobile)) {
			String prefix = mobile.substring(0, 3);
			String suffix = mobile.substring(8);
			return prefix + "*****" + suffix;
		}

		return "*****";
	}


	public static String[] stringsPingPrefix(String[] arr, String prefix) {

		String[] strings = new String[arr.length];
		for (int i = 0; i < arr.length; i++) {
			strings[i] = prefix + arr[i];
		}

		return strings;
	}

	// 替换邀请码和娃娃名
	public static String replaceInviteCodeAndName(String content, String code, String toyName) {
		String temp = content.replaceAll("\\{inviteCode\\}", code);
		temp = temp.replaceAll("\\{toyName\\}", toyName);
		return temp;
	}


	public static String replaceEmail(String email) {
		if (isEmpty(email)){
			return null;
		}
		//只显示@前面的首位和末位
		return email.replaceAll("(\\w?)(\\w+)(\\w)(@\\w+\\.[a-z]+(\\.[a-z]+)?)", "$1****$3$4");

	}

}
