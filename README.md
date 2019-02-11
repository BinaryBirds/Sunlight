# Sunlight (☀️)

Calculate dawn, dusk, golden and blue hour times by using various algorithms.



### Twilight Types

![](https://www.photopills.com/sites/default/files/tutorials/2014/twilights-magic-hours.jpg)



- Civil Twilight
- Nautical Twilight
- Astronomical Twilight
- Dawn (official)
- Dusk (official)
- The Golden Hour
- The Blue Hour



## Usage

Some examples:

```swift
import Sunlight

let sunlight = SunlightCalculator(latitude: 47.49801, longitude: 19.03991)
        
let officialDawn = sunlight.calculate(.dawn, twilight: .official)
let officialDusk = sunlight.calculate(.dusk, twilight: .official)

let civilDawn = sunlight.calculate(.dawn, twilight: .civil)
let civilDusk = sunlight.calculate(.dusk, twilight: .civil)

let astronomicalDawn = sunlight.calculate(.dawn, twilight: .astronomical)
let astronomicalDusk = sunlight.calculate(.dusk, twilight: .astronomical)

let nauticalDawn = sunlight.calculate(.dawn, twilight: .nautical)
let nauticalDusk = sunlight.calculate(.dusk, twilight: .nautical)

let blueHourStart = sunlight.calculate(.dawn, twilight: .custom(-8))
let blueHourEndGoldenHourStart = sunlight.calculate(.dusk, twilight: .custom(-4))
let goldenHourEnd = sunlight.calculate(.dusk, twilight: .custom(6))

```



## Install

Just use the [Swift Package Manager](https://theswiftdev.com/2017/11/09/swift-package-manager-tutorial/) as usual:

```swift
.package(url: "https://github.com/binarybirds/sunlight", from: "1.0.0"),
```

⚠️ Don't forget to add "Sunlight" to your target as a dependency!



## License

[WTFPL](LICENSE) - Do what the fuck you want to.



## Other sources

- https://en.wikipedia.org/wiki/Position_of_the_Sun 
- https://en.wikipedia.org/wiki/Sunrise_equation 

- https://www.codeproject.com/Articles/100174/Calculate-and-Draw-Moon-Phase 

- http://lamminet.fi/jarmo/rscalc.cc 

- https://www.timeanddate.com/astronomy/different-types-twilight.html 

- https://www.photopills.com/articles/understanding-golden-hour-blue-hour-and-twilights

