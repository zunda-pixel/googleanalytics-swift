public struct Item: Encodable, Sendable {
  public var id: String?
  public var name: String?
  public var affiliation: String?
  public var category: String?
  public var category2: String?
  public var category3: String?
  public var category4: String?
  public var category5: String?
  public var variant: String?
  public var brand: String?
  public var price: Price?
  public var discount: Double?
  public var index: UInt?
  public var quantity: UInt?
  public var coupon: String?
  public var listId: String?
  public var listName: String?
  public var locationId: String?

  public init(
    id: String? = nil,
    name: String? = nil,
    affiliation: String? = nil,
    category: String? = nil,
    category2: String? = nil,
    category3: String? = nil,
    category4: String? = nil,
    category5: String? = nil,
    variant: String? = nil,
    brand: String? = nil,
    price: Price? = nil,
    discount: Double? = nil,
    index: UInt? = nil,
    quantity: UInt? = nil,
    coupon: String? = nil,
    listId: String? = nil,
    listName: String? = nil,
    locationId: String? = nil
  ) {
    self.id = id
    self.name = name
    self.affiliation = affiliation
    self.category = category
    self.category2 = category2
    self.category3 = category3
    self.category4 = category4
    self.category5 = category5
    self.variant = variant
    self.brand = brand
    self.price = price
    self.discount = discount
    self.index = index
    self.quantity = quantity
    self.coupon = coupon
    self.listId = listId
    self.listName = listName
    self.locationId = locationId
  }

  private enum CodingKeys: String, CodingKey {
    case id = "item_id"
    case name = "item_name"
    case affiliation
    case category
    case category2
    case category3
    case category4
    case category5
    case variant
    case brand
    case value
    case currency
    case discount
    case index
    case quantity
    case coupon
    case listId = "list_id"
    case listName = "list_name"
    case locationId
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(id, forKey: .id)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(affiliation, forKey: .affiliation)
    try container.encodeIfPresent(category, forKey: .category)
    try container.encodeIfPresent(category2, forKey: .category2)
    try container.encodeIfPresent(category3, forKey: .category3)
    try container.encodeIfPresent(category4, forKey: .category4)
    try container.encodeIfPresent(category5, forKey: .category5)
    try container.encodeIfPresent(variant, forKey: .variant)
    try container.encodeIfPresent(brand, forKey: .brand)
    try container.encodeIfPresent(price?.value, forKey: .value)
    try container.encodeIfPresent(price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(discount, forKey: .discount)
    try container.encodeIfPresent(index, forKey: .index)
    try container.encodeIfPresent(quantity, forKey: .quantity)
    try container.encodeIfPresent(coupon, forKey: .coupon)
    try container.encodeIfPresent(listId, forKey: .listId)
    try container.encodeIfPresent(listName, forKey: .listName)
    try container.encodeIfPresent(locationId, forKey: .locationId)
  }
}
