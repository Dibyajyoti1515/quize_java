-- Migration 003: Seed 20 Question Bank Items across all Academic Subjects / Branches
-- Covering Single Choice, Multi-Choice, and True/False questions for:
-- 1: CS402 (Distributed Systems & Concurrency)
-- 2: CS301 (Advanced Data Structures & Algorithms)
-- 3: MATH210 (Discrete Probability & Stochastic Processes)
-- 4: CS505 (Cloud Infrastructure & Kubernetes Architecture)
-- 5: CS490 (Software Engineering Ethics, Governance & AI Law)

-- Reset sequence to avoid collision
SELECT setval('questions_question_id_seq', (SELECT GREATEST(COALESCE(MAX(question_id), 0), 10) FROM questions));

-- 1. CS402 Questions (Distributed Systems)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, created_by)
VALUES 
(11, NULL, 1, 'In the Raft consensus algorithm, what state does a node transition to when an election timeout elapses without receiving heartbeats?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Consensus Protocols', 'When a follower election timer expires without receiving an AppendEntries RPC heartbeat from a valid leader, it transitions to Candidate state.', 2),
(12, NULL, 1, 'Which guarantees are provided by Vector Clocks that scalar Lamport timestamps cannot provide?', 'MULTI_CHOICE', 4.00, 'HARD', 'Logical Clocks & Ordering', 'Vector clocks can detect whether two events are causally related (a -> b) or concurrent (a || b). Scalar Lamport clocks cannot distinguish concurrency.', 2),
(13, NULL, 1, 'True or False: In a Byzantine fault tolerance model, signatures can prevent a traitor node from forging false messages under synchronous communications.', 'TRUE_FALSE', 2.00, 'EASY', 'Byzantine Fault Tolerance', 'Cryptographic digital signatures provide authentication and non-repudiation, preventing traitor generals from forging messages.', 2),
(14, NULL, 1, 'Under the CAP Theorem, which database architectures prioritize Availability and Partition Tolerance (AP) over strict Consistency?', 'MULTI_CHOICE', 4.00, 'MEDIUM', 'Distributed Storage & CAP', 'DynamoDB and Apache Cassandra are classical examples of AP systems utilizing eventual consistency and vector versioning.', 2)
ON CONFLICT (question_id) DO NOTHING;

-- Options for CS402
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(11, 'A', 'Candidate', TRUE, 1),
(11, 'B', 'Leader', FALSE, 2),
(11, 'C', 'Observer', FALSE, 3),
(11, 'D', 'Pre-Vote Terminated', FALSE, 4),

(12, 'A', 'Detection of concurrent event execution', TRUE, 1),
(12, 'B', 'Exact physical clock wall-time synchronization', FALSE, 2),
(12, 'C', 'Exact causal precedence identification', TRUE, 3),
(12, 'D', 'Zero-latency broadcast delivery', FALSE, 4),

(13, 'A', 'True', TRUE, 1),
(13, 'B', 'False', FALSE, 2),

(14, 'A', 'Apache Cassandra', TRUE, 1),
(14, 'B', 'Amazon DynamoDB (Default eventual consistency mode)', TRUE, 2),
(14, 'C', 'Google Spanner (TrueTime synchronized)', FALSE, 3),
(14, 'D', 'PostgreSQL with synchronous replication', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- 2. CS301 Questions (Data Structures & Algorithms)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, created_by)
VALUES 
(15, NULL, 2, 'What is the worst-case search time complexity in a Red-Black Tree with n nodes?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Balanced Trees', 'A Red-Black Tree maintains height logarithmic in n (h <= 2 * log2(n + 1)), ensuring worst-case search is O(log n).', 2),
(16, NULL, 2, 'Which of the following properties are strictly required for a valid Red-Black Tree?', 'MULTI_CHOICE', 4.00, 'HARD', 'Balanced Trees', 'Properties: Root is black, every leaf (NIL) is black, if a node is red then both its children are black, and all paths from a node to descendant leaves contain the same number of black nodes.', 2),
(17, NULL, 2, 'True or False: Dijkstra''s shortest path algorithm correctly computes shortest paths in graphs with negative weight edges.', 'TRUE_FALSE', 2.00, 'EASY', 'Graph Theory', 'Dijkstra assumes edge weights are non-negative. Bellman-Ford or Floyd-Warshall must be used when negative edges exist.', 2),
(18, NULL, 2, 'What is the amortized time complexity of an insert operation into a dynamic array that doubles in capacity when full?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Amortized Analysis', 'Doubling capacity costs O(n) rarely, but amortized over n insertions, each append costs O(1) amortized time.', 2)
ON CONFLICT (question_id) DO NOTHING;

