import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

// Sample data for sponsors
final List<Sponsor> _sampleSponsors = [
  const Sponsor(
    id: 'google',
    name: 'Google',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg',
    websiteUrl: 'https://google.com',
    tier: 'platinum',
  ),
  const Sponsor(
    id: 'microsoft',
    name: 'Microsoft',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/9/96/Microsoft_logo_%282012%29.svg',
    websiteUrl: 'https://microsoft.com',
    tier: 'platinum',
  ),
  const Sponsor(
    id: 'meta',
    name: 'Meta',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/7/7b/Meta_Platforms_Inc._logo.svg',
    websiteUrl: 'https://meta.com',
    tier: 'gold',
  ),
  const Sponsor(
    id: 'amazon',
    name: 'Amazon',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
    websiteUrl: 'https://amazon.com',
    tier: 'gold',
  ),
  const Sponsor(
    id: 'apple',
    name: 'Apple',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
    websiteUrl: 'https://apple.com',
    tier: 'platinum',
  ),
  const Sponsor(
    id: 'nvidia',
    name: 'NVIDIA',
    logoUrl: 'https://upload.wikimedia.org/wikipedia/sco/2/21/Nvidia_logo.svg',
    websiteUrl: 'https://nvidia.com',
    tier: 'gold',
  ),
  const Sponsor(
    id: 'mongodb',
    name: 'MongoDB',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/9/93/MongoDB_Logo.svg',
    websiteUrl: 'https://mongodb.com',
    tier: 'silver',
  ),
  const Sponsor(
    id: 'vercel',
    name: 'Vercel',
    logoUrl:
        'https://assets.vercel.com/image/upload/q_auto/front/favicon/vercel/180x180.png',
    websiteUrl: 'https://vercel.com',
    tier: 'silver',
  ),
];

// Sample data for job opportunities
final List<JobOpportunity> _sampleJobs = [
  JobOpportunity(
    id: 'google-swe-intern',
    title: 'Software Engineering Intern',
    company: 'Google',
    companyLogoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg',
    description:
        'Join Google\'s engineering team to work on products used by billions of users.',
    applyUrl: 'https://careers.google.com/jobs/results/123456789/',
    location: 'Mountain View, CA',
    salary: '\$8,000/month',
    type: 'internship',
    tags: ['Software Engineering', 'Full Stack', 'Machine Learning'],
    postedDate: DateTime.now().subtract(const Duration(days: 2)),
    applicationDeadline: DateTime.now().add(const Duration(days: 30)),
  ),
  JobOpportunity(
    id: 'meta-frontend',
    title: 'Frontend Developer',
    company: 'Meta',
    companyLogoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/7/7b/Meta_Platforms_Inc._logo.svg',
    description: 'Build the next generation of social experiences.',
    applyUrl: 'https://careers.facebook.com/jobs/123456789/',
    location: 'Menlo Park, CA',
    salary: '\$140k - \$180k',
    type: 'full-time',
    tags: ['React', 'JavaScript', 'UI/UX'],
    postedDate: DateTime.now().subtract(const Duration(days: 5)),
    applicationDeadline: DateTime.now().add(const Duration(days: 21)),
  ),
  JobOpportunity(
    id: 'amazon-ml-engineer',
    title: 'Machine Learning Engineer',
    company: 'Amazon',
    companyLogoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
    description:
        'Work on cutting-edge ML systems that power Amazon\'s recommendations.',
    applyUrl: 'https://amazon.jobs/en/jobs/123456789/',
    location: 'Seattle, WA',
    prize: 'Best Hack Prize: \$10,000',
    type: 'full-time',
    tags: ['Machine Learning', 'Python', 'AWS'],
    postedDate: DateTime.now().subtract(const Duration(days: 1)),
    applicationDeadline: DateTime.now().add(const Duration(days: 45)),
  ),
  JobOpportunity(
    id: 'nvidia-gpu-compute',
    title: 'GPU Compute Specialist',
    company: 'NVIDIA',
    companyLogoUrl:
        'https://upload.wikimedia.org/wikipedia/sco/2/21/Nvidia_logo.svg',
    description: 'Develop high-performance computing solutions using CUDA.',
    applyUrl: 'https://nvidia.wd5.myworkdayjobs.com/123456789/',
    location: 'Santa Clara, CA',
    salary: '\$120k - \$160k',
    type: 'full-time',
    tags: ['CUDA', 'C++', 'High Performance Computing'],
    postedDate: DateTime.now().subtract(const Duration(days: 3)),
    applicationDeadline: DateTime.now().add(const Duration(days: 28)),
  ),
  JobOpportunity(
    id: 'mongodb-devrel',
    title: 'Developer Relations Engineer',
    company: 'MongoDB',
    companyLogoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/9/93/MongoDB_Logo.svg',
    description: 'Help developers build amazing applications with MongoDB.',
    applyUrl: 'https://mongodb.com/careers/jobs/123456789/',
    location: 'Remote',
    salary: '\$90k - \$130k',
    type: 'full-time',
    tags: ['Developer Relations', 'MongoDB', 'Community'],
    postedDate: DateTime.now().subtract(const Duration(days: 7)),
    applicationDeadline: DateTime.now().add(const Duration(days: 14)),
  ),
  JobOpportunity(
    id: 'vercel-frontend-intern',
    title: 'Frontend Engineering Intern',
    company: 'Vercel',
    companyLogoUrl:
        'https://assets.vercel.com/image/upload/q_auto/front/favicon/vercel/180x180.png',
    description: 'Build the future of web development tools.',
    applyUrl: 'https://vercel.com/careers/123456789/',
    location: 'San Francisco, CA',
    prize: 'Internship Stipend: \$5,000',
    type: 'internship',
    tags: ['React', 'Next.js', 'TypeScript'],
    postedDate: DateTime.now().subtract(const Duration(days: 4)),
    applicationDeadline: DateTime.now().add(const Duration(days: 20)),
  ),
];

// Providers
final sponsorsProvider = Provider<List<Sponsor>>((ref) {
  return _sampleSponsors;
});

final jobOpportunitiesProvider = Provider<List<JobOpportunity>>((ref) {
  return _sampleJobs;
});

// Filtered providers
final platinumSponsorsProvider = Provider<List<Sponsor>>((ref) {
  final sponsors = ref.watch(sponsorsProvider);
  return sponsors.where((sponsor) => sponsor.tier == 'platinum').toList();
});

final goldSponsorsProvider = Provider<List<Sponsor>>((ref) {
  final sponsors = ref.watch(sponsorsProvider);
  return sponsors.where((sponsor) => sponsor.tier == 'gold').toList();
});

final silverSponsorsProvider = Provider<List<Sponsor>>((ref) {
  final sponsors = ref.watch(sponsorsProvider);
  return sponsors.where((sponsor) => sponsor.tier == 'silver').toList();
});

final activeJobsProvider = Provider<List<JobOpportunity>>((ref) {
  final jobs = ref.watch(jobOpportunitiesProvider);
  return jobs.where((job) => !job.isExpired).toList();
});

final internshipJobsProvider = Provider<List<JobOpportunity>>((ref) {
  final jobs = ref.watch(activeJobsProvider);
  return jobs.where((job) => job.type == 'internship').toList();
});

final fullTimeJobsProvider = Provider<List<JobOpportunity>>((ref) {
  final jobs = ref.watch(activeJobsProvider);
  return jobs.where((job) => job.type == 'full-time').toList();
});
