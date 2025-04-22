# 🦷 DentaCarts Flutter

[![Flutter](https://img.shields.io/badge/Flutter-blue?logo=flutter)](https://flutter.dev)

**DentaCarts Flutter** is a specialized e-commerce application built using Flutter, designed specifically for dental products. Whether you're a customer looking to purchase dental supplies or an admin managing products and orders, DentaCarts provides a seamless and efficient experience.

This app supports **FAWaterk** as the sole payment gateway, ensuring secure and reliable transactions. It also includes advanced features like **state management using Cubit**, **wishlist functionality**, and **API integration with a Node.js backend**. The app is optimized for both **mobile users** and **admin management**, with distinct screens for each role.

---

## 🔧 Key Functionalities

### **Payment Integration**
- **FAWaterk**: The app exclusively uses Flutterwave for secure payment processing. This ensures reliability and compliance with global payment standards.

### **Mobile Screens**
- **Home Screen**: Browse featured dental products and categories.
- **Product Details**: View detailed information about each product, including options to add to cart or wishlist.
- **Shopping Cart**: Manage items in your cart, adjust quantities, and proceed to checkout securely via Flutterwave.
- **Wishlist**: Save favorite products for future reference or purchase. Wishlist data is synced across devices using the backend API.
- **Order History**: View past orders and their statuses.

### **Admin Screens**
- **Dashboard**: Access analytics and manage key metrics such as sales, revenue, and customer behavior.
- **Product Management**: Add new products, update existing ones, or remove discontinued items. Organize products into categories for easy navigation.
- **Order Management**: Handle customer orders efficiently, update order statuses, and process refunds.
- **Export Reports**: Generate PDF reports for products and orders for offline analysis.

---

## 🛠️ State Management with Cubit

The app leverages **Cubit**, part of the **flutter_bloc** package, for efficient state management. Cubit simplifies the handling of complex UI states and ensures smooth transitions between different app functionalities.

### **Key Features Managed by Cubit**
- **Wishlist Management**: Handles adding, removing, and fetching wishlist items.
- **Cart Management**: Manages cart operations such as adding, removing, and updating quantities.
- **Authentication**: Manages user login, registration, and session persistence.
- **Order Status Updates**: Tracks and updates the status of orders in real-time.
---

## 🌐 Backend Integration (Node.js)

The app's backend is powered by a **Node.js** server, which handles all API requests for product management, order processing, wishlist functionality, and more. Below are the key components of the backend:

### **Endpoints**
1. **Product Management**:
   - `GET /products`: Fetch all products.
   - `POST /products`: Add a new product (Admin only).
   - `PUT /products/:productId`: Update an existing product (Admin only).
   - `DELETE /products/:productId`: Delete a product (Admin only).

2. **Order Management**:
   - `GET /orders`: Fetch all orders (Admin only).
   - `POST /orders`: Create a new order.
   - `PUT /orders/:orderId`: Update order status (Admin only).

3. **Wishlist Management**:
   - `POST /wishlist/add`: Add a product to the wishlist.
   - `DELETE /wishlist/remove/:productId`: Remove a product from the wishlist.
   - `GET /wishlist`: Fetch all wishlist items for the logged-in user.

4. **Authentication**:
   - `POST /auth/register`: Register a new user.
   - `POST /auth/login`: Authenticate a user.
   - `POST /auth/logout`: Log out a user.

### **Database**
- The backend uses **MongoDB** as the database to store product, order, wishlist, and user data.
- User authentication is handled using **JWT (JSON Web Tokens)** for secure session management.

---

## 🚀 Getting Started

### Prerequisites
Before running the project, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/) for the backend server
- [MongoDB](https://www.mongodb.com/) for the database

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/engyahmed7/DentaCarts_flutter.git
   ```
2. Navigate to the project directory:
   ```bash
   cd DentaCarts_flutter
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---


## ⚙️ Development Workflow

### Contribution Guidelines
1. Fork the repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature description"
   ```
4. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Create a pull request to the main repository.
