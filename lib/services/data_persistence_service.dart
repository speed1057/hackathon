import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class DataPersistenceService {
  static const String _eventsKey = 'hackathon_events';
  static const String _teamsKey = 'hackathon_teams';
  static const String _submissionsKey = 'hackathon_submissions';
  static const String _judgeScoresKey = 'hackathon_judge_scores';
  static const String _initializedKey = 'hackathon_initialized';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Check if sample data has been initialized
  static Future<bool> isInitialized() async {
    await init();
    return _prefs!.getBool(_initializedKey) ?? false;
  }

  /// Mark as initialized
  static Future<void> markInitialized() async {
    await init();
    await _prefs!.setBool(_initializedKey, true);
  }

  /// Clear all data and reset initialization
  static Future<void> clearAllData() async {
    await init();
    await _prefs!.clear();
  }

  // Events
  static Future<List<Event>> loadEvents() async {
    await init();
    final jsonString = _prefs!.getString(_eventsKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) print('Error loading events: $e');
      return [];
    }
  }

  static Future<void> saveEvents(List<Event> events) async {
    await init();
    final jsonString = json.encode(events.map((e) => e.toJson()).toList());
    await _prefs!.setString(_eventsKey, jsonString);
  }

  // Teams
  static Future<List<Team>> loadTeams() async {
    await init();
    final jsonString = _prefs!.getString(_teamsKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Team.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) print('Error loading teams: $e');
      return [];
    }
  }

  static Future<void> saveTeams(List<Team> teams) async {
    await init();
    final jsonString = json.encode(teams.map((t) => t.toJson()).toList());
    await _prefs!.setString(_teamsKey, jsonString);
  }

  // Submissions
  static Future<List<Submission>> loadSubmissions() async {
    await init();
    final jsonString = _prefs!.getString(_submissionsKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Submission.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) print('Error loading submissions: $e');
      return [];
    }
  }

  static Future<void> saveSubmissions(List<Submission> submissions) async {
    await init();
    final jsonString = json.encode(submissions.map((s) => s.toJson()).toList());
    await _prefs!.setString(_submissionsKey, jsonString);
  }

  // Judge Scores
  static Future<List<JudgeScore>> loadJudgeScores() async {
    await init();
    final jsonString = _prefs!.getString(_judgeScoresKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => JudgeScore.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) print('Error loading judge scores: $e');
      return [];
    }
  }

  static Future<void> saveJudgeScores(List<JudgeScore> scores) async {
    await init();
    final jsonString = json.encode(scores.map((s) => s.toJson()).toList());
    await _prefs!.setString(_judgeScoresKey, jsonString);
  }

  /// Initialize with sample data
  static Future<void> initializeSampleData() async {
    if (await isInitialized()) return;

    if (kDebugMode) print('Initializing sample data...');

    // Create sample events
    final now = DateTime.now();
    final events = [
      Event(
        id: 'event_1',
        name: 'Web3 Innovation Hackathon',
        description:
            'Build the future of decentralized applications. Create innovative solutions using blockchain technology, smart contracts, and Web3 protocols.',
        startDate: now.add(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 9)),
        createdAt: now.subtract(const Duration(days: 14)),
      ),
      Event(
        id: 'event_2',
        name: 'AI for Good Challenge',
        description:
            'Develop AI solutions that make a positive impact on society. Focus on healthcare, education, environmental sustainability, or social justice.',
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 21)),
      ),
      Event(
        id: 'event_3',
        name: 'Mobile App Innovation Summit',
        description:
            'Create the next breakthrough mobile application. Whether it\'s productivity, entertainment, or utility - let your creativity shine.',
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.subtract(const Duration(days: 8)),
        createdAt: now.subtract(const Duration(days: 28)),
      ),
      Event(
        id: 'event_4',
        name: 'GameDev Jam 2024',
        description:
            'Design and develop an engaging game in 48 hours. Any platform, any genre - just make it fun and memorable!',
        startDate: now.add(const Duration(days: 14)),
        endDate: now.add(const Duration(days: 16)),
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];

    // Create sample teams
    final teams = [
      Team(
        id: 'team_1',
        eventId: 'event_1',
        name: 'Blockchain Builders',
        members: ['Alice Johnson', 'Bob Chen', 'Carol Martinez'],
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      Team(
        id: 'team_2',
        eventId: 'event_1',
        name: 'DeFi Innovators',
        members: ['David Kim', 'Eva Rodriguez', 'Frank Wilson'],
        createdAt: now.subtract(const Duration(days: 9)),
      ),
      Team(
        id: 'team_3',
        eventId: 'event_2',
        name: 'AI Healers',
        members: ['Grace Liu', 'Henry Thompson', 'Iris Patel'],
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      Team(
        id: 'team_4',
        eventId: 'event_2',
        name: 'EcoMind AI',
        members: ['Jack Singh', 'Kate Brown'],
        createdAt: now.subtract(const Duration(days: 14)),
      ),
      Team(
        id: 'team_5',
        eventId: 'event_3',
        name: 'Mobile Mavericks',
        members: ['Liam Davis', 'Maya Kumar', 'Noah White', 'Olivia Clark'],
        createdAt: now.subtract(const Duration(days: 25)),
      ),
    ];

    // Create sample submissions
    final submissions = [
      Submission(
        id: 'submission_1',
        eventId: 'event_2',
        teamId: 'team_3',
        projectTitle: 'MedAI Assistant',
        description:
            'An AI-powered medical diagnosis assistant that helps healthcare providers make more accurate diagnoses by analyzing patient symptoms, medical history, and test results. Features include symptom analysis, drug interaction checking, and treatment recommendations.',
        githubLink: 'https://github.com/aihealer/medai-assistant',
        submittedAt: now.subtract(const Duration(hours: 6)),
      ),
      Submission(
        id: 'submission_2',
        eventId: 'event_2',
        teamId: 'team_4',
        projectTitle: 'EcoTracker Pro',
        description:
            'A comprehensive environmental monitoring system using IoT sensors and AI analytics. Tracks air quality, water pollution, and waste management in real-time. Provides actionable insights for environmental protection and sustainability.',
        githubLink: 'https://github.com/ecomind/ecotracker-pro',
        submittedAt: now.subtract(const Duration(hours: 3)),
      ),
      Submission(
        id: 'submission_3',
        eventId: 'event_3',
        teamId: 'team_5',
        projectTitle: 'StudySync',
        description:
            'A collaborative study platform that connects students worldwide. Features include virtual study rooms, AI-powered study planning, progress tracking, and peer tutoring matching. Built with Flutter for cross-platform compatibility.',
        githubLink: 'https://github.com/mobilemavericks/studysync',
        submittedAt: now.subtract(const Duration(days: 9)),
      ),
    ];

    // Create sample judge scores
    final judgeScores = [
      JudgeScore(
        id: 'score_1',
        submissionId: 'submission_1',
        judgeName: 'Dr. Sarah Mitchell',
        score: 9,
        comment:
            'Excellent innovation in healthcare AI. The medical diagnosis assistant shows great potential for real-world impact. Clean code and well-documented API.',
        scoredAt: now.subtract(const Duration(hours: 2)),
      ),
      JudgeScore(
        id: 'score_2',
        submissionId: 'submission_1',
        judgeName: 'Prof. Michael Chang',
        score: 8,
        comment:
            'Impressive technical implementation. The AI model accuracy is good, though it could benefit from more diverse training data. Great user interface design.',
        scoredAt: now.subtract(const Duration(hours: 1)),
      ),
      JudgeScore(
        id: 'score_3',
        submissionId: 'submission_2',
        judgeName: 'Dr. Sarah Mitchell',
        score: 7,
        comment:
            'Good environmental monitoring concept. The IoT integration is solid but the AI analytics could be more sophisticated. Well-structured project overall.',
        scoredAt: now.subtract(const Duration(minutes: 45)),
      ),
      JudgeScore(
        id: 'score_4',
        submissionId: 'submission_2',
        judgeName: 'Prof. Michael Chang',
        score: 8,
        comment:
            'Strong technical foundation and clear environmental impact. The real-time monitoring system is well-designed. Documentation could be improved.',
        scoredAt: now.subtract(const Duration(minutes: 30)),
      ),
      JudgeScore(
        id: 'score_5',
        submissionId: 'submission_3',
        judgeName: 'Emily Rodriguez',
        score: 9,
        comment:
            'Outstanding mobile app development! StudySync addresses a real need in education. Excellent UI/UX design and smooth cross-platform performance.',
        scoredAt: now.subtract(const Duration(days: 8, hours: 3)),
      ),
      JudgeScore(
        id: 'score_6',
        submissionId: 'submission_3',
        judgeName: 'James Wilson',
        score: 8,
        comment:
            'Very well-executed project. The collaborative features are innovative and the AI study planning is a nice touch. Minor issues with notification system.',
        scoredAt: now.subtract(const Duration(days: 8, hours: 2)),
      ),
    ];

    // Save all data
    await saveEvents(events);
    await saveTeams(teams);
    await saveSubmissions(submissions);
    await saveJudgeScores(judgeScores);
    await markInitialized();

    if (kDebugMode) {
      print('Sample data initialized successfully!');
      print('- ${events.length} events');
      print('- ${teams.length} teams');
      print('- ${submissions.length} submissions');
      print('- ${judgeScores.length} judge scores');
    }
  }

  /// Load all data
  static Future<Map<String, dynamic>> loadAllData() async {
    return {
      'events': await loadEvents(),
      'teams': await loadTeams(),
      'submissions': await loadSubmissions(),
      'judgeScores': await loadJudgeScores(),
    };
  }
}
