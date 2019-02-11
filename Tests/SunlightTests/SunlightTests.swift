import XCTest
@testable import Sunlight

final class SunlightTests: XCTestCase {
    
    static var allTests = [
        ("testSchlyterAlgorithm", testSchlyterAlgorithm),
        ("testWilliamsAlgorithm", testWilliamsAlgorithm)
    ]
    
    let date = Date(timeIntervalSince1970: 1549918775)
    let latitude = 47.49801
    let longitude = 19.03991

    func calculate(algorithm: SunlightCalculatorAlgorithm, transition: Transition, twilight: Twilight) -> Date? {
        return algorithm.calculate(transition,
                                   on: self.date,
                                   latitude: self.latitude,
                                   longitude: self.longitude,
                                   twilight: twilight)
    }

    func test(_ algorithm: SunlightCalculatorAlgorithm,
              _ transition: Transition,
              _ twilight: Twilight,
              _ expectation: TimeInterval) {
        
        guard let result = self.calculate(algorithm: algorithm, transition: transition, twilight: twilight) else {
            return XCTFail("Date should be present!")
        }
        XCTAssertEqual(result.timeIntervalSince1970, expectation, "Calculated date is not equal to expectation.")
    }

    func testSchlyterAlgorithm() {
        let algorithm = SchlyterAlgorithm()
        
        self.test(algorithm, .dawn, .official, 1549864559.794311)
        self.test(algorithm, .dusk, .official, 1549900806.1035957)

        self.test(algorithm, .dawn, .civil, 1549862645.721756)
        self.test(algorithm, .dusk, .civil, 1549902720.1761508)

        self.test(algorithm, .dawn, .astronomical, 1549858333.9143946)
        self.test(algorithm, .dusk, .astronomical, 1549907031.983512)

        self.test(algorithm, .dawn, .nautical, 1549860473.1792872)
        self.test(algorithm, .dusk, .nautical, 1549904892.7186193)
        
        self.test(algorithm, .dawn, .custom(-8), 1549861916.0246394)
        self.test(algorithm, .dawn, .custom(-4), 1549863382.5804334)
        self.test(algorithm, .dawn, .custom(6), 1549867231.1860623)
        
        self.test(algorithm, .dusk, .custom(6), 1549898134.7118442)
        self.test(algorithm, .dusk, .custom(-4), 1549901983.3174734)
        self.test(algorithm, .dusk, .custom(-8), 1549903449.8732672)
    }
    
    func testWilliamsAlgorithm() {
        let algorithm = WilliamsAlgorithm()
        
        self.test(algorithm, .dawn, .official, 1549864694.0)
        self.test(algorithm, .dusk, .official, 1549900731.0)
        
        self.test(algorithm, .dawn, .civil, 1549862676.0)
        self.test(algorithm, .dusk, .civil, 1549902746.0)
        
        self.test(algorithm, .dawn, .astronomical, 1549858363.0)
        self.test(algorithm, .dusk, .astronomical, 1549907056.0)
        
        self.test(algorithm, .dawn, .nautical, 1549860503.0)
        self.test(algorithm, .dusk, .nautical, 1549904917.0)
        
        self.test(algorithm, .dawn, .custom(-8), 1549861946.0)
        self.test(algorithm, .dawn, .custom(-4), 1549863414.0)
        self.test(algorithm, .dawn, .custom(6), 1549867266.0)
        
        self.test(algorithm, .dusk, .custom(6), 1549898164.0)
        self.test(algorithm, .dusk, .custom(-4), 1549902009.0)
        self.test(algorithm, .dusk, .custom(-8), 1549903475.0)
    }
}
