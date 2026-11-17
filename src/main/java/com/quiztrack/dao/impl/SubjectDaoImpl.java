package com.quiztrack.dao.impl;

import com.quiztrack.dao.SubjectDao;
import com.quiztrack.model.Subject;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation of SubjectDao.
 */
public class SubjectDaoImpl implements SubjectDao {

    private static final Logger logger = LoggerFactory.getLogger(SubjectDaoImpl.class);

    @Override
    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT subject_id, subject_code, subject_name, department, description, created_by, created_at FROM subjects ORDER BY subject_code ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subject s = new Subject();
                s.setSubjectId(rs.getInt("subject_id"));
                s.setSubjectCode(rs.getString("subject_code"));
                s.setSubjectName(rs.getString("subject_name"));
                s.setDepartment(rs.getString("department"));
                s.setDescription(rs.getString("description"));
                s.setCreatedBy(rs.getInt("created_by"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (SQLException e) {
            logger.error("Error retrieving all subjects", e);
        }
        return list;
    }

    @Override
    public Optional<Subject> findById(int subjectId) {
        String sql = "SELECT subject_id, subject_code, subject_name, department, description, created_by, created_at FROM subjects WHERE subject_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject s = new Subject();
                    s.setSubjectId(rs.getInt("subject_id"));
                    s.setSubjectCode(rs.getString("subject_code"));
                    s.setSubjectName(rs.getString("subject_name"));
                    s.setDepartment(rs.getString("department"));
                    s.setDescription(rs.getString("description"));
                    s.setCreatedBy(rs.getInt("created_by"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    return Optional.of(s);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving subject by ID: {}", subjectId, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Subject> findByCode(String subjectCode) {
        String sql = "SELECT subject_id, subject_code, subject_name, department, description, created_by, created_at FROM subjects WHERE subject_code = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subjectCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject s = new Subject();
                    s.setSubjectId(rs.getInt("subject_id"));
                    s.setSubjectCode(rs.getString("subject_code"));
                    s.setSubjectName(rs.getString("subject_name"));
                    s.setDepartment(rs.getString("department"));
                    s.setDescription(rs.getString("description"));
                    s.setCreatedBy(rs.getInt("created_by"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    return Optional.of(s);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving subject by Code: {}", subjectCode, e);
        }
        return Optional.empty();
    }
}
