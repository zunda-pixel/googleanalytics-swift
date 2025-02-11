import Foundation

extension GoogleAnalytics {
  /// Add Payment Info event.
  ///
  /// This event signifies that a user has submitted their payment information.
  /// ```swift
  /// try await analytics.addPaymentInfo(
  ///   coupon: "SUMMER_FUN",
  ///   paymentType: "Visa",
  ///   price: Price(currency: .usd, value: 39.98),
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ]
  /// )
  /// ```
  public func addPaymentInfo(
    coupon: String? = nil,
    paymentType: String? = nil,
    price: Price? = nil,
    items: [Item],
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "add_payment_info",
      parameters: AddPaymentInfoParameters(
        coupon: coupon,
        paymentType: paymentType,
        price: price,
        items: items,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    
    try await log(for: event)
  }
}

struct AddPaymentInfoParameters: Encodable {
  var coupon: String?
  var paymentType: String?
  var price: Price?
  var items: [Item]
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  enum CodingKeys: String, CodingKey {
    case coupon
    case paymentType = "payment_type"
    case currency
    case value
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.paymentType, forKey: .paymentType)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

extension GoogleAnalytics {
  /// Add Shipping Info event.
  ///
  /// This event signifies that a user has submitted their shipping information.
  public func addShippingInfo(
    coupon: String? = nil,
    shippingTier: String? = nil,
    price: Price? = nil,
    items: [Item],
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "add_shipping_info",
      parameters: AddShippingInfoParameters(
        coupon: coupon,
        shippingTier: shippingTier,
        price: price,
        items: items,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    
    try await log(for: event)
  }
}

struct AddShippingInfoParameters: Encodable {
  var coupon: String?
  var shippingTier: String?
  var price: Price?
  var items: [Item]
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  enum CodingKeys: String, CodingKey {
    case coupon
    case shippingTier = "shipping_tier"
    case currency
    case value
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.shippingTier, forKey: .shippingTier)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

extension GoogleAnalytics {
  /// E-Commerce Add To Cart event.
  ///
  /// This event signifies that an item(s) was added to a cart for purchase.
  /// Add this event to a funnel with purchase to gauge the effectiveness of your checkout process.
  /// ```swift
  /// try await analytics.addToCart(
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ],
  ///   price: Price(currency: .usd, value: 39.98)
  /// )
  /// ```
  public func addToCart(
    items: [Item],
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "add_to_cart",
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }
}

struct CartItemParameters: Encodable {
  var items: [Item]
  var price: Price?
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  enum CodingKeys: String, CodingKey {
    case items
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

extension GoogleAnalytics {
  
  /// E-Commerce Add To Wishlist event.
  ///
  /// This event signifies that an item was added to a wishlist.
  /// Use this event to identify popular gift items.
  /// ```swift
  /// try await analytics.addToWithlist(
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ],
  ///   price: Price(currency: .usd, value: 39.98)
  /// )
  /// ```
  public func addToWithlist(
    items: [Item],
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "add_to_wishlist",
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }
}

extension GoogleAnalytics {
  /// E-Commerce Begin Checkout event.
  ///
  /// This event signifies that a user has begun the process of checking out.
  /// Add this event to a funnel with your purchase event to gauge the effectiveness of your checkout process.
  public func beginCheckout(
    items: [Item],
    coupon: String? = nil,
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "begin_checkout",
      parameters: BeginCheckoutParameters(
        items: items,
        coupon: coupon,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }
}

struct BeginCheckoutParameters: Encodable {
  var items: [Item]
  var coupon: String?
  var price: Price?
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  enum CodingKeys: String, CodingKey {
    case items
    case coupon
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

struct PurchaseParameters: Encodable {
  var transactionId: String?
  var coupon: String?
  var tax: Double?
  var price: Price?
  var shipping: Double?
  var items: [Item]
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  enum CodingKeys: String, CodingKey {
    case transactionId = "transaction_id"
    case coupon
    case tax
    case currency
    case value
    case shipping
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.transactionId, forKey: .transactionId)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.tax, forKey: .tax)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.shipping, forKey: .shipping)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

extension GoogleAnalytics {
  /// E-Commerce Purchase event.
  ///
  /// This event signifies that an item(s) was purchased by a user.
  public func purchase(
    transactionId: String? = nil,
    coupon: String? = nil,
    tax: Double? = nil,
    price: Price? = nil,
    shipping: Double? = nil,
    items: [Item],
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "purchase",
      parameters: PurchaseParameters(
        transactionId: transactionId,
        coupon: coupon,
        tax: tax,
        price: price,
        shipping: shipping,
        items: items,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// E-Commerce Refund event.
  ///
  /// This event signifies that a refund was issued.
  public func refund(
    transactionId: String? = nil,
    coupon: String? = nil,
    tax: Double? = nil,
    price: Price? = nil,
    shipping: Double? = nil,
    items: [Item]? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "refund",
      parameters: PurchaseParameters(
        transactionId: transactionId,
        coupon: coupon,
        tax: tax,
        price: price,
        shipping: shipping,
        items: items ?? [],
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// E-Commerce Remove from Cart event.
  ///
  /// This event signifies that an item(s) was removed from a cart.
  public func removeFromCart(
    items: [Item],
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "remove_from_cart",
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// E-commerce View Cart event.
  ///
  /// This event signifies that a user has viewed their cart.
  /// Use this to analyze your purchase funnel.
  public func viewCart(
    items: [Item],
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "view_cart",
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }
}