-- Options for CS301
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(15, 'A', 'O(1)', FALSE, 1),
(15, 'B', 'O(log n)', TRUE, 2),
(15, 'C', 'O(n)', FALSE, 3),
(15, 'D', 'O(n log n)', FALSE, 4),

(16, 'A', 'The root node is always Black', TRUE, 1),
(16, 'B', 'No two consecutive Red nodes appear on any path', TRUE, 2),
(16, 'C', 'Every path from a node to NIL leaves has the same black-height', TRUE, 3),
(16, 'D', 'Every Red node must have exactly two Red children', FALSE, 4),

(17, 'A', 'True', FALSE, 1),
(17, 'B', 'False', TRUE, 2),

(18, 'A', 'O(n)', FALSE, 1),
(18, 'B', 'O(log n)', FALSE, 2),
(18, 'C', 'O(1) amortized', TRUE, 3),
(18, 'D', 'O(n^2)', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- 3. MATH210 Questions (Discrete Probability & Stochastic Processes)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, created_by)
VALUES 
(19, NULL, 3, 'In a discrete-time Markov Chain, what property guarantees that transition probabilities depend solely on the current state?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Markov Chains', 'The Markov Property states that P(X_{n+1} = j | X_n = i, ..., X_0 = i_0) = P(X_{n+1} = j | X_n = i).', 3),
(20, NULL, 3, 'Which conditions are necessary for a Markov chain to possess a unique stationary distribution?', 'MULTI_CHOICE', 4.00, 'HARD', 'Markov Chains', 'An irreducible, positive recurrent, and aperiodic Markov chain has a unique limiting stationary distribution.', 3),
(21, NULL, 3, 'True or False: The Poisson distribution can be derived as a limiting case of the Binomial distribution when n -> infinity and p -> 0 with lambda = np constant.', 'TRUE_FALSE', 2.00, 'EASY', 'Poisson Distribution', 'This is the Law of Rare Events (Poisson Limit Theorem).', 3),
(22, NULL, 3, 'If X ~ Exp(lambda), what is the memoryless property represented mathematically?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Exponential Distribution', 'P(X > s + t | X > s) = P(X > t) for all s, t >= 0.', 3)
ON CONFLICT (question_id) DO NOTHING;

-- Options for MATH210
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(19, 'A', 'Memoryless / Markov Property', TRUE, 1),
(19, 'B', 'Central Limit Theorem', FALSE, 2),
(19, 'C', 'Martingale Equality', FALSE, 3),
(19, 'D', 'Bayesian Conjugacy', FALSE, 4),

(20, 'A', 'Irreducibility (all states communicate)', TRUE, 1),
(20, 'B', 'Positive Recurrence (finite expected return time)', TRUE, 2),
(20, 'C', 'Aperiodicity', TRUE, 3),
(20, 'D', 'Absorbing boundary conditions on all states', FALSE, 4),

(21, 'A', 'True', TRUE, 1),
(21, 'B', 'False', FALSE, 2),

(22, 'A', 'P(X > s + t | X > s) = P(X > t)', TRUE, 1),
(22, 'B', 'P(X > s + t) = P(X > s) * P(X > t)', FALSE, 2),
(22, 'C', 'E[X | X > s] = E[X] - s', FALSE, 3),
(22, 'D', 'Var(X | X > s) = 0', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- 4. CS505 Questions (Cloud Infrastructure & Kubernetes Architecture)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, created_by)
VALUES 
(23, NULL, 4, 'Which Kubernetes component acts as the distributed key-value datastore for all cluster state and configurations?', 'SINGLE_CHOICE', 3.00, 'EASY', 'Kubernetes Core', 'etcd is the strongly consistent, distributed key-value store used as Kubernetes backing store.', 2),
(24, NULL, 4, 'Which mechanisms does Kubernetes use to ensure container health and automatic self-healing?', 'MULTI_CHOICE', 4.00, 'MEDIUM', 'Container Probes', 'Kubernetes provides Liveness probes (restarts container on failure), Readiness probes (gates traffic), and Startup probes (protects slow initialization).', 2),
(25, NULL, 4, 'True or False: A Kubernetes ClusterIP service is accessible directly from outside the physical cluster network by external clients without an Ingress or NodePort.', 'TRUE_FALSE', 2.00, 'EASY', 'Kubernetes Networking', 'ClusterIP only exposes the Service on an internal cluster-routable IP, reachable only from within the cluster.', 2),
(26, NULL, 4, 'What is the role of the Container Network Interface (CNI) in Kubernetes?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Kubernetes Networking', 'CNI plugins (e.g. Calico, Flannel, Cilium) allocate IP addresses to Pods and configure network routing across cluster nodes.', 2)
ON CONFLICT (question_id) DO NOTHING;

