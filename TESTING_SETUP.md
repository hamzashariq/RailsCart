# RSpec Testing Setup

This project now has a comprehensive RSpec testing setup with the following features:

## Testing Gems Added

- **rspec-rails** (~> 6.1.0) - Main testing framework
- **factory_bot_rails** - For creating test data
- **faker** - For generating realistic fake data
- **shoulda-matchers** - For concise model testing
- **database_cleaner-active_record** - For cleaning test database between tests

## Test Configuration

### RSpec Configuration (`spec/rails_helper.rb`)
- FactoryBot syntax methods included
- Shoulda Matchers configured for Rails
- Database Cleaner configured for transaction strategy
- Devise test helpers included for authentication testing

### Support Files (`spec/support/`)
- `database_cleaner.rb` - Database cleaning configuration
- `devise.rb` - Authentication helpers for controller tests

## Factories (`spec/factories/`)

Comprehensive factories created for all models:

- **Companies** - With unique subdomains and content
- **Users** - With admin/customer traits and Devise integration
- **Products** - With price/stock traits (expensive, cheap, out_of_stock)
- **Carts** - With optional product associations
- **CartsProducts** - Join table with quantity variations
- **Orders** - With status traits and associations
- **Reviews** - With rating-based traits (excellent, good, average, poor, terrible)
- **DeliveryInformation** - With realistic address data
- **ProductSnapshots** - For order history
- **OrderHistories** - For tracking order status changes

## Model Tests (`spec/models/`)

Comprehensive test coverage for all models:

### User Model Tests
- Associations (company, cart, orders, avatar)
- Validations (name, email, user_type)
- Devise integration
- Callbacks (automatic cart creation)
- Instance methods (name, admin?, customer?)
- Multi-tenancy scoping

### Product Model Tests
- Associations (company, carts_products, reviews, image)
- Average rating calculation
- Ransack searchable attributes
- Multi-tenancy scoping
- Factory traits

### Cart Model Tests
- Associations (company, user, carts_products)
- Business logic (total_items, total_price, empty!)
- Multi-tenancy scoping

### Order Model Tests
- Associations and nested attributes
- Enum definitions and methods
- Callbacks (history tracking)
- Status transitions
- Total calculation
- Multi-tenancy scoping

### Review Model Tests
- Associations (user, product, images)
- Validations (rating range, uniqueness)
- Image attachment limits
- Impact on product ratings

### Company Model Tests
- Associations (users, products, carts, orders)
- Validations (name, subdomain uniqueness)

### CartsProduct Model Tests
- Join table associations
- Factory traits

## Test Statistics

- **109 test examples** with **0 failures**
- **2 pending tests** (DeliveryInformation and ProductSnapshot - placeholders)
- Comprehensive coverage of:
  - Model associations
  - Validations
  - Business logic methods
  - Callbacks
  - Multi-tenancy
  - Factory data creation

## Running Tests

```bash
# Run all model tests
bundle exec rspec spec/models

# Run specific model test
bundle exec rspec spec/models/user_spec.rb

# Run with documentation format
bundle exec rspec spec/models --format documentation

# Run with progress format
bundle exec rspec spec/models --format progress
```

## Key Features Tested

1. **Multi-tenancy** - All models properly scoped to companies
2. **User Authentication** - Devise integration with user types
3. **E-commerce Logic** - Cart calculations, order workflows, product reviews
4. **Data Integrity** - Validations, uniqueness constraints, associations
5. **Business Workflows** - Order status tracking, cart management
6. **File Attachments** - Product images, review images with limits

## Notes

- The project uses PostgreSQL with proper foreign key constraints
- All tests use database transactions for isolation
- FactoryBot provides realistic test data using Faker
- Shoulda Matchers provide concise association and validation testing
- Multi-tenant architecture is properly tested with ActsAsTenant

This testing setup provides a solid foundation for maintaining code quality and catching regressions as the application evolves. 