class ValidationService {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidGitHubUrl(String url) {
    final githubRegex = RegExp(
      r'^https:\/\/github\.com\/[\w\-\.]+\/[\w\-\.]+\/?$',
    );
    return githubRegex.hasMatch(url);
  }

  static bool isValidEventCode(String code) {
    return code.length >= 4 && code.length <= 10 && code.isNotEmpty;
  }

  static bool isValidTeamName(String name) {
    return name.trim().length >= 2 && name.trim().length <= 50;
  }

  static bool isValidProjectTitle(String title) {
    return title.trim().length >= 3 && title.trim().length <= 100;
  }

  static bool isValidDescription(String description) {
    return description.trim().length >= 10 && description.trim().length <= 1000;
  }

  static String? validateEventName(String name) {
    if (name.trim().isEmpty) return 'Event name is required';
    if (name.trim().length < 3) {
      return 'Event name must be at least 3 characters';
    }
    if (name.trim().length > 100) {
      return 'Event name must be less than 100 characters';
    }
    return null;
  }

  static String? validateEventDescription(String description) {
    if (description.trim().isEmpty) return 'Event description is required';
    if (description.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (description.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }

  static String? validateTeamName(String name, {bool isRequired = true}) {
    if (isRequired && name.trim().isEmpty) return 'Team name is required';
    if (name.trim().isNotEmpty && name.trim().length < 2) {
      return 'Team name must be at least 2 characters';
    }
    if (name.trim().length > 50) {
      return 'Team name must be less than 50 characters';
    }
    return null;
  }

  static String? validateProjectTitle(String title) {
    if (title.trim().isEmpty) return 'Project title is required';
    if (title.trim().length < 3) {
      return 'Project title must be at least 3 characters';
    }
    if (title.trim().length > 100) {
      return 'Project title must be less than 100 characters';
    }
    return null;
  }

  static String? validateGitHubUrl(String url) {
    if (url.trim().isEmpty) return 'GitHub URL is required';
    if (!isValidGitHubUrl(url.trim())) return 'Please enter a valid GitHub URL';
    return null;
  }

  static String? validateEventCode(String code) {
    if (code.trim().isEmpty) return 'Event code is required';
    if (!isValidEventCode(code.trim())) {
      return 'Event code must be between 4-10 characters';
    }
    return null;
  }
}
