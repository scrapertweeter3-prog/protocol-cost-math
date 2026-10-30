# ProtocolCostMath

Protocol cost math for Swift: price a wellness protocol by what it costs to
run, not by what the gear costs on the shelf.

- `costPerServing` - one container's price divided by its servings
- `stackCostPerDay` - a full supplement stack priced per day
- `costPerSession` - gear cost spread over the sessions it actually gets
- `breakEvenSessions` - the session count where home gear beats the venue rate
- `annualVenueCost` - a year of per-session pricing at the current cadence
- `decadeSavings` - ten years of venue spend against the one-time gear cost

All money math runs on `Decimal`, so cost audits never inherit
floating-point drift. Pure Foundation, no dependencies, iOS 13+ / macOS
10.15+, Swift 5.9.

## Why

Sticker price hides the real number. A home device that looks expensive is
cheaper than the lounge's per-session rate once the session count crosses
break-even, and a supplement stack is only comparable when every item is
priced per serving. This pod lays both out directly: cost per session,
break-even sessions, venue spend over a year and a decade, and the stack's
daily price.

## Usage

    let math = ProtocolCostMath()
    let perSession = try math.costPerSession(gearCost: 1200, sessions: 300)
    // perSession = 4: $4 a session over 300 uses

    let breakEven = try math.breakEvenSessions(gearCost: 1200, venueSessionCost: 45)
    // breakEven = 26.67: past 27 sessions the home unit wins

## Installation (CocoaPods)

    pod 'ProtocolCostMath', '~> 0.1'

Built by the [Hacked Self](https://hackedself.com) team, which publishes
cost-per-session breakdowns and evidence audits for longevity protocols and
gear.

## License

MIT