-- Options for CS505
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(23, 'A', 'etcd', TRUE, 1),
(23, 'B', 'kube-proxy', FALSE, 2),
(23, 'C', 'CoreDNS', FALSE, 3),
(23, 'D', 'kube-apiserver cache', FALSE, 4),

(24, 'A', 'Liveness Probes', TRUE, 1),
(24, 'B', 'Readiness Probes', TRUE, 2),
(24, 'C', 'Startup Probes', TRUE, 3),
(24, 'D', 'Static IP Leasing', FALSE, 4),

(25, 'A', 'True', FALSE, 1),
(25, 'B', 'False', TRUE, 2),

(26, 'A', 'Allocates IP addresses to pods and routes inter-pod cluster traffic', TRUE, 1),
(26, 'B', 'Compiles Dockerfiles into OCI images', FALSE, 2),
(26, 'C', 'Provides persistent block storage mounts', FALSE, 3),
(26, 'D', 'Enforces kernel cgroups CPU quotas', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- 5. CS490 Questions (Software Engineering Ethics, Governance & AI Law)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, created_by)
VALUES 
(27, NULL, 5, 'Under the EU AI Act, which risk category is assigned to AI systems deployed for biometric categorisation and emotion recognition in workplaces and educational institutions?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'AI Governance & Law', 'Biometric categorisation and emotion recognition in employment or education are classified as High-Risk (or Prohibited in sensitive scenarios) with stringent conformity assessments.', 3),
(28, NULL, 5, 'Under the GDPR, what fundamental rights do data subjects hold regarding automated individual decision-making and profiling (Article 22)?', 'MULTI_CHOICE', 4.00, 'HARD', 'Data Privacy Regulations', 'Data subjects have the right not to be subject to a decision based solely on automated processing having legal effects, the right to obtain human intervention, and the right to contest the decision.', 3),
(29, NULL, 5, 'True or False: An open-source software license under MIT allows third-party commercial redistribution without requiring the source code of modifications to be made public.', 'TRUE_FALSE', 2.00, 'EASY', 'Intellectual Property Law', 'The MIT license is a permissive license that does not impose copyleft obligations (unlike GPL).', 3),
(30, NULL, 5, 'In algorithmic fairness, what metric ensures that the proportion of positive classification outcomes is identical across all demographic sub-populations?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Algorithmic Fairness', 'Demographic Parity (Statistical Parity) requires P(Y_hat = 1 | A = 0) = P(Y_hat = 1 | A = 1).', 3)
ON CONFLICT (question_id) DO NOTHING;

-- Options for CS490
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(27, 'A', 'High Risk', TRUE, 1),
(27, 'B', 'Minimal / Low Risk', FALSE, 2),
(27, 'C', 'Voluntary Code of Practice only', FALSE, 3),
(27, 'D', 'Unregulated Tier', FALSE, 4),

(28, 'A', 'Right to obtain human intervention on the decision', TRUE, 1),
(28, 'B', 'Right to express one''s point of view and contest the decision', TRUE, 2),
(28, 'C', 'Right to receive meaningful information about the algorithmic logic involved', TRUE, 3),
(28, 'D', 'Right to immediate monetary statutory damages upon any automated computation', FALSE, 4),

(29, 'A', 'True', TRUE, 1),
(29, 'B', 'False', FALSE, 2),

(30, 'A', 'Demographic Parity (Statistical Parity)', TRUE, 1),
(30, 'B', 'Equalized Odds', FALSE, 2),
(30, 'C', 'Predictive Rate Parity', FALSE, 3),
(30, 'D', 'Calibration within Groups', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

SELECT setval('questions_question_id_seq', (SELECT GREATEST(COALESCE(MAX(question_id), 0), 30) FROM questions));
