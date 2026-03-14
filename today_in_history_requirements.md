# Today In History - iOS App Requirements Specification

## 1. Overview
An iOS mobile application that delivers daily historical facts from around the world, providing users with engaging, educational content across different regions and cultures.

## 2. Target Platforms
- iOS only (iPhone and iPad)
- Minimum deployment target: iOS 17
- Supported devices: iPhone 13 and newer, iPad Pro and newer generations

## 3. Core Functionality

### 3.1 Historical Fact Retrieval
- Daily fetch of 5 historical facts, one from each major world region:
  - North America (US/Canada)
  - Europe
  - Asia
  - Africa
  - South America

- Fact Characteristics:
  - 2-3 minute total reading time
  - Broken into manageable content chunks
  - Categorized by region/culture
  - Include images when possible
  - Provide link to full external article

### 3.2 User Preferences (Pro Feature)
- Configurable topic preferences (Pro Users Only):
  - Sports
  - History
  - Politics
  - Entertainment
  - Science
  - Technology
  - Social Movements
  - Military/Conflict History

### 3.3 Free Tier Preference Handling
- Free tier users will have all topics selected by default
- Pro users can customize preferences via Profile Page
- Preferences can be updated at any time

## 4. Fact Regeneration
- Free Tier:
  - Ability to regenerate facts 1 time per day
- Pro Tier:
  - Ability to regenerate facts up to 5 times per day

## 5. User Interface
### 5.1 Screens
- Main Page: Daily historical facts
- Profile Page: User preferences, subscription status
- Fact Detail Page: Expanded fact view with regenerate button
- External Link Handling: Confirm before leaving app to Safari/default browser

### 5.2 UI/UX Principles
- Modern, clean design
- Dark and light mode support
- Accessibility features:
  - VoiceOver support
  - Dynamic type sizing
  - Color contrast compliance

## 6. Technical Architecture

### 6.1 Backend & Data Management
- Supabase for:
  - User authentication
  - User preference storage
  - Usage tracking
  - Subscription management

### 6.2 Authentication
- Sign in with Apple
- Guest mode for free tier users
- Seamless pro tier upgrade path

### 6.3 Data Sources Strategy
- Primary Source: Wikipedia API
  - Comprehensive historical content
  - Global coverage across 5 major regions
  - Free and reliable endpoint
  - No additional licensing costs

- Image Retrieval
  - Use first available image from Wikipedia article
  - Fallback to default historical icon if no image present

- Content Selection Method
  - Utilize Wikipedia's "On This Day" and historical category pages
  - Cross-reference multiple language versions for global perspective
  - Implement lightweight caching to reduce API calls

### 6.4 Additional Technical Features
- Background fetch for daily content updates
- CoreData for local fact caching
- Save favorite historical facts
- Share functionality for facts
- Daily reminder/notification option

## 7. Monetization Strategy
- Free Tier:
  - Limited daily fact regenerations
  - Basic historical content
- Pro Tier:
  - Unlimited fact regenerations
  - Ad-free experience
  - Early access to premium content
- Implemented via Apple StoreKit
- Transparent pricing in App Store description

## 8. Performance Requirements
- App size under 50MB
- Minimal battery consumption
- Efficient data usage
- Quick fact loading (<2 seconds)

## 9. Compliance & Privacy
- GDPR compliance
- Apple App Store guidelines adherence
- Transparent data usage policy
- User data minimization

## 10. Future Roadmap Considerations
- International language support
- User-submitted historical fact suggestions
- More granular historical topic selection
- Integration with educational platforms

## 11. Technical Stack
- Language: Swift
- Framework: SwiftUI
- Backend: Supabase
- Payment: Apple StoreKit
- Authentication: Sign in with Apple

## 12. Development Milestones
1. Prototype and API integration
2. Core UI development
3. Authentication and user management
4. Fact generation and caching
5. Monetization implementation
6. Testing and refinement
7. App Store submission

## Appendix: API Considerations
- Wikipedia API (Primary Source)
- Wikimedia Commons for images

## Open Questions/Discussions
- Precise image licensing and attribution
- Depth of historical fact context
- Moderation strategy for historical content
