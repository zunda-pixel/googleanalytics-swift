import Foundation
import Testing

@testable import GoogleAnalytics

let client = GoogleAnalytics(
  httpClient: .urlSession(.shared),
  appId: ProcessInfo.processInfo.environment["APP_ID"]!,
  apiSecret: ProcessInfo.processInfo.environment["API_SECRET"]!,
  measurementId: ProcessInfo.processInfo.environment["MEASTUREMENT_ID"],
  appInstanceId: UUID().uuidString.replacingOccurrences(of: "-", with: ""),
  userId: "555666777888",
  userData: UserData(
    emailAddress: ["test@example.com"],
    phoneNumbers: ["08001234567"],
    address: [
      .init(
        firstName: "Fist Name",
        lastName: "Last Name",
        street: "1234 Street",
        city: "City",
        region: "Region",
        postalCode: "1234567",
        country: "US"
      )
    ]
  ),
  consent: Consent(
    adUserData: .granted,
    adPersonalization: .granted
  )
)

@Test
func validatePayload() async throws {
  struct Parameters: Encodable {
    var method: String
  }
  let loginEvent = Event(
    name: "login",
    parameters: ["key": "value1"]
  )

  let messages = try await client.validatePayload(for: [loginEvent])
  print(messages)
}

@Test
func appOpenToPurchaseItem() async throws {
  let sessionId = UUID().uuidString
  try await client.sessionStart(sessionId: sessionId)
  try await client.appOpen(sessionId: sessionId)
  try await client.screenView(name: "TutorialView", sessionId: sessionId)
  try await client.tutorialBegin(sessionId: sessionId, engagementTime: 3)
  try await client.tutorialComplete(sessionId: sessionId, engagementTime: 6)
  try await client.screenView(name: "TopView", sessionId: sessionId)
  try await client.screenView(name: "SearchView", sessionId: sessionId)
  try await client.search(term: "Beer", sessionId: sessionId)
  try await client.viewSearchResults(term: "Beer", sessionId: sessionId)
  try await client.selectItem(items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.addToWithlist(items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.screenView(name: "WithlistView", sessionId: sessionId)
  try await client.addToCart(items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.screenView(name: "CartView", sessionId: sessionId)
  try await client.viewCart(items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.removeFromCart(items: [.beer(quantiry: 1)], sessionId: sessionId)
  try await client.beginCheckout(items: [.beer(quantiry: 2)])
  let transactionId = UUID().uuidString
  try await client.addPaymentInfo(paymentType: "CreditCard", items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.addShippingInfo(coupon: "BeerCoupon123", items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.purchase(transactionId: transactionId, coupon: "BeerCoupon123", tax: 1.99, shipping: 2.99 * 2, items: [.beer(quantiry: 2)], sessionId: sessionId)
  try await client.refund(transactionId: transactionId, items: [.beer(quantiry: 2)], sessionId: sessionId)
}

@Test
func gameEvent() async throws {
  let sessionId = UUID().uuidString
  try await client.sessionStart(sessionId: sessionId)
  try await client.levelStart(levelName: "Level 1", sessionId: sessionId)
  try await client.postScore(score: 100, sessionId: sessionId)
  try await client.levelEnd(levelName: "Level 1", success: true, sessionId: sessionId)
  try await client.levelUp(level: 2, sessionId: sessionId)
  try await client.unlockAchievement(achievementId: UUID().uuidString, sessionId: sessionId)
  try await client.earnVirtualCurrency(currencyName: "Rupee", value: 123, sessionId: sessionId)
  try await client.spendVirtualCurrency(itemName: "NewItem", currencyName: "Rupee", value: 56, sessionId: sessionId)
}
extension Item {
  static func beer(quantiry: UInt) -> Item {
    Item(
      id: UUID().uuidString,
      name: "IPA Beer",
      affiliation: "Beer Store",
      category: "Alchol",
      category2: "Beer",
      category3: "IPA",
      variant: "24 Pack",
      brand: "Beer Brand",
      price: Price(currency: .usd, value: 2.99),
      discount: 1.99,
      quantity: quantiry
    )
  }
}
