# Lewach: Digitalizing the Traditional Ethiopian Product Exchange System

## Introduction

Lewach is a mobile application that digitalizes the traditional Ethiopian product exchange system, allowing users to trade goods digitally. This app is primarily designed for Ethiopian users, focusing on middle and lower-class communities, enabling them to exchange products in a modern, user-friendly way. Lewach provides a platform where users can list their products, set eligibility criteria for exchange, and trade goods seamlessly.


[Final Project Blog Article](#)  
[Author's LinkedIn](https://www.linkedin.com/in/natnael-kebede-13553a197/)

---

## 💻 Technical Challenges and Decisions
Developing Lewach was a mix of excitement and a steep learning curve. Here are a few key technical aspects:

## 1. State Management with GetX
Managing multiple screens and complex user interactions was a challenge, and I chose GetX for state management. This solution gave me control over state, dependency injection, and routing in one cohesive package, reducing the need for boilerplate code. I spent a significant amount of time optimizing the app's performance using this approach.

## 2. Firebase Backend
Firebase Firestore is the backbone of Lewach. It powers:

User Authentication (leveraging phone numbers for accessibility, especially in rural areas).
Real-time Listings: Items listed for trade are stored and fetched in real time, ensuring users always see the latest offers.
Firebase was chosen for its scalability, but working with its free Spark plan posed some limitations. As the app grows, I plan to transition to more robust pricing tiers to handle increased user load.

## 3. UI/UX Design
One of the most challenging aspects was designing a user interface that felt familiar yet modern. I wanted the app to appeal to both tech-savvy users and those less familiar with mobile technology. I faced difficulties making the app responsive and ensuring images weren’t cut off in the grid views, but I learned a lot about using BoxFit and other layout tools in Flutter.


In future iterations, I envision integrating AI-based matching suggestions, where the app could suggest optimal trades based on user history and preferences, making exchanges even smoother.

## 🚧 Struggles and Growth
This project wasn’t without struggles. I learned a lot about balancing feature development with bug fixing and improving the UI/UX.

However, these struggles led to some of my most significant growth moments. I developed stronger problem-solving skills and learned the importance of prioritization when resources are limited.

## 🎯 Next Steps and Vision
Lewach is just the beginning. Here are some future features and improvements I want to implement:

AI-Powered Trade Recommendations: Using machine learning to suggest trades based on users' history and preferences.
Expanded User Base: With plans to scale up the app, I aim to reach users in neighboring countries who might benefit from this kind of digital barter system.
Offline Mode: I want to introduce offline capabilities for users in areas with unreliable internet access.
Sustainability Initiatives: Encourage users to trade eco-friendly products or recycle used items to promote sustainability through the Lewach platform.


## Installation

To run this project locally, follow these steps:

1. **Clone the repository**:
   \`\`\`bash
   git clone https://github.com/your-username/lewach.git
   \`\`\`

2. **Navigate to the project directory**:
   \`\`\`bash
   cd lewach
   \`\`\`

3. **Install dependencies**:
   \`\`\`bash
   flutter pub get
   \`\`\`

4. **Set up Firebase**:

   - Create a Firebase project in the Firebase console.
   - Add Android and iOS apps to the Firebase project.
   - Download and place the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files in their respective directories.
   - Update Firebase authentication methods and Firestore database rules.

5. **Run the app**:
   \`\`\`bash
   flutter run
   \`\`\`

---

## Usage

Once installed, you can use the Lewach app to:

- **Add Items**: List products that you wish to trade, including details such as product name, status, and eligible items for exchange.
- **Browse Listings**: Explore products available for trade from other users.
- **Product Exchange**: Engage in direct item-for-item trades with other users based on mutually agreed terms.
- **Notifications**: Get notified when someone is interested in exchanging products with you.

---

## Contributing

We welcome contributions to improve Lewach! Here's how you can help:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a Pull Request.

For major changes, please open an issue to discuss what you would like to change.

---

## Related Projects

Here are some similar or related projects you might find interesting:

- [SwapIt](https://example.com): A platform for trading everyday items with a global community.
- [TradeBuddy](https://example.com): An app for trading services and goods locally.
- [BarterWorld](https://example.com): A decentralized bartering system for goods and services.

---

## Licensing

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
