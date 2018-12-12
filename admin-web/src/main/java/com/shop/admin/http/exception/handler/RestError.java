/*
 * Copyright 2012 Stormpath, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.shop.admin.http.exception.handler;

import com.mine.common.response.CommonResponseCode;
import org.springframework.util.ObjectUtils;

/**
 * @author Les Hazlewood
 */
public class RestError {

    private final CommonResponseCode gmResponseCode;
    private final String message;
    private final String developerMessage;
    private final String moreInfoUrl;
    private final Throwable throwable;

    public RestError(CommonResponseCode gmResponseCode, String message, String developerMessage, String moreInfoUrl, Throwable throwable) {
        if (gmResponseCode == null) {
            throw new NullPointerException("gmResponseCode argument cannot be null.");
        }
        this.gmResponseCode = gmResponseCode;
        this.message = message;
        this.developerMessage = developerMessage;
        this.moreInfoUrl = moreInfoUrl;
        this.throwable = throwable;
    }

    public CommonResponseCode getGmResponseCode() {
        return gmResponseCode;
    }

    public String getMessage() {
        return message;
    }

    public String getDeveloperMessage() {
        return developerMessage;
    }

    public String getMoreInfoUrl() {
        return moreInfoUrl;
    }

    public Throwable getThrowable() {
        return throwable;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o instanceof RestError) {
            RestError re = (RestError) o;
            return ObjectUtils.nullSafeEquals(getGmResponseCode(), re.getGmResponseCode()) &&
                    ObjectUtils.nullSafeEquals(getMessage(), re.getMessage()) &&
                    ObjectUtils.nullSafeEquals(getDeveloperMessage(), re.getDeveloperMessage()) &&
                    ObjectUtils.nullSafeEquals(getMoreInfoUrl(), re.getMoreInfoUrl()) &&
                    ObjectUtils.nullSafeEquals(getThrowable(), re.getThrowable());
        }

        return false;
    }

    @Override
    public int hashCode() {
        //noinspection ThrowableResultOfMethodCallIgnored
        return ObjectUtils.nullSafeHashCode(new Object[]{
                getGmResponseCode(), getMessage(), getDeveloperMessage(), getMoreInfoUrl(), getThrowable()
        });
    }

    public String toString() {
        //noinspection StringBufferReplaceableByString
        return new StringBuilder().append(getGmResponseCode().code())
                .append(" (").append(getGmResponseCode()).append(" )")
                .toString();
    }

    public static class Builder {

        private CommonResponseCode gmResponseCode;
        private String message;
        private String developerMessage;
        private String moreInfoUrl;
        private Throwable throwable;

        public Builder() {
        }

        public Builder setResponseCode(int statusCode) {
            this.gmResponseCode = CommonResponseCode.fromInt(statusCode);
            return this;
        }

        public Builder setResponseCode(CommonResponseCode status) {
            this.gmResponseCode = status;
            return this;
        }

        public Builder setMessage(String message) {
            this.message = message;
            return this;
        }

        public Builder setDeveloperMessage(String developerMessage) {
            this.developerMessage = developerMessage;
            return this;
        }

        public Builder setMoreInfoUrl(String moreInfoUrl) {
            this.moreInfoUrl = moreInfoUrl;
            return this;
        }

        public Builder setThrowable(Throwable throwable) {
            this.throwable = throwable;
            return this;
        }

        public RestError build() {
            if (this.gmResponseCode == null) {
                this.gmResponseCode = CommonResponseCode.COMMON_SERVER_ERROR;
            }
            return new RestError(this.gmResponseCode, this.message, this.developerMessage, this.moreInfoUrl, this.throwable);
        }
    }
}