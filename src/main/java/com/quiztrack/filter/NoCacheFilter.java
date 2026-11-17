package com.quiztrack.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Prevents client-side caching on sensitive student, teacher, and admin console pages.
 * Ensures the browser 'Back' button cannot be used to view confidential exam or proctor data after logout.
 */
@WebFilter(filterName = "NoCacheFilter", urlPatterns = {"/admin/*", "/teacher/*", "/student/*", "/api/*"})
public class NoCacheFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, max-age=0");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
        }
        chain.doFilter(request, response);
    }
}
