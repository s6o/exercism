// Package weather provides a forecast based on the city and condition.
package weather

var (
	// CurrentCondition represents the current weather condition.
	CurrentCondition string
	// CurrentLocation represents the current city.
	CurrentLocation string
)

// Forecast returns a string with the current weather forecast for specified city.
func Forecast(city, condition string) string {
	CurrentLocation, CurrentCondition = city, condition
	return CurrentLocation + " - current weather condition: " + CurrentCondition
}
