# BuyIt

Feature-first Flutter app for discovering shops and items, with category browsing, favourites, profile, and cart.

## Structure (Feature-first)

```
lib/
  core/
    data/            # DataProvider, local JSON loaders, API fallbacks
    models/          # Product, Shop, Review, etc.
    providers/       # CartProvider, others
    services/        # StorageService, LocationService, FavouritesService
    widgets/         # Reusable UI widgets (ProductCard, Shimmers)
  features/
    home/            # HomeScreen (+ helper widgets)
    categories/      # CategoriesScreen (browse all subcategories)
    items/           # ItemScreen (shops/products within a category)
    shops/           # ShopDetailScreen, ShopsNearYou
    favourites/      # FavouritesScreen
    profile/         # ProfileScreen
    auth/            # Onboarding, LoginScreen, SignupScreen
```

Note: Files are currently under `lib/screens/`, `lib/data/`, `lib/models/`, `lib/services/`, etc. Moving to the above folders is planned; imports will be updated accordingly.

## Naming conventions

- Files: `snake_case.dart` (e.g., `item_screen.dart`)
- Classes: `PascalCase` (e.g., `ItemScreen`)
- Constants: `camelCase` or `SCREAMING_SNAKE_CASE` for top-level consts
- Private members: prefix with `_`

## Navigation contracts

- `ItemScreen`
  - `initialFilter` (String?):
    - If `initialIsCategory == true` → main category title
    - If `false` → subcategory filter value (maps to display title)
  - `initialIsCategory` (bool?): indicates source context
  - `initialCategoryTitle` (String?): parent category name when opened via subcategory

## Data model links

- `assets/data/categories.json` provides:
  - Main category names (used for shop grouping)
  - Subcategories with `title` (display) and `filter` (machine key)
- `assets/data/products.json`
  - Each product `category` must equal a subcategory `filter` value
- `assets/data/shops.json`
  - Each shop `categories` must include main category names (e.g., `Grocery`, `Beauty & Personal Care`)

## Avatar persistence and refresh

- Profile image is stored via `StorageService` under `StorageKeys.profileImagePath`
- `HomeScreen` reloads avatar on navigation changes and app resume (`WidgetsBindingObserver`)
- After picking a new file image, `FileImage(...).evict()` is called to bust cache for immediate UI update

## Common flows

- Home → tap a main category card → `ItemScreen` opens with that category (title matches category)
- Home/Categories → tap a subcategory → `ItemScreen` opens with that chip preselected
- ItemScreen chips:
  - `All`: shows shops for current main category
  - Subcategory chip: shows products filtered by subcategory `filter`, further constrained to shops under the current main category

## Development notes

- Shop ID is a `String` (e.g., `"shop_001"`). `Product.shopId` matches it. This enables `getProducts(shopId)` to filter correctly.
- If a subcategory shows no items, verify `products.json` uses the correct `filter` value from `categories.json`.
- To add a new main category:
  1) Add it to `categories.json` with subcategories
  2) Ensure shops that belong to it include the main category in their `categories`
  3) Seed products with `category` set to a subcategory `filter`
