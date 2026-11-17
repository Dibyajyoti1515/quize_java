package com.quiztrack.dao;

import com.quiztrack.model.Subject;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for Academic Subjects.
 */
public interface SubjectDao {

    List<Subject> findAll();

    Optional<Subject> findById(int subjectId);

    Optional<Subject> findByCode(String subjectCode);
}
