import Foundation
import MemberwiseInit

extension Event {
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
  public static func addPaymentInfo(
    coupon: String? = nil,
    paymentType: String? = nil,
    price: Price? = nil,
    items: [Item] = [],
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "add_payment_info",
      timestamp: timestamp,
      parameters: AddPaymentInfoParameters(
        coupon: coupon,
        paymentType: paymentType,
        price: price,
        items: items,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit
public struct AddPaymentInfoParameters: Encodable {
  public var coupon: String?
  public var paymentType: String?
  public var price: Price?
  public var items: [Item]
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case coupon
    case paymentType = "payment_type"
    case currency
    case value
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.paymentType, forKey: .paymentType)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encode(self.items, forKey: .items)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

extension Event {
  /// Add Shipping Info event.
  ///
  /// This event signifies that a user has submitted their shipping information.
  public static func addShippingInfo(
    coupon: String? = nil,
    shippingTier: String? = nil,
    price: Price? = nil,
    items: [Item] = [],
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "add_shipping_info",
      timestamp: timestamp,
      parameters: AddShippingInfoParameters(
        coupon: coupon,
        shippingTier: shippingTier,
        price: price,
        items: items,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit
public struct AddShippingInfoParameters: Encodable {
  public var coupon: String?
  public var shippingTier: String?
  public var price: Price?
  public var items: [Item]
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case coupon
    case shippingTier = "shipping_tier"
    case currency
    case value
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.shippingTier, forKey: .shippingTier)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encode(self.items, forKey: .items)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

extension Event {
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
  public static func addToCart(
    items: [Item],
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "add_to_cart",
      timestamp: timestamp,
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit
public struct CartItemParameters: Encodable {
  public var items: [Item]
  public var price: Price?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case items
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

extension Event {

  /// E-Commerce Add To Wishlist event.
  ///
  /// This event signifies that an item was added to a wishlist.
  /// Use this event to identify popular gift items.
  /// ```swift
  /// try await analytics.addToWishlist(
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ],
  ///   price: Price(currency: .usd, value: 39.98)
  /// )
  /// ```
  public static func addToWishlist(
    items: [Item],
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "add_to_wishlist",
      timestamp: timestamp,
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// E-Commerce Begin Checkout event.
  ///
  /// This event signifies that a user has begun the process of checking out.
  /// Add this event to a funnel with your purchase event to gauge the effectiveness of your checkout process.
  public static func beginCheckout(
    items: [Item],
    coupon: String? = nil,
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "begin_checkout",
      timestamp: timestamp,
      parameters: BeginCheckoutParameters(
        items: items,
        coupon: coupon,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

public struct BeginCheckoutParameters: Encodable {
  public var items: [Item]
  public var coupon: String?
  public var price: Price?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case items
    case coupon
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.items, forKey: .items)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit()
public struct PurchaseParameters: Encodable {
  public var transactionId: String?
  public var coupon: String?
  public var tax: Double?
  public var price: Price?
  public var shipping: Double?
  public var items: [Item]
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
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

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.transactionId, forKey: .transactionId)
    try container.encodeIfPresent(self.coupon, forKey: .coupon)
    try container.encodeIfPresent(self.tax, forKey: .tax)
    try container.encodeIfPresent(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.shipping, forKey: .shipping)
    try container.encode(self.items, forKey: .items)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

extension Event {
  /// E-Commerce Purchase event.
  ///
  /// This event signifies that an item(s) was purchased by a user.
  public static func purchase(
    transactionId: String? = nil,
    coupon: String? = nil,
    tax: Double? = nil,
    price: Price? = nil,
    shipping: Double? = nil,
    items: [Item],
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "purchase",
      timestamp: timestamp,
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
  }

  /// E-Commerce Refund event.
  ///
  /// This event signifies that a refund was issued.
  public static func refund(
    transactionId: String? = nil,
    coupon: String? = nil,
    tax: Double? = nil,
    price: Price? = nil,
    shipping: Double? = nil,
    items: [Item]? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "refund",
      timestamp: timestamp,
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
  }

  /// E-Commerce Remove from Cart event.
  ///
  /// This event signifies that an item(s) was removed from a cart.
  public static func removeFromCart(
    items: [Item],
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "remove_from_cart",
      timestamp: timestamp,
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// E-commerce View Cart event.
  ///
  /// This event signifies that a user has viewed their cart.
  /// Use this to analyze your purchase funnel.
  public static func viewCart(
    items: [Item],
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "view_cart",
      timestamp: timestamp,
      parameters: CartItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}
