import Foundation

/// Protocol cost math: what a wellness protocol actually costs to run, and
/// when owning the gear beats paying per session. Gear reviews quote sticker
/// prices; the number that decides the purchase is cost per session over the
/// life of the device, the session count where home equipment stops being the
/// expensive option, and what a supplement stack costs per day.
///
/// All money math runs on `Decimal`, so cost audits never inherit
/// floating-point drift. Pure Foundation, no dependencies.
public enum ProtocolCostMathError: Error, Equatable {
    case negativeMoney
    case nonPositiveSessions
    case nonPositiveServings
    case emptyStack
}

public struct ProtocolCostMath {

    public init() {}

    // MARK: - Supplement stack costs

    /// What one container costs per serving. The unit every stack comparison
    /// should start from instead of the shelf price.
    @discardableResult
    public func costPerServing(price: Decimal, servings: Decimal) throws -> Decimal {
        guard servings > 0 else { throw ProtocolCostMathError.nonPositiveServings }
        if price < 0 { throw ProtocolCostMathError.negativeMoney }
        return price / servings
    }

    /// Daily cost of a full stack: every item priced per serving and summed.
    /// The number a stack has to justify every morning.
    @discardableResult
    public func stackCostPerDay(items: [(price: Decimal, servings: Decimal)]) throws -> Decimal {
        guard !items.isEmpty else { throw ProtocolCostMathError.emptyStack }
        var total = Decimal(0)
        for item in items {
            total += try costPerServing(price: item.price, servings: item.servings)
        }
        return total
    }

    // MARK: - Gear cost per session

    /// True cost of one session on owned gear: purchase price spread over the
    /// sessions the device actually gets. The number to set against the gym
    /// lounge or studio's per-session rate.
    @discardableResult
    public func costPerSession(gearCost: Decimal, sessions: Decimal) throws -> Decimal {
        guard sessions > 0 else { throw ProtocolCostMathError.nonPositiveSessions }
        if gearCost < 0 { throw ProtocolCostMathError.negativeMoney }
        return gearCost / sessions
    }

    /// The session count where owned gear beats the venue's per-session
    /// price. Below it the home setup was the splurge; above it every
    /// session is a discount.
    @discardableResult
    public func breakEvenSessions(gearCost: Decimal, venueSessionCost: Decimal) throws -> Decimal {
        guard venueSessionCost > 0 else { throw ProtocolCostMathError.negativeMoney }
        if gearCost < 0 { throw ProtocolCostMathError.negativeMoney }
        return gearCost / venueSessionCost
    }

    // MARK: - Venue vs owned gear over time

    /// A year of the venue habit at a given weekly-ish cadence: per-session
    /// price times sessions per month times twelve.
    @discardableResult
    public func annualVenueCost(venueSessionCost: Decimal, sessionsPerMonth: Decimal) throws -> Decimal {
        if venueSessionCost < 0 || sessionsPerMonth < 0 { throw ProtocolCostMathError.negativeMoney }
        return venueSessionCost * sessionsPerMonth * 12
    }

    /// Ten years of venue spend minus the one-time gear cost: what owning
    /// the device actually saves at this cadence, or what it wastes if the
    /// number goes negative.
    @discardableResult
    public func decadeSavings(gearCost: Decimal, venueSessionCost: Decimal, sessionsPerMonth: Decimal) throws -> Decimal {
        let venueDecade = try annualVenueCost(venueSessionCost: venueSessionCost, sessionsPerMonth: sessionsPerMonth) * 10
        if gearCost < 0 { throw ProtocolCostMathError.negativeMoney }
        return venueDecade - gearCost
    }
}
