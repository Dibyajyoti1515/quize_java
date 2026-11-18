package com.quiztrack;

import com.quiztrack.dao.ExamDao;
import com.quiztrack.dao.QuestionDao;
import com.quiztrack.dao.QuizAssignmentDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.StudentDao;
import com.quiztrack.dao.SubjectDao;
import com.quiztrack.dao.impl.ExamDaoImpl;
import com.quiztrack.dao.impl.QuestionDaoImpl;
import com.quiztrack.dao.impl.QuizAssignmentDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.dao.impl.StudentDaoImpl;
import com.quiztrack.dao.impl.SubjectDaoImpl;
import com.quiztrack.model.Cohort;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.QuizAssignment;
import com.quiztrack.model.StudentDashboardData.StudentQuizCard;
import com.quiztrack.model.Subject;
import com.quiztrack.model.User;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.TeacherServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class TeacherQuizCreationTest {

    private static QuizDao quizDao;
    private static QuestionDao questionDao;
    private static SubjectDao subjectDao;
    private static QuizAssignmentDao quizAssignmentDao;
    private static StudentDao studentDao;
    private static ExamDao examDao;
    private static TeacherService teacherService;

    private static final int TEACHER_RONALD_ID = 2; // Ronald Vance
    private static final int TEACHER_ALISTAIR_ID = 3; // Dr. Alistair Finch (Unrelated teacher)
    private static int createdQuizId = 0;
    private static int createdQuestionId = 0;
    private static int duplicatedQuestionId = 0;

    @BeforeAll
    public static void setUp() {
        quizDao = new QuizDaoImpl();
        questionDao = new QuestionDaoImpl();
        subjectDao = new SubjectDaoImpl();
        quizAssignmentDao = new QuizAssignmentDaoImpl();
        studentDao = new StudentDaoImpl();
        examDao = new ExamDaoImpl();
        teacherService = new TeacherServiceImpl(quizDao, questionDao, subjectDao);
    }

    @AfterAll
    public static void tearDown() {
        // Clean up any remaining test quiz if not already deleted
        if (createdQuizId > 0) {
            try {
                teacherService.deleteQuiz(createdQuizId, TEACHER_RONALD_ID);
            } catch (Exception ignored) {}
        }
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: SubjectDao retrieves active subjects")
    public void testGetAllSubjects() {
        List<Subject> subjects = teacherService.getAllSubjects();
        assertNotNull(subjects, "Subjects list should not be null");
        assertTrue(subjects.size() >= 3, "There should be at least 3 subjects in database");

        boolean hasCS402 = subjects.stream().anyMatch(s -> "CS402".equalsIgnoreCase(s.getSubjectCode()));
        assertTrue(hasCS402, "CS402 should be in the subjects list");
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: TeacherService creates a new Quiz with parameters")
    public void testCreateQuiz() {
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Diagnostic Assessment on Cache Coherence");
        quiz.setDescription("Evaluation covering MESI, directory-based protocols, and memory bus snoop latency.");
        quiz.setSubjectId(1); // CS402
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(45);
        quiz.setTotalMarks(new BigDecimal("20.00"));
        quiz.setPassPercentage(new BigDecimal("60.00"));
        quiz.setNegativeMarking(true);
        quiz.setNegativeMarkValue(new BigDecimal("0.50"));
        quiz.setMaxTabSwitches(3);
        quiz.setFullscreenRequired(true);
        quiz.setWebcamRequired(true);
        quiz.setShuffleQuestions(true);
        quiz.setStatus("DRAFT");

        Quiz created = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(created, "Created quiz must not be null");
        assertTrue(created.getQuizId() > 0, "Created quiz must have generated ID");
        createdQuizId = created.getQuizId();

        assertEquals("DRAFT", created.getStatus());
        assertTrue(created.isNegativeMarking());
        assertEquals(new BigDecimal("0.50"), created.getNegativeMarkValue());
        assertTrue(created.isFullscreenRequired());
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Fetch and Update Quiz parameters")
    public void testUpdateQuiz() {
        assertTrue(createdQuizId > 0, "Quiz ID must be valid");
        Optional<Quiz> fetchedOpt = teacherService.getQuizById(createdQuizId);
        assertTrue(fetchedOpt.isPresent(), "Quiz must be found in DB");

        Quiz q = fetchedOpt.get();
        q.setTitle("CS402: Diagnostic Assessment on Cache Coherence (Revised)");
        q.setDurationMinutes(50);
        q.setPassPercentage(new BigDecimal("65.00"));

        boolean updated = teacherService.updateQuiz(q, TEACHER_RONALD_ID);
        assertTrue(updated, "Quiz update must succeed for owner");

        Optional<Quiz> recheckOpt = teacherService.getQuizById(createdQuizId);
        assertTrue(recheckOpt.isPresent());
        assertEquals("CS402: Diagnostic Assessment on Cache Coherence (Revised)", recheckOpt.get().getTitle());
        assertEquals(50, recheckOpt.get().getDurationMinutes());
        assertEquals(new BigDecimal("65.00"), recheckOpt.get().getPassPercentage());
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Create Question with 4 options and mark correct answer")
    public void testCreateQuestionWithOptions() {
        Question question = new Question();
        question.setQuizId(createdQuizId);
        question.setSubjectId(1);
        question.setQuestionText("In the MESI cache coherence protocol, what does the 'E' state stand for?");
        question.setQuestionType("SINGLE_CHOICE");
        question.setPoints(new BigDecimal("4.00"));
        question.setNegativeMarks(new BigDecimal("0.50"));
        question.setDifficultyLevel("HARD");
        question.setTaxonomyTopic("Cache Coherence Protocols");
        question.setExplanation("E stands for Exclusive: the line is present only in the current cache and is clean.");

        List<QuestionOption> options = new ArrayList<>();
        options.add(new QuestionOption("A", "Evicted", false, 1));
        options.add(new QuestionOption("B", "Exclusive", true, 2));
        options.add(new QuestionOption("C", "Extended", false, 3));
        options.add(new QuestionOption("D", "Ephemeral", false, 4));
        question.setOptions(options);

        Question created = teacherService.createQuestion(question, TEACHER_RONALD_ID);
        assertNotNull(created, "Created question must not be null");
        assertTrue(created.getQuestionId() > 0, "Created question must have a valid ID");
        createdQuestionId = created.getQuestionId();

        // Verify options were persisted
        Optional<Question> retrievedOpt = teacherService.getQuestionById(createdQuestionId);
        assertTrue(retrievedOpt.isPresent(), "Question must be retrievable");
        Question retrieved = retrievedOpt.get();
        assertEquals(4, retrieved.getOptions().size(), "Question must have 4 options");

        QuestionOption correctOpt = retrieved.getOptions().stream().filter(QuestionOption::isCorrect).findFirst().orElse(null);
        assertNotNull(correctOpt, "Must have a correct option marked");
        assertEquals("B", correctOpt.getOptionLetter());
        assertEquals("Exclusive", correctOpt.getOptionText());
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Retrieve Questions for Quiz")
    public void testGetQuestionsForQuiz() {
        List<Question> questions = teacherService.getQuestionsForQuiz(createdQuizId);
        assertNotNull(questions);
        assertEquals(1, questions.size(), "Should have exactly 1 question in the new quiz");
        assertEquals(createdQuestionId, questions.get(0).getQuestionId());
        assertEquals("HARD", questions.get(0).getDifficultyLevel());
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Duplicate Question within Quiz")
    public void testDuplicateQuestion() {
        int dupId = teacherService.duplicateQuestion(createdQuestionId, createdQuizId, TEACHER_RONALD_ID);
        assertTrue(dupId > 0, "Duplicated question must have valid ID");
        duplicatedQuestionId = dupId;

        Optional<Question> dupOpt = teacherService.getQuestionById(dupId);
        assertTrue(dupOpt.isPresent());
        Question dup = dupOpt.get();
        assertTrue(dup.getQuestionText().contains("(Copy)"), "Duplicated question text must contain '(Copy)'");
        assertEquals(4, dup.getOptions().size(), "Duplicated question must copy all options");

        List<Question> questions = teacherService.getQuestionsForQuiz(createdQuizId);
        assertEquals(2, questions.size(), "Quiz must now have 2 questions");
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Question Bank search and difficulty filtering")
    public void testQuestionBankFiltering() {
        // Query for HARD questions in subject 1 (CS402)
        List<Question> hardQuestions = teacherService.getQuestionBank(1, "HARD", null, null, 10, 0);
        assertNotNull(hardQuestions);
        assertFalse(hardQuestions.isEmpty(), "Should find hard questions in question bank");
        assertTrue(hardQuestions.stream().allMatch(q -> "HARD".equalsIgnoreCase(q.getDifficultyLevel())));

        // Keyword search for "Vector"
        List<Question> searchResults = teacherService.getQuestionBank(null, null, null, "Vector", 10, 0);
        assertNotNull(searchResults);
        assertFalse(searchResults.isEmpty(), "Keyword search for 'Vector' should return matching questions");
        assertTrue(searchResults.stream().anyMatch(q -> q.getQuestionText().contains("Vector") || (q.getExplanation() != null && q.getExplanation().contains("Vector"))));
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Add question from Bank to Quiz and Remove from Quiz via quiz_questions (B2)")
    public void testAddAndRemoveQuestionFromBank() {
        // Find a standalone bank question
        List<Question> bankQuestions = teacherService.getQuestionBank(1, null, null, null, 10, 0);
        assertNotNull(bankQuestions);
        assertFalse(bankQuestions.isEmpty(), "Bank must contain questions");

        int bankQId = bankQuestions.get(0).getQuestionId();

        // Add to our quiz
        boolean added = teacherService.addQuestionToQuiz(bankQId, createdQuizId, TEACHER_RONALD_ID);
        assertTrue(added, "Should successfully link question to quiz");

        assertTrue(questionDao.isQuestionInQuiz(bankQId, createdQuizId), "Question must be present in quiz_questions");
        List<Question> quizQuestions = teacherService.getQuestionsForQuiz(createdQuizId);
        assertTrue(quizQuestions.stream().anyMatch(q -> q.getQuestionId() == bankQId), "Quiz must contain added bank question");

        // Question must still be present in the question bank (not deleted or hijacked!)
        assertTrue(teacherService.getQuestionById(bankQId).isPresent(), "Bank question must still exist in DB");

        // Remove from quiz
        boolean removed = teacherService.removeQuestionFromQuiz(bankQId, createdQuizId, TEACHER_RONALD_ID);
        assertTrue(removed, "Should successfully unlink question from quiz");

        assertFalse(questionDao.isQuestionInQuiz(bankQId, createdQuizId), "Question must not be in quiz_questions after removal");
        List<Question> quizQuestionsAfter = teacherService.getQuestionsForQuiz(createdQuizId);
        assertFalse(quizQuestionsAfter.stream().anyMatch(q -> q.getQuestionId() == bankQId), "Quiz must not contain removed bank question");

        // Question must still exist intact in DB
        Optional<Question> qAfterRemove = teacherService.getQuestionById(bankQId);
        assertTrue(qAfterRemove.isPresent(), "Bank question must remain intact in DB after removal from quiz");
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Ownership Protection - Cross-teacher mutation must fail")
    public void testOwnershipProtection() {
        // Teacher 3 (Alistair Finch) should not be the owner of Ronald's quiz
        boolean isOwner = teacherService.isQuizOwnedBy(createdQuizId, TEACHER_ALISTAIR_ID);
        assertFalse(isOwner, "Dr. Finch should NOT own Ronald Vance's quiz");

        // Dr. Finch attempting to update Ronald's quiz
        Quiz spoofQuiz = new Quiz();
        spoofQuiz.setQuizId(createdQuizId);
        spoofQuiz.setTitle("Hacked Quiz Title");
        spoofQuiz.setDurationMinutes(10);
        spoofQuiz.setTotalMarks(new BigDecimal("100.00"));

        boolean updateResult = teacherService.updateQuiz(spoofQuiz, TEACHER_ALISTAIR_ID);
        assertFalse(updateResult, "Updating another teacher's quiz must fail");

        // Dr. Finch attempting to delete Ronald's quiz
        boolean deleteResult = teacherService.deleteQuiz(createdQuizId, TEACHER_ALISTAIR_ID);
        assertFalse(deleteResult, "Deleting another teacher's quiz must fail");

        // Verify quiz is intact
        Optional<Quiz> intact = teacherService.getQuizById(createdQuizId);
        assertTrue(intact.isPresent());
        assertNotEquals("Hacked Quiz Title", intact.get().getTitle(), "Quiz title must not have changed");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Quiz Status Transitions (Publish & Draft)")
    public void testQuizStatusTransitions() {
        // Publish quiz
        boolean published = teacherService.setQuizStatus(createdQuizId, TEACHER_RONALD_ID, "ACTIVE");
        assertTrue(published, "Publishing quiz must succeed");

        Optional<Quiz> qPub = teacherService.getQuizById(createdQuizId);
        assertTrue(qPub.isPresent());
        assertEquals("ACTIVE", qPub.get().getStatus());

        // Revert to draft
        boolean drafted = teacherService.setQuizStatus(createdQuizId, TEACHER_RONALD_ID, "DRAFT");
        assertTrue(drafted, "Reverting to draft must succeed");

        Optional<Quiz> qDraft = teacherService.getQuizById(createdQuizId);
        assertTrue(qDraft.isPresent());
        assertEquals("DRAFT", qDraft.get().getStatus());
    }

    @Test
    @Order(11)
    @DisplayName("Test 11: Teacher successfully deletes own quiz and associated questions")
    public void testDeleteQuiz() {
        boolean deleted = teacherService.deleteQuiz(createdQuizId, TEACHER_RONALD_ID);
        assertTrue(deleted, "Quiz deletion by owner must succeed");

        Optional<Quiz> deletedOpt = teacherService.getQuizById(createdQuizId);
        assertTrue(deletedOpt.isEmpty(), "Deleted quiz should no longer exist in database");

        // Reset so tearDown doesn't attempt to re-delete
        createdQuizId = 0;
        if (duplicatedQuestionId > 0) {
            try {
                teacherService.deleteQuestion(duplicatedQuestionId, TEACHER_RONALD_ID);
            } catch (Exception ignored) {}
            duplicatedQuestionId = 0;
        }
        if (createdQuestionId > 0) {
            try {
                teacherService.deleteQuestion(createdQuestionId, TEACHER_RONALD_ID);
            } catch (Exception ignored) {}
            createdQuestionId = 0;
        }
    }

    @Test
    @Order(12)
    @DisplayName("Test 12: Validation - Short or blank quiz title rejected")
    public void testValidationShortTitleRejected() {
        Quiz badQuiz = new Quiz();
        badQuiz.setTitle("AB"); // Less than 3 characters
        badQuiz.setSubjectId(1);
        badQuiz.setDurationMinutes(30);

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuiz(badQuiz, TEACHER_RONALD_ID);
        }, "Quiz with title < 3 characters must be rejected");
    }

    @Test
    @Order(13)
    @DisplayName("Test 13: Validation - Duration exceeding max allowed limit rejected")
    public void testValidationExceedingDurationRejected() {
        Quiz badQuiz = new Quiz();
        badQuiz.setTitle("Valid Assessment Title");
        badQuiz.setSubjectId(1);
        badQuiz.setDurationMinutes(999); // Exceeds system max (180)

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuiz(badQuiz, TEACHER_RONALD_ID);
        }, "Duration exceeding system maximum must be rejected");
    }

    @Test
    @Order(14)
    @DisplayName("Test 14: Validation - Scheduled quiz without start or end time rejected")
    public void testValidationScheduledWithoutDatesRejected() {
        Quiz badQuiz = new Quiz();
        badQuiz.setTitle("Scheduled Assessment Without Window");
        badQuiz.setSubjectId(1);
        badQuiz.setDurationMinutes(45);
        badQuiz.setStatus("SCHEDULED");
        // No start_time or end_time

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuiz(badQuiz, TEACHER_RONALD_ID);
        }, "Scheduled quiz without start or end time must be rejected");
    }

    @Test
    @Order(15)
    @DisplayName("Test 15: Validation - Start time after end time rejected; candidate entry window accepted")
    public void testValidationInvalidDateWindowRejected() {
        long now = System.currentTimeMillis();
        Timestamp start = new Timestamp(now + 3600000L); // +1 hour
        Timestamp endBefore = new Timestamp(now + 1800000L); // +30 mins (before start)

        Quiz badQuiz1 = new Quiz();
        badQuiz1.setTitle("Assessment With Backwards Dates");
        badQuiz1.setSubjectId(1);
        badQuiz1.setDurationMinutes(30);
        badQuiz1.setStartTime(start);
        badQuiz1.setEndTime(endBefore);

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuiz(badQuiz1, TEACHER_RONALD_ID);
        }, "Start time after end time must be rejected");

        // Candidate entry window: 10 min entry window for 60 min exam is valid candidate entry window
        Timestamp endShort = new Timestamp(now + 3600000L + 600000L); // +10 min window
        Quiz entryWindowQuiz = new Quiz();
        entryWindowQuiz.setTitle("Assessment With Candidate Entry Window");
        entryWindowQuiz.setSubjectId(1);
        entryWindowQuiz.setDurationMinutes(60); // 60 min exam duration
        entryWindowQuiz.setStartTime(start);
        entryWindowQuiz.setEndTime(endShort); // 10 min entry window

        Quiz createdEntryQuiz = assertDoesNotThrow(() -> {
            return teacherService.createQuiz(entryWindowQuiz, TEACHER_RONALD_ID);
        }, "Candidate entry window shorter than duration must be permitted");
        assertNotNull(createdEntryQuiz);
        assertTrue(createdEntryQuiz.getQuizId() > 0);
        teacherService.deleteQuiz(createdEntryQuiz.getQuizId(), TEACHER_RONALD_ID);
    }

    @Test
    @Order(16)
    @DisplayName("Test 16: Successful creation of a Scheduled Quiz with valid window")
    public void testCreateScheduledQuizWithValidDates() {
        long now = System.currentTimeMillis();
        Timestamp start = new Timestamp(now + 86400000L); // +24 hours
        Timestamp end = new Timestamp(now + 86400000L + 7200000L); // +26 hours (2 hour window)

        Quiz scheduledQuiz = new Quiz();
        scheduledQuiz.setTitle("CS402: Scheduled Final Exam Window");
        scheduledQuiz.setDescription("Covers end-to-end distributed algorithms.");
        scheduledQuiz.setSubjectId(1);
        scheduledQuiz.setTeacherId(TEACHER_RONALD_ID);
        scheduledQuiz.setDurationMinutes(60);
        scheduledQuiz.setTotalMarks(BigDecimal.ZERO);
        scheduledQuiz.setPassPercentage(new BigDecimal("40.00"));
        scheduledQuiz.setStatus("SCHEDULED");
        scheduledQuiz.setStartTime(start);
        scheduledQuiz.setEndTime(end);

        Quiz created = teacherService.createQuiz(scheduledQuiz, TEACHER_RONALD_ID);
        assertNotNull(created, "Scheduled quiz must be created");
        assertTrue(created.getQuizId() > 0);
        assertEquals("SCHEDULED", created.getStatus());
        assertNotNull(created.getStartTime());
        assertNotNull(created.getEndTime());

        // Clean up
        teacherService.deleteQuiz(created.getQuizId(), TEACHER_RONALD_ID);
    }

    @Test
    @Order(17)
    @DisplayName("Test 17: Many-to-many reuse across multiple quizzes via quiz_questions (B2)")
    public void testQuestionSharedAcrossMultipleQuizzes() {
        // Create Quiz A
        Quiz quizA = new Quiz();
        quizA.setTitle("CS402: Quiz Alpha for Reuse Test");
        quizA.setSubjectId(1);
        quizA.setTeacherId(TEACHER_RONALD_ID);
        quizA.setDurationMinutes(30);
        quizA.setStatus("DRAFT");
        Quiz createdA = teacherService.createQuiz(quizA, TEACHER_RONALD_ID);
        assertNotNull(createdA);

        // Create Quiz B
        Quiz quizB = new Quiz();
        quizB.setTitle("CS402: Quiz Beta for Reuse Test");
        quizB.setSubjectId(1);
        quizB.setTeacherId(TEACHER_RONALD_ID);
        quizB.setDurationMinutes(30);
        quizB.setStatus("DRAFT");
        Quiz createdB = teacherService.createQuiz(quizB, TEACHER_RONALD_ID);
        assertNotNull(createdB);

        try {
            // Create a question in the bank (not linked to any quiz initially)
            Question sharedQ = new Question();
            sharedQ.setSubjectId(1);
            sharedQ.setQuestionText("What is the CAP theorem consistency model?");
            sharedQ.setQuestionType("SINGLE_CHOICE");
            sharedQ.setPoints(new BigDecimal("5.00"));
            sharedQ.setDifficultyLevel("MEDIUM");
            sharedQ.setTaxonomyTopic("Distributed Systems");
            sharedQ.addOption(new QuestionOption("A", "Linearizability", true, 1));
            sharedQ.addOption(new QuestionOption("B", "Eventual", false, 2));

            Question createdQ = teacherService.createQuestion(sharedQ, TEACHER_RONALD_ID);
            assertNotNull(createdQ);
            int sharedQId = createdQ.getQuestionId();

            // Link to Quiz A and Quiz B
            boolean addedA = teacherService.addQuestionToQuiz(sharedQId, createdA.getQuizId(), TEACHER_RONALD_ID);
            boolean addedB = teacherService.addQuestionToQuiz(sharedQId, createdB.getQuizId(), TEACHER_RONALD_ID);
            assertTrue(addedA, "Question should link to Quiz A");
            assertTrue(addedB, "Question should link to Quiz B");

            // Verify both quizzes have the question
            assertTrue(questionDao.isQuestionInQuiz(sharedQId, createdA.getQuizId()));
            assertTrue(questionDao.isQuestionInQuiz(sharedQId, createdB.getQuizId()));
            assertEquals(1, questionDao.countQuestionsInQuiz(createdA.getQuizId()));
            assertEquals(1, questionDao.countQuestionsInQuiz(createdB.getQuizId()));

            // Remove from Quiz A only
            boolean removedA = teacherService.removeQuestionFromQuiz(sharedQId, createdA.getQuizId(), TEACHER_RONALD_ID);
            assertTrue(removedA);

            // Assert: Quiz A no longer has it, but Quiz B still has it!
            assertFalse(questionDao.isQuestionInQuiz(sharedQId, createdA.getQuizId()));
            assertTrue(questionDao.isQuestionInQuiz(sharedQId, createdB.getQuizId()));
            assertEquals(0, questionDao.countQuestionsInQuiz(createdA.getQuizId()));
            assertEquals(1, questionDao.countQuestionsInQuiz(createdB.getQuizId()));

            // Clean up question
            teacherService.deleteQuestion(sharedQId, TEACHER_RONALD_ID);
        } finally {
            teacherService.deleteQuiz(createdA.getQuizId(), TEACHER_RONALD_ID);
            teacherService.deleteQuiz(createdB.getQuizId(), TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(18)
    @DisplayName("Test 18: Points override and sort ordering in quiz_questions join table")
    public void testQuizQuestionsPointsOverrideAndSortOrder() {
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Quiz for Points Override Test");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(30);
        quiz.setStatus("DRAFT");
        Quiz createdQuiz = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(createdQuiz);

        try {
            Question q = new Question();
            q.setSubjectId(1);
            q.setQuestionText("Base Question with Standard 2.00 Points");
            q.setQuestionType("SINGLE_CHOICE");
            q.setPoints(new BigDecimal("2.00"));
            q.addOption(new QuestionOption("A", "Option A", true, 1));
            q.addOption(new QuestionOption("B", "Option B", false, 2));

            Question createdQ = teacherService.createQuestion(q, TEACHER_RONALD_ID);
            assertNotNull(createdQ);
            int qId = createdQ.getQuestionId();

            // Add with override points = 10.00 and sort_order = 5
            boolean added = questionDao.addQuestionToQuiz(qId, createdQuiz.getQuizId(), 5, new BigDecimal("10.00"));
            assertTrue(added);

            List<Question> questions = teacherService.getQuestionsForQuiz(createdQuiz.getQuizId());
            assertEquals(1, questions.size());
            assertEquals(new BigDecimal("10.00"), questions.get(0).getPoints(), "Effective points should reflect points_override");

            teacherService.deleteQuestion(qId, TEACHER_RONALD_ID);
        } finally {
            teacherService.deleteQuiz(createdQuiz.getQuizId(), TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(19)
    @DisplayName("Test 19: Adding Question #2 as Blank Item does not overwrite Question #1 (B4)")
    public void testAddSecondQuestionAsBlankItem() {
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Quiz for Question Builder Multi-Item Test");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(30);
        quiz.setStatus("DRAFT");
        Quiz createdQuiz = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(createdQuiz);

        try {
            // 1. Create Question #1
            Question q1 = new Question();
            q1.setQuizId(createdQuiz.getQuizId());
            q1.setSubjectId(1);
            q1.setQuestionText("Question #1: First original prompt text");
            q1.setQuestionType("SINGLE_CHOICE");
            q1.setPoints(new BigDecimal("4.00"));
            q1.addOption(new QuestionOption("A", "Option A1", true, 1));
            q1.addOption(new QuestionOption("B", "Option B1", false, 2));

            Question createdQ1 = teacherService.createQuestion(q1, TEACHER_RONALD_ID);
            assertNotNull(createdQ1);
            int q1Id = createdQ1.getQuestionId();

            // 2. Create Question #2 (Simulating Blank Item submission with questionId = 0)
            Question q2 = new Question();
            q2.setQuestionId(0);
            q2.setQuizId(createdQuiz.getQuizId());
            q2.setSubjectId(1);
            q2.setQuestionText("Question #2: Second new prompt text");
            q2.setQuestionType("SINGLE_CHOICE");
            q2.setPoints(new BigDecimal("3.00"));
            q2.addOption(new QuestionOption("A", "Option A2", false, 1));
            q2.addOption(new QuestionOption("B", "Option B2", true, 2));

            Question createdQ2 = teacherService.createQuestion(q2, TEACHER_RONALD_ID);
            assertNotNull(createdQ2);
            int q2Id = createdQ2.getQuestionId();

            // Assert: Question 2 has a distinct ID and did not overwrite Question 1
            assertNotEquals(q1Id, q2Id, "Question 2 must have a distinct ID from Question 1");

            // Verify both questions exist in quiz
            List<Question> questions = teacherService.getQuestionsForQuiz(createdQuiz.getQuizId());
            assertEquals(2, questions.size(), "Quiz must now contain both Question 1 and Question 2");

            Optional<Question> verifyQ1 = teacherService.getQuestionById(q1Id);
            assertTrue(verifyQ1.isPresent());
            assertEquals("Question #1: First original prompt text", verifyQ1.get().getQuestionText(), "Question 1 text must be intact");

            Optional<Question> verifyQ2 = teacherService.getQuestionById(q2Id);
            assertTrue(verifyQ2.isPresent());
            assertEquals("Question #2: Second new prompt text", verifyQ2.get().getQuestionText(), "Question 2 text must match submission");

            // Clean up
            teacherService.deleteQuestion(q1Id, TEACHER_RONALD_ID);
            teacherService.deleteQuestion(q2Id, TEACHER_RONALD_ID);
        } finally {
            teacherService.deleteQuiz(createdQuiz.getQuizId(), TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(20)
    @DisplayName("Test 20: Question Validation - Prompt length and positive points (B5)")
    public void testQuestionValidationPromptAndPoints() {
        // Invalid prompt (< 3 chars)
        Question badPrompt = new Question();
        badPrompt.setSubjectId(1);
        badPrompt.setQuestionText("Hi");
        badPrompt.setPoints(new BigDecimal("2.00"));
        badPrompt.addOption(new QuestionOption("A", "Yes", true, 1));
        badPrompt.addOption(new QuestionOption("B", "No", false, 2));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(badPrompt, TEACHER_RONALD_ID);
        }, "Question prompt with < 3 characters must be rejected");

        // Invalid points (<= 0)
        Question badPoints = new Question();
        badPoints.setSubjectId(1);
        badPoints.setQuestionText("Valid question prompt text");
        badPoints.setPoints(BigDecimal.ZERO);
        badPoints.addOption(new QuestionOption("A", "Yes", true, 1));
        badPoints.addOption(new QuestionOption("B", "No", false, 2));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(badPoints, TEACHER_RONALD_ID);
        }, "Question with <= 0 points must be rejected");
    }

    @Test
    @Order(21)
    @DisplayName("Test 21: Question Validation - Options count and correct answers (B5)")
    public void testQuestionValidationOptionsRequirements() {
        // Less than 2 options
        Question oneOption = new Question();
        oneOption.setSubjectId(1);
        oneOption.setQuestionText("Question with only one option");
        oneOption.setPoints(new BigDecimal("2.00"));
        oneOption.addOption(new QuestionOption("A", "Single", true, 1));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(oneOption, TEACHER_RONALD_ID);
        }, "Question with < 2 options must be rejected");

        // SINGLE_CHOICE with 0 correct answers
        Question singleNoCorrect = new Question();
        singleNoCorrect.setSubjectId(1);
        singleNoCorrect.setQuestionText("Single choice question with no correct answer");
        singleNoCorrect.setQuestionType("SINGLE_CHOICE");
        singleNoCorrect.setPoints(new BigDecimal("2.00"));
        singleNoCorrect.addOption(new QuestionOption("A", "Option A", false, 1));
        singleNoCorrect.addOption(new QuestionOption("B", "Option B", false, 2));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(singleNoCorrect, TEACHER_RONALD_ID);
        }, "Single choice with 0 correct answers must be rejected");

        // SINGLE_CHOICE with > 1 correct answers
        Question singleMultiCorrect = new Question();
        singleMultiCorrect.setSubjectId(1);
        singleMultiCorrect.setQuestionText("Single choice question with two correct answers");
        singleMultiCorrect.setQuestionType("SINGLE_CHOICE");
        singleMultiCorrect.setPoints(new BigDecimal("2.00"));
        singleMultiCorrect.addOption(new QuestionOption("A", "Option A", true, 1));
        singleMultiCorrect.addOption(new QuestionOption("B", "Option B", true, 2));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(singleMultiCorrect, TEACHER_RONALD_ID);
        }, "Single choice with > 1 correct answers must be rejected");

        // TRUE_FALSE with 3 options
        Question tfThreeOptions = new Question();
        tfThreeOptions.setSubjectId(1);
        tfThreeOptions.setQuestionText("True false question with three options");
        tfThreeOptions.setQuestionType("TRUE_FALSE");
        tfThreeOptions.setPoints(new BigDecimal("2.00"));
        tfThreeOptions.addOption(new QuestionOption("A", "True", true, 1));
        tfThreeOptions.addOption(new QuestionOption("B", "False", false, 2));
        tfThreeOptions.addOption(new QuestionOption("C", "Maybe", false, 3));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(tfThreeOptions, TEACHER_RONALD_ID);
        }, "True/False with != 2 options must be rejected");

        // MULTI_CHOICE with 0 correct answers
        Question multiNoCorrect = new Question();
        multiNoCorrect.setSubjectId(1);
        multiNoCorrect.setQuestionText("Multi choice question with 0 correct answers");
        multiNoCorrect.setQuestionType("MULTI_CHOICE");
        multiNoCorrect.setPoints(new BigDecimal("2.00"));
        multiNoCorrect.addOption(new QuestionOption("A", "Option A", false, 1));
        multiNoCorrect.addOption(new QuestionOption("B", "Option B", false, 2));

        assertThrows(IllegalArgumentException.class, () -> {
            teacherService.createQuestion(multiNoCorrect, TEACHER_RONALD_ID);
        }, "Multi-choice with 0 correct answers must be rejected");
    }

    @Test
    @Order(22)
    @DisplayName("Test 22: Persistence of MULTI_CHOICE (multiple correct) and TRUE_FALSE questions (B5)")
    public void testMultiChoiceAndTrueFalsePersistence() {
        // 1. MULTI_CHOICE with 2 correct options
        Question multiQ = new Question();
        multiQ.setSubjectId(1);
        multiQ.setQuestionText("Which of the following are consensus protocols? (Select all that apply)");
        multiQ.setQuestionType("MULTI_CHOICE");
        multiQ.setPoints(new BigDecimal("5.00"));
        multiQ.addOption(new QuestionOption("A", "Paxos", true, 1));
        multiQ.addOption(new QuestionOption("B", "Binary Search", false, 2));
        multiQ.addOption(new QuestionOption("C", "Raft", true, 3));
        multiQ.addOption(new QuestionOption("D", "QuickSort", false, 4));

        Question createdMulti = teacherService.createQuestion(multiQ, TEACHER_RONALD_ID);
        assertNotNull(createdMulti);
        int multiId = createdMulti.getQuestionId();

        Optional<Question> retrievedMulti = teacherService.getQuestionById(multiId);
        assertTrue(retrievedMulti.isPresent());
        assertEquals("MULTI_CHOICE", retrievedMulti.get().getQuestionType());
        assertEquals(4, retrievedMulti.get().getOptions().size());
        long correctInMulti = retrievedMulti.get().getOptions().stream().filter(QuestionOption::isCorrect).count();
        assertEquals(2, correctInMulti, "MULTI_CHOICE question must persist both correct options");

        // 2. TRUE_FALSE question
        Question tfQ = new Question();
        tfQ.setSubjectId(1);
        tfQ.setQuestionText("In Raft, a leader sends heartbeat messages via AppendEntries RPCs.");
        tfQ.setQuestionType("TRUE_FALSE");
        tfQ.setPoints(new BigDecimal("2.00"));
        tfQ.addOption(new QuestionOption("A", "True", true, 1));
        tfQ.addOption(new QuestionOption("B", "False", false, 2));

        Question createdTf = teacherService.createQuestion(tfQ, TEACHER_RONALD_ID);
        assertNotNull(createdTf);
        int tfId = createdTf.getQuestionId();

        Optional<Question> retrievedTf = teacherService.getQuestionById(tfId);
        assertTrue(retrievedTf.isPresent());
        assertEquals("TRUE_FALSE", retrievedTf.get().getQuestionType());
        assertEquals(2, retrievedTf.get().getOptions().size());
        assertEquals("True", retrievedTf.get().getOptions().get(0).getOptionText());
        assertTrue(retrievedTf.get().getOptions().get(0).isCorrect());
        assertEquals("False", retrievedTf.get().getOptions().get(1).getOptionText());
        assertFalse(retrievedTf.get().getOptions().get(1).isCorrect());

        // Clean up
        teacherService.deleteQuestion(multiId, TEACHER_RONALD_ID);
        teacherService.deleteQuestion(tfId, TEACHER_RONALD_ID);
    }

    @Test
    @Order(23)
    @DisplayName("Test 23: Quiz settings editing and parameter updates (B7)")
    public void testUpdateQuizParameters() {
        Quiz testQuiz = new Quiz();
        testQuiz.setTitle("CS402: Mid-Term Systems Architecture");
        testQuiz.setDescription("Initial assessment description.");
        testQuiz.setSubjectId(1);
        testQuiz.setTeacherId(TEACHER_RONALD_ID);
        testQuiz.setDurationMinutes(45);
        testQuiz.setTotalMarks(new BigDecimal("10.00"));
        testQuiz.setPassPercentage(new BigDecimal("40.00"));
        testQuiz.setStatus("DRAFT");
        Quiz created = teacherService.createQuiz(testQuiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            Optional<Quiz> qOpt = teacherService.getQuizById(quizId);
            assertTrue(qOpt.isPresent(), "Created quiz must exist");
            Quiz quiz = qOpt.get();

            quiz.setTitle("CS402: Advanced Distributed Systems Architecture");
            quiz.setDescription("Updated comprehensive mid-term assessment covering consensus and consistency.");
            quiz.setDurationMinutes(75);
            quiz.setPassPercentage(new BigDecimal("50.00"));
            quiz.setNegativeMarking(true);
            quiz.setNegativeMarkValue(new BigDecimal("1.00"));
            quiz.setShuffleQuestions(true);
            quiz.setFullscreenRequired(true);
            quiz.setWebcamRequired(false);
            quiz.setMaxTabSwitches(5);

            boolean updated = teacherService.updateQuiz(quiz, TEACHER_RONALD_ID);
            assertTrue(updated, "Teacher must be able to update quiz parameters");

            Optional<Quiz> reloaded = teacherService.getQuizById(quizId);
            assertTrue(reloaded.isPresent());
            assertEquals("CS402: Advanced Distributed Systems Architecture", reloaded.get().getTitle());
            assertEquals(75, reloaded.get().getDurationMinutes());
            assertEquals(new BigDecimal("50.00"), reloaded.get().getPassPercentage());
            assertEquals(new BigDecimal("1.00"), reloaded.get().getNegativeMarkValue());
            assertFalse(reloaded.get().isWebcamRequired());
            assertEquals(5, reloaded.get().getMaxTabSwitches());
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(24)
    @DisplayName("Test 24: Publish validation checklist rejects invalid quizzes (B8)")
    public void testPublishValidationChecklist() {
        // 1. Create a bare quiz with 0 questions
        Quiz emptyQuiz = new Quiz();
        emptyQuiz.setTitle("Empty Quiz For Validation");
        emptyQuiz.setSubjectId(1);
        emptyQuiz.setTeacherId(TEACHER_RONALD_ID);
        emptyQuiz.setDurationMinutes(30);
        emptyQuiz.setStatus("DRAFT");
        Quiz createdEmpty = teacherService.createQuiz(emptyQuiz, TEACHER_RONALD_ID);
        assertNotNull(createdEmpty);
        int emptyQuizId = createdEmpty.getQuizId();

        try {
            // Must fail publish validation because 0 questions exist
            IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
                teacherService.validateQuizForPublish(emptyQuizId, TEACHER_RONALD_ID);
            });
            assertTrue(ex.getMessage().contains("at least 1 question"), "Should reject quiz with 0 questions: " + ex.getMessage());

            // 2. Add a valid question to the quiz
            Question q = new Question();
            q.setSubjectId(1);
            q.setQuizId(emptyQuizId);
            q.setQuestionText("Which port does HTTPS use by default?");
            q.setQuestionType("SINGLE_CHOICE");
            q.setPoints(new BigDecimal("4.00"));
            q.addOption(new QuestionOption("A", "80", false, 1));
            q.addOption(new QuestionOption("B", "443", true, 2));
            Question createdQ = teacherService.createQuestion(q, TEACHER_RONALD_ID);
            assertNotNull(createdQ);

            // 3. Set elapsed past end time and verify rejection
            Quiz qWithPastEnd = teacherService.getQuizById(emptyQuizId).get();
            long now = System.currentTimeMillis();
            qWithPastEnd.setStartTime(new Timestamp(now - 3600 * 1000L));
            qWithPastEnd.setEndTime(new Timestamp(now - 1800 * 1000L)); // ended 30 mins ago
            quizDao.update(qWithPastEnd);

            IllegalArgumentException exPast = assertThrows(IllegalArgumentException.class, () -> {
                teacherService.validateQuizForPublish(emptyQuizId, TEACHER_RONALD_ID);
            });
            assertTrue(exPast.getMessage().contains("already elapsed"), "Should reject quiz with elapsed end time: " + exPast.getMessage());

            // 4. Set invalid window (start > end) and verify rejection
            qWithPastEnd.setStartTime(new Timestamp(now + 7200 * 1000L));
            qWithPastEnd.setEndTime(new Timestamp(now + 3600 * 1000L)); // end before start!
            quizDao.update(qWithPastEnd);

            IllegalArgumentException exWindow = assertThrows(IllegalArgumentException.class, () -> {
                teacherService.validateQuizForPublish(emptyQuizId, TEACHER_RONALD_ID);
            });
            assertTrue(exWindow.getMessage().contains("before end time"), "Should reject inverted window: " + exWindow.getMessage());

            // Clean up question
            teacherService.removeQuestionFromQuiz(createdQ.getQuestionId(), emptyQuizId, TEACHER_RONALD_ID);
            teacherService.deleteQuestion(createdQ.getQuestionId(), TEACHER_RONALD_ID);
        } finally {
            teacherService.deleteQuiz(emptyQuizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(25)
    @DisplayName("Test 25: Smart scheduling and status lifecycle on publish (B8)")
    public void testSmartPublishAndScheduling() {
        // Create a scheduled quiz with future start time
        Quiz schedQuiz = new Quiz();
        schedQuiz.setTitle("CS402: Scheduled Final Exam");
        schedQuiz.setSubjectId(1);
        schedQuiz.setTeacherId(TEACHER_RONALD_ID);
        schedQuiz.setDurationMinutes(60);
        long now = System.currentTimeMillis();
        Timestamp futureStart = new Timestamp(now + 24 * 3600 * 1000L); // tomorrow
        Timestamp futureEnd = new Timestamp(now + 26 * 3600 * 1000L);   // tomorrow + 2 hrs
        schedQuiz.setStartTime(futureStart);
        schedQuiz.setEndTime(futureEnd);
        schedQuiz.setStatus("DRAFT");

        Quiz created = teacherService.createQuiz(schedQuiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            // Add a valid question
            Question q = new Question();
            q.setSubjectId(1);
            q.setQuizId(quizId);
            q.setQuestionText("What is the CAP theorem?");
            q.setQuestionType("SINGLE_CHOICE");
            q.setPoints(new BigDecimal("10.00"));
            q.addOption(new QuestionOption("A", "Consistency, Availability, Partition tolerance", true, 1));
            q.addOption(new QuestionOption("B", "Concurrency, Atomicity, Persistence", false, 2));
            Question createdQ = teacherService.createQuestion(q, TEACHER_RONALD_ID);
            assertNotNull(createdQ);

            // Assign Cohort 1 to satisfy target assignment publish requirement
            boolean assigned = teacherService.assignQuizToCohort(quizId, 1, futureEnd, TEACHER_RONALD_ID);
            assertTrue(assigned, "Assigning cohort to quiz must succeed");

            // Validate for publish
            assertDoesNotThrow(() -> teacherService.validateQuizForPublish(quizId, TEACHER_RONALD_ID));

            // Smart scheduling: start_time is in the future -> transitions to SCHEDULED
            teacherService.setQuizStatus(quizId, TEACHER_RONALD_ID, "SCHEDULED");
            Optional<Quiz> pubOpt = teacherService.getQuizById(quizId);
            assertTrue(pubOpt.isPresent());
            assertEquals("SCHEDULED", pubOpt.get().getStatus(), "Future start time quiz should be SCHEDULED");

            // Revert to draft
            teacherService.setQuizStatus(quizId, TEACHER_RONALD_ID, "DRAFT");
            assertEquals("DRAFT", teacherService.getQuizById(quizId).get().getStatus());

            // Immediate start time -> transitions to ACTIVE
            teacherService.setQuizStatus(quizId, TEACHER_RONALD_ID, "ACTIVE");
            assertEquals("ACTIVE", teacherService.getQuizById(quizId).get().getStatus());

            // Clean up
            teacherService.removeQuestionFromQuiz(createdQ.getQuestionId(), quizId, TEACHER_RONALD_ID);
            teacherService.deleteQuestion(createdQ.getQuestionId(), TEACHER_RONALD_ID);
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(26)
    @DisplayName("Test 26: Time-driven status lifecycle sync (SCHEDULED -> ACTIVE -> COMPLETED) (B8)")
    public void testTimeDrivenStatusLifecycleSync() {
        long now = System.currentTimeMillis();
        // 1. Create a quiz with start_time 10 mins ago and end_time 30 mins in the future, marked SCHEDULED
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Auto-Activating Exam");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(30);
        quiz.setStartTime(new Timestamp(now - 10 * 60 * 1000L));
        quiz.setEndTime(new Timestamp(now + 30 * 60 * 1000L));
        quiz.setStatus("SCHEDULED");

        Quiz created = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            // Trigger lifecycle sync
            int transitioned = quizDao.syncQuizStatusLifecycle();
            assertTrue(transitioned >= 1, "Should transition at least 1 quiz");

            Optional<Quiz> activatedOpt = teacherService.getQuizById(quizId);
            assertTrue(activatedOpt.isPresent());
            assertEquals("ACTIVE", activatedOpt.get().getStatus(), "SCHEDULED quiz with past start_time must transition to ACTIVE");

            // 2. Now simulate end_time passing (set end_time to 5 mins in past)
            Quiz activeQuiz = activatedOpt.get();
            activeQuiz.setEndTime(new Timestamp(now - 5 * 60 * 1000L));
            quizDao.update(activeQuiz);

            // Trigger lifecycle sync
            int completedCount = quizDao.syncQuizStatusLifecycle();
            assertTrue(completedCount >= 1, "Should transition expired quiz to COMPLETED");

            Optional<Quiz> completedOpt = teacherService.getQuizById(quizId);
            assertTrue(completedOpt.isPresent());
            assertEquals("COMPLETED", completedOpt.get().getStatus(), "ACTIVE quiz with past end_time must transition to COMPLETED");
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(27)
    @DisplayName("Test 27: Assign quiz to cohort and verify assignment in DB & department scoping (B1)")
    public void testAssignQuizToCohortAndDepartmentScoping() {
        // 1. Verify available cohorts for Ronald Vance are scoped to Computer Science
        List<Cohort> cohorts = teacherService.getAvailableCohortsForTeacher(TEACHER_RONALD_ID);
        assertNotNull(cohorts);
        assertFalse(cohorts.isEmpty(), "Ronald Vance should have available cohorts in Computer Science");
        for (Cohort c : cohorts) {
            assertEquals("Computer Science", c.getDepartment(), "Cohort must belong to teacher's department");
        }

        // 2. Create test quiz
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Cohort Assignment Test");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(45);
        quiz.setStatus("DRAFT");
        Quiz created = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            int cohortId = cohorts.get(0).getCohortId();
            Timestamp dueAt = new Timestamp(System.currentTimeMillis() + 48 * 3600 * 1000L);

            // 3. Assign to cohort
            boolean assigned = teacherService.assignQuizToCohort(quizId, cohortId, dueAt, TEACHER_RONALD_ID);
            assertTrue(assigned, "Assigning cohort to quiz should succeed");

            // 4. Verify assignment query returns enriched details
            List<QuizAssignment> assignments = teacherService.getQuizAssignments(quizId, TEACHER_RONALD_ID);
            assertEquals(1, assignments.size(), "Should have exactly 1 assignment");
            QuizAssignment qa = assignments.get(0);
            assertEquals(cohortId, qa.getCohortId());
            assertEquals("CS Senior Cohort 2026", qa.getCohortName());
            assertEquals(6, qa.getEnrolledStudentsCount(), "Cohort 1 has 6 enrolled students");

            // 5. Cross-teacher security check: Alistair Finch cannot assign to Ronald's quiz
            boolean unauthorizedAssign = teacherService.assignQuizToCohort(quizId, cohortId, dueAt, TEACHER_ALISTAIR_ID);
            assertFalse(unauthorizedAssign, "Unrelated teacher cannot assign cohorts to another teacher's quiz");
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(28)
    @DisplayName("Test 28: Assign quiz to student, verify duplicate prevention and removal (B1)")
    public void testAssignQuizToStudentAndDuplicatePrevention() {
        // 1. Verify available students for Ronald Vance
        List<User> students = teacherService.getAvailableStudentsForTeacher(TEACHER_RONALD_ID);
        assertNotNull(students);
        assertFalse(students.isEmpty(), "Ronald Vance should have available students");
        for (User u : students) {
            assertEquals("Computer Science", u.getDepartment(), "Available students must belong to teacher's department");
        }

        // 2. Create test quiz
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Individual Student Assignment Test");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(30);
        quiz.setStatus("DRAFT");
        Quiz created = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            int studentId = 4; // Alex Mercer
            Timestamp dueAt = new Timestamp(System.currentTimeMillis() + 24 * 3600 * 1000L);

            // 3. Assign individual student
            boolean assigned = teacherService.assignQuizToStudent(quizId, studentId, dueAt, TEACHER_RONALD_ID);
            assertTrue(assigned, "Assigning individual student should succeed");

            List<QuizAssignment> assignments = teacherService.getQuizAssignments(quizId, TEACHER_RONALD_ID);
            assertEquals(1, assignments.size());
            QuizAssignment qa = assignments.get(0);
            assertEquals(studentId, qa.getStudentId());
            assertEquals("Alex Mercer", qa.getStudentName());
            assertEquals("CS-2022-041", qa.getStudentIdentifier());

            // 4. Duplicate assignment attempt should be handled gracefully (idempotent)
            boolean dupeAssigned = teacherService.assignQuizToStudent(quizId, studentId, dueAt, TEACHER_RONALD_ID);
            assertTrue(dupeAssigned, "Duplicate assignment should be handled safely");
            assertEquals(1, teacherService.getQuizAssignments(quizId, TEACHER_RONALD_ID).size(), "Still exactly 1 assignment");

            // 5. Remove assignment
            boolean removed = teacherService.removeQuizAssignment(qa.getAssignmentId(), quizId, TEACHER_RONALD_ID);
            assertTrue(removed, "Removing assignment should succeed");
            assertEquals(0, teacherService.getQuizAssignments(quizId, TEACHER_RONALD_ID).size(), "Assignments list should now be empty");
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(29)
    @DisplayName("Test 29: Publish checklist requires at least one assignment target (B1)")
    public void testPublishChecklistRequiresAssignmentTarget() {
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Target Requirement Publish Test");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(30);
        quiz.setStatus("DRAFT");
        Quiz created = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            // Add a valid question
            Question q = new Question();
            q.setSubjectId(1);
            q.setQuizId(quizId);
            q.setQuestionText("What protocol operates on TCP port 443?");
            q.setQuestionType("SINGLE_CHOICE");
            q.setPoints(new BigDecimal("5.00"));
            q.addOption(new QuestionOption("A", "HTTPS", true, 1));
            q.addOption(new QuestionOption("B", "HTTP", false, 2));
            Question createdQ = teacherService.createQuestion(q, TEACHER_RONALD_ID);
            assertNotNull(createdQ);

            // Validation with 0 assignments MUST fail
            IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
                teacherService.validateQuizForPublish(quizId, TEACHER_RONALD_ID);
            });
            assertTrue(ex.getMessage().contains("assign the examination to at least one cohort or student"),
                    "Must reject publish when no targets assigned: " + ex.getMessage());

            // Now assign Cohort 1
            teacherService.assignQuizToCohort(quizId, 1, null, TEACHER_RONALD_ID);

            // Now publish validation should pass
            assertDoesNotThrow(() -> teacherService.validateQuizForPublish(quizId, TEACHER_RONALD_ID));

            // Clean up
            teacherService.removeQuestionFromQuiz(createdQ.getQuestionId(), quizId, TEACHER_RONALD_ID);
            teacherService.deleteQuestion(createdQ.getQuestionId(), TEACHER_RONALD_ID);
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(30)
    @DisplayName("Test 30: Student visibility in getAssignedQuizzes and window eligibility in isStudentEligible (B1)")
    public void testStudentVisibilityAndEligibility() {
        long now = System.currentTimeMillis();
        // 1. Create an active quiz for Ronald Vance
        Quiz quiz = new Quiz();
        quiz.setTitle("CS402: Live Distributed Systems Assessment");
        quiz.setSubjectId(1);
        quiz.setTeacherId(TEACHER_RONALD_ID);
        quiz.setDurationMinutes(60);
        quiz.setStartTime(new Timestamp(now - 10 * 60 * 1000L)); // started 10 mins ago
        quiz.setEndTime(new Timestamp(now + 2 * 3600 * 1000L));   // ends in 2 hrs
        quiz.setStatus("ACTIVE");
        Quiz created = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            int studentId = 4; // Alex Mercer, in Cohort 1

            // Initially, student is NOT eligible (no assignment yet)
            assertFalse(examDao.isStudentEligible(quizId, studentId), "Student must not be eligible before quiz assignment");

            // Assign quiz to Cohort 1 (which includes student 4)
            teacherService.assignQuizToCohort(quizId, 1, null, TEACHER_RONALD_ID);

            // Now student IS eligible
            assertTrue(examDao.isStudentEligible(quizId, studentId), "Student in assigned cohort must be eligible");

            // Student 4's assigned quiz list includes this quiz with canStart = true
            List<StudentQuizCard> cards = studentDao.getAssignedQuizzes(studentId);
            boolean found = false;
            for (StudentQuizCard card : cards) {
                if (card.getQuizId() == quizId) {
                    found = true;
                    assertEquals("ACTIVE", card.getStatus());
                    assertTrue(card.isCanStart(), "Active quiz within window should have canStart=true");
                    break;
                }
            }
            assertTrue(found, "Newly assigned quiz must appear on student's dashboard");

            // An ineligible student ID (e.g. 99999) must return false
            assertFalse(examDao.isStudentEligible(quizId, 99999), "Unenrolled student must not be eligible");

            // If the quiz start_time is in the future, isStudentEligible returns false
            quiz.setStartTime(new Timestamp(now + 24 * 3600 * 1000L)); // tomorrow
            quizDao.update(quiz);
            assertFalse(examDao.isStudentEligible(quizId, studentId), "Future start_time quiz must not be startable by student");
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }
}
