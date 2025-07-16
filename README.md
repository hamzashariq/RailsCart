# RailsCart - Multi-Tenant E-commerce Platform

A powerful, multi-tenant e-commerce platform built with Ruby on Rails that allows multiple businesses to run their online stores from a single application instance. Each store operates independently with its own subdomain, branding, products, and customers.

## 🚀 Features

### Multi-Tenant Architecture
- **Subdomain-based tenancy**: Each store operates on its own subdomain (e.g., `store1.example.com`, `store2.example.com`)
- **Complete isolation**: Each tenant has separate users, products, orders, and data
- **Scalable design**: Single codebase serves multiple independent stores

### Core E-commerce Features
- **Product Management**: Full CRUD operations for products with image uploads
- **Shopping Cart**: Persistent cart functionality for both logged-in and guest users
- **Order Management**: Complete order lifecycle with status tracking
- **Payment Processing**: Integrated Stripe payments with checkout sessions
- **User Reviews**: Customer review system with ratings
- **Inventory Tracking**: Stock management for products

### Admin Panel
- **ActiveAdmin Integration**: Comprehensive admin interface for store management
- **Dashboard Analytics**: Order statistics, user metrics, and sales data
- **User Management**: Admin and customer user roles with proper authorization
- **Order Tracking**: Real-time order status updates and history

### User Experience
- **Responsive Design**: Mobile-first design with Tailwind CSS
- **Modern UI/UX**: Clean, professional interface with Flowbite components
- **Authentication**: Secure user registration and login with Devise
- **Progressive Web App**: PWA capabilities for mobile app-like experience

## 🛠 Tech Stack

### Backend
- **Ruby**: 3.2.0
- **Rails**: 7.2.0
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Authorization**: Role-based access control
- **Multi-tenancy**: acts_as_tenant gem
- **Payments**: Stripe API
- **Admin Panel**: ActiveAdmin

### Frontend
- **CSS Framework**: Tailwind CSS
- **UI Components**: Flowbite
- **JavaScript**: Stimulus (Hotwire)
- **Turbo**: For SPA-like navigation
- **Asset Pipeline**: Importmap for modern JavaScript

### Development & Testing
- **Testing**: RSpec with FactoryBot and Faker
- **Code Quality**: RuboCop with Rails Omakase configuration
- **Security**: Brakeman for security scanning
- **Development**: Pry for debugging

## 📋 Prerequisites

- Ruby 3.2.0
- PostgreSQL
- Node.js (for asset compilation)
- Stripe account (for payments)

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ecommerce_app
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Setup environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Setup database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

5. **Start the development server**
   ```bash
   bin/dev
   ```

## ⚙️ Configuration

### Environment Variables
Create a `.env` file in the root directory with the following variables:

```env
# Database
DATABASE_URL=postgresql://username:password@localhost/ecommerce_app_development

# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...

# Rails
RAILS_MASTER_KEY=your_master_key
```

### Subdomain Setup
For local development, you'll need to set up subdomain routing:

1. **Add entries to your hosts file** (`/etc/hosts` on macOS/Linux):
   ```
   127.0.0.1 store1.localhost
   127.0.0.1 store2.localhost
   127.0.0.1 admin.localhost
   ```

2. **Or use a service like ngrok** for external testing:
   ```bash
   ngrok http 3000
   ```

## 🏗 Application Structure

### Models
- **Company**: Represents each tenant/store
- **User**: Customers and admins with role-based access
- **Product**: Store inventory with images and reviews
- **Cart**: Shopping cart functionality
- **Order**: Order management with status tracking
- **Review**: Customer product reviews

### Controllers
- **ApplicationController**: Base controller with tenant setup
- **HomeController**: Landing page and store front
- **ProductsController**: Product browsing and details
- **CartsController**: Shopping cart management
- **OrdersController**: Order creation and tracking
- **PaymentsController**: Stripe payment processing

### Key Features Implementation

#### Multi-Tenancy
```ruby
# All models use acts_as_tenant for data isolation
class Product < ApplicationRecord
  acts_as_tenant(:company)
  # ... rest of model
end

# Controllers set tenant by subdomain
class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:company, :subdomain)
  # ... rest of controller
end
```

#### Payment Processing
```ruby
# Stripe integration for secure payments
def create
  session = Stripe::Checkout::Session.create(
    customer_email: current_user.email,
    line_items: [order_line_items],
    mode: "payment",
    success_url: success_payments_url,
    cancel_url: cancel_payments_url
  )
  redirect_to session.url
end
```

## 🧪 Testing

Run the test suite:
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 📊 Admin Panel

Access the admin panel at `/admin_panel` (requires admin user role):

- **Dashboard**: Overview of store statistics
- **Users**: Manage customers and admin users
- **Products**: Add/edit/delete products
- **Orders**: Track and manage orders
- **Companies**: Manage tenant stores

## 🔧 Development

### Adding a New Store
1. Create a new company record with unique subdomain
2. Set up DNS/subdomain routing
3. Create admin user for the new store
4. Configure store-specific settings

### Customization
- **Styling**: Modify Tailwind classes in views
- **Features**: Add new controllers/models following Rails conventions
- **Integrations**: Add new gems and configure in initializers

## 📝 API Documentation

The application provides a web interface, but key endpoints include:

- `GET /products` - Product listing
- `POST /carts_products` - Add to cart
- `POST /orders` - Create order
- `POST /payments` - Process payment

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

Built with ❤️ using Ruby on Rails
