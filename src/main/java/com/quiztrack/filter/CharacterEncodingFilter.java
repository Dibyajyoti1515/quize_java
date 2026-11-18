package com.quiztrack.filter;

import jakarta.servlet.*;
import java.io.IOException;

/**
 * Ensures all HTTP requests and responses use UTF-8 character encoding.
 * Configured canonically in web.xml (B14).
 */
public class CharacterEncodingFilter implements Filter {

    private static final String ENCODING = "UTF-8";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(ENCODING);
        response.setCharacterEncoding(ENCODING);
        chain.doFilter(request, response);
    }
}
